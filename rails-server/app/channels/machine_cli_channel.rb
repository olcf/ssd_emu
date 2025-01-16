class MachineCliChannel < ApplicationCable::Channel
  # TODO: update backend code to receive command and recognize command!
  def subscribed
    # stream_from "some_channel"
    stream_from "MachineCliChannel"

    @serverContainer = Rails.application.config.serverContainer
    user = User.find(params[:id])
    username = user.username
    machine_name = params[:machine].gsub(/[^0-9A-Za-z]/,'').downcase  
          
    @machine_full_path = '/data/'+machine_name+'/'+username + '/'

    # Create a directory with the name as job if not exists (silent mode)
    @serverContainer.exec(["mkdir","-p",@machine_full_path])
    @serverContainer.exec(["cd",@machine_full_path])
    
    # Welcome Message from Machine
    welcome_message = <<~WELCOME_TEXT
    ############################################################################
                              NOTICE TO USERS
    This is a Federal computer system and is the property of the United States
    Government.  It is for authorized use only.  Users (authorized or
    unauthorized) have no explicit or implicit expectation of privacy.

    Any or all uses of this system and all files on this system may be
    intercepted, monitored, recorded, copied, audited, inspected, and disclosed 
    to authorized site, Department of Energy, and law enforcement personnel, as 
    well as authorized officials of other agencies, both domestic and foreign. 
    By using this system, the user consents to such interception, monitoring, 
    recording, copying, auditing, inspection, and disclosure at the discretion 
    of authorized site or Department of Energy personnel. 
    Unauthorized or improper use of this system may result in administrative 
    disciplinary action and civil and criminal penalties.  By continuing to use 
    this system you indicate your awareness of and consent to these terms and 
    conditions of use.  LOG OFF IMMEDIATELY if you do not agree to the 
    conditions stated in this warning. 
    ############################################################################
WELCOME_TEXT


    ActionCable.server.broadcast "MachineCliChannel", {command:"ssh",output:welcome_message,error:"", path:"/"}
  end
  def receive(data)
    # When we receive commands from user, we will perform a job to run that command in docker. 
    user_command = data["command"]
    user_path = data["path"]
    user_path = "/" if user_path.nil? || user_path.empty?

    # Adding echo in command will result in array of output, where, first element is the executed output, second element is path obtained from pwd
    # We will see the current directory using pwd.

    result_from_command = @serverContainer.exec(["bin/bash","-c","cd #{user_path} && #{user_command} && echo ' ' && pwd"])
    exit_code = result_from_command[2]
    
    # Exit Code of 0 means Success!!!!
    if exit_code === 0
      output = result_from_command[0]
      
      # since user commands may output in multiple length, we are executing pwd on end which is why we will take last
      user_path = output.last
      # remove whitespace if we have valid path string
      user_path = user_path.strip unless user_path.nil?
      
      user_output = ""
      # user will have output if and only if size of output is more than 1, since we will have at least 1 output always due to echo and pwd command 
      user_output = output[0] if output.length > 1

      ActionCable.server.broadcast "MachineCliChannel",{command:user_command,output: user_output,error:"",path:user_path}
    else
      ActionCable.server.broadcast "MachineCliChannel",{command:user_command,output: "",error: result_from_command[1],path:user_path}
    end


    # Here, run the command using a job!
  end
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
