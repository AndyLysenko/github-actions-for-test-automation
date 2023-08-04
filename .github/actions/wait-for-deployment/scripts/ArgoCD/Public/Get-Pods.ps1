function Get-Pods {
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
        $resourceTree = Get-ResourceTree -ServerUrl $ServerUrl -ApplicationName $applicationName -JWT $JWT

        $pods = $resourceTree.nodes | Where-Object { $_.kind -eq "Pod"}
        $pods
    }
}