Param(
    [int]$Port = 8000
)

function Find-Launcher {
    if (Get-Command py -ErrorAction SilentlyContinue) { return "py" }
    if (Get-Command python -ErrorAction SilentlyContinue) { return "python" }
    if (Get-Command npx -ErrorAction SilentlyContinue) { return "npx" }
    return $null
}

$launcher = Find-Launcher
if (-not $launcher) {
    Write-Host "Error: Neither 'py', 'python' nor 'npx' was found on PATH. Install Python 3 or Node.js (for npx)." -ForegroundColor Red
    exit 1
}

if ($launcher -eq 'py') {
    $serverCmd = "py -3 -m http.server $Port"
} elseif ($launcher -eq 'python') {
    $serverCmd = "python -m http.server $Port"
} else {
    $serverCmd = "npx http-server -p $Port"
}

Write-Host "Starting server with: $serverCmd"
# Start the server in a new PowerShell window so it keeps running
Start-Process powershell -ArgumentList "-NoExit", "-Command", $serverCmd

# Give the server a moment to start
Start-Sleep -Milliseconds 500

$uri = "http://localhost:$Port/index.html"
Write-Host "Opening $uri in your default browser..."
Start-Process $uri

Write-Host "Server started in a separate PowerShell window. To stop the server, close that window or press Ctrl+C there." -ForegroundColor Green
