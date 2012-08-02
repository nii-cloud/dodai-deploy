class eucalyptus::common::install{
    include apt
    apt::key {
        "C1240596":
            content => template("eucalyptus/c1240596-eucalyptus-release-key.pub");
    }

    apt::sources_list {
        "euca2ools":
            ensure  => present,
            content => "deb http://downloads.eucalyptus.com/software/euca2ools/2.1/ubuntu precise main";

        "eucalyptus":
            ensure  => present,
            content => "deb http://downloads.eucalyptus.com/software/eucalyptus/3.1/ubuntu precise main";
    }
}

