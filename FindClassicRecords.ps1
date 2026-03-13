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

#region do it...

$systemAccountUserId = (Get-PnPUser -Identity "System Account" -Connection $sharepoint._connection).Id
<#
$query = @"
<View>
    <Query>
        <Where>
            <Eq>
                <FieldRef Name="CheckoutUser" />
                <Value Type="Text">System Account</Value>
            </Eq>
        </Where>
    </Query>
</View>
"@
#>
$query = @"
<View>
    <Query>
        <Where>
            <Eq>
                <FieldRef Name="CheckoutUser" LookupId="True" />
                <Value Type="Integer">$systemAccountUserId</Value>
            </Eq>
        </Where>
    </Query>
</View>
"@

$items = Get-PnPListItem -List $settings.listName -Query $query -PageSize 500 -Connection $sharePoint._connection

foreach ($item in $items)
{
    Write-Host "$($item.Id) $($item['FileLeafRef'])"
}

#endregion
