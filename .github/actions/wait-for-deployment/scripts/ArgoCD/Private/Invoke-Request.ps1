function Invoke-Request {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [hashtable]$Request)
    Process {
        try {
            $response = Invoke-RestMethod @Request -StatusCodeVariable "statusCode" -ResponseHeadersVariable "responseHeaders" -SkipHttpErrorCheck
        }
        catch {
            Write-Warning -Message $_.Exception.Message
        }

        Write-Debug "status code: $($statusCode)"
        Write-Debug ($response|ConvertTo-Json -Depth 10)

        if($statusCode -ge 200 -and $statusCode -le 299) {
            $response | Add-Member -MemberType NoteProperty -Name 'headers' -Value $responseHeaders
            $response
        }
        else {
            throw "$($Request.Uri) failed with $($statusCode): $response"
        }
    }
}