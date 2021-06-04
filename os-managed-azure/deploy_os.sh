export RESOURCEGROUP=fiserv_rg
export LOCATION=eastus
export CLUSTER=fiserv_os
export DOMAIN=la-cucaracha.net

# Follow Steps here: https://docs.microsoft.com/en-us/azure/openshift/tutorial-create-cluster

# Create Resource Group
az group create --name $RESOURCEGROUP --location $LOCATION

# Create Network
az network vnet create --resource-group $RESOURCEGROUP --name aro-vnet --address-prefixes 10.0.0.0/22

# Subnet for masters
az network vnet subnet create \
  --resource-group $RESOURCEGROUP \
  --vnet-name aro-vnet \
  --name master-subnet \
  --address-prefixes 10.0.0.0/23 \
  --service-endpoints Microsoft.ContainerRegistry

# Subnet for workers
az network vnet subnet create \
  --resource-group $RESOURCEGROUP \
  --vnet-name aro-vnet \
  --name worker-subnet \
  --address-prefixes 10.0.2.0/23 \
  --service-endpoints Microsoft.ContainerRegistry

# Disable subnet private endpoint policies
az network vnet subnet update \
  --name master-subnet \
  --resource-group $RESOURCEGROUP \
  --vnet-name aro-vnet \
  --disable-private-link-service-network-policies true

# Create Cluster
az aro create \
  --resource-group $RESOURCEGROUP \
  --name $CLUSTER \
  --vnet aro-vnet \
  --master-subnet master-subnet \
  --worker-subnet worker-subnet \
  --pull-secret @pull-secret.txt \
#  --domain $DOMAIN

# Connect to Cluster: https://docs.microsoft.com/en-us/azure/openshift/tutorial-connect-cluster
az aro list-credentials \
  --name $CLUSTER \
  --resource-group $RESOURCEGROUP

# Get console URL
az aro show \
  --name $CLUSTER \
  --resource-group $RESOURCEGROUP \
  --query "consoleProfile.url" -o tsv

######################
### CUSTOM DOMAIN ###
######################

## Get DNS entries
#az aro show -n fiserv_os -g fiserv_rg --query '{api:apiserverProfile.ip, ingress:ingressProfiles[0].ip}'
## "api": "20.72.187.49",
## "ingress": "20.72.189.59"
## Create DNS Zone for domain

#az network private-dns zone create -g $RESOURCEGROUP -n $DOMAIN
#az network dns record-set a add-record -g $RESOURCEGROUP -z $DOMAIN -n api -a 20.72.187.49
#az network dns record-set a add-record -g $RESOURCEGROUP -z $DOMAIN -n ingress -a 20.72.189.59

######################
######################


apiServer=$(az aro show -g $RESOURCEGROUP -n $CLUSTER --query apiserverProfile.url -o tsv)

oc login $apiServer -u kubeadmin -p
