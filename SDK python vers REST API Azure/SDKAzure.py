import os
from azure.identity import ClientSecretCredential
from azure.mgmt.compute import ComputeManagementClient

# Récupérer depuis les variables d'environnement
tenant_id = os.environ["AZURE_TENANT_ID"]
client_id = os.environ["AZURE_CLIENT_ID"]
client_secret = os.environ["AZURE_CLIENT_SECRET"]
subscription_id = os.environ["AZURE_SUBSCRIPTION_ID"]

# Auth via Service Principal
credential = ClientSecretCredential(tenant_id, client_id, client_secret)
client = ComputeManagementClient(credential, subscription_id)

# Lister les VM
for vm in client.virtual_machines.list_all():
    print(vm.name)
    
