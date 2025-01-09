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


    ActionCable.server.broadcast "MachineCliChannel", {command:"ssh",output:welcome_message}
  end
  def receive(data)
    # When we receive commands from user, we will perform a job to run that command in docker. 
    user_command = data["command"]
    result_from_command = @serverContainer.exec(["bin/bash","-c","#{user_command}"])
    exit_code = result_from_command[2]
    
    # Exit Code of 0 means Success!!!!
    if exit_code === 0
      ActionCable.server.broadcast "MachineCliChannel",{command:user_command,output: result_from_command[0],error:""}
    else
      ActionCable.server.broadcast "MachineCliChannel",{command:user_command,output: "",error: result_from_command[1]}
    end


    # Here, run the command using a job!
  end
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
