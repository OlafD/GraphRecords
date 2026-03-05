class AccessToken
{
    <########## public members ##########>

    <########## hidden/private members ##########>

    hidden [string] $_tokenType
    hidden [string] $_accessToken
    
    <########## constructors ##########>

    AccessToken([string] $ClientId, [SecureString] $ClientSecret, [string]$TenantId, [string] $Scope)
    {
        $scopeEncoded = [System.Web.HttpUtility]::UrlEncode($Scope)
        $plainClientSecret = ConvertFrom-SecureString -SecureString $ClientSecret -AsPlainText
        $grantType = "client_credentials"

        $uri = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"

        $body = "client_id=$ClientId&scope=$scopeEncoded&client_secret=$plainClientSecret&grant_type=$grantType"

        $header = @{
            ContentType = "application/x-www-form-urlencoded"
        }

        $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $header -Body $body -ContentType "application/x-www-form-urlencoded"

        $this._tokenType = $response.token_type
        $this._accessToken = $response.access_token
    }

    AccessToken([string] $ClientId, [string] $TenantId)
    {
        if ($this._haveMsalPsModule() -eq $true)
        {
            Clear-MsalTokenCache

            $token = Get-MsalToken -TenantId $TenantId -ClientId $ClientId -Interactive

            $this._accessToken = $token.AccessToken
            $this._tokenType = $token.TokenType
        }
    }

    <########## public methods ##########>

    [string] GetTokenType()
    {
        return $this._tokenType
    }

    [string] GetAccessToken()
    {
        return $this._accessToken
    }

    [hashtable] GetAccessTokenAsHeader()
    {
        $result = @{
            Authorization = "$($this._tokenType) $($this._accessToken)"
        }
        return $result
    }

    <########## hidden/private methods ##########>

    hidden [bool] _HaveMsalPsModule()
    {
        $haveMsalPsModule = $null -ne ( get-module -ListAvailable | Where-Object { $_.Name -like "Msal*" } )

        return $haveMsalPsModule
    }
}
