variable "ibm_bmx_api_key" {
  type        = "string"
  description = "Your IBM Cloud API Key "
}

variable "sl_user_name" {
  type        = "string"
  description = "Your SL User name "
}

variable "sl_api_key" {
  type        = "string"
  description = "Your SL API Key "
}

variable "rg_name" {
  type        = "string"
  description = "Resource group name"
}

variable "region" {
  type        = "string"
  description = "Bluemix region"
  default     = "us-south"
}

variable "cluster_name" {
  type        = "string"
  default     = "schematics-stage"
  description = "Your k8s cluster name"
}

variable "datacenter" {
  type        = "string"
  default     = "dal10"
  description = "Your datacenter. check with 'bx cs locations'"
}

variable "zones" {
  type    = "list"
  default = ["dal10", "dal12", "dal13"]
}

variable "wp_name" {
  default = "schematics-services"
}

variable "c_pub_vlan" {
  default = "schematics_pub_vlan"
}

variable "c_pri_vlan" {
  default = "schematics_pri_vlan"
}

variable "az_pub_vlan" {
  default = "schematics_pub_vlan"
}

variable "az_pri_vlan" {
  default = "schematics_pri_vlan"
}

variable "machine_type" {
  type        = "string"
  default     = "b3c.4x16"
  description = "Your desired machine types, check with 'bx cs machine-types <datacenter>'"
}

variable "wp_machine_type" {
  type        = "string"
  default     = "b3c.4x16"
  description = "machine types for control plane nodes"
}

variable "size_per_zone" {
  type        = "string"
  default     = "3"
  description = "Your desired number of nodes per zone in the ingress pool"
}

variable "isolation" {
  type        = "string"
  default     = "public"
  description = "public or private"
}
