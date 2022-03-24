# AIPC-Course March 2022  

Place private key in workshop01 folder & add `terraform.tfstate`

## Course notes:  
### Terraform
providers.tf -> providers  
variables.tf -> declaration  
terraform.tfvars -> Set all sensitive variables here  

### Ansible  

`ansible-playbook -i inventory.yaml playbook.yaml`  
`ansible all -i inventory.yaml -m ping`  

Ansible - executes playbooks. There are 2 types of Ansible provisioner  
• ansible-local - run Ansible playbooks in the VM.  
• ansible - run Ansible playbooks on the local machine targeting the VM

### Packer  

`export PKR_VAR_region=“sgp1”`
`packer build -var-file=variables.pkrvars.hcl builder.pkr.hcl`  

Anisble provisioner creates a host alias called default. Just need to provide playbook