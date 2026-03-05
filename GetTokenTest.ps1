using module Tools
using module AccessToken

$settings = [Tools]::LoadSettings(".\local.settings.json")

$secret = ConvertTo-SecureString $settings.appOnly.clientSecret -AsPlainText -Force

$accessTokenObject = [AccessToken]::new($settings.appOnly.clientId, $secret, $settings.tenantId, $settings.appOnly.scope)

Write-Host
