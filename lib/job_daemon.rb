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
require "thread"

class JobDaemon < DaemonSpawn::Base
  def start(args)
    puts "Start daemon"

    @lockers = {}
    @threads = []

    mq = MessageQueueClient.new
    mq.subscribe do |msg_obj|
      @threads << do_in_thread(msg_obj)
    end

    puts "Daemon started"
    while !@stopped
      sleep 1
    end

    mq.unsubscribe
    mq.close

    @threads.each{|t| t.join}

    puts "Daemon stopped"
  end

  def stop
    @stopped = true
    puts "Stop daemon"
  end

  def do_in_thread(msg_obj)
    auth_token = msg_obj[:params][:auth_token]
    @lockers[auth_token] = Mutex::new unless @lockers.has_key? auth_token
    Thread.new do
      puts "Thread for #{auth_token}"
      @lockers[auth_token].synchronize do
        begin
          p msg_obj
          operation_name = msg_obj[:operation]
          Operations.new(operation_name).invoke msg_obj[:params]
        rescue Exception => exc
          puts auth_token
          puts exc.inspect
          puts exc.backtrace
        end        

        @threads.delete self
      end
    end
  end
end
