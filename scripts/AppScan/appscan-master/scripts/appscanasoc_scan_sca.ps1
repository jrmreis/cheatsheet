
# appscan update
appscan api_login -u $asocApiKeyId -P $asocApiKeySecret -persist
appscan prepare_sca

if ($artifactName -like "*.zip"){
    write-host "Identificado arquivo .zip"
    $artifactFolder=".\compilado"
    Expand-Archive -Path $artifactName -DestinationPath $artifactFolder
}else{
    write-host "Nao identificado arquivo compactado"
}

if ($(Test-Path *.irx) -eq $False){
	Write-host "IRX file not found. Check if there is content to be analyzed.";
	exit 1;
}

$scanName="$CI_PROJECT_NAME.zzz$CI_JOB_ID"
write-host $scanName

appscan queue_analysis -a $asocAppName -n $scanName > scanId.txt
$scanId = Get-Content .\scanId.txt -tail 1
$scanStatus = appscan status -i $scanId

while ("$scanStatus" -like "*Running*"){
  $scanStatus = appscan status -i $scanId;
  write-host $scanStatus
  sleep 10
}

appscan get_report -i $scanId -s scan -t security
appscan get_report -i $scanId -s scan -t licenses
