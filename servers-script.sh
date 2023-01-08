#!/bin/bash

echo '' > /etc/ssh/trusted-user-ca-keys.pem

echo '' > /etc/ssh/ssh_host_rsa_key-cert.pub


echo 'TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem' >> /etc/ssh/sshd_config
echo 'HostKey /etc/ssh/ssh_host_rsa_key' >> /etc/ssh/sshd_config
echo 'HostCertificate /etc/ssh/ssh_host_rsa_key-cert.pub' >> /etc/ssh/sshd_config
chmod 0640 /etc/ssh/ssh_host_rsa_key-cert.pub
systemctl restart ssh
