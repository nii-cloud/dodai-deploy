#!/bin/bash

# install apache2
apt-get install apache2 -y
a2enmod headers proxy proxy_http proxy_balancer ssl rewrite
/etc/init.d/apache2 reload

# change setting of puppetmaster
sed -i -e "s/SERVERTYPE=webrick/SERVERTYPE=mongrel/g" /etc/default/puppetmaster
sed -i -e "s/PUPPETMASTERS=1/PUPPETMASTERS=10/g" /etc/default/puppetmaster
sed -i -e "s/PORT=8140/PORT=18140/g" /etc/default/puppetmaster

# create puppetmaster site for apache2
cat <<CONF > /etc/apache2/sites-available/puppetmaster
Listen 8140

ProxyRequests Off
ProxyBadHeader Ignore


<Proxy balancer://puppetmaster>
        BalancerMember http://127.0.0.1:18140
        BalancerMember http://127.0.0.1:18141
        BalancerMember http://127.0.0.1:18142
        BalancerMember http://127.0.0.1:18143
        BalancerMember http://127.0.0.1:18144
        BalancerMember http://127.0.0.1:18145
        BalancerMember http://127.0.0.1:18146
        BalancerMember http://127.0.0.1:18147
        BalancerMember http://127.0.0.1:18148
        BalancerMember http://127.0.0.1:18149
</Proxy>

<VirtualHost *:8140>
        SSLEngine On
        SSLCipherSuite SSLv2:-LOW:-EXPORT:RC4+RSA
        SSLCertificateFile /var/lib/puppet/ssl/certs/CERT_NAME.pem
        SSLCertificateKeyFile /var/lib/puppet/ssl/private_keys/CERT_NAME.pem
        SSLCertificateChainFile /var/lib/puppet/ssl/ca/ca_crt.pem
        SSLCACertificateFile /var/lib/puppet/ssl/ca/ca_crt.pem
        SSLCARevocationFile /var/lib/puppet/ssl/ca/ca_crl.pem

        SSLVerifyClient optional
        SSLVerifyDepth 1
        SSLOptions +StdEnvVars

        RequestHeader set X-SSL-Subject %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-DN %{SSL_CLIENT_S_DN}e
        RequestHeader set X-Client-Verify %{SSL_CLIENT_VERIFY}e

        <Location />
                SetHandler balancer-manager
                Order allow,deny
                Allow from all
        </Location>

        ProxyPass / balancer://puppetmaster/
        ProxyPassReverse / balancer://puppetmaster/
        ProxyPreserveHost On

        ErrorLog /var/log/apache2/error.log
        CustomLog /var/log/apache2/access.log combined
        CustomLog /var/log/apache2/balancer_ssl_requests.log "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"

</VirtualHost>
CONF

# change CERT_NAME in /etc/apache2/sites-available/puppetmaster
fqdn="`facter fqdn`"
if [ "$fqdn" = "" ]; then
  fqdn="`facter hostname`"
fi
sed -i -e "s/CERT_NAME/$fqdn/g" /etc/apache2/sites-available/puppetmaster

# disable default site and enable puppetmaster site.
a2dissite default
a2ensite puppetmaster

# disable default ports
sed -i -e "s/Include ports.conf/#Include ports.conf/g" /etc/apache2/apache2.conf
/etc/init.d/apache2 reload

chown -R puppet:puppet /var/lib/puppet
chown -R puppet:puppet /etc/puppet

/etc/init.d/puppetmaster restart
