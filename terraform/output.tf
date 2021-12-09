resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl", {
    db_ip   = module.db_server.public_ip,
    uat_ip  = module.uat_server.public_ip,
    prod_ip = module.prod_server.public_ip,
    demo_ip = module.demo_server.public_ip,
    key_path = var.key_path
  })
  filename = "inventory"
}