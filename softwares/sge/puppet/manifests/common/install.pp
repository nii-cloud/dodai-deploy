class sge::common::install {
    file {
        "/tmp/sge":
            ensure => directory,
            mode => 644;

        "/tmp/sge/sun-jre-preseed.conf":
            alias => "sun-jre-preseed",
            source => "puppet:///modules/sge/sun-jre-preseed.conf";
    }

    exec {
        "update-java-alternatives -s java-6-sun > /dev/null 2>&1; exit 0":
            alias => "alternatives-java",
            require => Package[sun-java6-jre];
    }

    package {
        sun-java6-jre:
            responsefile => "/tmp/sge/sun-jre-preseed.conf",
            require => File["sun-jre-preseed"];
    }
}
