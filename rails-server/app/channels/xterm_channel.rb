class XtermChannel < ApplicationCable::Channel
  def subscribed
    stream_from "xterm_output"
    ActionCable.server.broadcast("xterm_output",{type:'confirm_subscription'})
    start_shell_session
  end

  def receive(data)
    input = data["input"]
    # write& is to make sure, we don't call closed if write is nil; equiv to @write != nil and @write.closed?
    if @write&.closed?
      Rails.logger.debug("XtermChannel Closing the pipe inside receive function.")
      return
    end
  
    begin
      @write.write(input)
    rescue Errno::EPIPE => e
      Rails.logger.error("XtermChannel : #{e.message}")
    rescue => e
      Rails.logger.error("XtermChannel Write error: #{e.message}")
    end
  end

  def unsubscribed
    # Basically SIGTERM
    Process.kill("TERM", @pid) if @pid
  rescue
    Rails.logger.debug("Unable to terminate process #{@pid} || KILLING IT NOW")
    Process.kill("KILL",@pid) if @pid
  end

  private

  def start_shell_session
    require 'pty'

    begin
      @read, @write, @pid = PTY.spawn("docker exec -it slurmctld bin/bash")
      # @read and @write are File which inherits from IO
      # These behave exactly like linux sockets
      # @write.write("Hi! this is awesome")
      # @read.readpartial(4) => Hi!
      # @read.readpartial(2) => th
      
      emu_welcome_message = "EMU is a software that emulates the supercomputer environment at Oak Ridge National Laboratory(ORNL), allowing beginners to familiarize with supercomputers and the job submission process.\n"
        ActionCable.server.broadcast("xterm_output",emu_welcome_message)
      # Read in a Thread so it won't block other user's connection
      Thread.new do
        begin
          # reading 1024 characters (1KB) so each websocket chunk is not too big and too small
          while (output = @read.readpartial(1024))
            ActionCable.server.broadcast("xterm_output", output)
          end
        rescue Errno::EIO
          Rails.logger.info("XtermChannel PTY read closed")
        end
      end
    rescue => e
      Rails.logger.error("XTermChannel something didn't work in docker container, it exited: #{e.message}")
    end
  end
end
