function Wait-ForDeployment {
    <#
        .SYNOPSIS
        Waits for docker image deployment by Argo CD.

        .DESCRIPTION
        Depending on the environment picks ArgoCD server URL and access token.
        Checks deployment status of specified docker-image on environment for deploy-wait-timeout period of time with deploy-wait-polling-interval interval.

        .PARAMETER ServerUrl
        Argo CD server URL.

        .PARAMETER ServiceName
        Specifies name of the service to be deployed. Should be equal to the repo name in GitHub. Example: propperty-planner-service, battery-service.

        .PARAMETER Environment
        Environment to be deployed to, according to Alfheim naming convention (dev, em, hw, staging, prod).

        .PARAMETER DockerImage
        Specifies name(not tag!) of the image to be deployed. It includes Url of Azure Container Registry, project name and docker-image-tag (e.g. sasalfsharedacr.azurecr.io/property-planner-service:alf-2.2.0-develop.63.b310663f).

        .PARAMETER JWT
        JWT token to access Argo CD instance.

        .PARAMETER TimeoutSec
        Time to wait for image to be deployed in seconds. Default value: 300.

        .PARAMETER PollingIntervalSec
        An interval to poll ArgoCD API to check the deployment status. Default value: 30.

        .INPUTS
        None.

        .OUTPUTS
        None. Exit code 0 if no errors.

        .EXAMPLE
        PS> Wait-ForDeployment -ServerUrl argocd.test.andylysenko.cloud -ServiceName property-planner-service -Environment dev -DockerImage sasalfsharedacr.azurecr.io/property-planner-service:alf-0.1.0 -Timeout 30 -JWT token_value

        .LINK
        Online version: https://github.com/andy-lysenko/templates/tree/main/.github/actions/wait-for-deployment
    #>
    
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$ServerUrl,
        [Parameter(Mandatory=$true)]
        [string]$ServiceName,
        [Parameter(Mandatory=$true)]
        [string]$Environment,
        [Parameter(Mandatory=$true)]
        [string]$DockerImage,
        [Parameter(Mandatory=$true)]
        [string]$JWT,
        [Parameter(Mandatory=$false)]
        [Int16]$TimeoutSec = 300,
        [Parameter(Mandatory=$false)]
        [Int16]$PollingIntervalSec = 30
    )
    Process {
        Write-Host $PSScriptRoot
        $applicationName = "${ServiceName}-${Environment}"
        Write-Host "Waiting for image '${DockerImage}' to be deployed"

        $timeout = New-TimeSpan -Seconds $TimeoutSec
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        do {
            try {
                $pods = Get-Pods -ServerUrl $ServerUrl -ApplicationName $applicationName -JWT $JWT
                Write-Host "Found '$(${pods}.Count)' pods"
                $podsPretty = $pods | ForEach-Object {
                    [PSCustomObject]@{
                        Image        = $_.images[0]
                        HealthStatus = $_.health.status
                    }
                }
                Write-Host ($podsPretty | Format-Table | Out-String)
    
                if (($podsPretty | Where-Object { ($_.Image -eq $DockerImage) -and ($_.HealthStatus -eq "Healthy")}).Count -gt 0){
                    Write-Host "Image has been successfully deployed"
                    exit 0
                }
            } catch{
                Write-Error -Message $_.Exception.Message
            }

            Write-Host "Image is not deployed yet. Waiting for '${PollingIntervalSec}' seconds"
            Start-Sleep $PollingIntervalSec
        } while ($stopwatch.elapsed -lt $timeout)

        Write-Error "After '${TimeoutSec}' seconds image '${DockerImage}' hasn't been deployed."
        exit 1
    }
}

# Import-Module C:\dev\andylysenko_GitHub\api-integration-tests\scripts\ArgoCD\ArgoCD.psd1 -Force
# Get-Help Wait-ForDeployment -full
