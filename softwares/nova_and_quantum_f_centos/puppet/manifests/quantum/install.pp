class nova_and_quantum_f_centos::quantum::install {
    package {
        [openstack-quantum, openstack-quantum-linuxbridge, tunctl]:
    }

    file {
        "/etc/quantum/quantum.conf":
            content => template("$proposal_id/etc/quantum/quantum.conf.erb"),
            mode => 644,
            alias => "conf",
	    require => Package[openstack-quantum];

        "/etc/quantum/api-paste.ini":
            content => template("$proposal_id/etc/quantum/api-paste-quantum.ini.erb"),
            mode => 644,
            alias => "paste",
            require => Package[openstack-quantum];

        "/etc/quantum/plugin.ini":
            content => template("$proposal_id/etc/quantum/plugin.ini.erb"),
            mode => 644,
            alias => "plugin",
            require => Package[openstack-quantum];

        "/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini":
            content => template("$proposal_id/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini.erb"),
            mode => 644,
            alias => "linuxbride_plugin",
            require => Package[openstack-quantum-linuxbridge];


        "/var/lib/quantum/quantum-init.sh":
            source => "puppet:///modules/nova_and_quantum_f_centos/quantum-init.sh",
            alias => "quantum-init.sh",
            require => File["conf","paste","plugin","linuxbride_plugin"];
    }

    exec {
#	" quantum-server-setup --plugin linuxbridge":
#            alias => "plugin-setup",
#            require => Package[openstack-quantum,openstack-quantum-linuxbridge];

        "/var/lib/quantum/quantum-init.sh 2>&1":
            alias => "quantum-init.sh",
            require => File["quantum-init.sh"];

        "service quantum-server start; service quantum-linuxbridge-agent start":
            require => Exec["quantum-init.sh"];
    }

}
