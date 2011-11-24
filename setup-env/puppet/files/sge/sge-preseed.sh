#!/bin/bash

#
# Copyright 2011 National Institute of Informatics.
#
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

MASTER_NODE_NAME=$1
MY_HOSTNAME=`hostname`

cat <<SGE_PRESEED | debconf-set-selections
gridengine-client       shared/gridenginemaster string  $MASTER_NODE_NAME
gridengine-common       shared/gridenginemaster string  $MASTER_NODE_NAME
gridengine-master       shared/gridenginemaster string  $MASTER_NODE_NAME
gridengine-qmon         shared/gridenginemaster string  $MASTER_NODE_NAME
gridengine-exec         shared/gridenginemaster string  $MASTER_NODE_NAME
gridengine-client       shared/gridenginecell   string  default
gridengine-common       shared/gridenginecell   string  default
gridengine-master       shared/gridenginecell   string  default
gridengine-qmon         shared/gridenginecell   string  default
gridengine-exec         shared/gridenginecell   string  default
gridengine-client       shared/gridengineconfig boolean true
gridengine-common       shared/gridengineconfig boolean true
gridengine-master       shared/gridengineconfig boolean true
gridengine-exec         shared/gridengineconfig boolean true
gridengine-qmon         shared/gridengineconfig boolean true
postfix postfix/root_address            string
postfix postfix/rfc1035_violation       boolean false
postfix postfix/mydomain_warning        boolean
postfix postfix/mynetworks              string  127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
postfix postfix/mailname                string  $MY_HOSTNAME
postfix postfix/tlsmgr_upgrade_warning  boolean
postfix postfix/recipient_delim         string  +
postfix postfix/main_mailer_type        select  Local only
postfix postfix/destinations            string  $MY_HOSTNAME, localhost.localdomain, localhost
postfix postfix/retry_upgrade_warning   boolean
SGE_PRESEED
