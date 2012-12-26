class nova_and_quantum_f_centos::nova_network::install {
#     service {
#        openstack-nova-network:
#            ensure => running,
#            require => File["/etc/nova/nova.conf"];
#     }
}
