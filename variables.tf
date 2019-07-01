# azure service principal info
variable "subscription_id" {
  default = "_add_here_"
}

# client_id or app_id
variable "client_id" {
  default = "_add_here_"
}

variable "client_secret" {
  default = "_add_here_"
}

# tenant_id or directory_id
variable "tenant_id" {
  default = "_add_here_"
}

# admin password
variable "admin_username" {
  default = "azureuser"
}

variable "admin_keydata" {
  default = "add_here"
}

variable "admin_password" {
  default = "_C0mples_p@ssword_"
}

# service variables
variable "rgname" {
  default = "test-dnc"
}

variable "prefix" {
  default = "jmeter"
}

variable "location" {
  default = "koreacentral"
}

variable "vnetname" {
  default = "jmetervnet"
}

variable "subnetname" {
  default = "agtsubnet"
}

variable "vmsize" {
  default = "Standard_DS1_v2"
}

variable "osimageuri" {
  default = "add_here"
}

variable "agtcount" {
  default = 2
}

variable "tag" {
  default = "jmeter"
}

variable "vmscript" {
  default = "./vmscript.sh"
}
