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
$work_dir = "/tmp"

Exec {
    path => "/usr/bin:/bin:/usr/sbin:/sbin:$work_dir:/usr/local/bin",
		logoutput => true,
    cwd => "$work_dir"
}

File {
    owner => root,
    group => root,
    mode => 777
}

import "packages/*.pp"

