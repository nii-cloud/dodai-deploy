module MCollective
     module Agent
         class Node < RPC::Agent
             action "info" do
                 validate :network, String

                 network = request[:network]

                 ips = `cat /etc/network/interfaces | grep "address"`.split("\n").collect{|i| i.match(/[0-9\.]+/)[0]}
                 min_ip = `ipcalc #{network} -b -n | grep HostMin`.match(/[0-9\.]+/)[0]
                 max_ip = `ipcalc #{network} -b -n | grep HostMax`.match(/[0-9\.]+/)[0]
                 min_ip_parts = min_ip.split(".").collect{|i| i.to_i}
                 max_ip_parts = max_ip.split(".").collect{|i| i.to_i}

                 ip = nil
                 ips.each {|i|
                     parts = i.split(".").collect{|part| part.to_i}
                     in_range = true
                     parts.each_index{|index|
                         if parts[index] < min_ip_parts[index] or parts[index] > max_ip_parts[index]
                             in_range = false
                             break
                         end
                     }
                     if in_range
                         ip = i
                         break
                     end
                 }
                 name = `hostname -f`.strip
                 if ip then
                   retval="#{name}:#{ip}"
                 end
                 reply.data = retval
             end
         end
     end
end
