# ========================================
# Test d'authentification Azure AD pour Azure Function
# ========================================

$tenantId = "1324dfb4-4457-41c3-a943-293c61bbd70c"
$clientId = "963957ad-f5c8-4c63-94a8-f9064daff06e"
$clientSecret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
$scope = "api://963957ad-f5c8-4c63-94a8-f9064daff06e/.default"

$tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

# Préparer le body en form-url-encoded
$body = @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $clientSecret
    scope         = $scope
}

$bodyForm = [string]::Join('&', ($body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }))

# Obtenir le token
try {
    $tokenResponse = Invoke-RestMethod -Method Post -Uri $tokenUrl -Body $bodyForm -ContentType "application/x-www-form-urlencoded"
    $accessToken = $tokenResponse.access_token
    Write-Host "✓ Token obtenu avec succès !"
} catch {
    Write-Host "✗ Échec de l'obtention du token :" $_.Exception.Message
    exit
}

# Test d'appel à la fonction
$functionUrl = "https://mafonctionsql.azurewebsites.net/api/InsererUtilisateur"
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type"  = "application/json"
}

$payload = @{
    nom   = "Test"
    email = "test@example.com"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Method Post -Uri $functionUrl -Headers $headers -Body $payload
    Write-Host "✓ Appel à la Function réussi !"
    $response | ConvertTo-Json -Depth 5 | Write-Host
} catch {
    Write-Host "✗ Échec de l'appel à la Function : " $_.Exception.Message
}
