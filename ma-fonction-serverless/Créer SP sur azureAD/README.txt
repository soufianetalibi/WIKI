
 -Créer l'app registration "MonAppFrontEnd" sur AzureAD (via le script)

   az ad app list --display-name "MonAppFrontEnd" --query "[].{Name:displayName, AppId:appId}" -o table
         Name            AppId
         --------------  ------------------------------------
         MonAppFrontEnd  963957ad-f5c8-4c63-94a8-f9064daff06e
 - az ad app show --id 963957ad-f5c8-4c63-94a8-f9064daff06e --query identifierUris
 - az ad app update --id 963957ad-f5c8-4c63-94a8-f9064daff06e --identifier-uris "api://963957ad-f5c8-4c63-94a8-f9064daff06e"

 -Activer l'authentification azureAD au niveau de la fonction serverless "MaFonctionSQL" : 

$FUNC_APP_NAME="MaFonctionSQL"
$RESOURCE_GROUP="AgeFunctionRG"
$APP_REGISTRATION_ID="963957ad-f5c8-4c63-94a8-f9064daff06e"
$TENANT_ID="1324dfb4-4457-41c3-a943-293c61bbd70c"

az webapp auth update --name $FUNC_APP_NAME --resource-group $RESOURCE_GROUP --enabled true --action "LoginWithAzureActiveDirectory" --aad-allowed-token-audiences "api://$APP_REGISTRATION_ID" --aad-client-id $APP_REGISTRATION_ID --aad-token-issuer-url "https://sts.windows.net/$TENANT_ID/"

 Vérifier la config : 

 az webapp auth show --name $FUNC_APP_NAME --resource-group $RESOURCE_GROUP

========================
Tester l'appel de la fonction via un tocken Bearer AzureAD via cmd powershell : 

$FUNCTION_URL     = "https://mafonctionsql.azurewebsites.net/api/InsererUtilisateur"

====

$env:AZURE_TENANT_ID = "1324dfb4-4457-41c3-a943-293c61bbd70c"
$env:AZURE_CLIENT_ID = "963957ad-f5c8-4c63-94a8-f9064daff06e"
$env:AZURE_CLIENT_SECRET = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

Executer le script "Tester-fonction.ps1"