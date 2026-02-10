# Azure – RDP via Azure Bastion

######  Azure Bastion is a fully managed PaaS service that provides secure and seamless RDP/SSH connectivity to your virtual machines directly over TLS from the Azure portal, or via the native SSH or RDP client already installed on your local computer. Azure Bastion is deployed directly in your virtual network and supports all VMs in the virtual network using private IP addresses. When you connect via Azure Bastion, your virtual machines don't need a public IP address, agent, or special client software.

###### We provision the entire Windows Server stack using Terraform, starting with networking, enforcing no public IPs and no inbound RDP. Administrative access is provided through Azure Bastion, which acts as a managed RDP proxy over HTTPS. Access is controlled via Azure AD RBAC, and all activity is logged to Azure Monitor. This achieves the same security outcome as AWS Session Manager while aligning with Azure’s PaaS-first model.

# Terraform Azure Windows Server (No Public RDP)
                    ┌─────────────────────────────┐
                    │        Admin / DevOps       │
                    │   Terraform CLI / Pipeline  │
                    └──────────────┬──────────────┘
                                   │
                          Terraform Apply
                                   │
         ┌─────────────────────────┴─────────────────────────┐
         │                     Azure                         │
         │                                                   │
         │  ┌───────────────┐        ┌─────────────────────┐ │
         │  │ Resource Group│──────▶│   Azure AD / RBAC   │ │
         │  └───────────────┘        └─────────────────────┘ │
         │                                                   │
         │  ┌──────────────────────── VNET ────────────────┐ │
         │  │                                              │ │ 
         │  │  ┌──────────────┐   ┌─────────────────────┐  │ │
         │  │  │ Workload     │   │ AzureBastionSubnet  │  │ │
         │  │  │ Subnet       │   │ (/26 mandatory)     │  │ │
         │  │  │              │   └──────────┬──────────┘  │ │
         │  │  │  ┌────────┐  │              │             │ │
         │  │  │  │ Windows│ ◀┼──────────────┘            │ │
         │  │  │  │ Server │ │   Bastion (PaaS)            │ │
         │  │  │  │  VM    │ │   RDP over HTTPS            │ │
         │  │  │  │ NO PIP │ │                             │ │
         │  │  │  └────────┘ │                             │ │
         │  │  │     ▲       │                             │ │
         │  │  │     │       │                             │ │
         │  │  │  NSG (No    │                             │ │
         │  │  │  inbound)   │                             │ │
         │  │  └─────────────┘                             │ │
         │  └──────────────────────────────────────────────┘ │
         │                                                   │
         │  Logs → Azure Monitor / Log Analytics             │
         └───────────────────────────────────────────────────┘

This repository provisions a **secure Windows Server on Azure** using Terraform with:

- ❌ No Public IP on VM
- ❌ No inbound RDP (3389)
- ✅ Azure Bastion for secure access
- ✅ Azure AD + RBAC
- ✅ Centralized logging with Log Analytics

## Architecture
  - **bastion Overview** https://learn.microsoft.com/en-us/azure/bastion/bastion-overview
  - **Bastion Private-Only-Architecture** https://learn.microsoft.com/en-us/azure/bastion/media/private-only-deployment/private-only-architecture.png#lightbox
  - **Bastion Architecture**  https://learn.microsoft.com/en-us/azure/bastion/media/bastion-overview/architecture.png#lightbox
  - **Bastion Bastion-Shared-Pool**  https://learn.microsoft.com/en-us/azure/bastion/media/quickstart-developer/bastion-shared-pool.png
- Azure VNet with isolated subnets
- Azure Bastion (Standard SKU)  https://learn.microsoft.com/en-us/azure/bastion/bastion-sku-comparison 
- Azure Bastion pricing combines hourly SKU charges with outbound data transfer costs. Billing starts from the moment Bastion is deployed, regardless of usage. https://azure.microsoft.com/en-us/pricing/details/azure-bastion/
- Windows Server 2022
- NSG with zero inbound rules
### 🟦 Azure – RDP via Azure Bastion
```bash
┌──────────────────────────────┐
│        Admin / Engineer      │
│  Azure Portal / Native RDP   │
└──────────────┬───────────────┘
               │ HTTPS (443)
               ▼
┌──────────────────────────────┐
│       Azure Bastion          │
│   (Managed PaaS Service)     │
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
```
## Prerequisites
- Azure subscription
- Azure CLI (`az login`)
- Terraform >= 1.5
- Azure AD user object ID
### 📁 Repository Structure
```bash
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
```

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

 ###### This Terraform project provisions a Windows Server on Azure with zero public exposure. RDP access is delivered via Azure Bastion over HTTPS, access is governed by Azure AD RBAC, and all activity is logged centrally. The design mirrors AWS Session Manager but follows Azure’s PaaS networking model.
  
# Project Security Overview

##  📌 Critical Security Points

1. **Security Layering**  
   Security is enforced at both the **network** and **platform** layers.

2. **Managed Services**  
   Security controls are applied using **managed PaaS services**.

3. **Bastion Host Exposure**  
   The **bastion host** has a **public IP**, allowing external access.

4. **VM Isolation**  
   The **VM does not have a public IP**, ensuring it remains private.

5. **Access Path**  
   All access to the VM is routed **through the bastion host** for controlled entry.

## Summary
- Managed PaaS handles security at multiple layers.  
- The VM remains isolated with no direct public exposure.  
- The bastion acts as a secure gateway for access.


