# Name:    PersonatorConsumerCloudAPI
# Purpose: Execute the PersonatorConsumerCloudAPI program


######################### Parameters ##########################
param(
    $addressline1 = '', 
    $city = '', 
    $state = '', 
    $postal = '', 
    $country = '', 
    $license = '', 
    [switch]$quiet = $false
    )


########################## Main ############################
Write-Host "`n==================== Melissa Personator Consumer Cloud API =====================`n"

# Get license (either from parameters or user input)
if ([string]::IsNullOrEmpty($license) ) {
  $license = Read-Host "Please enter your license string"
}

# Check for License from Environment Variables 
if ([string]::IsNullOrEmpty($license) ) {
  $license = $env:MD_LICENSE
}

if ([string]::IsNullOrEmpty($license)) {
  Write-Host "`nLicense String is invalid!"
  Exit
}

# Run project
if ([string]::IsNullOrEmpty($addressline1) -and [string]::IsNullOrEmpty($city) -and [string]::IsNullOrEmpty($state) -and [string]::IsNullOrEmpty($postal) -and [string]::IsNullOrEmpty($country)) {
  python3 PersonatorConsumerPython3.py --license $license 
}
else {
  python3 PersonatorConsumerPython3.py --license $license  --addressline1 $addressline1 --city $city --state $state --postal $postal --country $country
}
