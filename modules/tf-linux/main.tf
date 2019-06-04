data "template_file" "instance_user_data" {
  template = "${var.user_data}"

  vars {
    device_name         = "${var.serverinfo["device_names"]}"
    mount_name          = "${var.serverinfo["mount_names"]}"
    ssh_public_key      = "${var.ssh_public_key}"
    ssh_private_key     = "${var.ssh_private_key}"
    storageacct         = "${var.storageacct}"
  }
}

data "template_file" "instance_aem_data" {
  template = "${file(var.aem_data)}"

  vars {
    storageacct         = "${var.storageacct}"
  }
}

resource "null_resource" "linux_server_instances_bootstrap_empty" {
  count      = "${var.serverscount}"
  depends_on = ["data.template_file.instance_user_data"]

  connection {
    host        = "${element(var.pub_ips, count.index)}"
    type        = "ssh"
    user        = "${var.os_user}"
    private_key = "${file(var.ssh_private_key)}"
  }

  provisioner "file" {
    content      = "${data.template_file.instance_user_data.rendered}"
    destination = "/tmp/linux-common.sh"
  }

  provisioner "file" {
    content      = "${data.template_file.instance_aem_data.rendered}"
    destination = "/tmp/buildaem.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/*.sh"
    ]
  }

}

output "done" {
 value      = "done"
 depends_on = ["null_resource.linux_server_instances_bootstrap_empty.*.id"]
}

resource "null_resource" "instancecount_server_instances" {
  count      = "${var.serverscount}"
  depends_on = ["null_resource.linux_server_instances_bootstrap_empty"]

  connection {
    host        = "${element(var.pub_ips, count.index)}"
    type        = "ssh"
    user        = "${var.os_user}"
    private_key = "${file(var.ssh_private_key)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo /tmp/linux-common.sh ${var.chef_project}"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chef-client -E ${var.environment} -o role[base]"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo /tmp/buildaem.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chef-client -E ${var.environment} -o role[${var.role}]"
    ]
  }
}

output "status" {
  value      = "status"
  depends_on = ["null_resource.instancecount_server_instances.*.id"]
}
