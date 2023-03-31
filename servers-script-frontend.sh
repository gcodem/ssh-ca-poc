#!/bin/bash

apt update && apt install gpg
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install vault

echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDY2WJPio/KSWo6+AnD0O0wElDu/ghLnr9tIUPBrW9NmLgSaib8+vBHuVeTcOTpo6kUY0H3jIfEquwX35yeV9LLCtyTqNOfaE53AUQ2yenSw+VvB1PMte07nrfgRla/EZqRy3CnOXzOJ6xBBRy8LoLdmb65QEZdUjkGKVqTw+cuCjcMZxrH/lL8rN/uLoI1X/vb9T1hNAnSIlsn8M/spZMtsT/IeIgLsBt6/66FRc4gM91Ef7z3Im94H2R/hLOxEKbxR6Cveuo+eEO5tCT+Nh4+d9OIPf6ncNs5zigGwmRUd+JXz4zNygcFdBEImpnHJdINERQfjQvXrIHPeXXrWGWf2osngPD+e5XfjJFZCpO9qDEXtyL19+jedHDzSeItkXmiBv3zHjqG43MbHzEzA/evDlFt/anA+WOaYBE7wEtc3uDF0PRkLqSRnrwcTfq0HROdHFcUtuOUCDAuQhHziwZtTH0jXkxHCvpdZ4HbKFVa6VQ5/W5TW0D3c9KU2zTHbdQKQ1ZhBmLkO3dFWAsD7XRrqFkwWjP0cEu0JNPuuQlbaUH3O1ebE6OY5mxOrCt4nP4qs/mANWpHjSXr+7pAewQUzYX9aigjFHD/+b82OkTJ4TJE/J6vFU7QbGMRutl+tVBPxbNUAul61zrigFsA8H1avzjZ2sbhINzGVV7JlDdzlw==' > /etc/ssh/trusted-user-ca-keys.pem

mkdir /etc/ssh/auth_principals
sudo echo 'ubuntu' > /etc/ssh/auth_principals/ubuntu
sudo echo 'frontend' > /etc/ssh/auth_principals/frontend
echo 'AuthorizedPrincipalsFile /etc/ssh/auth_principals/%u' >> /etc/ssh/sshd_config
echo 'TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem' >> /etc/ssh/sshd_config
echo 'HostKey /etc/ssh/ssh_host_rsa_key' >> /etc/ssh/sshd_config
echo 'HostCertificate /etc/ssh/ssh_host_rsa_key-cert.pub' >> /etc/ssh/sshd_config
chmod 0640 /etc/ssh/ssh_host_rsa_key-cert.pub
systemctl restart ssh

curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
sudo systemctl restart google-cloud-ops-agent.target
