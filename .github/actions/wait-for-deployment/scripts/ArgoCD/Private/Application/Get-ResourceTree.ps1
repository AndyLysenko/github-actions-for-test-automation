function Get-ResourceTree {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$ServerUrl,
        [Parameter(Mandatory=$true)]
        [string]$ApplicationName,
        [Parameter(Mandatory=$true)]
        [string]$JWT
    )
    Process {
        $request = @{
            Uri = "https://$ServerUrl/api/v1/applications/$ApplicationName/resource-tree"
            Method = "Get"
            Headers = @{
                "Authorization" = "Bearer $JWT"
                "Accept" = "application/json"
            }
        }

        $response = Invoke-Request $request
        $response
    }
}