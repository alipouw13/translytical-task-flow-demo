<#
.SYNOPSIS
    Stamps your own Fabric workspace / database identifiers into the artifact
    definitions so they can be deployed to your tenant.

.DESCRIPTION
    The artifacts in this repo ship with placeholders instead of hard-coded
    identifiers. Run this once, after you have created the SQL database, the
    user data function and the workspace, to replace every placeholder with
    your own values.

    Run with -WhatIf first to see what would change.

.EXAMPLE
    .\Set-Environment.ps1 `
        -WorkspaceName      'Translytical Demo' `
        -WorkspaceId        '00000000-0000-0000-0000-000000000000' `
        -SqlServerFqdn      'abcdef.database.fabric.microsoft.com' `
        -SqlDatabaseName    'SQL_Demo-11111111-1111-1111-1111-111111111111' `
        -SqlDatabaseId      '11111111-1111-1111-1111-111111111111' `
        -UserDataFunctionId '22222222-2222-2222-2222-222222222222'
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$WorkspaceName,
    [Parameter(Mandatory)][string]$WorkspaceId,
    [Parameter(Mandatory)][string]$SqlServerFqdn,
    [Parameter(Mandatory)][string]$SqlDatabaseName,
    [Parameter(Mandatory)][string]$SqlDatabaseId,
    [Parameter(Mandatory)][string]$UserDataFunctionId,
    [string]$SemanticModelId = '',
    [string]$ReportId = '',
    [string]$Root = (Split-Path $PSScriptRoot -Parent)
)

$map = [ordered]@{
    '<WORKSPACE_NAME>'        = $WorkspaceName
    '<WORKSPACE_ID>'          = $WorkspaceId
    '<SQL_SERVER_FQDN>'       = $SqlServerFqdn
    '<SQL_DATABASE_NAME>'     = $SqlDatabaseName
    '<SQL_DATABASE_ID>'       = $SqlDatabaseId
    '<USER_DATA_FUNCTION_ID>' = $UserDataFunctionId
}
if ($SemanticModelId) { $map['<SEMANTIC_MODEL_ID>'] = $SemanticModelId }
if ($ReportId)        { $map['<REPORT_ID>']         = $ReportId }

$extensions = '.tmdl', '.json', '.pbir', '.pbism', '.py', '.platform'
$targets = Get-ChildItem -Path $Root -Recurse -File |
    Where-Object { $extensions -contains $_.Extension.ToLower() -and $_.FullName -notmatch '\\scripts\\' }

$changed = 0
foreach ($file in $targets) {
    $text = Get-Content -LiteralPath $file.FullName -Raw
    $original = $text
    foreach ($k in $map.Keys) { $text = $text.Replace($k, $map[$k]) }
    if ($text -ne $original) {
        if ($PSCmdlet.ShouldProcess($file.FullName, 'replace placeholders')) {
            [IO.File]::WriteAllText($file.FullName, $text, [Text.UTF8Encoding]::new($false))
        }
        Write-Host "  updated $($file.FullName.Substring($Root.Length + 1))"
        $changed++
    }
}

Write-Host ""
Write-Host "$changed file(s) updated." -ForegroundColor Green

$remaining = Get-ChildItem -Path $Root -Recurse -File |
    Where-Object { $extensions -contains $_.Extension.ToLower() } |
    Select-String -Pattern '<[A-Z_]+>' -List
if ($remaining) {
    Write-Warning 'Placeholders still present in:'
    $remaining | ForEach-Object { Write-Warning "  $($_.Path)" }
} else {
    Write-Host 'No placeholders remain.' -ForegroundColor Green
}
