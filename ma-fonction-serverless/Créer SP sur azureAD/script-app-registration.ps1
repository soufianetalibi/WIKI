# Variables
$APP_NAME = "MonAppFrontEnd"

# Créer App Registration
$APP = az ad app create --display-name $APP_NAME --sign-in-audience AzureADMyOrg --query "{AppId:appId}" -o json | ConvertFrom-Json
$APP_ID = $APP.AppId

# Créer Service Principal
az ad sp create --id $APP_ID | Out-Null

# Générer client secret
$CLIENT_SECRET = az ad app credential reset --id $APP_ID --display-name "${APP_NAME}_Secret" --years 2 --query password -o tsv

# Récupérer Tenant ID
$TENANT_ID = az account show --query tenantId -o tsv

Write-Host "Client ID : $APP_ID"
Write-Host "Client Secret : $CLIENT_SECRET"
Write-Host "Tenant ID : $TENANT_ID"
