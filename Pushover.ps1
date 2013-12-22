$PushoverURI = 'https://api.pushover.net/1/messages.json'
$PushoverUserKey = 'udFKDUGUbYXm32uogzLcp4EHskkBAV'
$PushoverAppToken = 'agAvpEEvTb36Cdo6HkV5yUq6eyNT1q'
$Global:PreviousPushMessages = @()

Function Send-PushoverMessage {
param(
    [string]$Message = "",
    [string]$Title = "",
    [string]$URL = '',
    [string]$URLTitle = '',
    [ValidateSet("-1","0","1","2")] 
    [int]$Priority = '0',
    [int]$Expire = '86400',
    [ValidateSet("CashRegister","Bike","Bugle","Classical","Cosmic","Falling","GameLan","Incomming","Intermission","Magic","Mechanical","PianoBar","Siren","SpaceAlarm","TugBoat","Alien","Climb","Persistent","Echo","UpDown","none")]
    [string]$Sound = '',
    [int]$Retry
)


    $Parameters = @{
        token=$PushoverAppToken
        user=$PushoverUserKey
        message=$Message
        title=$Title
        url=$URL
        url_title=$URLTitle
        priority=$Priority
        expire=$Expire
        sound=$sound.ToLower()
        retry=$Retry

    }

    $Results = $Parameters | Invoke-RestMethod -Uri $PushoverURI -Method Post
    $Results | Add-Member -MemberType NoteProperty -Name DateTime -Value (Get-Date)
    $Results | Add-Member -MemberType NoteProperty -Name Title -Value $Parameters.Title
    $Global:PreviousPushMessages += $Results
    #Write-Output $Results

}

Function Get-PushoverReceipt {
    param (
        [string]$Receipt = ''
    )

    if ($Receipt -eq '') { 
        Write-Warning "Invalid Receipt" 
    } else {
        Invoke-WebRequest -Uri "https://api.pushover.net/1/receipts/5e35b93f4d2e1daa5778a6109e99a22d.json?token=agAvpEEvTb36Cdo6HkV5yUq6eyNT1q"
    }

}
