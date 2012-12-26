class nova_and_quantum_centos_f::nova_network::install {
#     service {
#        openstack-nova-network:
#            ensure => running,
#            require => File["/etc/nova/nova.conf"];
#     }
}
