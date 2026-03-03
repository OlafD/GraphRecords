using module Tools
using module AccessToken

$settings = [Tools]::LoadSettings(".\local.settings.json")

$secret = ConvertTo-SecureString $settings.clientSecret -AsPlainText -Force

$accessTokenObject = [AccessToken]::new($settings.clientId, $secret, $settings.tenantId, $settings.scope)

Write-Host
