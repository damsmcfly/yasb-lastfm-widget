$ProgressPreference = 'SilentlyContinue'

# Configuration
$api_key = "<CHANGE_API_KEY_HERE>"
$user = "<CHANGE_USERNAME_HERE>"
$period = "7day"
$limit = 5

# Fetch user info
$userInfo = Invoke-RestMethod "https://ws.audioscrobbler.com/2.0/?method=user.getinfo&user=$user&api_key=$api_key&format=json"

# Fetch top artists
$topArtists = Invoke-RestMethod "https://ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=$user&api_key=$api_key&format=json&limit=$limit&period=$period"

# Fetch top albums
$topAlbums = Invoke-RestMethod "https://ws.audioscrobbler.com/2.0/?method=user.gettopalbums&user=$user&api_key=$api_key&format=json&limit=$limit&period=$period"

# Fetch top tracks
$topTracks = Invoke-RestMethod "https://ws.audioscrobbler.com/2.0/?method=user.gettoptracks&user=$user&api_key=$api_key&format=json&limit=$limit&period=$period"

# Extract user info
$playcount =       [int64]$userInfo.user.playcount
$artist_count =    [int64]$userInfo.user.artist_count
$track_count =     [int64]$userInfo.user.track_count
$album_count =     [int64]$userInfo.user.album_count
$registered =      [int64]$userInfo.user.registered.unixtime
$username =        $userInfo.user.name

# Format numbers with spaces
$playcountFormatted =       '{0:N0}' -f $playcount -replace ',', " "
$artist_countFormatted =   '{0:N0}' -f $artist_count -replace ',', " "
$track_countFormatted =    '{0:N0}' -f $track_count -replace ',', " "
$album_countFormatted =    '{0:N0}' -f $album_count -replace ',', " "

# Convert unix time → YYYY-MM-DD
$registeredDate = [DateTimeOffset]::FromUnixTimeSeconds($registered).ToString('yyyy-MM-dd')

# Format top 5 artists as a string
$top5ArtistsString = ""
foreach ($artist in $topArtists.topartists.artist) {
    $top5ArtistsString += "- $($artist.name) ($($artist.playcount))<br>"
}
$top5ArtistsString = $top5ArtistsString.TrimEnd("<br>")

# Format top 5 albums as a string
$top5AlbumsString = ""
foreach ($album in $topAlbums.topalbums.album) {
    $top5AlbumsString += "- $($album.name) by $($album.artist.name) ($($album.playcount))<br>"
}
$top5AlbumsString = $top5AlbumsString.TrimEnd("<br>")

# Format top 5 tracks as a string
$top5TracksString = ""
foreach ($track in $topTracks.toptracks.track) {
    $top5TracksString += "- $($track.name) by $($track.artist.name) ($($track.playcount))<br>"
}
$top5TracksString = $top5TracksString.TrimEnd("<br>")

# Create output object
$output = @{
    playcount =         $playcountFormatted
    artist_count =      $artist_countFormatted
    track_count =       $track_countFormatted
    album_count =       $album_countFormatted
    username =          $username
    registered =        $registeredDate
    top_artists =       $top5ArtistsString
    top_albums =        $top5AlbumsString
    top_tracks =        $top5TracksString
}

# Output as JSON
$output | ConvertTo-Json -Compress
