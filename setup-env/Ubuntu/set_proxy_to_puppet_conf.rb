#!/usr/bin/env ruby

url = ARGV.shift
md = url.match /\/\/(.*):(.*)/
if md
  host = md[1]
  port = md[2]
else
  md = url.match /\/\/(.*)/
  host = md[1]
  port = "80"
end

`echo "[agent]" >> /etc/puppet/puppet.conf`
`echo http_proxy_host=#{host} >> /etc/puppet/puppet.conf`
`echo http_proxy_port=#{port} >> /etc/puppet/puppet.conf`
