export RESOURCEGROUP=fiserv_rg
export CLUSTER=fiserv_os

az aro delete --resource-group $RESOURCEGROUP --name $CLUSTER
