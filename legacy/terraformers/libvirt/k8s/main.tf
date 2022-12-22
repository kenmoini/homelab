# HA Kubernetes on Libvirt

## Setup

### 1. Install the LibVirt Terraform Provider
###    There is a helper script in this repository at `bash_scripts/setup_libvirt_terraform_provider.sh`
###    Ensure to check for the latest version - there may be an easier to use the provider in the future
###
### 2. Set up SSH Authorized keys
###    Your local user (luser) will need to have an SSH key pair generated `ssh-keygen -t rsa -b 4096`
###    Then, `ssh-copy-id -i ~/.ssh/your_key_pair root@rocinante` and for target hosts
###
### 3. Run the SSH Agent
###    `eval $(ssh-agent -s)`
###    and then
###    `ssh-add ~/.ssh/your_key_pair`
###    
###    

#  Now you can continue to `terraform init && terraform plan`