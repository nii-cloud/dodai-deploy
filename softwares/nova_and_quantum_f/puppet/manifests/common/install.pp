class nova_and_quantum_f::common::install {
    include nova_and_quantum_f::common::python_mysqldb
    include nova_and_quantum_f::common::add_source_list

    package {
        [python-nova, python-eventlet, python-novaclient, nova-doc]:
            require => Exec[apt-get_update];

        nova-common:
            require => [Package[python-novaclient], Apt::Key["EC4926EA"], Apt::Sources_list[folsom]];
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
