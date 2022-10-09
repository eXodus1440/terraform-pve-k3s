variable "pm_api_url" { default = "https://<PROXMOX IP>:8006/api2/json" }
variable "pm_user" { default = "root@pam" }
variable "pm_password" {
  default = "root@pam"
  sensitive = true
}

variable "searchdomain" { default = "example.com" }
variable "nameserver" { default = "172.16.0.2" }
variable "gateway" { default = "172.16.0.1"}
variable "ipaddr_network" { default = "172.16.0"}
variable "cidr" { default = "24" }
variable "sshkeys" { default = "~/.ssh/rsa.pub" }
variable "private_key" { default = "~/.ssh/rsa" }

// Cloud-init config
variable "ciuser" { default = "ubuntu" }
variable "cipassword" {
  default = "BasicVMqemu"
  sensitive = true
}

variable "configuration" {
  description = "The total configuration, List of Objects/Dictionary"
  default = [{}]
}
