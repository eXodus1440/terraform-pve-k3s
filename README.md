# terraform-pve-k3s
Deploying k3s master and worker nodes into Proxmox with Terraform

References used to create this configuration
- https://www.middlewareinventory.com/blog/terraform-create-multiple-ec2-different-config/
- https://www.middlewareinventory.com/blog/terraform-ebs_block_device-example/
- https://github.com/AKSarav/Terraform-Count-ForEach

Initalise terraform
```bash
terraform init
```

Create a tfvars file and populate it with your variables
```bash
cat << 'EOF' > k3s.auto.tfvars
pm_api_url = "https://<PROXMOX IP>:8006/api2/json"
pm_user = "root@pam"
pm_password = "root@pam"
searchdomain = "example.com"
nameserver = "192.168.0.2"
sshkeys = "~/.ssh/rsa.pub"
private_key = "~/.ssh/rsa"
ciuser = "ubuntu"
cipassword = "BasicVMqemu"
EOF
```

Creates an execution plan to preview the changes
```bash
terraform plan --var-file=k3s.tfvars
```

Apply the proposed changes
```bash
terraform apply --var-file=k3s.tfvars
```

To delete all remote objects managed by a particular Terraform configuration
```bash
terraform destroy --var-file=k3s.tfvars
```