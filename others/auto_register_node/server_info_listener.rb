#!/usr/bin/env ruby

require 'socket'

port = 12345

require File.dirname(__FILE__) + '/utils'

def update_settings(name)
  puts "update settings."
  `sed -i -e "s/SERVER/#{name}/" /etc/mcollective/server.cfg`
end

def restart_services()
  puts "restart mcollective."
  `/etc/init.d/mcollective stop`
  `/etc/init.d/mcollective start`
end

udps = UDPSocket.open()
udps.bind("0.0.0.0", port)

is_server = true
loop do
  name_ips = udps.recv(65535).split(",")
  name_ips.each {|name_ip|
    name, ip = name_ip.split ":"

    puts name
    puts ip
  
    old_ip = get_ip name
    puts "old_ip: " + old_ip

    if old_ip != ip
      update_host name, ip
    end

    next unless is_server

    # the first one is dodai-deploy server's name and ip.
    if system("grep SERVER /etc/mcollective/server.cfg") or old_ip != ip
      update_settings name
      restart_services
    end
    is_server = false
  }
end

udps.close
