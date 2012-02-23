#!/usr/bin/env ruby

require 'json'
require 'socket'

def get_broadcast_address(subnet)
  `TERM=xterm ipcalc #{subnet} -b -n | grep Broadcast`.strip.match(/[0-9\.]+/)[0]
end

def get_node_host_ips()
  return [] unless File.exists? "/etc/dodai/node_infos"

  f = open "/etc/dodai/node_infos"
  node_infos = JSON.parse(f.read)
  f.close

  node_infos
end

def send_to_client(broadcast, port)
  host_ips = get_node_host_ips

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

send_to_client get_broadcast_address(subnet), port
