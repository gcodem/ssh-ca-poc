# Introduction

### Readme in progress

## Signed SSH Certificates

[Hashicorp Vault:](https://developer.hashicorp.com/vault/docs/secrets/ssh/signed-ssh-certificates)

> The signed SSH certificates is the simplest and most powerful in terms of setup complexity and in terms of being platform agnostic. By leveraging Vault's powerful CA capabilities and functionality built into OpenSSH, clients can SSH into target hosts using their own local SSH keys.
> In this section, the term "client" refers to the person or machine performing the SSH operation. The "host" refers to the target machine. If this is confusing, substitute "client" with "user".
> This page will show a quick start for this secrets engine. For detailed documentation on every path, use vault path-help after mounting the secrets engine.

Code is leveraging the `terraform-google-module` for fast and easy deployment of "production ready" Vault deployment. More information on the usage and configuration can be found [here](https://github.com/terraform-google-modules/terraform-google-vault#vault-on-gce-terraform-module)

[terraform-google-module](https://registry.terraform.io/modules/terraform-google-modules/vault/google/latest#usage)

### Usage

You can deploy the modules separately using `terraform apply -target=module.servers or module.vault` - this is useful for creating and configuring the vault as a CA to then populate `servers-script.sh` with desired values. This is **not a good practice** however and I utilize it only for my development environment and saving time. Normally I would use CI, custom VM image or configuration management tool to add the`trusted-user-ca-keys.pem, ssh_host_rsa_key-cert.pub` and for adding the `TrustedUserCAKeys, HostCertificate and HostKey` to `/etc/ssh/sshd_config`

After deploying vault with `terraform apply -target=module.vault` code, follow the steps as described in the module README - [here](https://github.com/terraform-google-modules/terraform-google-vault#usage).

> The Vault servers will automatically unseal using the Google Cloud KMS
> key created earlier. The recovery shares are to be given to operators
> to unseal the Vault nodes in case Cloud KMS is unavailable in a
> disaster recovery. They can also be used to generate a new root token.
> Distribute these keys to trusted people on your team (like people who
> will be on-call and responsible for maintaining Vault).

Follow the steps described in Hashicorp readme
[Signing Key & Role Configuration](https://developer.hashicorp.com/vault/docs/secrets/ssh/signed-ssh-certificates#signing-key-role-configuration)

```text
vault read -field=public_key ssh-client-signer/config/ca
```

When you reach this step, you can put it's value into the `servers-script.sh` which is a startup script to create `/etc/ssh/trusted-user-ca-keys.pem` on the host machines.

Similarly with the Host Key Signing, create the `ssh_host_rsa_key-cert.pub` and put it into the startup script. Run `servers` module with terraform to deploy virtual machines. If you populated the startup script you should be able to ssh into every google compute engine VM with `ssh -i signed-cert.pub -i ~/.ssh/id_rsa username@CE_VM_IP`

## Host Key Signing

In progress.
