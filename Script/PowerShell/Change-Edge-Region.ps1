$ESC = [char]27
$Black = "$ESC[90m"
$Red = "$ESC[91m"       # [Error]
$Green = "$ESC[92m"     # [Success]
$Yellow = "$ESC[93m"    # [Warning]
$Blue = "$ESC[94m"
$Magenta = "$ESC[95m"
$Cyan = "$ESC[96m"      # [Notice]
$White = "$ESC[97m"
$NC = "$ESC[0m"         # No Color

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
            Write-Host "${Green}[Success]${NC} Updated to 'US'."
            Start-Process "msedge.exe"
        } else {
            Write-Host "${Red}[Error]${NC} Required keys missing or array too short. No changes made."
            pause
        }
    } catch {
        Write-Host "${Red}[Error]${NC} An error occurred during jq processing."
        pause
    }
} else {
    Write-Host "${Red}[Error]${NC} File not found: $filePath"
    pause
}
