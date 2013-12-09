$PushoverURI = 'https://api.pushover.net/1/messages.json'
$PushoverUserKey = 'udFKDUGUbYXm32uogzLcp4EHskkBAV'
$PushoverAppToken = 'agAvpEEvTb36Cdo6HkV5yUq6eyNT1q'

Function Send-PushoverMessage {
param(
    $Message = "",
    $Title = "",
    $URL = '',
    $URLTitle = ''
)


    $Parameters = @{
        token=$PushoverAppToken
        user=$PushoverUserKey
        message=$Message
        title=$Title
        url=$URL
        url_title=$URLTitle

    }

    Write-Output ($Parameters | Invoke-RestMethod -Uri $PushoverURI -Method Post)

}

Send-PushoverMessage -Title "Test" -Message "Patriots Won" -URL 'http://ngetchell.com' -URLTitle 'Best Blog Ever'