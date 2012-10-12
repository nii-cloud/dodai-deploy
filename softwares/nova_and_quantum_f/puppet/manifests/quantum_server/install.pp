class nova_and_quantum_f::quantum_server::install {

    include nova_and_quantum_f::quantum_common::install
    include nova_and_quantum_f::common::python_mysqldb

    package {
        [quantum-server, python-cliff, python-pyparsing]:
            require => Package[quantum-common];
    }

    file {
        "/etc/default/quantum-server":
            content => template("$proposal_id/etc/default/quantum-server.erb"),
            alias => "default",
            mode => 644,
            require => Package[quantum-server];
    }

    exec {
        "stop quantum-server; start quantum-server":
            require => [Package[python-mysqldb], File["default", "conf", "paste", "plugin"]];
    }
}
