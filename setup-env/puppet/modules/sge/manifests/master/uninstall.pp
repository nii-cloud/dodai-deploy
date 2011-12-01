class sge::master::uninstall {
    include sge::common::uninstall

    file {
        "/tmp/sge/master-uninit.sh":
            source => "puppet:///modules/sge/master-uninit.sh",
            alias => "master-uninit";
    }

    exec {
        "/tmp/sge/master-uninit.sh 2>&1":
            alias => "master-uninit",
            notify => Package[gridengine-common, gridengine-client, postfix, bsd-mailx],
            require => File["master-uninit"];
    }
}
