# CertScanPro - SSL Certificate & Subdomain Extractor
```bash
   ______          __  _____                  ____           
  / ____/__  _____/ /_/ ___/_________ _____  / __ \_________ 
 / /   / _ \/ ___/ __/\__ \/ ___/ __ `/ __ \/ /_/ / ___/ __ \
/ /___/  __/ /  / /_ ___/ / /__/ /_/ / / / / ____/ /  / /_/ /
\____/\___/_/   \__//____/\___/\__,_/_/ /_/_/   /_/   \____/ 
                                            https://msuport.vercel.app
```

## Overview

**CertScanPro** is a PowerShell-based tool designed to extract SSL certificate data and subdomains from a target domain using the **crt.sh** API. Additionally, it checks the HTTP status codes of discovered subdomains and presents them in both the terminal and an optional HTML report.

## Features

✅ Extracts SSL certificate details from **crt.sh** ✅ Finds associated subdomains from SSL certificate data ✅ Checks **HTTP status codes** of discovered subdomains ✅ **Color-coded status codes** in both terminal and HTML report ✅ Generates an **interactive HTML report** with Bootstrap styling ✅ Includes a **search feature** in the report for easy filtering

## Prerequisites

Ensure you have the following:

- Windows with **PowerShell** (tested on PowerShell 5.1 and later)
- Internet connection to fetch data from **crt.sh**

## Installation

1. **Clone the repository or download the script:**
   ```sh
   git clone https://github.com/Dit-Developers/CertScanPro.git
   cd CertScanPro
   ```
2. **Run PowerShell with execution permissions:**
   ```powershell
   Set-ExecutionPolicy Unrestricted -Scope Process
   ```

## Usage

Run the script with PowerShell:

```powershell
.\CertScanPro.ps1
```

### Example Run

```
Enter the domain name: example.com
Subdomains found:
sub1.example.com [200]
sub2.example.com [403]
sub3.example.com [404]
Do you want to generate an HTML report? (yes/no)
```

### Color-Coded Status Codes

- **200 (Green):** OK
- **301/302 (Yellow):** Redirects
- **403 (Red):** Forbidden
- **404 (Gray):** Not Found
- **Others (Cyan):** Unknown

## HTML Report

If you choose to generate an HTML report, the file `cert_report.html` will be created in the same directory. It includes:

- **SSL Certificate Details** (Issuer, Validity, Serial Number, etc.)
- **Subdomains with Status Codes** (color-coded)
- **Searchable Table** to filter results

### Example HTML Output



## License

MIT License. Feel free to modify and enhance!

## Author

**Muhammad Sudais Usmani**\
[https://msuport.vercel.app](https://msuport.vercel.app)

