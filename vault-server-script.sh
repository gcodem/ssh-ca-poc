#!/bin/bash

touch /var/log/vault_audit.log
touch /var/log/vault_audit.log
chmod 644 /var/log/vault_audit.log 
chown vault:vault /var/log/vault_audit.log
vault audit enable file file_path=/var/log/vault_audit.log