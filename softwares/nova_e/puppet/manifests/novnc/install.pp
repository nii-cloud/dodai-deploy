class nova_e::novnc::install {
    package {
        [nova-consoleauth, python-numpy]:
    }

    file {
        "/var/lib/novnc.tgz":
            source => "puppet:///modules/nova_e/novnc.tgz",
            alias => "novnc.tgz";

        "/etc/init/novnc.conf":
            source => "puppet:///modules/nova_e/novnc.conf",
            alias => "novnc.conf";
    }

    exec {
        "rm -rf novnc; tar xzvf novnc.tgz":
            cwd => "/var/lib",
            alias => "novnc.tgz",
            require => File["novnc.tgz"];

        "stop novnc; start novnc":
            require => [File["novnc.conf"], Exec["novnc.tgz"]];
    }
}
