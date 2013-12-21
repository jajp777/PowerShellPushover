$PushoverURI = 'https://api.pushover.net/1/messages.json'
$PushoverUserKey = 'udFKDUGUbYXm32uogzLcp4EHskkBAV'
$PushoverAppToken = 'agAvpEEvTb36Cdo6HkV5yUq6eyNT1q'
$Global:PreviousPushMessages = @()

Function Send-PushoverMessage {
param(
    $Message = "",
    $Title = "",
    [ValidateSet('-1','0','1','2')]
    $Priority = '0',
    [string]$URL ='',
    [string]$URLTitle = '',
    #[DateTime]$Timestamp = '',
    [String]$Device,
    [int]$Expire = '',
    [ValidateSet("CashRegister","Bike","Bugle","Classical","Cosmic","Falling","GameLan","Incomming","Intermission","Magic","Mechanical","PianoBar","Siren","SpaceAlarm","TugBoat","Alien","Climb","Persistent","Echo","UpDown","none")]
    [string]$Sound = ''
)


    $Parameters = @{
        token=$PushoverAppToken
        user=$PushoverUserKey
        message=$Message
        title=$Title
        url=$URL
        url_title=$URLTitle
        priority=$Priority
        device=$Device
        #timestamp=(Get-Date $Timestamp -UFormat %s) -replace("[,\.]\d*", "")
        expire=$Expire
        sound=$sound.ToLower()

    }

    #Write-Output ($Parameters | Invoke-RestMethod -Uri $PushoverURI -Method Post)
    $Results = $Parameters | Invoke-RestMethod -Uri $PushoverURI -Method Post
    $Results | Add-Member -MemberType NoteProperty -Name DateTime -Value (Get-Date)
    $Results | Add-Member -MemberType NoteProperty -Name Title -Value $Parameters.Title
    $Global:PreviousPushMessages += $Results
    Write-Output $Results
}

