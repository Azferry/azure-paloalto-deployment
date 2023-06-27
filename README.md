# PaloAlto NVA Lab Deployment for Azure Enterprise Scale Landing Zones

This GitHub open-source project aims to provide a comprehensive lab environment for deploying and configuring PaloAlto Network Virtual Appliances (NVAs) on Azure. The primary objective is to use infrastructure as code to automate the process of management and configuration of the network security infrastructure, in an enterprise scale environment.
![palo_diagram](img/Diagram.png)

## Prerequisites

Before you begin, ensure that you have the following:

1. Access to an Azure subscription
   1. With Contributor Access - Deployment of resource group and accept marketplace agreements.
2. Basic knowledge of Terraform

## Deployment Steps

### Azure Resources Deployment

Follow the steps below to deploy the Azure Resources:

1. Clone the GitHub repository
2. Change to the directory ```cd .\palo-deploy```
3. Initialize the Terraform environment - ```terraform init```
4. Optional: modify the ```pavm01.json``` to fit to your environment.
5. Run ```terraform plan``` to validate the configuration.
6. Run ```terraform apply``` to create the resources in Azure.

### PaloAlto Configuration

Follow the steps below to deploy the configuration for the firewall:

1. Change to the directory ```cd .\palo-config```
2. Initialize the Terraform environment - ```terraform init```
3. Modify the Terraform files to include your specific configuration settings.
4. Run ```terraform plan``` to validate the configuration.
5. Run ```terraform apply``` to configure the palo.
6. Login to the firewall portal with the public IP or Public IP DNS
   1. Access Via Default DNS - ```https://<PUBLIC_IP_MGT_NIC_DNS>.<AZURE_REGION>.cloudapp.azure.com/php/login.php```
   2. Access Via IP - ```https://<PUBLIC_IP_MGT_NIC_IP>/php/login.php```
7. In the palo portal commit the changes terraform added

## Post-deployment Steps

After the deployment is complete, perform the following post-deployment steps:

1. Change the users password from the default
2. Create a service account for go forward configuration with terraform
3. Add Additional firewall policies and rules to the firewall.
4. Configure the management interface network security group to block all traffic except for allowed locations.
5. Configure the routing tables and virtual network gateways.
6. Test the connectivity and functionality of the firewall.

## Cleanup Lab Environment

This project uses the builtin terraform destroy command as a cleanup mechanism to remove all resources provisioned in azure for the lab. The cleanup process helps users avoid unnecessary costs and orphaned resources Azure environment.

```powershell
cd .\palo-deploy

terraform destroy
```

## Troubleshooting

### Test connectivity on interfaces

To test connectivity on each of the interfaces, login via SSH to the VM and use the ping command with the source IP of the nic.

```shell
## Ping for management interface
Ping host 8.8.8.8

## Ping for untrust interface
ping source <UnTurst_NIC_IP> host 8.8.8.8

## Ping for trust interface
ping source <Turst_NIC_IP> host 8.8.8.8
```

### azurerm_marketplace_agreement Out Of State

The marketplace agreement may have already been accepted causing terraform to error out. To get pass this import the object into the terraform state or comment out the object in the resource.standard.tf file.

![TF_MarketPlaceError](img/error-tfimport-makagreement.jpg)

## Contributions and Feedback

This project welcomes contributions and feedback from the open-source community. Whether it's bug reports, feature requests, or code contributions, all forms of participation are encouraged. Together, we can enhance the project's capabilities, address potential issues, and make it more valuable for users.
