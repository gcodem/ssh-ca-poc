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
  storage_bucket_force_destroy = true
  load_balancing_scheme        = var.load_balancing_scheme
  allow_public_egress          = var.allow_public_egress
}

output "vault_addr" {
  value = module.vault.vault_addr
}
