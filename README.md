# Tabs vs Spaces - API

A RESTful API that captures and provides scores for the game client for the _Tabs vs Spaces_ demo during [Breakout 254: Supercharging game dev with Microsoft's cloud native and AI technology](https://build.microsoft.com/en-US/sessions/d5961473-d046-4884-8c5c-6f917cfd9fe0). Built on Python with Flask, Docker, and Azure. 

**Disclaimer** - This repository and all associated repository are provided as-is and for demo purposes only. The goal of this repository, and related respository, is to demonstrate the value-add of cloud-native technologies and approaches during the inner game dev loop.

## Setup 
First, pull down the repo:

```bash
git clone git@github.com:max-at-microsoft/tabs-vs-spaces-api.git
cd tabs-vs-spaces-api/
```

Next, create a `.env` file in the the root of the project:

```env
COSMOS_ENDPOINT=XXX
COSMOS_KEY=XXX
COSMOS_DATABASE=tabsvsspaces
```

## One-time Azure setup
If you are starting from scratch, you will need to run a one time setup and standup Azure infrasturcture to support the release pipeline. If you have already done this, you can skip down to _Deployment_

Set your active AZ subscription to your personal:

```bash
az login
az account set --name {your_alias}
```

Here are the values you should use in your deployment:

| Environment Key | Value         |
| --------------- | ------------- |
| `Resource Group`| `tabs-vs-spaces` |
| `Location`      | `westus`     |
| `Cosmos Account`| `tabsvsspaces` |


### Setup the Resource Group
First, make sure the resource group is created:

```bash
az group create --location eastus  --name tabs-vs-spaces-api
```

This should create a resource group named `tabs-vs-spaces` in your current Azure subscription.

## Setup cosmosdb

Next run this in the root directory:

```bash
az deployment group create --resource-group tabs-vs-spaces --template-file .azure/cosmos-db.bicep
```

## Update your .env file
With your newly created resources, update your `.env` to use the values.

## Run the dev image locally:
To run the development harness locally with hot reloading, please run the following command:

```bash
docker compose up --build dev
```

This will run the app at [http://localhost:5001](http://localhost:5001)

## Run the release image locally:
To run the production harness locally, please run the following command:

```bash
docker compose up --build release
```

This will run the app at [http://localhost](http://localhost)


# Build and push latest release image
This will allow you to push your registry. Containers apps using latest tags will be updates upon a successful build.

```bash
az login
az acr login -n {REGISTRY_NAME}
az acr build --registry {REGISTRY_NAME} --image tabs-vs-spaces-api/release:latest .
```