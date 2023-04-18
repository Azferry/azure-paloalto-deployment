# azure-paloalto-deployment
Deploy and configure a PA-VM for azure using terraform. 



## Troubleshooting

### azurerm_marketplace_agreement Out Of State

The marketplace agreement may have already been accepted causing terraform to error out. To get pass this import the object into the terraform state or comment out the object in the resource.standard.tf file.

![TF_MarketPlaceError](img/error-tfimport-makagreement.jpg)
