class Graph
{
    <########## public members ##########>

    <########## hidden/private members ##########>

    # static [string] $_retentionLabelName = "SPO-Record-Locked-Until-Undeclared"
    # static [string] $_retentionLabelName = "eSignature Test"
    # static [string] $_retentionLabelName = "eSignature New"
    # static [string] $_retentionLabelName = "SPO-Record"
    # static [string] $_retentionLabelName = "eSignature retain"
    static [string] $_retentionLabelName = "Test-A1"

    <########## constructors ##########>

    <########## public methods ##########>

    static [string] GetGraphSiteId([string] $SiteUrl, [hashtable] $Header)
    {
        # remove https:// at the beginning
        $siteUrl1 = $SiteUrl.Replace("https://", "")
        # result olafdidszunsap.sharepoint.com/sites/restcalltester
        # add colon in front of first slash
        $slashposition = $siteUrl1.IndexOf("/")
        $siteUrl2 = $siteUrl1.Insert($slashposition, ":")
        # result olafdidszunsap.sharepoint.com:/sites/restcalltester

        $restUri = "https://graph.microsoft.com/v1.0/sites/$siteUrl2"

        $statusCode = ""
        $response = Invoke-RestMethod -Uri $restUri -Method Get -Headers $Header -StatusCodeVariable "statusCode"

        return $response.id
    }

    static [string] GetDriveIdByListname([string] $GraphSiteId, [string] $Listname, [hashtable] $Header)
    {
        $result = ""

        $restUri = "https://graph.microsoft.com/v1.0/sites/$GraphSiteId/drives"

        $response = Invoke-RestMethod -Uri $restUri -Method Get -Headers $Header -StatusCodeVariable "statusCode"

        foreach ($element in $response.value)
        {
            if ($element.name -eq $Listname)
            {
                $result = $element.id

                break
            }
        }

        return $result
    }

    static [string] GetListId([string] $GraphSiteId, [string] $Listname, [hashtable] $Header)
    {
        $restUri = "https://graph.microsoft.com/v1.0/sites/$GraphSiteId/lists/$Listname"

        $statusCode = ""

        $response = Invoke-RestMethod -Uri $restUri -Method Get -Headers $Header -StatusCodeVariable "statusCode"

        return $response.id
    }

    static [string] GetDriveItemIdByListItem([string] $GraphSiteId, [string] $ListId, [string] $ItemId, [hashtable] $Header)
    {
        $restUri = "https://graph.microsoft.com/v1.0/sites/$GraphSiteId/lists/$ListId/items/$ItemId/driveItem"

        $statusCode = ""

        $response = Invoke-RestMethod -Uri $restUri -Method Get -Headers $Header -StatusCodeVariable "statusCode"

        return $response.id
    }

    static [object] GetRetentionLabel([string] $DriveId, [string] $DriveItemId, [hashtable] $Header)
    {
        $restUri = "https://graph.microsoft.com/v1.0/drives/$DriveId/items/$DriveItemId/retentionLabel"

        $statusCode = ""

        $response = Invoke-RestMethod -Uri $restUri -Method Get -Headers $Header -StatusCodeVariable "statusCode"

        return $response
    }

    static [string] SetRetentionLabel([string] $DriveId, [string] $DriveItemId, [string] $LabelName, [hashtable] $Header)
    {
        $restUri = "https://graph.microsoft.com/v1.0/drives/$DriveId/items/$DriveItemId/retentionLabel"

        if ($header.ContainsKey("Content-Type") -eq $false)
        {
            $header.Add("Content-Type", "application/json")
        }

        $body = @"
{
  "name": "$($LabelName)"
}
"@

        $statusCode = ""

        $response = Invoke-RestMethod -Uri $restUri -Method Patch -Body $body -Headers $Header -StatusCodeVariable "statusCode"

        return $response
    }

    static [string] RemoveRetentionLabel([string] $DriveId, [string] $DriveItemId, [hashtable] $Header)
    {
        $restUri = "https://graph.microsoft.com/v1.0/drives/$DriveId/items/$DriveItemId/retentionLabel"

        $statusCode = ""

        $response = Invoke-RestMethod -Uri $restUri -Method Delete -Headers $Header -StatusCodeVariable "statusCode"

        return $response
    }

    static [string] LockDocument([string] $DriveId, [string] $DriveItemId, [hashtable] $Header)
    {
        $restUri = "https://graph.microsoft.com/v1.0/drives/$DriveId/items/$DriveItemId/retentionLabel"

        if ($header.ContainsKey("Content-Type") -eq $false)
        {
            $header.Add("Content-Type", "application/json")
        }

        $body = @"
{
  "retentionSettings": {
    "isRecordLocked": true
  }
}
"@

        $statusCode = ""

        $response = Invoke-RestMethod -Uri $restUri -Method Patch -Body $body -Headers $Header -StatusCodeVariable "statusCode"

        return $response
    }

    static [string] UnlockDocument([string] $DriveId, [string] $DriveItemId, [hashtable] $Header)
    {
        $restUri = "https://graph.microsoft.com/v1.0/drives/$DriveId/items/$DriveItemId/retentionLabel"

        $header.Add("Content-Type", "application/json")

        $body = @"
{
  "retentionSettings": {
    "isRecordLocked": false
  }
}
"@

        $statusCode = ""

        $response = Invoke-RestMethod -Uri $restUri -Method Patch -Body $body -Headers $Header -StatusCodeVariable "statusCode"

        return $response
    }

    static [string] RemoveLabelOnDocument([string] $DriveId, [string] $DriveItemId, [hashtable] $Header)
    {
        $restUri = "https://graph.microsoft.com/v1.0/drives/$DriveId/items/$DriveItemId/retentionLabel"

        $statusCode = ""

        $response = Invoke-RestMethod -Uri $restUri -Method Delete -Headers $Header -StatusCodeVariable "statusCode"

        return $response
    }

    <# Administrative methods and functions using delegated permissions #>

    static [object] ListRetentionLabels([hashtable] $Header)
    {
        $restUri = "https://graph.microsoft.com/v1.0/security/labels/retentionLabels?`$expand=retentionEventType"

        $statusCode = ""

        $response = Invoke-RestMethod -Uri $restUri -Method Get -Headers $Header -StatusCodeVariable "statusCode"

        return $response
    }

    static [object] DeleteRetentionLabel($RetentionLabelName, [hashtable] $Header)
    {
        $retentionLabelId = [Graph]::_GetRetentionLabelId($RetentionLabelName, $Header)

        if ($retentionLabelId -ne "")
        {
            $restUri = "https://graph.microsoft.com/v1.0/security/labels/retentionLabels/$retentionLabelId"

            $statusCode = ""

            $response = Invoke-RestMethod -Uri $restUri -Method Delete -Headers $Header -StatusCodeVariable "statusCode"

            return $response
        }

        return $null
    }

    <########## hidden/private methods ##########>

    static [string] _GetRetentionLabelId([string] $RetentionLabelName, [hashtable] $Header)
    {
        $result = ""

        $response = [Graph]::ListRetentionLabels($Header)

        $retentionLabel = $response.value | Where-Object { $_.displayName -eq $RetentionLabelName }

        if ($null -ne $retentionLabel)
        {
            $result = $retentionLabel.id
        }

        return $result
    }
}