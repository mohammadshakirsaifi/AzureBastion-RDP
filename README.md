# AzureBastion-RDP
Azure – RDP via Azure Bastion
```txt
“We provision the entire Windows Server stack using Terraform, starting with networking, enforcing no public IPs and no inbound RDP. Administrative access is provided through Azure Bastion, which acts as a managed RDP proxy over HTTPS. Access is controlled via Azure AD RBAC, and all activity is logged to Azure Monitor. This achieves the same security outcome as AWS Session Manager while aligning with Azure’s PaaS-first model.”
```
# Terraform Azure Windows Server (No Public RDP)
                    ┌─────────────────────────────┐
                    │        Admin / DevOps        │
                    │   Terraform CLI / Pipeline   │
                    └──────────────┬──────────────┘
                                   │
                          Terraform Apply
                                   │
         ┌─────────────────────────┴─────────────────────────┐
         │                     Azure                          │
         │                                                     │
         │  ┌───────────────┐       ┌─────────────────────┐  │
         │  │ Resource Group│──────▶│   Azure AD / RBAC    │  │
         │  └───────────────┘       └─────────────────────┘  │
         │                                                     │
         │  ┌──────────────────────── VNET ─────────────────┐ │
         │  │                                                 │ │
         │  │  ┌──────────────┐   ┌─────────────────────┐  │ │
         │  │  │ Workload     │   │ AzureBastionSubnet  │  │ │
         │  │  │ Subnet       │   │ (/26 mandatory)     │  │ │
         │  │  │              │   └──────────┬──────────┘  │ │
         │  │  │  ┌────────┐ │              │              │ │
         │  │  │  │ Windows│◀┼──────────────┘              │ │
         │  │  │  │ Server │ │   Bastion (PaaS)             │ │
         │  │  │  │  VM    │ │   RDP over HTTPS              │ │
         │  │  │  │ NO PIP │ │                               │ │
         │  │  │  └────────┘ │                               │ │
         │  │  │     ▲       │                               │ │
         │  │  │     │       │                               │ │
         │  │  │  NSG (No     │                               │ │
         │  │  │  inbound)   │                               │ │
         │  │  └─────────────┘                               │ │
         │  └────────────────────────────────────────────────┘ │
         │                                                     │
         │  Logs → Azure Monitor / Log Analytics               │
         └─────────────────────────────────────────────────────┘

This repository provisions a **secure Windows Server on Azure** using Terraform with:

- ❌ No Public IP on VM
- ❌ No inbound RDP (3389)
- ✅ Azure Bastion for secure access
- ✅ Azure AD + RBAC
- ✅ Centralized logging with Log Analytics

## Architecture
- Azure VNet with isolated subnets
- Azure Bastion (Standard SKU)
- Windows Server 2022
- NSG with zero inbound rules
### 🟦 Azure – RDP via Azure Bastion
┌──────────────────────────────┐
│        Admin / Engineer      │
│  Azure Portal / Native RDP  │
└──────────────┬───────────────┘
               │ HTTPS (443)
               ▼
┌──────────────────────────────┐
│       Azure Bastion          │
│   (Managed PaaS Service)    │
│ - Azure AD + RBAC            │
│ - Session recording          │
│ - Runs in VNet               │
└──────────────┬───────────────┘
               │ RDP (Private IP)
               ▼
┌──────────────────────────────┐
│      Windows VM              │
│  - NO Public IP              │
│  - No inbound NSG rules      │
│  - No agent required         │
└──────────────────────────────┘

## Prerequisites
- Azure subscription
- Azure CLI (`az login`)
- Terraform >= 1.5
- Azure AD user object ID
### 📁 Repository Structure
terraform-azure-windows/
├── README.md
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── network.tf
├── vm.tf
├── bastion.tf
├── rbac.tf
├── monitoring.tf
├── terraform.tfvars
└── modules/
    ├── network/
    ├── windows-vm/
    └── bastion/


## Usage

```bash
terraform init
terraform plan
terraform apply
```
### Access
- Azure Portal → VM → Connect → Bastion
- Security Model
- Comparable to AWS SSM Session Manager, but implemented as a managed network PaaS.

  ```txt
  “This Terraform project provisions a Windows Server on Azure with zero public exposure. RDP access is delivered via Azure Bastion over HTTPS, access is governed by Azure AD RBAC, and all activity is logged centrally. The design mirrors AWS Session Manager but follows Azure’s PaaS networking model.”
  ```
