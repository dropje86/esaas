resource "openstack_compute_instance_v2" "consul" {
    region = "${var.region}"
    count = "1"
    flavor_name = "2C-2G-20G-V1-S"
    name = "${format("consul%03d", count.index+1)}"
    image_name = "ubuntu-trusty"
    key_pair = "${var.key_pair}"

    security_groups = [ "!!CHANGEME!!" ]

    user_data = "${data.template_cloudinit_config.bootstrap_saltminion.rendered}"
    availability_zone = "${format("zone%d", (count.index % 3) + 1)}"

    metadata {
      environment = "${var.environment}"
      region = "${var.region}"
      cluster = "default"
      role = "consul"
    }

    lifecycle {
      ignore_changes = ["image_name", "key_pair", "flavor_name", "user_data"]
    }
}
