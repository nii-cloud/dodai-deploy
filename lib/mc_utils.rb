require "mcollective"
include MCollective::RPC

class McUtils

  def self.find_hosts
    mc = rpcclient "rpcutil", :options => self._rpcoptions 
    result = mc.discover
    mc.disconnect
    result
  end
  
  def self.puppetd_runonce(node_names)
    options = self._rpcoptions
    options[:filter]["fact"] = [{:fact => "hostname", :value => node_names.join("|"), :operator => "=~"}]
    options[:verbose] = true
    options[:timeout] = Settings.mcollective.timeout 
    options[:disctimeout] = Settings.mcollective.discovery_timeout

    mc = rpcclient "puppetd", :options => options
    output = mc.runonce :server => `hostname -f`.strip
    mc.disconnect
  
    ret = {}
    p output
    output.each do |item|
      puts item.to_yaml

      status_code = item.results[:statuscode]
      if status_code == 0
				message = item.results[:data][:output].gsub /\e[\[0-9;]+m/, ""
				status_code = 1 if /^E: / =~ message or /^err: / =~ message
      else
        message = item.results[:statusmsg]
      end

      ret[item.results[:sender]] = {:status_code => status_code, :message => message}
    end

    node_names.each do |node_name|
      ret[node_name] = {:status_code => 1, :message => "We did not discover any nodes."} unless ret.has_key? node_name
    end 

    ret
  end

  def self._rpcoptions
    {:filter=>{"identity"=>[], "fact"=>[], "agent"=>[], "cf_class"=>[]}, 
     :collective=>nil, 
     :config=>"/etc/mcollective/client.cfg", 
     :disctimeout=>Settings.mcollective.discovery_timeout, 
     :verbose=>false, 
     :progress_bar=>true, 
     :timeout=>Settings.mcollective.timeout
    }
  end
end
