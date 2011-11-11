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

$glance_templates_dir = "${proposal_id}"

class glance::install {
    package { [glance, "python-httplib2", "python-swift"]:}

    file {
        "/etc/glance/glance-api.conf":
            content => template("$glance_templates_dir/etc/glance/glance-api.conf.erb"),
            mode => 644,
            alias => "glance-api",
            require => Package["glance"];

        "/etc/glance/glance-registry.conf":
            content => template("$glance_templates_dir/etc/glance/glance-registry.conf.erb"),
            mode => 644,
            alias => "glance-registry",
            require => Package["glance"];
    }

    exec {
        "stop glance-api; stop glance-registry; start glance-api; start glance-registry":
             require => File["glance-api", "glance-registry"];
    }
}

class glance::uninstall {
    package {
        ["glance"]:
            ensure => purged;
    }

    exec {
        "rm -rf /var/lib/glance/*":
            require => Package[glance]
    }
}

class glance::test {
    file {
        "/tmp/glance":
            ensure => directory,
            mode => 644
    }   

    file {
        "/tmp/glance/test.sh":
            alias => "test.sh",
            source => "puppet:///files/glance/test.sh",
            require => File["/tmp/glance"]
    }

    exec {
        "/tmp/glance/test.sh 2>&1":
            alias => "test.sh",
            require => File["test.sh"],
    } 
}
