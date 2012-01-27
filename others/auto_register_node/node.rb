module MCollective
     module Agent
         class Node < RPC::Agent
             action "info" do
                 validate :network, String

                 network = request[:network]
                 parts = network.split(".")
                 while parts.length > 0 and parts[-1] == "0"
                   parts.pop
                 end
               
                 subnet_short = parts.join(".")
                 puts subnet_short
                 matches  = `ifconfig | grep "inet addr" | grep "#{subnet_short}"`.match(/[0-9\.]+/)
                 if matches
                   ip = matches[0]
                 else
                   ip = nil 
                 end

                 name = `hostname -f`.strip
                 if ip then
                   retval="---node_info---#{name}:#{ip}---node_info---"
                 end
                 reply.data = retval
             end
         end
     end
end
