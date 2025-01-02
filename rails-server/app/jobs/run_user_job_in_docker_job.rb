class RunUserJobInDockerJob < ApplicationJob
  queue_as :default

  def perform(job_id)
    # setup in docker_initializer.rb
    serverContainer = Rails.application.config.serverContainer
    job = Job.find(job_id)
    
    # preparing job by updating state to 'R'
    job.state = 'R'
    job.save
    
    
    begin     
      # preparing username and folder name for adding script
      username = job.user.username
      machine_name = job.machine.name.gsub(/[^0-9A-Za-z]/,'').downcase  
      
      # removing all non alpha-numeric part of name
      job_folder_name = job.name.gsub(/[^0-9A-Za-z]/,'').downcase     
      # If job name is only composed of non alpha-numeric characters, use test as folder_name
      job_folder_name = "test" if job_folder_name.length <= 0
      
      job_full_path = '/data/'+machine_name+'/'+username + '/'+job_folder_name
      script_full_path = job_full_path + '/script.sh'

      # Create a directory with the name as job if not exists (silent mode)
      serverContainer.exec(["mkdir","-p",job_full_path])
      
      # Copy the script to some script.sh file
      # cat <<'EOF' > filename.txt content \nEOF\n 
      # <<'EOF' is used as here Tag (WITH QUOTATION), as it interpret everything as normal string with no substitution.
      # > is used to copy content to file that we will pass 
      # EOF is delimiter; Important thing to note about EOF is that it should not have any preceding or trailing commands.
      # More at: https://pubs.opengroup.org/onlinepubs/9699919799.2018edition/utilities/V3_chap02.html#tag_18_07_04
      # TODO: Implement sbatch running the jobs
      serverContainer.exec(['bash','-c',"cat <<'EOF_NO_GUESS' > #{script_full_path}; \n#{createScript(job)} \nEOF_NO_GUESS\n "])
      
      # Change the permission for script.sh to +x so that we can execute it
      serverContainer.exec(["chmod","+x",script_full_path])
      
      # Execute the script.sh file
      result = serverContainer.exec(["bin/bash","-c", "cd #{job_full_path} && /bin/bash ./script.sh"])
      
      # Re looking job because at the time of execution, user could edit job details when we are executing this code
      job = Job.find(job_id);
      
      # Error is saved in 1st column, if the exit code is other than 0
      exit_code = result[2]
      
      if exit_code == 0
        # NO ERROR
        # First value from result is output which is an array
        job.out = result[0].join("\n")
        job.state = "CD" #CD means completed
        job.job_reason_code = "None"
        
        # If success, no error
        job.err = nil
      else
        job.err = result[1].join('\n')
        job.state = "CD"
        job.job_reason_code = "NonZeroExitCode"
        # If Error, no success
        job.out = nil
      end

    rescue => error
      job.out = nil
      job.err = "Error with connecting to simulation machine! Open issue on official repository or report to contributors. #{error}"
      job.job_reason_code="JobLaunchFailure"
      job.state = "CD"
    ensure
      job.save
    end
  end
  def format_time(seconds)
    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    remaining_seconds = seconds % 60
    "#{hours}:#{minutes}:#{remaining_seconds}"
  end
  def createScript(job)
    script_name = "#{job.name.gsub(/[^0-9A-Za-z]/, '').downcase}\n"
    script = <<~SCRIPT
      #!/bin/bash
      #SBATCH -J #{script_name}
      #SBATCH -A #{job.project.name}
      #SBATCH -N #{job.nodes}
      #SBATCH -t #{format_time(job.walltime)}
      SCRIPT

      
    script += "#SBATCH -o #{job.out_file}\n" if job.out_file
    script += "#SBATCH -e #{job.err_file}\n" if job.err_file
    script += "#SBATCH --threads-per-core=#{job.cores}\n" if job.cores
    script += "#SBATCH -S #{job.slurm_cores}\n" if job.slurm_cores
    script += "#SBATCH --mail-user=#{job.mail_user}\n" if job.mail_user
    script += "#SBATCH --mail-type=#{job.mail_type}\n" if job.mail_type
      
    script += "#{job.script}\n"


    return script
  end
end
