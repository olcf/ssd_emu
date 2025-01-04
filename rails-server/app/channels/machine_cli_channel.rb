class MachineCliChannel < ApplicationCable::Channel
  # TODO: update backend code to receive command and recognize command!
  def subscribed
    # stream_from "some_channel"
    puts "Receiving message from subscribed!!!"
    stream_from "MachineCliChannel"
  end
  def execute_command(data)
    given_command = data["cmd"]
    ActionCable.server.broadcast("MachineCliChannel",message:"Response from backend")
  end
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
