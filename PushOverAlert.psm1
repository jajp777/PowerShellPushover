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
    [string]$Message = "",
    [string]$Title = "",
    [string]$URL = '',
    [string]$URLTitle = '',
    [ValidateSet("-1","0","1","2")] 
    [int]$Priority = '0',
    [int]$Expire = '86400',
    [DateTime]$Timestamp = '',
    [String]$Device,    
    [ValidateSet("CashRegister","Bike","Bugle","Classical","Cosmic","Falling","GameLan","Incomming","Intermission","Magic","Mechanical","PianoBar","Siren","SpaceAlarm","TugBoat","Alien","Climb","Persistent","Echo","UpDown","none")]
    [string]$Sound = '',
    [int]$Retry
)

    $Config = Import-Clixml "$CommandPath\pushoverapiauth.xml"

    $Parameters = @{
        token=$Config.AppToken
        user=$Config.UserKey
        message=$Message
        title=$Title
        url=$URL
        url_title=$URLTitle
        priority=$Priority
        device=$Device
        timestamp=(Get-Date $Timestamp -UFormat %s) -replace("[,\.]\d*", "")
        expire=$Expire
        sound=$sound.ToLower()
        retry=$Retry

    }

    #Write-Output ($Parameters | Invoke-RestMethod -Uri $PushoverURI -Method Post)
    $Results = $Parameters | Invoke-RestMethod -Uri $PushoverURI -Method Post
    $Results | Add-Member -MemberType NoteProperty -Name DateTime -Value (Get-Date)
    $Results | Add-Member -MemberType NoteProperty -Name Title -Value $Parameters.Title
    $Global:PreviousPushMessages += $Results
    Write-Output $Results
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
