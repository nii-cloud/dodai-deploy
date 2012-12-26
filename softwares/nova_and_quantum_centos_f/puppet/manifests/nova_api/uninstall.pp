class nova_and_quantum_centos_f::nova_api::uninstall {
    include nova_and_quantum_centos_f::common::uninstall

    package{
       euca2ools:
         ensure => purged
    }
}

