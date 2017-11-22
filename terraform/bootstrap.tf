data "template_cloudinit_config" "bootstrap_saltmaster" {
    base64_encode = false
    gzip = false

    part {
        content_type = "text/cloud-config"
        content      = "${file("bootstrap/user_data.yaml")}"
    }

    part {
        content_type = "text/x-shellscript"
        content      = "${file("bootstrap/salt-master.sh")}"
    }
}

data "template_cloudinit_config" "bootstrap_saltminion" {
    base64_encode = false
    gzip = false

    part {
        content_type = "text/cloud-config"
        content      = "${file("bootstrap/user_data.yaml")}"
    }

    part {
        content_type = "text/x-shellscript"
        content      = "${file("bootstrap/salt-minion.sh")}"
    }
}
