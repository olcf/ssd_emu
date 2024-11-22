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
      serverContainer.exec(['bash','-c',"echo #{job.script} > #{username}/#{job.name}/script.sh"])
      
      # Change the permission for script.sh to +x so that we can execute it
      serverContainer.exec(["chmod","+x","#{username}/#{job.name}/script.sh"])
      
      # Execute the script.sh file
      result = serverContainer.exec(["bin/bash","-c", "cd #{username}/#{job.name} && /bin/bash ./script.sh"])
      
      puts "output from given script "
      puts result
      # Re looking job because at the time of execution, user could edit job details when we are executing this code
      job = Job.find(job_id);
      
      # Error is saved in 1st column, if the exit code is other than 0
      exit_code = result[2] 
      puts "Exit code = #{exit_code}"
      
      if exit_code == 0
        # NO ERROR
        # First value from result is output which is an array
        job.out = result[0].join("\n")
        # If success, no error
        job.err = ""
      else
        job.err = result[1].join('\n')
        # If Error, no success
        job.out = ""
      end
      job.save

    
    end
    
  end
end
