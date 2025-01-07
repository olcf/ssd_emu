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
    
    # ActionCable.server.broadcast "MachineCliChannel", {command:"ssh",output:"You are logged in!!!"}
  end
  def receive(data)
    # When we receive commands from user, we will perform a job to run that command in docker. 
    user_command = data["command"]
    result_from_command = @serverContainer.exec(["#{user_command}"])
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
