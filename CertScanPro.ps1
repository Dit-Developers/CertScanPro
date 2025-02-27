# Tool: CertScanPro - SSL Certificate & Subdomain Extractor

# Banner
$Banner = @"
   ______          __  _____                  ____           
  / ____/__  _____/ /_/ ___/_________ _____  / __ \_________ 
 / /   / _ \/ ___/ __/\__ \/ ___/ __ `/ __ \/ /_/ / ___/ __ \
/ /___/  __/ /  / /_ ___/ / /__/ /_/ / / / / ____/ /  / /_/ /
\____/\___/_/   \__//____/\___/\__,_/_/ /_/_/   /_/   \____/ 
                                            https://msuport.vercel.app
"@
Write-Host $Banner -ForegroundColor Cyan
Write-Host "Developed by Muhammad Sudais Usmani" -ForegroundColor Yellow

# Function to fetch certificate data
function Get-CertData {
    param ([string]$domain)
    $url = "https://crt.sh/?q=$domain&output=json"

    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -Headers @{"User-Agent"="Mozilla/5.0"}
        return $response
    } catch {
        Write-Host "Error fetching data: $_" -ForegroundColor Red
        return $null
    }
}

# Function to extract subdomains
function Extract-Subdomains {
    param ([array]$certData)
    $subdomains = @()
    foreach ($entry in $certData) {
        $names = $entry.name_value -split "\n"
        $subdomains += $names
    }
    return ($subdomains | Where-Object {$_ -ne ""} | Select-Object -Unique)
}

# Function to fetch subdomain status codes
function Get-StatusCode {
    param ([string]$subdomain)
    
    try {
        $response = Invoke-WebRequest -Uri "http://$subdomain" -Method Head -UseBasicParsing -TimeoutSec 5
        return $response.StatusCode
    } catch {
        if ($_.Exception.Response) {
            return $_.Exception.Response.StatusCode.Value__
        } else {
            return "N/A"
        }
    }
}

# Function to generate HTML report
function Generate-Report {
    param ([array]$certData, [array]$subdomains)
    
    Add-Type -AssemblyName System.Web
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $html = @"
    <html>
    <head>
        <title>CertScanPro - SSL Certificate Report</title>
        <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css'>
        <script src='https://code.jquery.com/jquery-3.6.0.min.js'></script>
        <script>
            function searchTable() {
                var input, filter, table, tr, td, i, txtValue;
                input = document.getElementById("searchInput");
                filter = input.value.toUpperCase();
                table = document.getElementById("dataTable");
                tr = table.getElementsByTagName("tr");
                
                for (i = 1; i < tr.length; i++) {
                    td = tr[i].getElementsByTagName("td");
                    if (td.length > 0) {
                        let found = false;
                        for (let j = 0; j < td.length; j++) {
                            if (td[j]) {
                                txtValue = td[j].textContent || td[j].innerText;
                                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                                    found = true;
                                    break;
                                }
                            }
                        }
                        tr[i].style.display = found ? "" : "none";
                    }       
                }
            }
        </script>
        <style>
            .status-200 { color: green; font-weight: bold; }
            .status-301, .status-302 { color: orange; font-weight: bold; }
            .status-403 { color: red; font-weight: bold; }
            .status-404 { color: gray; font-weight: bold; }
            .status-na { color: cyan; font-weight: bold; }
        </style>
    </head>
    <body class='container mt-4'>
        <header class='pb-2 border-bottom'>
            <h2 class='mb-3'>Certificate Data Report</h2>
        </header>

        <p class='text-muted'>Generated on: $timestamp</p>

        <h3>Subdomains & Status Codes</h3>
        <table class='table table-bordered'>
            <thead>
                <tr>
                    <th>Subdomain</th>
                    <th>Status Code</th>
                </tr>
            </thead>
            <tbody>
"@

    foreach ($sub in $subdomains) {
        $status = Get-StatusCode -subdomain $sub
        $statusClass = "status-na"
        if ($status -eq 200) { $statusClass = "status-200" }
        elseif ($status -eq 301 -or $status -eq 302) { $statusClass = "status-301" }
        elseif ($status -eq 403) { $statusClass = "status-403" }
        elseif ($status -eq 404) { $statusClass = "status-404" }

        $html += "<tr><td>$sub</td><td class='$statusClass'>$status</td></tr>"
    }

    $html += @"
            </tbody>
        </table>
    </body>
    </html>
"@
    
    $html | Out-File -Encoding utf8 "cert_report.html"
    Write-Host "Report generated: cert_report.html" -ForegroundColor Green
}

# Main Execution
$domain = Read-Host "Enter the domain name"
$certData = Get-CertData -domain $domain

if ($certData) {
    $subdomains = Extract-Subdomains -certData $certData
    
    Write-Host "Subdomains found:" -ForegroundColor Green
    
    foreach ($sub in $subdomains) {
        $status = Get-StatusCode -subdomain $sub
        $color = "Cyan"
        if ($status -eq 200) { $color = "Green" }
        elseif ($status -eq 301 -or $status -eq 302) { $color = "Yellow" }
        elseif ($status -eq 403) { $color = "Red" }
        elseif ($status -eq 404) { $color = "Gray" }

        Write-Host "$sub [$status]" -ForegroundColor $color
    }

    $generateReport = Read-Host "Do you want to generate an HTML report? (yes/no)"
    if ($generateReport -eq "yes") {
        Generate-Report -certData $certData -subdomains $subdomains
    }
} else {
    Write-Host "No data retrieved for the domain." -ForegroundColor Red
}
