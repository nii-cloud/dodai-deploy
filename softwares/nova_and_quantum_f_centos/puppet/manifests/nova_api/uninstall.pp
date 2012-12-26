class nova_and_quantum_f_centos::nova_api::uninstall {
    include nova_and_quantum_f_centos::common::uninstall

    package{
       euca2ools:
         ensure => purged
    }
}

