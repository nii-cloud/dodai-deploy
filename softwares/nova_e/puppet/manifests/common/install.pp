class nova_e::common::install {
    package {
        [python-mysqldb, python-nova, python-eventlet, python-novaclient, nova-doc]:;

        nova-common:
            require => Package[python-novaclient]
    }

    file {
        "/etc/nova/nova.conf":
            content => template("$proposal_id/etc/nova/nova.conf.erb"),
            mode => 644,
            require => Package[nova-common];

        "/etc/nova/api-paste.ini":
            content => template("$proposal_id/etc/nova/api-paste.ini.erb"),
            mode => 644,
            require => Package[nova-common];
    }
}
