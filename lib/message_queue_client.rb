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
