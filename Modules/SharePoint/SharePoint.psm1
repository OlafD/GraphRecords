class SharePoint
{
    <########## public members ##########>

    <########## hidden/private members ##########>

    hidden [object] $_connection

    <########## constructors ##########>

    SharePoint([string] $Url)
    {
        $this._connection = Connect-PnPOnline -Url $url -ClientId (Get-Item Env:\ENTRAID_APP_ID).Value -Interactive -ReturnConnection
    }

    SharePoint([string] $Url, [string] $ClientId)
    {
        $this._connection = Connect-PnPOnline -Url $url -ClientId $ClientId -Interactive -ReturnConnection
    }

    <########## public methods ##########>

    [void] DeclareRecord([string] $Listname, [string] $ItemId)
    {
        Set-PnPListItemAsRecord -List $Listname -Identity $ItemId -Connection $this._connection
    }

    [void] UndeclareRecord([string] $Listname, [string] $ItemId)
    {
        Clear-PnPListItemAsRecord -List $Listname -Identity $ItemId -Connection $this._connection
    }

    [bool] IsItemRecord([string] $Listname, [string] $ItemId)
    {
        return Test-PnPListItemIsRecord -List $Listname -Identity $ItemId -Connection $this._connection
    }

    <########## hidden/private methods ##########>

}