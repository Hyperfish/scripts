#This script adds the Hyperfish enterprise application to the Helpdesk Administrators role in Azure AD
#This is intended to fix the recent Graph restrictions around updating user phone numbers that revoked 
#the Hyperfish Agent's ability to write mobile phone and business phone attributes.

function Fix {
#check for AzureAD PowerShell Module
Write-Host "Checking for AAD PS Module..."
    if (Get-Module -ListAvailable -Name AzureAD) {
        Write-Host "AzureAD PowerShell Module exists -- continuing"
    } else {
        Write-Host "AzureAD PowerShell Module not found -- Installing AzureAD PowerShell Module"
        Install-Module AzureAD}

#Start AAD PSSession and auth in
Connect-AzureAD | Out-Null

#check for Hyperfish Service Application
    if (Get-AzureADServicePrincipal -all $true | Where-Object {$_.DisplayName -eq 'Hyperfish Service'}) {
    $hfSP = Get-AzureADServicePrincipal -all $true | Where-Object {$_.DisplayName -eq 'Hyperfish Service'}
    Write-Host "Found application" $hfSP.DisplayName "with OID" $hfSP.ObjectId
    } else {
        Write-Host "Hyperfish Service not found in this AAD Tenant"
        Write-Host "Make sure the global admin account belongs to the correct tenant, and that Hyperfish is listed as an enterprise application"
        Write-Host "Script termination"
        Exit}

#Get AzureAD Helpdesk Admin role and grant to Hyperfish Service
$azureHDARole = Get-AzureADDirectoryRole | Where-Object {$_.displayName -eq 'Helpdesk Administrator'}

Write-Host "Adding" $hfSP.DisplayName "to" $azureHDARole.DisplayName "role"
Add-AzureADDirectoryRoleMember -ObjectId $azureHDARole.ObjectId -RefObjectId $hfSP.ObjectId

Start-Sleep -s 3

#check for membership
Write-Host "Checking role membership..."
    if (Get-AzureADDirectoryRoleMember -ObjectId $azureHDARole.ObjectId | Where-Object {$_.objectId -eq $hfSP.ObjectId}) {
        $info = Get-AzureADDirectoryRoleMember -ObjectId $azureHDARole.ObjectId | Where-Object {$_.objectId -eq $hfSP.ObjectId} | Select AppDisplayName,ObjectId,PublisherName
        Write-Host "Successfully found:" -ForegroundColor Green
        Write-Output $info
    } else {
        Write-Host "Could not find" + $hfSP.displayname + "in role. Failed to add Hyperfish Service to Helpdesk Administrator role." -ForegroundColor Red
    }
}

Fix
