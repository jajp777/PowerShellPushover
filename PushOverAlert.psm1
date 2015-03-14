$CommandPath = split-path $PSCommandPath

$PushoverURI = 'https://api.pushover.net/1/messages.json'
$Global:PreviousPushMessages = @()

Function Save-PushoverAPIInformation {
[cmdletbinding()]
param(
    
    [parameter(Mandatory=$True)]
    [ValidateNotNull()]
    [string]$UserKey,
    
    [parameter(Mandatory=$True)]
    [ValidateNotNull()]
    [string]$AppToken

)

    $ReturnObject = New-Object -TypeName psobject -Property @{
        UserKey=$UserKey
        AppToken=$AppToken
    }
    Write-Verbose "Savinging Pushover API information to $("$CommandPath\PushOverAPIAuth.xml")"
    $ReturnObject | Export-clixml -Path "$CommandPath\PushOverAPIAuth.xml"

}

Function Send-PushoverMessage {
[cmdletbinding()]
param(
    [string]$token = "$(Import-Clixml "$CommandPath\pushoverapiauth.xml" | Select-Object -ExpandProperty AppToken)",

    [string]$user = "$(Import-Clixml "$CommandPath\pushoverapiauth.xml" | Select-Object -ExpandProperty UserKey)",

    [Parameter(Mandatory=$true)]
    [string]$message = "",

    
    [string]$title,
    
    [string]$url = '',
    
    [string]$url_title = '',
    
    [ValidateSet("-2","-1","1")] 
    [int]$priority,

    [ValidateSet("pushover","bike","bugle","cashregister","classical","cosmic","falling","gamelan","incoming","intermission","magic","mechanical","pianobar","siren","spacealarm","tugboat","alien","climb","persistent","echo","updown","none")]
    [string]$sound,
        
    [DateTime]$timestamp
)
DynamicParam {
        $ParameterName = 'device'
        $RuntimeDefinedParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $AttributeCollection.Add($ParameterAttribute) 
        $devices = Get-PushoverUserDevices
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($devices)
        $AttributeCollection.Add($ValidateSetAttribute)
        $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
        $RuntimeDefinedParameterDictionary.Add($ParameterName, $RuntimeParameter)
        return $RuntimeDefinedParameterDictionary
}

    BEGIN {}
    PROCESS {}
    END {
        $params = @{}
        foreach($h in $MyInvocation.MyCommand.Parameters.GetEnumerator()) {
                $key = $h.Key
                if ($key -match "Debug|Verbose|OutVariable|WarningVariable|OutBuffer|ErrorVariable|PipelineVariable|ErrorAction|WarningAction") {
                    break;
                }
                $val = Get-Variable -Name $key | Select-Object -ExpandProperty Value
                #Skip Automatic Variables
                if (([String]::IsNullOrEmpty($val) -and (!$PSBoundParameters.ContainsKey($key)))) {
                    break;
                }
                if ($key -eq 'timestamp') {
                    $val = (Get-Date $val.ToUniversalTime() -UFormat %s) -Replace("[,\.]\d*", "") 
             
                }
                $params[$key] = $val
        }

        $Results = $params | Invoke-RestMethod -Uri $PushoverURI -Method Post
        $Results | Add-Member -MemberType NoteProperty -Name DateTime -Value (Get-Date)
        $Results | Add-Member -MemberType NoteProperty -Name Title -Value $params.Title
        $Global:PreviousPushMessages += $Results
    }
}



Function Get-PushoverReceipt {
    param (
        [string]$Receipt = ''
    )

    if ($Receipt -eq '') { 
        Write-Warning "Invalid Receipt" 
    } else {
        Invoke-WebRequest -Uri "https://api.pushover.net/1/receipts/$Receipt.json?token=$PushoverAppToken"
    }

}

Function Get-PushoverUserDevices {
param(
    [string]$token = "$(Import-Clixml "$CommandPath\pushoverapiauth.xml" | Select-Object -ExpandProperty AppToken)",

    [string]$user = "$(Import-Clixml "$CommandPath\pushoverapiauth.xml" | Select-Object -ExpandProperty UserKey)"
)


    $Parameters = @{
        token=$token;
        user=$user;
    }

    $Result = $Parameters | Invoke-RestMethod -Uri 'https://api.pushover.net/1/users/validate.json' -Method Post
    Write-Output $Result.devices
}