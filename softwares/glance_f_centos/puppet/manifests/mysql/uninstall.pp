class glance_f_centos::mysql::uninstall {

    exec {
           "openstack-db --drop --service glance -r nova 2>&1":
    }

}

