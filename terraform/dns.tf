resource "openstack_dns_recordset_v2" "to_fabio" {
    region        = "${var.region}"
    zone_id       = "${var.zone_id}"
    name          = "*.${var.domain}."
    description   = "Wildcard record to fabio001"
    ttl           = 300
    type          = "CNAME"
    records       = ["fabio001.${var.domain}."]
}
