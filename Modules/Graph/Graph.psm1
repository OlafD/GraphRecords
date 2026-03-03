class Graph
{
    <########## public members ##########>

    <########## hidden/private members ##########>

    static [string] $_retentionLabelName = "eSignature New"

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

    static [string] GetRetentionLabel([string] $DriveId, [string] $DriveItemId, [hashtable] $Header)
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

    <########## hidden/private methods ##########>

}