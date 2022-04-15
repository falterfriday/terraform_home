variable "pm_api_token_id" {
  type = string
}
variable "pm_api_token_secret" {
  type = string
}
variable "pm_api_url" {
  type = string
}
variable "pm_template" {
  type = string
}
variable "pm_storage_pool" {
  type = string
}
variable "pm_storage_type" {
  type = string
}
variable "pm_ssh_pub_key" {
  type = string
}
variable "pm_dmz_ip_nameserver" {
  type = string
}
variable "pm_sandbox_ip_nameserver" {
  type = string
}
variable "ci_user" {
  type = string
}
variable "ci_password" {
  type = string
}
variable "vms" {
  description = "vm variables in a dictionary "
  type        = map(any)
}