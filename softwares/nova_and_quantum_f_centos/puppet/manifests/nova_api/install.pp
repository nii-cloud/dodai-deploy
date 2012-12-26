class nova_and_quantum_f_centos::nova_api::install {
    include nova_and_quantum_f_centos::common::install

    package{
        euca2ools:
    }

    exec {
	"openstack-db --init --service nova -r nova":
            alias => "nova-create-db",
            require => File["/etc/nova/nova.conf"];  
      
	"nova-manage db sync":
	  alias => "db-sync",
	  require => Exec["nova-create-db"];
    }

    service {
        openstack-nova-api:
            ensure => running,
            require => Exec["db-sync"];
    }
}
