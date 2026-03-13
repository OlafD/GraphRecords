using module Tools
using module AccessToken
using module Graph
using module SharePoint

#region general preparation

$itemId = "1"
$retentionLabel = [Graph]::_retentionLabelName

$settings = [Tools]::LoadSettings(".\local.settings.json")

#endregion

#region connection preparation

$secret = ConvertTo-SecureString $settings.appOnly.clientSecret -AsPlainText -Force

$accessTokenObject = [AccessToken]::new($settings.appOnly.clientId, $secret, $settings.tenantId, $settings.appOnly.scope)

$sharePoint = [SharePoint]::new($settings.siteUrl)

#endregion

#region check record setting in classic

$isClassicRecord = $sharePoint.IsItemRecord($settings.listname, $itemId)

if ($isClassicRecord -eq $true)
{
    $sharePoint.UndeclareRecord($settings.listname, $itemId)
}

#endregion

#region set record in modern

$header = $accessTokenObject.GetAccessTokenAsHeader()

$graphSiteId = [Graph]::GetGraphSiteId($settings.siteUrl, $header)
$graphDriveId = [Graph]::GetDriveIdByListname($graphSiteId, $settings.listName, $header)
$graphDriveItemId = [Graph]::GetDriveItemIdByListItem($graphSiteId, $settings.listName, $itemId, $header)

$labelResponse = [Graph]::SetRetentionLabel($graphDriveId, $graphDriveItemId, $retentionLabel, $header)

#endregion

Write-Host
