#!/usr/bin/env ruby

require 'socket'

port = 12345

require File.dirname(__FILE__) + '/utils'

udps = UDPSocket.open()
udps.bind("0.0.0.0", port)

loop do
  name, ip = udps.recv(65535).split(":")
  puts name
  puts ip

  old_ip = get_ip name
  puts "old_ip: " + old_ip
  next if old_ip == ip

  if old_ip == ""
    add_host name, ip
    update_settings name
    restart_services
  end

  update_host name, ip
end

udps.close
