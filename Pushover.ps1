$PushoverURI = 'https://api.pushover.net/1/messages.json'
$PushoverUserKey = 'udFKDUGUbYXm32uogzLcp4EHskkBAV'
$PushoverAppToken = 'agAvpEEvTb36Cdo6HkV5yUq6eyNT1q'

Function Send-PushoverMessage {
param(
    $Message = "",
    $Title = "",
    [ValidateSet('-1','0','1','2')]
    $Priority = '0',
    [string]$URL ='',
    [string]$URLTitle = '',
    [DateTime]$Timestamp=(Get-Date),
    [String]$Device
)


    $Parameters = @{
        token=$PushoverAppToken
        user=$PushoverUserKey
        message=$Message
        title=$Title
        url=$URL
        url_title=$URLTitle
        Priority=$Priority
        Sound=$Sound
        device=$Device
        timestamp=(Get-Date $Timestamp -UFormat %s) -replace("[,\.]\d*", "")

    }

    Write-Output ($Parameters | Invoke-RestMethod -Uri $PushoverURI -Method Post)

}

