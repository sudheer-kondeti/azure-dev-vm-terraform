# azure-dev-vm-terraform
Terraform Azure DevBox is an IaC solution for provisioning a fully configured development environment in Microsoft Azure. It automates the creation of virtual networks, secure access and developer-ready virtual machines (Windows) using Terraform

# Terraform Azure DevBox

Provision a developer-ready Virtual Machine in Azure using Terraform.  
This project automates the creation of a Windows or Linux development VM, installs essential tools, and can optionally clone source code repositories.

---

## 🚀 Features
- Creates an Azure Virtual Network, Subnet, and Public IP  
- Provisions a Windows or Ubuntu VM (configurable)  
- Installs developer tools (Git, IntelliJ IDEA, Docker, Kubernetes CLI, Helm, Azure CLI, etc.)  
- Supports private/public repo cloning on first boot  
- Optional integration with Azure Key Vault for secure secrets  
- Supports Spot VM for lower cost (with eviction risk)

---

## 📂 Project Structure
├── main.tf # Core Terraform configuration
├── variables.tf # Input variables
├── outputs.tf # Outputs after provisioning
├── install-devtools.ps1 # (Optional) Windows script to install dev tools
└── README.md # Project documentation

---

## ⚙️ Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5  
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)  
- An Azure Subscription (Free or Paid)  
---

## 🛠 Usage

1. Clone this repo:
   ```bash
   git clone https://github.com/your-org/terraform-azure-devbox.git
   cd terraform-azure-
   
2. Initialize Terraform:
   terraform init
3. Plan and apply:
   terraform plan
   terraform apply -auto-approve
   
4. Connect to your VM:
   az vm list-ip-addresses --name dev-vm --resource-group dev-rg

💰 Cost Estimates
=
- Standard B4ms (Windows 11): ~$0.18/hour
- Standard B4ms (Ubuntu): ~$0.07/hour
- Spot VM discount: up to 70% cheaper (if available)

⚠️ Stop or deallocate the VM when not in use to avoid charges.

🔐 Security Notes
=
- Don’t hardcode credentials (e.g. GitHub PAT) in main.tf
- Use Azure Key Vault for secret management
- Restrict RDP/SSH to your IP only
