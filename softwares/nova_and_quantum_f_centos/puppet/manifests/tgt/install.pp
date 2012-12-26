class nova_and_quantum_centos_f::tgt::install {
    include nova_and_quantum_centos_f::cinder_volume::install
      
    exec{
        "service tgtd start":
           require => Exec["cinder.conf","targets.conf"];
    }
}
