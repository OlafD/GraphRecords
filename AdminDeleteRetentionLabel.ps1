using module Tools
using module AccessToken
using module Graph

param (
    [Parameter(Mandatory)]
    [string] $Labelname
)

$settings = [Tools]::LoadSettings(".\local.settings.json")

$accessTokenObject = [AccessToken]::new($settings.delegated.clientId, $settings.tenantId)

$header = $accessTokenObject.GetAccessTokenAsHeader()

$response = [Graph]::DeleteRetentionLabel($LabelName, $header)

$response

Write-Host
