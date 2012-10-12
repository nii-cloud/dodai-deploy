class nova_and_quantum_f::quantum_server::uninstall{
    include nova_and_quantum_f::quantum_common::uninstall

    package {
        quantum-server:
            ensure => purged,
            require => Exec["quantum-uninit.sh"];
    }

    file {
        "/var/lib/quantum/quantum-uninit.sh":
            alias => "quantum-uninit.sh",
            content => template("nova_and_quantum_f/quantum-uninit.sh.erb");
    }

    exec {
        "/var/lib/quantum/quantum-uninit.sh":
            alias => "quantum-uninit.sh",
            before => Package[quantum-common, quantum-plugin-linuxbridge, python-quantum, python-quantumclient],
            require => File["quantum-uninit.sh"];
    }
}
