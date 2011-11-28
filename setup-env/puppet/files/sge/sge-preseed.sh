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
MASTER_NODE=$1
echo "MASTER_NODE_NAME:$MASTER_NODE"

cat <<SGE_PRESEED | debconf-set-selections
gridengine-client	shared/gridenginemaster	string	$MASTER_NODE
gridengine-common	shared/gridenginemaster	string	$MASTER_NODE
gridengine-master	shared/gridenginemaster	string	$MASTER_NODE
gridengine-qmon	shared/gridenginemaster	string	$MASTER_NODE
gridengine-client	shared/gridenginecell	string	default
gridengine-common	shared/gridenginecell	string	default
gridengine-master	shared/gridenginecell	string	default
gridengine-qmon	shared/gridenginecell	string	default
gridengine-client	shared/gridengineconfig	boolean	true
gridengine-common	shared/gridengineconfig	boolean	true
gridengine-master	shared/gridengineconfig	boolean	true
gridengine-qmon	shared/gridengineconfig	boolean	true
postfix	postfix/root_address	string	
postfix	postfix/rfc1035_violation	boolean	false
postfix	postfix/mydomain_warning	boolean	
postfix	postfix/mynetworks	string	127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
postfix	postfix/mailname	string	/etc/mailname
postfix	postfix/tlsmgr_upgrade_warning	boolean	
postfix	postfix/recipient_delim	string	+
postfix	postfix/main_mailer_type	select	No configuration
postfix	postfix/destinations	string	
postfix	postfix/retry_upgrade_warning	boolean	
# Install postfix despite an unsupported kernel?
postfix	postfix/kernel_version_warning	boolean	
postfix	postfix/not_configured	error	
postfix	postfix/mailbox_limit	string	0
postfix	postfix/relayhost	string	
postfix	postfix/procmail	boolean	
postfix	postfix/bad_recipient_delimiter	error	
postfix	postfix/protocols	select	
postfix	postfix/chattr	boolean	false
SGE_PRESEED
