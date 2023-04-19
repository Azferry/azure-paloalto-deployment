# Introduction

 Provides step-by-step instructions for deploying a Palo Alto Firewall Network Virtual Appliance (NVA) in Microsoft Azure using Terraform.

## Prerequisites

Before you begin, ensure that you have the following:

1. A valid Azure subscription
2. Access to the Azure portal
3. A valid Palo Alto Firewall license
   1. The license allows the use of advanced features, basic traffic flows will work.
4. Basic knowledge of Terraform

## Deployment Steps

### Azure Resources

Follow the steps below to deploy the Azure Resources:

1. Clone the GitHub repository
2. Change to the directory ```cd .\palo-deploy```
3. Initialize the Terraform environment - ```terraform init```
4. Modify the Terraform files to include your specific configuration settings.
5. Run ```terraform plan``` to validate the configuration.
6. If the configuration is valid, run the command ```terraform apply``` to create the resources in Azure.

### Palo Configuration

Follow the steps below to deploy the configuration for the firewall:

1. Change to the directory ```cd .\palo-config```
2. Initialize the Terraform environment - ```terraform init```
3. Modify the Terraform files to include your specific configuration settings.
4. Run ```terraform plan``` to validate the configuration.
5. If the configuration is valid, run the command ```terraform apply``` to configure the palo.

## Post-deployment Steps

After the deployment is complete, perform the following post-deployment steps:

1. Change the users password from the default
2. Create a service account for go forward configuration with terraform
3. Configure the firewall policies and rules.
4. Configure the interfaces and zones.
5. Configure the routing tables and virtual network gateways.
6. Test the connectivity and functionality of the firewall.

## Troubleshooting

### azurerm_marketplace_agreement Out Of State

The marketplace agreement may have already been accepted causing terraform to error out. To get pass this import the object into the terraform state or comment out the object in the resource.standard.tf file.

![TF_MarketPlaceError](img/error-tfimport-makagreement.jpg)
