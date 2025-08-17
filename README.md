# azure-dev-vm-terraform

[![Terraform](https://img.shields.io/badge/Terraform-≥1.5-blueviolet?logo=terraform)](https://www.terraform.io/)  
[![Azure](https://img.shields.io/badge/Azure-Cloud-blue?logo=microsoft-azure)](https://azure.microsoft.com/)  
[![OS](https://img.shields.io/badge/OS-Windows%2011%20%7C%20Ubuntu-green?logo=windows)](#)  
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Terraform Azure DevBox** is an Infrastructure-as-Code (IaC) solution that provisions a fully configured cloud development environment in Microsoft Azure. It automates the creation of networking resources, secure access, and developer-ready virtual machines (Windows or Linux), with pre-installed tools to help you start coding immediately.

---

## 🚀 Features
- Automated setup of Azure Virtual Network, Subnet, and Public IP
- Provisioning of **Windows 11** or **Ubuntu** virtual machines (configurable)
- Pre-installation of popular development tools:
    - Git
    - IntelliJ IDEA
    - Docker / Kubernetes CLI
    - Helm
    - Azure CLI
- Automatic cloning of public/private Git repositories on first boot
- Optional integration with **Azure Key Vault** for secret management
- Cost optimization with **Spot VM** support (up to 70% savings with eviction risk)

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
   ```bash 
   terraform init
3. Plan and apply:
   ```bash
   terraform plan
   terraform apply -auto-approve
   
4. Connect to your VM:
   ```bash 
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
