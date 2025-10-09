Param(
    [int]$Port = 8000
)

$listener = New-Object System.Net.HttpListener

# Add both IPv4 and localhost prefixes to avoid situations where 'localhost' resolves to IPv6 only
$prefixes = @(
    "http://127.0.0.1:$Port/",
    "http://localhost:$Port/"
)

foreach ($p in $prefixes) {
    try {
        $listener.Prefixes.Add($p)
    } catch {
        # Use -f formatting to avoid variable parsing issues inside double quotes
        Write-Warning ("Could not add prefix {0}: {1}" -f $p, $_)
    }
}

try {
    $listener.Start()
} catch {
    Write-Error "Failed to start HttpListener. Try running PowerShell as Administrator or choose a different port. Details: $_"
    exit 1
}

Write-Host "Serving $(Get-Location) on:" -ForegroundColor Green
foreach ($p in $listener.Prefixes) { Write-Host "  $p" }

# Open the IPv4 address explicitly so browsers that resolve localhost to 127.0.0.1 succeed
$openUrl = "http://127.0.0.1:$Port/index.html"
Start-Process $openUrl

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        Start-Job -ArgumentList $context -ScriptBlock {
            param($context)
            $req = $context.Request
            $resp = $context.Response
            $path = $req.Url.AbsolutePath
            if ($path -eq '/') { $path = '/index.html' }

            $rel = [System.Uri]::UnescapeDataString($path.TrimStart('/').Replace('/', [IO.Path]::DirectorySeparatorChar))
            $filePath = Join-Path (Get-Location) $rel

            if (-not (Test-Path $filePath)) {
                $resp.StatusCode = 404
                $msg = "404 Not Found"
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($msg)
                $resp.ContentLength64 = $buffer.Length
                $resp.ContentType = 'text/plain'
                $resp.OutputStream.Write($buffer, 0, $buffer.Length)
                $resp.OutputStream.Close()
                return
            }

            try {
                $bytes = [System.IO.File]::ReadAllBytes($filePath)
                $ext = [IO.Path]::GetExtension($filePath).ToLower()
                switch ($ext) {
                    '.html' { $ctype = 'text/html' }
                    '.htm'  { $ctype = 'text/html' }
                    '.js'   { $ctype = 'application/javascript' }
                    '.css'  { $ctype = 'text/css' }
                    '.png'  { $ctype = 'image/png' }
                    '.jpg'  { $ctype = 'image/jpeg' }
                    '.jpeg' { $ctype = 'image/jpeg' }
                    '.gif'  { $ctype = 'image/gif' }
                    '.svg'  { $ctype = 'image/svg+xml' }
                    '.ico'  { $ctype = 'image/x-icon' }
                    '.wasm' { $ctype = 'application/wasm' }
                    '.json' { $ctype = 'application/json' }
                    default { $ctype = 'application/octet-stream' }
                }

                $resp.ContentType = $ctype
                $resp.ContentLength64 = $bytes.Length
                $resp.OutputStream.Write($bytes, 0, $bytes.Length)
                $resp.OutputStream.Close()
            } catch {
                try {
                    $resp.StatusCode = 500
                    $msg = "500 Internal Server Error"
                    $buffer = [System.Text.Encoding]::UTF8.GetBytes($msg)
                    $resp.ContentLength64 = $buffer.Length
                    $resp.ContentType = 'text/plain'
                    $resp.OutputStream.Write($buffer, 0, $buffer.Length)
                    $resp.OutputStream.Close()
                } catch { }
            }
        } | Out-Null
    }
} finally {
    Write-Host "Shutting down listener..." -ForegroundColor Yellow
    try { $listener.Stop(); $listener.Close() } catch { }
}
