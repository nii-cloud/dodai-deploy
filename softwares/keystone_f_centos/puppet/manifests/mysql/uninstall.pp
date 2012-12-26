class keystone_f_centos::mysql::uninstall {

    exec {
	"openstack-db --drop --service keystone -r nova 2>&1":
    }
}

