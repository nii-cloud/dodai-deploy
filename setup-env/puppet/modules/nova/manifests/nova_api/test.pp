class nova::nova_api::test {
    $image_file_name = "image_kvm.tgz"

    file {
        "/tmp/nova/test.sh":
            alias => "test.sh",
            source => "puppet:///modules/nova/test.sh",
            require => File["/tmp/nova"];
    }

    exec {
        "/tmp/nova/test.sh $image_file_name $project $user 2>&1":
            alias => "test.sh",
            require => File["test.sh", "$image_file_name"];
    }

    file {
        "/tmp/nova/$image_file_name":
            alias => "$image_file_name",
            source => "puppet:///modules/nova/$image_file_name",
            require => File["/tmp/nova"];
    }
}
