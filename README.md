# Introduction

### Readme in progress

### Steps

terraform plan -target=module.vault
terraform apply -target=module.vault
export VAULT_ADDR="$(terraform output vault_addr)"
export VAULT_CACERT="$(pwd)/ca.crt"

Follow steps described in [terraform-google-module](https://registry.terraform.io/modules/terraform-google-modules/vault/google/latest#usage)

vault operator init \
 -recovery-shares 5 \
 -recovery-threshold 3

The Vault servers will automatically unseal using the Google Cloud KMS key created earlier. The recovery shares are to be given to operators to unseal the Vault nodes in case Cloud KMS is unavailable in a disaster recovery. They can also be used to generate a new root token. Distribute these keys to trusted people on your team (like people who will be on-call and responsible for maintaining Vault).

_Save this initial root token and do not clear your history. You will need this token to continue the tutorial._
vault login
vault secrets enable -path=ssh-client-signer ssh

vault write ssh-client-signer/config/ca \
 private_key=@/home/gev/.ssh/gcplabcakey \
 public_key=@/home/gev/.ssh/gcplabcakey.pub

add the key to the machine

vault write ssh-client-signer/roles/my-role -<<"EOH"
{
"algorithm_signer": "rsa-sha2-256",
"allow_user_certificates": true,
"allowed_users": "\*",
"allowed_extensions": "permit-pty,permit-port-forwarding",
"default_extensions": {
"permit-pty": ""
},
"key_type": "ca",
"default_user": "ubuntu",
"ttl": "30m0s"
}
EOH

generate a key
ssh-keygen -t rsa -C "user@example.com"

sign the key
vault write ssh-client-signer/sign/my-role \
 public_key=@$HOME/.ssh/id_rsa.pub

save it
vault write -field=signed_key ssh-client-signer/sign/my-role \
 public_key=@$HOME/.ssh/id_rsa.pub > signed-cert.pub

vault operator init \
 -recovery-shares 5 \
 -recovery-threshold 3
vault login
vault secrets enable -path=ssh-client-signer ssh

vault write ssh-client-signer/config/ca \
    private_key=@/home/gev/.ssh/gcplabcakey \
    public_key=@/home/gev/.ssh/gcplabcakey.pub

```text
vault write ssh-client-signer/roles/my-role -<<"EOH"
{
  "algorithm_signer": "rsa-sha2-256",
  "allow_user_certificates": true,
  "allowed_users": "*",
  "allowed_extensions": "permit-pty,permit-port-forwarding",
  "default_extensions": {
    "permit-pty": ""
  },
  "key_type": "ca",
  "default_user": "gevorg",
  "ttl": "30m0s"
}
EOH
```
