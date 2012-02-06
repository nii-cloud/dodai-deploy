module MCollective
     module Agent
         class Node < RPC::Agent
             action "info" do
                 validate :network, String

                 network = request[:network]

                 ips = `ifconfig | grep "inet addr"`.split("\n").collect{|i| i.match(/addr:([0-9\.]+) /)[1]}
                 min_ip = `ipcalc #{network} -b -n | grep HostMin`.match(/[0-9\.]+/)[0]
                 max_ip = `ipcalc #{network} -b -n | grep HostMax`.match(/[0-9\.]+/)[0]

                 ip = nil
                 ips.each {|i|
                     if i >= min_ip and i <= max_ip
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
