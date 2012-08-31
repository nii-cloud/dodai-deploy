#!/usr/bin/env ruby
nic_name = ARGV.shift
bridge_name = ARGV.shift
#interfaces_file = ARGV.shift
interfaces_file = "/etc/network/interfaces"

puts "Checking bridge name #{bridge_name}..."
if system "grep #{bridge_name} #{interfaces_file}"
  puts "Bridge #{bridge_name} has existed."
  exit 0
end
puts "The bridge can be set." 
puts

puts "Checking network interface #{nic_name}..."
unless system "grep #{nic_name} #{interfaces_file}"
  puts "Network interface #{nic_name} doesn't exist."
  exit 1
end
puts "The network interface exists."
puts

nic_begin = false
lines = []
open(interfaces_file) {|file|
  while line = file.gets
    if line =~ /^[ ]*auto[ ]+#{nic_name}/
      nic_begin = true
      lines << line
      lines << "iface #{nic_name} inet manual"
      lines << "auto #{bridge_name}"
      lines << "iface #{bridge_name} inet static"
      next
    end

    if nic_begin
      next if line =~ /^[ ]*iface[ ]+#{nic_name}/
      if line =~ /^[ ]*auto[ ]+eth/
        nic_begin = false
        lines << " bridge_ports #{nic_name}"
        lines << " bridge_stp off"
      end
    end

    lines << line
  end
}

if nic_begin
  lines << " bridge_ports #{nic_name}"
  lines << " bridge_stp off"
end

puts "Update network interfaces file."
file = File.open(interfaces_file, "w")
file.puts lines
file.close
