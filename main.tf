################################################
# Load cluster configuration to access it with
# the provisioner
################################################

data "ibm_container_cluster_config" "cluster_cfg" {
  cluster_name_id   = "${ibm_container_cluster.cluster.id}"
  config_dir        = "/tmp"
  region            = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
}

resource "ibm_network_vlan" "cluster_pub_vlan" {
  name       = "${var.c_pub_vlan}"
  datacenter = "${var.datacenter}"
  type       = "PUBLIC"
}

resource "ibm_network_vlan" "cluster_pri_vlan" {
  name       = "${var.c_pri_vlan}"
  datacenter = "${var.datacenter}"
  type       = "PRIVATE"
}

resource "ibm_network_vlan" "az_pub_vlan" {
  count      = "${length(var.zones)}"
  name       = "${var.az_pub_vlan}${count.index}"
  datacenter = "${element(var.zones,count.index)}"
  type       = "PUBLIC"
}

resource "ibm_network_vlan" "az_pri_vlan" {
  count      = "${length(var.zones)}"
  name       = "${var.az_pri_vlan}${count.index}"
  datacenter = "${element(var.zones,count.index)}"
  type       = "PRIVATE"
}

data "ibm_resource_group" "resource_group" {
  name = "${var.rg_name}"
}

################################################
# Create the cluster
################################################
resource "ibm_container_cluster" "cluster" {
  name               = "${var.cluster_name}"
  resource_group_id  = "${data.ibm_resource_group.resource_group.id}"
  region             = "${var.region}"
  datacenter         = "${var.datacenter}"
  update_all_workers = "false"
  machine_type       = "${var.machine_type}"
  isolation          = "${var.isolation}"
  disk_encryption    = "true"
  public_vlan_id     = "${ibm_network_vlan.cluster_pub_vlan.id}"
  private_vlan_id    = "${ibm_network_vlan.cluster_pri_vlan.id}"

  wait_time_minutes = "180"
}

resource "ibm_container_worker_pool" "worker_pool" {
  worker_pool_name  = "${var.wp_name}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  machine_type      = "${var.wp_machine_type}"
  cluster           = "${ibm_container_cluster.cluster.id}"
  region            = "${var.region}"
  size_per_zone     = "${var.size_per_zone}"
  hardware          = "shared"
  disk_encryption   = "true"

  //User can increase timeouts
  timeouts {
    update = "180m"
  }
}

resource "ibm_container_worker_pool_zone_attachment" "availability_zone" {
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  cluster           = "${ibm_container_cluster.cluster.id}"
  region            = "${var.region}"
  worker_pool       = "${element(split("/",ibm_container_worker_pool.worker_pool.id),1)}"
  zone              = "${var.datacenter}"
  public_vlan_id    = "${ibm_network_vlan.cluster_pub_vlan.id}"
  private_vlan_id   = "${ibm_network_vlan.cluster_pri_vlan.id}"

  timeouts {
    create = "180m"
  }
}

resource "ibm_container_worker_pool_zone_attachment" "availability_zone_1" {
  count             = "${length(var.zones)}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  cluster           = "${ibm_container_cluster.cluster.id}"
  region            = "${var.region}"
  worker_pool       = "${element(split("/",ibm_container_worker_pool.worker_pool.id),1)}"
  zone              = "${element(var.zones,count.index)}"
  private_vlan_id   = "${element(ibm_network_vlan.az_pri_vlan.*.id,count.index)}"
  public_vlan_id    = "${element(ibm_network_vlan.az_pub_vlan.*.id,count.index)}"

  timeouts {
    create = "180m"
  }
}

# EOF

