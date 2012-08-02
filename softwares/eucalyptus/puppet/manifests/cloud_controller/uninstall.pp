class eucalyptus::cloud_controller::uninstall{
    include eucalyptus::common::uninstall
    package {
        [eucalyptus-cloud, eucalyptus-walrus, python-eucadmin, "postgresql-9.1"]:
            ensure => purged;
    }

    exec {
      "rm -rf {/etc,/usr/share,/var/log,/var/lib}/eucalyptus/*; rm -rf /var/lib/postgresql/*":
            require => Package[eucalyptus-cloud, eucalyptus-walrus, python-eucadmin, "postgresql-9.1"];
    }
}
