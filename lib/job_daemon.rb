class JobDaemon < DaemonSpawn::Base
  def start(args)
    puts "Start daemon"
    mq = MessageQueueClient.new
    mq.subscribe do |msg_obj|
      begin 
        p msg_obj
        operation_name = msg_obj[:operation]
        Operations.new.invoke operation_name, msg_obj[:params]
      rescue Exception => exc
        puts exc.inspect
        puts exc.backtrace
      end
    end

    puts "Daemon started"
    while !@stopped
      sleep 1
    end

    mq.unsubscribe
    mq.close

    puts "Daemon stopped"
  end

  def stop
    @stopped = true
    puts "Stop daemon"
  end
end
