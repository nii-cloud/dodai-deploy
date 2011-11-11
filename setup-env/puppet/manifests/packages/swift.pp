/*
 * Copyright 2011 National Institute of Informatics.
 *
 *
 *    Licensed under the Apache License, Version 2.0 (the "License"); you may
 *    not use this file except in compliance with the License. You may obtain
 *    a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 *    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 *    License for the specific language governing permissions and limitations
 *    under the License.
 */

$swift_templates_dir = "$proposal_id" 
$swift_files_rel_dir = "files/swift"

class swift_common {
    user { swift: }

    file {
        "/etc/swift":
            ensure => directory,
            mode => 644,
            owner => "swift",
            group => "swift";

        "/etc/swift/cert.crt":
            source => "puppet:///$swift_files_rel_dir/cert.crt",
            mode => 644,
            require => File["/etc/swift"];

        "/etc/swift/cert.key":
            source => "puppet:///$swift_files_rel_dir/cert.key",
            mode => 644,
            require => File["/etc/swift"];

        "/etc/swift/swift.conf":
            content => template("$swift_templates_dir/etc/swift/swift.conf.erb"),
            mode => 644,
            owner => "swift",
            group => "swift",
            require => [File["/etc/swift"]];

        "/tmp/swift":
            ensure => directory,
            mode => 644
    }
}

class swift_proxy::install {
    include swift_common

    package { swift: }

    package {
        ["swift-proxy", memcached]:
            require => [File["/etc/swift/swift.conf"], Package["swift"]]
    }

    file {
        "/etc/swift/proxy-server.conf":
            content => template("$swift_templates_dir/etc/swift/proxy-server.conf.erb"),
            mode => 644,
            require => Package["swift-proxy"];

        "/tmp/swift/storage-servers":
            content => template("/etc/puppet/templates/swift/storage-servers.erb");

        "/tmp/swift/proxy-init.sh":
            source => "puppet:///$swift_files_rel_dir/proxy-init.sh",
            require => File["/etc/swift/proxy-server.conf", "/tmp/swift"];

        "/tmp/swift/python-swauth.deb":
            source => "puppet:///$swift_files_rel_dir/python-swauth_1.0.2-1_all.deb",
            require => File["/tmp/swift"];
    }

    exec {
        "/tmp/swift/proxy-init.sh $storage_dev $ring_builder_replicas 2>&1":
            require => File["/tmp/swift/proxy-init.sh", "/tmp/swift/storage-servers", "/tmp/swift/python-swauth.deb"]
    }
}

class swift_proxy::uninstall {
    package {
        ["swift", "swift-proxy"]:
            ensure => purged,
            require => Exec["proxy-uninit.sh"]
    }

    file {
       "/tmp/swift/proxy-uninit.sh":
           source => "puppet:///$swift_files_rel_dir/proxy-uninit.sh"
    }

    exec {
        "/tmp/swift/proxy-uninit.sh":
            alias => "proxy-uninit.sh",
            require => File["/tmp/swift/proxy-uninit.sh"]
    }
}

class swift_proxy::test {
    file {
       "/tmp/swift/test.sh":
           source => "puppet:///$swift_files_rel_dir/test.sh"
    }

    exec {
        "/tmp/swift/test.sh $super_admin_key 2>&1":
            require => File["/tmp/swift/test.sh"]
    }

}

class swift_storage::install {
    include swift_common

    package {
        ["swift-account", "swift-container", "swift-object", xfsprogs, rsync]:
            require => File["/etc/swift/swift.conf"]
    }

    file {
        "/etc/rsyncd.conf":
            content => template("$swift_templates_dir/etc/rsyncd.conf.erb"),
            mode => 644,
            require => Package["rsync"];

       "/tmp/swift/rsync-init.sh":
           source => "puppet:///$swift_files_rel_dir/rsync-init.sh",
           require => File["/etc/rsyncd.conf", "/tmp/swift"];

        "/etc/swift/account-server.conf":
            content => template("$swift_templates_dir/etc/swift/account-server.conf.erb"),
            mode => 644,
            alias => "account-server.conf",
            require => Package["swift-account"];

        "/etc/swift/container-server.conf":
            content => template("$swift_templates_dir/etc/swift/container-server.conf.erb"),
            mode => 644,
            alias => "container-server.conf",
            require => Package["swift-container"];

        "/etc/swift/object-server.conf":
            content => template("$swift_templates_dir/etc/swift/object-server.conf.erb"),
            mode => 644,
            alias => "object-server.conf",
            require => Package["swift-object"];

        "/tmp/swift/storage-init.sh":
            source => "puppet:///$swift_files_rel_dir/storage-init.sh",
            require => File["account-server.conf", "container-server.conf", "object-server.conf", "/tmp/swift"];
    }

    exec {
        "/tmp/swift/rsync-init.sh 2>&1":
            alias => "rsync-init",
            require => File["/tmp/swift/rsync-init.sh"];

        "/tmp/swift/storage-init.sh $swift_proxy 2>&1":
            require => [File["/tmp/swift/storage-init.sh"], Exec["rsync-init"]]
    }
}

class swift_storage::uninstall {
    package {
        ["swift-account", "swift-container", "swift-object", "xfsprogs", "rsync"]:
           ensure => purged,
           require => Exec["storage-uninit.sh"] 
    }

    file {
       "/tmp/swift/storage-uninit.sh":
           source => "puppet:///$swift_files_rel_dir/storage-uninit.sh"
    }

    exec {
        "/tmp/swift/storage-uninit.sh $storage_path $storage_dev 2>&1":
            alias => "storage-uninit.sh",
            require => File["/tmp/swift/storage-uninit.sh"]
    }
}
