using module Tools
using module AccessToken
using module Graph

$itemId = "3"
$retentionLabel = [Graph]::_retentionLabelName

$settings = [Tools]::LoadSettings(".\local.settings.json")

$secret = ConvertTo-SecureString $settings.appOnly.clientSecret -AsPlainText -Force

$accessTokenObject = [AccessToken]::new($settings.appOnly.clientId, $secret, $settings.tenantId, $settings.appOnly.scope)

$header = $accessTokenObject.GetAccessTokenAsHeader()

$graphSiteId = [Graph]::GetGraphSiteId($settings.siteUrl, $header)
$graphDriveId = [Graph]::GetDriveIdByListname($graphSiteId, $settings.listName, $header)
$graphDriveItemId = [Graph]::GetDriveItemIdByListItem($graphSiteId, $settings.listName, $itemId, $header)

$getLabelResponse = [Graph]::GetRetentionLabel($graphDriveId, $graphDriveItemId, $header)
$labelResponse = [Graph]::SetRetentionLabel($graphDriveId, $graphDriveItemId, $retentionLabel, $header)
# $lockResponse = [Graph]::LockDocument($graphDriveId, $graphDriveItemId, $header)

Write-Host
