#!/usr/bin/env ruby

def get_ip(name)
  line = `grep #{name} /etc/hosts`.strip
  return "" if line == "" or not line =~ /^[0-9]/

  line.match(/^[0-9\.]+/)[0]
end

def add_host(name, ip)
  short_name = name.split(".")[0]
  `echo "#{ip} #{name} #{short_name}" >> /etc/hosts`
end

def update_host(name, ip)
  `sed -i -e '/#{name}/d' /etc/hosts`

  add_host name, ip
end
