# Store Terraform State in Azure Storage

This repository contains an example of how you can provision and configure Terraform to store state in an Azure Storage Account, using nothing but Terraform itself.

## Overview

The provided Terraform file will:
* Create an Azure Resource Group
* Create an Azure Storage Account
* Create a Container inside of the Azure Storage Account
* Migrate the local TF State file to the new Azure Storage Account Container

## Preqrequisites

* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) (used `v1.1.7` for this example)
* An Azure subscription. If you do not have an Azure account, you can [create one now](https://azure.microsoft.com/en-us/free/).
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (used `v2.34.1` for this example)

## The Process

### First make sure you're logged in to Azure CLI

1. In a terminal, use the Azure CLI to login by typing: `az login`

* For more information on this login process, please [see this page](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli).
* If you end up automating any of this eventually, you should use an Azure Service Principal or Managed Identity to execute all of your Terraform actions, [see this page](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#creating-a-service-principal-using-the-azure-cli).

### Provision Resource Group and Storage Account

1. Take a look at the `main.tf` file and adjust values accordingly
2. Run `terraform init` to download provider(s)
3. Run `terraform apply` to run configuration against Azure

### Move Local TF State into Azure Storage Account Container

1. Uncomment the `backend { ... }` configuration section and update it to reflect your own values
2. Run `terraform init` again to re-initialize using the newly uncommented Azure Storage Account backend.
3. Answer `yes` to migrate your local `*.tfstate` file to the Azure Storage Account backend.
4. That's it! Check the Container in your Azure Storage Account and you should see the TF State file there now.

### Using same Storage Account Container for other projects

Going forward in your future projects, simply include the same `backend { ... }` configuration block in those files and you're good to go! (Granted you're still logged-in via Azure CLI properly of course)

## Notes

* Obviously you'll want to change the `main.tf` to use any variables, naming conventions, etc. that you're accustomed to in your own environment. This repo simply shows that this process works and can be a viable option to get your state files into remote storage easily.
* I provision this set of resources separately from others, as my TF State files may not always come from a single project; rather I forsee having many TF State files spawned from many projects that all have differing lifecycles and lifetimes. (e.g. I plan on deploying Azure DNS resources in another set of TF configurations, and those will have their own TF State that repsents their own indepent lifecycle)
* You could also create the Storage Account initially using something like Azure CLI, but I decided to try and use as much of Terraform as possible to reduce my tool sprawl. In the event I want to use AWS as my backend, this keeps things as simple as possible.
* These are not the official templates I use in my own personal configurations. I'm providing these simply as an example to help jump-start other folks. As always, check Best Practices guides for Terraform and Azure, as they change over time.