variable "resource_group_name" {
  type = string
  default = "dev-vm-rg"
}
variable "location" {
  type = string
  default = "Central US"
}
variable "vm_name" {
  type = string
  default = "dev-vm"
}
variable "admin_username" {
  type = string
  default = "root123"
}
variable "admin_password" {
  type = string
  default = "Helloworld@333"
}
