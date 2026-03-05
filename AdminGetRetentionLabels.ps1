using module Tools
using module AccessToken
using module Graph

$settings = [Tools]::LoadSettings(".\local.settings.json")

$accessTokenObject = [AccessToken]::new($settings.delegated.clientId, $settings.tenantId)

$header = $accessTokenObject.GetAccessTokenAsHeader()

$response = [Graph]::ListRetentionLabels($header)

ConvertTo-Json -InputObject $response.value -Depth 16 | Out-File C:\Temp\GetRetentionLabels-Response.json

Write-Host
