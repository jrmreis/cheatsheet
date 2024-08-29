write-host "======== Step: Checking Security Gate ========"
# Get the scanname variable and jobid variable from file scanName_var.txt and jobId_var.txt created by script appscanase_scan.ps1
$scanName=(Get-Content .\scanName_var.txt);
$jobId=(Get-Content .\jobId_var.txt);
# ASE Authentication getting sessionId
$sessionId=$(Invoke-WebRequest -Method "POST" -Headers @{"Accept"="application/json"} -ContentType 'application/json' -Body "{`"keyId`": `"$aseApiKeyId`",`"keySecret`": `"$aseApiKeySecret`"}" -Uri "https://$aseHostname`:9443/ase/api/keylogin/apikeylogin" -SkipCertificateCheck | Select-Object -Expand Content | ConvertFrom-Json | select -ExpandProperty sessionId);
# Get vulnerabilities total from ASE API and parse into json variable
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
$vulnSummary=$((Invoke-WebRequest -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"}-Uri "https://$aseHostname`:9443/ase/api/summaries/issues_v2?query=scanname%3D$scanName%20($jobId)&group=Severity" -SkipCertificateCheck).content | ConvertFrom-json)
# Security Gate steps
[int]$highIssues = ($vulnSummary | Where {$_.tagName -eq 'High'}).numMatch
[int]$mediumIssues = ($vulnSummary | Where {$_.tagName -eq 'Medium'}).numMatch
[int]$lowIssues = ($vulnSummary | Where {$_.tagName -eq 'Low'}).numMatch
[int]$infoIssues = ($vulnSummary | Where {$_.tagName -eq 'Information'}).numMatch
[int]$totalIssues = $highIssues+$mediumIssues+$lowIssues+$infoIssues
$maxIssuesAllowed = $maxIssuesAllowed -as [int]

write-host "There is $highIssues high issues, $mediumIssues medium issues, $lowIssues low issues and $infoIssues informational issues."
write-host "The company policy permit less than $maxIssuesAllowed $sevSecGw severity."

if (( $highIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "highIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $mediumIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "mediumIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $lowIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "lowIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $totalIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "totalIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
else{  
write-host "Security Gate passed"
  }

# If you want to delete every files after execution
# Remove-Item -path $CI_PROJECT_DIR\* -recurse -exclude *.pdf,*.json,*.xml
