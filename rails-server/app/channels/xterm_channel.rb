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
      @read, @write, @pid = PTY.spawn("docker exec -it slurmctld bash")
  
      # Read in a Thread so it won't block other user's connection
      Thread.new do
        begin
          @read.each_char do |char|
            ActionCable.server.broadcast("xterm_output", char)
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
