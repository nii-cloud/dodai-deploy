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
class MessageQueueClient
  def initialize
    activemq = Settings.activemq
    @client = Stomp::Client.new activemq.user, activemq.password, activemq.host, activemq.port, true
  end

  def subscribe
    @client.subscribe "/topic/deploy" do |msg|
      msg_obj = YAML.load msg.body
      yield msg_obj
    end
  end

  def publish(msg_obj)
    @client.publish "/topic/deploy", msg_obj.to_yaml
  end 

  def unsubscribe
    @client.unsubscribe
  end

  def close
    @client.close
  end
end
