class Tools
{
    <########## public members ##########>

    <########## hidden/private members ##########>

    <########## constructors ##########>

    Tools()
    {}

    <########## public methods ##########>

    static [PSCustomObject] LoadSettings([string] $SettingsFile)
    {
        $fileContent = [string](Get-Content -Path $SettingsFile)

        $json = ConvertFrom-Json -InputObject $fileContent -Depth 16

        return $json
    }

    static [int] GetPercentage([int] $Total, [int] $Current)
    {
        return (($Current * 100) / $Total)
    }

    static [DateTime] SlackTsToDateTime([string] $SlackTs)
    {
        if ($SlackTs.IndexOf(".") -gt 0)
        {
            $epoch = [double]($SlackTs -split "\.")[0]   # take the seconds part
            $microSec = [double]($SlackTs -split "\.")[1]
            $microSec = $microSec * 10
        }
        else
        {
            $epoch = [double]($SlackTs -split "\.")[0]   # take the seconds part
            $microSec = 0
        }

        $datetime = [System.DateTimeOffset]::FromUnixTimeSeconds($epoch).ToLocalTime()

        $dateTime = [DateTime]::FromBinary($datetime.Ticks + $microSec)

        return $dateTime
    }

    <########## hidden/private methods ##########>

}