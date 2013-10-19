$PushoverURI = 'https://api.pushover.net/1/messages.json'
$PushoverUserKey = 'udFKDUGUbYXm32uogzLcp4EHskkBAV'
$PushoverAppToken = 'agAvpEEvTb36Cdo6HkV5yUq6eyNT1q'

Function Send-PushoverMessage {
param(
    $Message = "",
    $Title = ""
)


    $Parameters = @{
        token=$PushoverAppToken
        user=$PushoverUserKey
        message=$Message
        title=$Title

    }

    Write-Output ($Parameters | Invoke-RestMethod -Uri $PushoverURI -Method Post)

}

