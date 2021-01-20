+++
title = "Deploying to an Azure Container Instance"
weight = 8
template = "doc.html"
aliases = ["docs/using/azure-container-instance"]
+++

Urbit can be deployed as a [Docker Image](https://hub.docker.com/r/tloncorp/urbit). Microsoft's [Azure](https://azure.com) hosting service allows docker containers to be deployed without necessitating the management of underlying VM instances.

## Initialize your ship

When deploying a ship in a container, it is best to boot your ship locally and then copy your pier to the cloud storage which will be volume-mounted. Container-hosting services generally do not provide console access to individual containers.

In particular, you will want to run `+code` from your dojo locally before copying your pier to the cloud. Save the provided code, you will use it when signing into your ship's Landscape frontend or running API calls against it.

## Warnings

- We recommend deploying only moons or comets via this method, unless you are absolutely sure you know what you are doing. Mistakes in the deployment procedure can lead to data loss and/or require a breach.
- Landscape will be exposed via *insecure HTTP over the public internet*. Thus, this guide should only be used for experimentation or as a basis for creating more secure deployments, e.g. by deploying nginx with LetsEncrypt as a reverse proxy.

## Install `azure-cli` and log in

This guide assumes that you are running a recent version of a major Linux distribution.
Ensure that the [`azure-cli` package is installed](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) on your machine.

Log in to your Azure subscription:

```shell
az login
```

This should open a browser window for you to log in to your Azure account and select your subscription.
If not, it will print a URL to visit in your browser and a code for you to enter at that URL.
Once you have successfully logged in in the browser, the `az login` command should complete in the terminal.

## Create a resource group

All Azure resources must be part of a resource group. By creating a resource group just for your ship deployment,
it will be easy to remove all resources when you are done experimenting or if you decide to migrate
your ship elsewhere.

```shell
URBIT_AZ_RESOURCE_GROUP_NAME=sapmel-palnet-ritpub-sipsyl
URBIT_AZ_REGION=eastus # change to whichever Azure region seems best to you
az group create -n $URBIT_AZ_RESOURCE_GROUP_NAME -l $URBIT_AZ_REGION
```

## Create a storage account and file share

Azure storage resources share authentication credentials as part of storage accounts. Create a storage account
in the resource group we set up in the previous step:

```shell
URBIT_AZ_STORAGE_ACCOUNT_NAME=sapmelpalnetritpubsipsyl
az storage account create \
  --resource-group $URBIT_AZ_RESOURCE_GROUP_NAME \
  --name $URBIT_AZ_STORAGE_ACCOUNT_NAME \
  --location $URBIT_AZ_REGION
```

Create an Azure file share which will hold your ship's pier and be mounted to the container:

```shell
URBIT_AZ_SHARE_NAME=sapmel-palnet-ritpub-sipysl
az storage share create \
  --name $URBIT_AZ_SHARE_NAME \
  --account-name $URBIT_AZ_STORAGE_ACCOUNT_NAME
```

Get the storage key for the storage account and store it in a variable:

```shell
URBIT_AZ_STORAGE_KEY=$(az storage account keys list --resource-group $URBIT_AZ_RESOURCE_GROUP_NAME --account-name $URBIT_AZ_STORAGE_ACCOUNT_NAME --query "[0].value" --output tsv)
```

## Copy the urbit ship to the file share

The Azure CLI has a convenient command for copying files to a file share:

Assuming your pier (the directory containing the data for your ship) is in e.g. `sapmel-palnet-ritpub-sipsyl`:

```shell
az storage file upload-batch \
  --source sapmel-palnet-ritpub-sipsyl \
  --destination $URBIT_AZ_SHARE_NAME \
  --account-name $URBIT_AZ_STORAGE_ACCOUNT_NAME \
  --destination-path sapmel-palnet-ritpub-sipsyl
```

## Start an ACI container
Download the [`urbit-azure.jq`](urbit-azure.jq) JQ filter.
We will use this JQ filter to create the YAML description for our ACI deployment.
(Recall that YAML is a superset of JSON, so we can use JSON tooling to create valid YAML.)

Pass the environment variables from before as arguments to the filter.

```shell
jq -n -f urbit-azure.jq \
  --arg SHIPNAME sapmel-palnet-ritpub-sipsyl \
  --arg SHARENAME $URBIT_AZ_SHARE_NAME \
  --arg STORAGEACCOUNTNAME $URBIT_AZ_STORAGE_ACCOUNT_NAME \
  --arg STORAGEACCOUNTKEY $URBIT_AZ_STORAGE_KEY \
  > urbit-azure.yaml
```

Create an azure container in your resource group using the spec:

```shell
az container create -g $URBIT_AZ_RESOURCE_GROUP_NAME --file urbit-azure.yaml
```

## Access your ship

Once the `az container create` command finishes, the output will include a public DNS name.
Since the container maps your ship's HTTP interface on port 80, you can simply browse to this DNS name in a web browser and authenticate using the code you obtained earlier.

**Remember, this is an *insecure* HTTP connection.**

## Parting thoughts
Setting up an HTTPS proxy for Urbit is beyond the scope of this tutorial, but an easy and standard way to approach the problem would be to configure an [Azure Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/) instance in front of your Azure Container Instance runing your Urbit ship, and configure the application gateway for SSL.
