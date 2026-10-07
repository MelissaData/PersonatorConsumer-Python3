<#
.SYNOPSIS
    Runs the Melissa Personator Consumer Cloud API Python 3 sample.

.DESCRIPTION
    This script runs PersonatorConsumerPython3.py with python3, passing along the license
    and (if supplied) the address fields.

    Overall flow:
      1. Resolve the license (parameter, prompt, or MD_LICENSE environment variable).
      2. Run PersonatorConsumerPython3.py: with the address fields if any was supplied,
         otherwise with only the license (the Python program prompts for each field).

.PARAMETER addressline1
    Street address to test.

.PARAMETER city
    City to test.

.PARAMETER state
    State to test.

.PARAMETER postal
    Postal code to test.

.PARAMETER country
    Country to test.

.PARAMETER license
    License string. Resolved in this order:
      1. This parameter.
      2. An interactive prompt, if the parameter was not supplied.
      3. The MD_LICENSE environment variable, if the prompt was left blank.
    Note that the environment variable is the last resort, not the first: running
    without -license always prompts, even when MD_LICENSE is set.

.PARAMETER quiet
    Accepted for parity with other sample scripts; not currently used to suppress output.

.EXAMPLE
    .\PersonatorConsumerPython3.ps1 -license "your-license"

.EXAMPLE
    .\PersonatorConsumerPython3.ps1 -addressline1 "22382 Avenida Empresa" -city "Rancho Santa Margarita" -state "CA" -postal "92688" -country "United States" -license "your-license"
#>


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
# No address fields supplied -> run with only the license (the program prompts); otherwise pass the supplied ones through.
if ([string]::IsNullOrEmpty($addressline1) -and [string]::IsNullOrEmpty($city) -and [string]::IsNullOrEmpty($state) -and [string]::IsNullOrEmpty($postal) -and [string]::IsNullOrEmpty($country)) {
  python3 PersonatorConsumerPython3.py --license $license
}
else {
  # Only pass flags that have a value. Windows PowerShell drops empty-string arguments to
  # native programs, which would shift the next flag name into this flag's value.
  # Any field left out here is prompted for by the program.
  $runArgs = @('--license', $license)
  if (-not [string]::IsNullOrEmpty($addressline1)) { $runArgs += '--addressline1', $addressline1 }
  if (-not [string]::IsNullOrEmpty($city))         { $runArgs += '--city', $city }
  if (-not [string]::IsNullOrEmpty($state))        { $runArgs += '--state', $state }
  if (-not [string]::IsNullOrEmpty($postal))       { $runArgs += '--postal', $postal }
  if (-not [string]::IsNullOrEmpty($country))      { $runArgs += '--country', $country }
  python3 PersonatorConsumerPython3.py @runArgs
}
