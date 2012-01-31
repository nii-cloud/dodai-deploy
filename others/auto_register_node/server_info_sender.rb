#!/usr/bin/env ruby

require 'socket'

def get_hostname_and_ip(subnet)
  parts = subnet.split(".")
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
   
  return [`hostname -f`.strip, ip]
end

def get_broadcast_net(subnet)
  parts = subnet.split(".")
  subnet_parts = []
  while parts.length > 0 and parts[-1] == "0"
    subnet_parts.push "255"
    parts.pop 
  end

  (parts + subnet_parts).join(".")
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
