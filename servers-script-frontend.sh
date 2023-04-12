#!/bin/bash

apt update && apt install gpg
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install vault

echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVriU5r0LXQsf4Px3qOSaZeHxAgVdsnYSrPAsFoHVvG6DSpcbScDXaTcyuTBBN3YXGUFSmMRjQXLCHHp3M8LoZkyBiYJKN9U312Zi7PJJmgLzAQv/IQWKZcBTZgsiqXaGlBNXixj90EUd4te7KJXpLqMswE5bBx107KYDnvoEdx9H0wdXmzVT6tJ2S0WoFgSNHxRWlEfkmdEjRthsTEMx5dwmHGRiy1Aqa2jMBddHaYWtUiyzs9ig4Ov1pzW7S4kJmscarQKRijwh9fERAJw80+RAxh9B3kK+hr+egfmQ7l9gcBoD8hYvpzOBaD6n8IEYLI3z/vAkpkJvqTfzqmwKMYGW0Xw5aLPt9fUEpIJgU8hPpl7BM4rhnAyLimVqD5PJbCyhPDcDErJMTONgKOt2Y27VF3wx5VXFEOyrFgdygj91BlSkRjAfmuaxPdcGEDitGqUJH1vcXz3ivoOutMHWP9wczH8OvVSH5dxqfVPkKO33A6RLaII+9iUbAIalJP3YRwYkLtfso1bHgQqMItQfHQAA+GWtDrj6VFHis73mb64Je2aH1+DQVYP8OaTJ9Pprg8aUe3uD56QO1Itx5t8nRsUs/0D7pCe9UwPMbAa0wZ09aC+5D3QNUK3KiflCajlSqYhXbEunqo/m6FFyGeUM3MLTe7xuI9eTCweTRU2906w==' > /etc/ssh/trusted-user-ca-keys.pem

echo 'TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem' >> /etc/ssh/sshd_config
echo 'HostKey /etc/ssh/ssh_host_rsa_key' >> /etc/ssh/sshd_config
echo 'HostCertificate /etc/ssh/ssh_host_rsa_key-cert.pub' >> /etc/ssh/sshd_config
chmod 0640 /etc/ssh/ssh_host_rsa_key-cert.pub
systemctl restart ssh

#Groups and policies
mkdir /etc/ssh/auth_principals
sudo echo 'ubuntu' > /etc/ssh/auth_principals/ubuntu
sudo echo 'frontend' > /etc/ssh/auth_principals/frontend
echo 'AuthorizedPrincipalsFile /etc/ssh/auth_principals/%u' >> /etc/ssh/sshd_config
systemctl restart ssh

#Auditing servers
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
sudo systemctl restart google-cloud-ops-agent.target
