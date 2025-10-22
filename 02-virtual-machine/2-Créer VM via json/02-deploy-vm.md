# Deploy Azure VM using Arm templates

### Create resource group if it does not exist 

```
az group create --name vscode --location 'Central US'
```

### Create virtual machine

Switch to the folder where you have the `01-create-vm.json` file available.

```
az deployment group create --resource-group vscode --template-file 01-create-vm.json
```

Se connecter sur la VM : 


IAM de la VM :
 
ajouter le user à l'un des groupes RBAC suivants : 

 Virtual Machine Administrator Login → droits administrateur
 Virtual Machine User Login → droits utilisateur standard

 Accès RDP : AzureAD\admin@couldsky.com

  dsregcmd /status (AzureAdJoined : YES)