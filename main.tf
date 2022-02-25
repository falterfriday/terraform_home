/**********************************************************
 *
 * Proxmox Home - Infra as Code (IaC)
 * Location: ./main.tf
 *
 * Description:
 *  - Starting point for Home Terraform IaC
 *
 * Listening To:
 *  - Saliva: Every Six Seconds
 * 
 *********************************************************/

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.6"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true

  pm_debug      = true
  pm_log_enable = true
  pm_log_file   = "tf-plugin-proxmox.log"
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}