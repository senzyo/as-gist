if ($args.Length -ne 1) {
  Write-Host "Usage: $(Split-Path $MyInvocation.MyCommand.Path -Leaf) <dir>"
  Exit 1
}
$dir = $args[0]
$branch = "master"

if (!(Test-Path $dir)) {
  Write-Host "Directory does not exist."
  exit 1
}

if (Test-Path "$dir\.git") {
  $branch = (git -C "$dir" branch -r | ForEach-Object { $_ -split '/' | Select-Object -Last 1 })
  $remote = (git -C "$dir" remote -v | Where-Object { $_ -match "(fetch)" } | ForEach-Object { $_.Split('')[1] })
  Remove-Item "$dir\.git" -Recurse -Force
} else {
  while ($true) {
    Write-Host "Example: git@github.com:senzyo-desu/blog.git"
    Write-Host "         https://github.com/senzyo-desu/blog.git"
    $remote = Read-Host "Input remote origin address: "
    if ($remote -match '\.git$') {
      break
    } else {
      Write-Host "Format error, try again." 
    }
  }
}

Set-Location $dir
git init

if (Test-Path ".gitmodules") {
  Get-Content ".gitmodules" | ForEach-Object {
    $path = ($_ -split ' = ')[1] -replace '^\s+' -replace '\s+$'
    if ($path) {
      Remove-Item $path -Recurse
      $url = (($_ -split ' = ')[2] -split ' ')[0] -replace '^\s+' -replace '\s+$' 
      if ($url) { 
        git submodule add "$url" "$path"
        git submodule update --remote --merge
      }
    }
  }
}

git add -A
git commit -m "Reinitialize" 
git branch -m $branch
git remote add origin $remote
