#!/usr/bin/env ruby

require 'json'
require 'socket'

def get_hostname_and_ip(subnet)
  ips = `/sbin/ifconfig | grep "inet addr"`.split("\n").collect{|i| i.match(/addr:([0-9\.]+) /)[1]}
  min_ip = `TERM=xterm ipcalc #{subnet} -b -n | grep HostMin`.match(/[0-9\.]+/)[0]
  max_ip = `TERM=xterm ipcalc #{subnet} -b -n | grep HostMax`.match(/[0-9\.]+/)[0]

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

  return [`hostname -f`.strip, ip]
end

def get_broadcast_net(subnet)
  `TERM=xterm ipcalc #{subnet} -b -n | grep Broadcast`.strip.match(/[0-9\.]+/)[0]
end

def get_node_host_ips()
  return [] unless File.exists? "/etc/dodai/node_infos"

  f = open "/etc/dodai/node_infos"
  node_infos = JSON.parse(f.read)
  f.close

  node_infos
end

def send_to_client(host_ip, broadcast, port)
  host, ip = host_ip
  if not host or not ip then
    puts "host or ip is empty!"
    return
  end

  host_ips = ["#{host}:#{ip}"] + get_node_host_ips

  p host_ips
  puts "broadcast: #{broadcast}"
  udp = UDPSocket.open()
  sockaddr = Socket.pack_sockaddr_in(port, broadcast)
  udp.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, 1)
  udp.send(host_ips.join(","), 0, sockaddr)
  udp.close
end

subnet = ARGV.shift
port = 12345 

send_to_client get_hostname_and_ip(subnet), get_broadcast_net(subnet), port
