Invoke Azure REST API with curl
To make a REST API call to Azure is required an Authorization header, specifying a token. The token can be acquired in different ways.

1. Method1: Acquire token from resources.azure.com
When the user sign-in Azure management portal a token is issued. You can acquire the token in the web browser at the link:

https://resources.azure.com/api/token?plaintext=true  
2. Method2: Acquire token in powershell
Use the powershell command Get-AzAccessToken:

(Get-AzAccessToken).Token
3. Method3: Acquire token in Azure CLI
Use the Azure CLI az account get-access-token:

az account get-access-token --query "accessToken" --output tsv
3. Examples of Invoke Azure REST API
PUT a JSON file with curl:

curl -X PUT -H "Authorization:Bearer eyJ0eX..." -H "Content-Type: application/json" -d @JSON_FILENAME
3.1 Create a storage account
curl -X PUT "https://management.azure.com/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP_NAME}/providers/Microsoft.Storage/storageAccounts/{ACCOUNT_NAME}?api-version=2022-09-01" -H "Authorization:Bearer eyJ0eX..." -H "Content-Type:application/json" -d @input-storage.json -D - 
parameters:

-d, --data: sends the specified data in a POST request to the HTTP server, in the same way that a browser does when a user has filled in an HTML form and presses the submit button
-D, --dump-header: write the received protocol headers to file. Dump headers to stdout(-D -)
the input.json file is included in the post.

3.2 Get a storage account
curl -X GET "https://management.azure.com/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP_NAME}/providers/Microsoft.Storage/storageAccounts/{ACCOUNT_NAME}?api-version=2022-09-01" -H "Authorization:Bearer eyJ0eX..." -H "Content-Type:application/json" -o output.json -D - 
parameters:

-o, --output <file>: write output to <file> instead of stdout
The token is quite long alphanumeric string. In windows, to get the syntax shorter and readable, you can assign the value of token to a powershell variable and then use it in curl command:

$mytoken= (Get-AzAccessToken).Token 
curl -X GET "https://management.azure.com/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP_NAME}/providers/Microsoft.Storage/storageAccounts/{ACCOUNT_NAME}?api-version=2022-09-01" -H "Authorization:Bearer $mytoken" -H "Content-Type:application/json" -o output.json -D - 
3.2 Create a vnet
$mytoken= (Get-AzAccessToken).Token 
curl -X PUT "https://management.azure.com/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP_NAME}/providers/Microsoft.Network/virtualNetworks/{VNET_NAME}?api-version=2022-07-01" -H "Authorization:Bearer $mytoken" -H "Content-Type:application/json" -d @input-vnet.json 
3.2 Get a vnet
$mytoken= (Get-AzAccessToken).Token 
curl -X GET "https://management.azure.com/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP_NAME}/providers/Microsoft.Network//virtualNetworks/{VNET_NAME}?api-version=2022-07-01" -H "Authorization:Bearer $mytoken" -H "Content-Type:application/json"
