# Spin up the Azure infrastructure using Bicep and AZ CLI

This guide is intended for engineers who are setting up Azure resources for the tabs-vs-spaces platform. The guide assumes that you have the Azure Command Line Interface (AZ CLI) installed and you have logged in per the instructions in the `README`   

## Step 1: Login with Azure CLI

Before anything else, open up your command line in the root of this project and login to your desired tenant like so:

```bash
az login -t {TENANT_ID} 
```

Next, you will need to set the subscription. Use the following in your terminal:

```bash
az account set -s {SUBSCRIPTION_ID}
```   

## Step 2: Creating the resource group

Create an `tabs-vs-spaces` Resource Group in the specified subscription above which contains all of the MCT Azure resources.  In the terminal, provide the following: 

```bash
az group create --location westus --name tabs-vs-spaces
```

This lock will prevent the resource group from being deleted accidentally.

## Step 3: Spin up the Azure resources with the main Bicep file

The next step is to run the `main.bicep` file to create all of the Azure resoureces.In the root of the project, run the following command:

```bash
az deployment group create --resource-group tabs-vs-spaces --template-file .azure/main.bicep --parameters .azure/parameters.json
```

This will create the following resources:

- [Azure Container Registry](./acr.bicep)
- [Container App Environment](./app-env.bicep)
- [Container App](./container-app.bicep)
- [App Insights](./insights.bicep)
- [Log Analytics](./main.bicep)