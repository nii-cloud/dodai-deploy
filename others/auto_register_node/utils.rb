#!/usr/bin/env ruby

def get_ip(name)
  line = `grep #{name} /etc/hosts`.strip
  return "" if line == "" or not line =~ /^[0-9]/

  line.match(/^[0-9\.]+/)[0]
end

def add_host(name, ip)
  `echo "#{ip} #{name}" >> /etc/hosts`
end

def update_host(name, ip)
  `sed -i -e '/#{name}/d' /etc/hosts`
  `echo "#{ip} #{name}" >> /etc/hosts`
end


