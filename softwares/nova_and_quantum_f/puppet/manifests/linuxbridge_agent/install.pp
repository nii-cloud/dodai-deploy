class nova_and_quantum_f::linuxbridge_agent::install {

    include nova_and_quantum_f::quantum_common::install

    package {
        quantum-plugin-linuxbridge-agent:
            require => Package[quantum-common];
    }

    exec {
        "stop quantum-plugin-linuxbridge-agent; start quantum-plugin-linuxbridge-agent":
            require => Package[quantum-plugin-linuxbridge-agent];
    }
}
