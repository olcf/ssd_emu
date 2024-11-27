class RunUserJobInDockerJob < ApplicationJob
  queue_as :default

  def perform(job_id)
    # setup in docker_initializer.rb
    serverContainer = Rails.application.config.serverContainer
    job = Job.find(job_id)
    username = job.user.username

    
    begin     
      # Create user folder if not available(silent mode)
      serverContainer.exec(["mkdir", "-p",username])
      
      # Create a directory with the name as job if not exists (silent mode)
      serverContainer.exec(["mkdir","-p",username+'/'+job.name])
      
      # Copy the script to some script.sh file
      # cat <<'EOF' > filename.txt content \nEOF\n 
      # <<'EOF' is used as here Tag (WITH QUOTATION), as it interpret everything as normal string with no substitution.
      # > is used to copy content to file that we will pass 
      # EOF is delimiter; Important thing to note about EOF is that it should not have any preceding or trailing commands.
      # More at: https://pubs.opengroup.org/onlinepubs/9699919799.2018edition/utilities/V3_chap02.html#tag_18_07_04
      serverContainer.exec(['bash','-c',"cat <<'EOF_NO_GUESS' > #{username}/#{job.name}/script.sh #{job.script} \nEOF_NO_GUESS\n "])
      
      # Change the permission for script.sh to +x so that we can execute it
      serverContainer.exec(["chmod","+x","#{username}/#{job.name}/script.sh"])
      
      # Execute the script.sh file
      result = serverContainer.exec(["bin/bash","-c", "cd #{username}/#{job.name} && /bin/bash ./script.sh"])
      
      # Re looking job because at the time of execution, user could edit job details when we are executing this code
      job = Job.find(job_id);
      
      # Error is saved in 1st column, if the exit code is other than 0
      exit_code = result[2] 
      
      if exit_code == 0
        # NO ERROR
        # First value from result is output which is an array
        job.out = result[0].join("\n")
        # If success, no error
        job.err = nil
      else
        job.err = result[1].join('\n')
        # If Error, no success
        job.out = nil
      end

    rescue Exception
      job.out = nil
      job.err = "Error with connecting to simulation machine! Open issue on official repository or report to contributors."
    ensure
      job.save
    end
  end
end
