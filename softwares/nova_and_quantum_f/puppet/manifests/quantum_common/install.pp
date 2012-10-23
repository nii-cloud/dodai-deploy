class nova_and_quantum_f::quantum_common::install {
    include nova_and_quantum_f::common::add_source_list 
    package {
        [quantum-common, quantum-plugin-linuxbridge]:
            require => Exec[apt-get_update];
    }

    file {
        "/etc/quantum/quantum.conf":
            content => template("$proposal_id/etc/quantum/quantum.conf.erb"),
            mode => 644,
            alias => "conf",
            require => Package[quantum-common];

        "/etc/quantum/api-paste.ini":
            content => template("$proposal_id/etc/quantum/api-paste-quantum.ini.erb"),
            mode => 644,
            alias => "paste",
            require => Package[quantum-common];

        "/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini":
            content => template("$proposal_id/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini.erb"),
            mode => 644,
            alias => "plugin",
            require => Package[quantum-plugin-linuxbridge];
    }
}
