#!/usr/bin/env ruby

require 'socket'

def get_hostname_and_ip(subnet)
  ips = `/sbin/ifconfig | grep "inet addr"`.split("\n").collect{|i| i.match(/addr:([0-9\.]+) /)[1]}
  min_ip = `TERM=xterm ipcalc #{subnet} -b -n | grep HostMin`.match(/[0-9\.]+/)[0]
  max_ip = `TERM=xterm ipcalc #{subnet} -b -n | grep HostMax`.match(/[0-9\.]+/)[0]

  ip = nil
  ips.each {|i|
    if i >= min_ip and i <= max_ip
      ip = i
      break
    end
  }

  return [`hostname -f`.strip, ip]
end

def get_broadcast_net(subnet)
  `TERM=xterm ipcalc #{subnet} -b -n | grep Broadcast`.strip.match(/[0-9\.]+/)[0]
end

def send_to_client(host_ip, broadcast, port)
  host, ip = host_ip
  if not host or not ip then
    puts "host or ip is empty!"
    return
  end

  puts "host: #{host}"
  puts "ip: #{ip}"
  puts "broadcast: #{broadcast}"
  udp = UDPSocket.open()
  sockaddr = Socket.pack_sockaddr_in(port, broadcast)
  udp.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
  udp.send(host_ip.join(":"), 0, sockaddr)
  udp.close
end

subnet = ARGV.shift
port = 12345 

send_to_client get_hostname_and_ip(subnet), get_broadcast_net(subnet), port
