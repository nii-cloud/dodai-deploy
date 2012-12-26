class nova_and_quantum_f_centos::nova_api::test {
    $image_file_name = "image_kvm.tgz"


    file {
        "/var/lib/nova/test.sh":
            alias => "test.sh",
            content => template("nova_and_quantum_f_centos/test.sh.erb");

        "/var/lib/nova/$image_file_name":
            alias => "$image_file_name",
            source => "puppet:///modules/nova_and_quantum_f_centos/$image_file_name";
    }

    exec {
        "/var/lib/nova/test.sh $image_file_name 2>&1":
            alias => "test.sh",
            require => File["test.sh", "$image_file_name"];
    }
}
