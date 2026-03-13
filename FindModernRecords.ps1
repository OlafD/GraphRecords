using module Tools
using module AccessToken
using module Graph
using module SharePoint

#region general preparation

$retentionLabel = [Graph]::_retentionLabelName

$settings = [Tools]::LoadSettings(".\local.settings.json")

#endregion

#region connection preparation

$sharePoint = [SharePoint]::new($settings.siteUrl)

#endregion

#region do it...

$query = @"
<View>
    <Query>
        <Where>
            <Eq>
                <FieldRef Name="_ComplianceTag" />
                <Value Type="Text">$retentionLabel</Value>
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
