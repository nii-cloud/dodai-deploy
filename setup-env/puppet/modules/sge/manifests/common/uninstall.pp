class sge::common::uninstall {
    package {
        [gridengine-common, gridengine-client, postfix, bsd-mailx]:
            ensure => purged,
            notify => Exec["rm-dir"];
    }

    exec {
        "rm -rf /tmp/sge 2>&1":
            alias => "rm-dir";
    }
}
