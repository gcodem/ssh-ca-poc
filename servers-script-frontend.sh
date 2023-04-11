#!/bin/bash

apt update && apt install gpg
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install vault

echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCd8ElfXcYY47kFF2qkiAWN6r2e966id7nTahTdXTjTY1vzCQ/WBosdCSrv9cOzzyt2JtbI+518/L+P21l5irJBpbyCoIPU+N3kHDQdPerFRBJOm2A4l3tUl9so+v+Muk+ePljvxLdEDY5y+/oZOorasWiZ4nPlA+1ocYfv/ZlA8CZY88X13OjhdVBFnwgE4YUdjsAMdtavzLYxXjrFWflgKrLzL4xihKtqptn8TNpIA4usqtHSNOFgm2AumrQFdK6a6pSILFDRExZHKAUD4eGYpScJaEjiA9TzTpwXotYUBPX2KbFI/xWJ3Rzz2mg0mT64XkiVgc11duWagdOu5IoR2nmNiyIeSH02WuiJ7nDV077mgghTUkMdnhfT5hprYF0f6itoDockh3sJE1QhuS21njwiC70DR61ow7JQTSeyAW+negJ3WF69J6jjqNTAJLPBBnnmYlmvkTn+n0jpIWI7c8sKjlJKzyirGEGI6c3h+nnYC9TxOt9kMvWflWQ3vMcjVYnFVynfRI+L8/bL05MwBY+TVYAFAsOf+Qk91UdIkfQayk020/zSgYoLIwpncRu5UhHfmcd376RRYL2u12wUKFJK3/HL7z/dPk58KSsc/1BABF3ui4f8gyKTjqDVm2GFyrO4nV/dd9SATM5chpwEgs76TvXF76zAB42+9dIxtQ==' > /etc/ssh/trusted-user-ca-keys.pem

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
