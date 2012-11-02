class eucalyptus::cloud_controller::test{
    $image_file_name = "image_kvm.tgz"

    package {
        gawk:
    }

    file {
        "/var/lib/eucalyptus/test.sh":
            alias => "test.sh",
            content => template("eucalyptus/test.sh.erb");

        "/var/lib/eucalyptus/$image_file_name":
            alias => "$image_file_name",
            source => "puppet:///modules/eucalyptus/$image_file_name";
    }

    exec{
        "/var/lib/eucalyptus/test.sh $image_file_name 2>&1":
            require => [File["test.sh", "$image_file_name"], Package[gawk]];
    }
}
