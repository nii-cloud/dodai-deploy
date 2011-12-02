class nova::nova_api::install {
    nova::component {
        ["nova-api", "python-libvirt", euca2ools, unzip, gawk]:
    }
}
