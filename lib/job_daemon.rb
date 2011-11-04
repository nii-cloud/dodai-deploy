#
# Copyright 2011 National Institute of Informatics.
#
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
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
