$ErrorActionPreference = "Stop"

$gitInstallPath = Join-Path $env:ProgramFiles "Git"
$git = Join-Path $gitInstallPath "cmd\git.exe"
if (-not (Test-Path $git)) {
    throw "No se encontró Git en $git."
}

$env:Path = "$(Join-Path $gitInstallPath 'cmd');$(Join-Path $gitInstallPath 'mingw64\bin');$env:Path"
$env:GCM_INTERACTIVE = "always"

$repositoryRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repositoryRoot

& $git add -- Index.html
if ($LASTEXITCODE -ne 0) {
    throw "No se pudo preparar Index.html para el commit."
}

& $git diff --cached --quiet -- Index.html
if ($LASTEXITCODE -eq 1) {
    & $git commit --only -m "Update Index.html" -- Index.html
    if ($LASTEXITCODE -ne 0) {
        throw "No se pudo crear el commit de Index.html."
    }
} elseif ($LASTEXITCODE -ne 0) {
    throw "No se pudo comprobar si Index.html tiene cambios."
}

& $git push --set-upstream origin main
if ($LASTEXITCODE -ne 0) {
    throw "No se pudo enviar el cambio a GitHub. Revisa la autenticación y la conexión."
}
