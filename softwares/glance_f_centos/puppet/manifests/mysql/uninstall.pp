class glance_centos_f::mysql::uninstall {

    exec {
           "openstack-db --drop --service glance -r nova 2>&1":
    }

}

