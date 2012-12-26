class keystone_centos_f::mysql::uninstall {

    exec {
	"openstack-db --drop --service keystone -r nova 2>&1":
    }
}

