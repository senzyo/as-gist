$filePath = "$env:LocalAppData\Microsoft\Edge\User Data\Local State"
$tempPath = "$env:LocalAppData\Microsoft\Edge\User Data\Local State.tmp"

if (Test-Path $filePath) {
    $jqFilter = @"
    if (
        has(\"variations_country\") and
        (.variations_permanent_consistency_country | type == \"array\" and length > 1) and
        has(\"variations_safe_seed_permanent_consistency_country\") and
        has(\"variations_safe_seed_session_consistency_country\")
    ) then (
        .variations_country = `$v |
        .variations_permanent_consistency_country[1] = `$v |
        .variations_safe_seed_permanent_consistency_country = `$v |
        .variations_safe_seed_session_consistency_country = `$v
    ) else
        error(\"MISSING_KEYS\")
    end
"@

    try {
        $jsonResult = & jq --arg v "US" $jqFilter "$filePath" 2>$null
        if ($LASTEXITCODE -eq 0 -and $jsonResult) {
            [System.IO.File]::WriteAllLines($tempPath, $jsonResult)
            Move-Item -Path "$tempPath" -Destination "$filePath" -Force
            Write-Host "Success: Specified items have been updated to 'US'." -ForegroundColor Green
            Start-Process "msedge.exe"
        } else {
            Write-Host "Required keys missing or array too short. No changes made." -ForegroundColor Red
            pause
        }
    } catch {
        Write-Host "An error occurred during jq processing." -ForegroundColor Red
        pause
    }
} else {
    Write-Host "Error: File not found at $filePath" -ForegroundColor Red
    pause
}
