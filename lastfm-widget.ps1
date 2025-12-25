$ProgressPreference = 'SilentlyContinue'

$r = Invoke-RestMethod 'https://ws.audioscrobbler.com/2.0/?method=user.getinfo&user=<___CHANGE_USERNAME_HERE___>&api_key=<___CHANGE_API_KEY_HERE___>&format=json'

$playcount = 	[int64]$r.user.playcount
$artist_count = [int64]$r.user.artist_count
$track_count = 	[int64]$r.user.track_count
$album_count = 	[int64]$r.user.album_count
$registered = 	[int64]$r.user.registered.unixtime
$username  = 	$r.user.name

# format number with spaces
$playcountFormatted = 		'{0:N0}' -f $playcount -replace ',', " "
$artist_countFormatted = 	'{0:N0}' -f $artist_count -replace ',', " "
$track_countFormatted = 	'{0:N0}' -f $track_count -replace ',', " "
$album_countFormatted = 	'{0:N0}' -f $album_count -replace ',', " "

# convert unix time → YYYY-MM-DD
$registeredDate = [DateTimeOffset]::FromUnixTimeSeconds($registered).ToString('yyyy-MM-dd')

@{
    playcount = 	$playcountFormatted
    artist_count = 	$artist_countFormatted
    track_count = 	$track_countFormatted
    album_count = 	$album_countFormatted
    username  = 	$username
    registered  = 	$registeredDate
} | ConvertTo-Json -Compress