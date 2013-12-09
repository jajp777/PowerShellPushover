$PushoverURI = 'https://api.pushover.net/1/messages.json'
$PushoverUserKey = 'udFKDUGUbYXm32uogzLcp4EHskkBAV'
$PushoverAppToken = 'agAvpEEvTb36Cdo6HkV5yUq6eyNT1q'

Function Send-PushoverMessage {
param(
    $Message = "",
    $Title = "",
    $URL = '',
    $URLTitle = '',
    [ValidateSet("-1","0","1","2")] 
    [int]$Priority = '0'
)


    $Parameters = @{
        token=$PushoverAppToken
        user=$PushoverUserKey
        message=$Message
        title=$Title
        url=$URL
        url_title=$URLTitle
        priority=$Priority

    }

    Write-Output ($Parameters | Invoke-RestMethod -Uri $PushoverURI -Method Post)

}