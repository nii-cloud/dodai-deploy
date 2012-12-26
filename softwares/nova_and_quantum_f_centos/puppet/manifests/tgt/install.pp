class nova_and_quantum_f_centos::tgt::install {
    include nova_and_quantum_f_centos::cinder_volume::install
      
    exec{
        "service tgtd start":
           require => Exec["cinder.conf","targets.conf"];
    }
}
