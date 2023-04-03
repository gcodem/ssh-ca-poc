provider "google" {
  credentials = file(var.credentials)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

module "servers" {
  source = "./servers"
  ssh_key = var.ssh_key
  vm_count = 2
}

module "vault" {
  source                       = "terraform-google-modules/vault/google"
  project_id                   = var.project_id
  region                       = var.region
  kms_keyring                  = var.kms_keyring
  kms_crypto_key               = var.kms_crypto_key
  user_startup_script          = "vault-server-script.sh"
}

output "vault_addr" {
  value = module.vault.vault_addr
}
