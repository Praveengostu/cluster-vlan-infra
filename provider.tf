################################################
# Configure the IBM Cloud Provider
################################################
provider "ibm" {
  ibmcloud_api_key   = "${var.ibm_bmx_api_key}"
  softlayer_username = "${var.sl_user_name}"
  softlayer_api_key  = "${var.sl_api_key}"
  region             = "${var.region}"
}
