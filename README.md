# yasb-lastfm-widget
Last.fm widget for YASB

![YASB - lastfm-widget](https://raw.githubusercontent.com/damsmcfly/yasb-lastfm-widget/refs/heads/main/lastfm-widget.png)


## 1.  Create a file named lastfm-widget.ps1
Add the following content to the file. Be sure to replace <___CHANGE_API_KEY_HERE___> with your [last.fm API key](https://www.last.fm/api/account/create)) and <___CHANGE_USERNAME_HERE___> with your Last.fm username.
Save the file to a folder, it will be needed for step 2.
```
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
```

## 2. In YASB's config.yaml
Make sure to replace <___CHANGE_PATH_HERE___> with the full path to the lastfm-widget.ps1 file you just created, and <___CHANGE_USERNAME_HERE___> with your Last.fm username

```
lastfm:
    type: "yasb.custom.CustomWidget"
    options:
      label: "<span>\uf202</span> {data[playcount]}"
      label_alt: "<span>\uf202</span> {data[username]}, user since {data[registered]}"
      class_name: "lastfm-widget"
      tooltip: true
      tooltip_label: "<b>{data[username]}</b> (last.fm)<br><small><i>user since {data[registered]}</i></small><hr><span>\uf202</span> <b>Scrobbles:</b> {data[playcount]}<hr><span>\ued35</span> <b>Artists:</b> {data[artist_count]}<br><span>\udb81\uddee</span> <b>Albums:</b> {data[album_count]}<br><span>\udb81\udf5a</span><b>Tracks:</b> {data[track_count]}"
      exec_options:
        run_cmd: >
          powershell -NoProfile -File C:\<___CHANGE_PATH_HERE___>\lastfm-widget.ps1
        run_interval: 300000   # every 5 minutes
        return_format: "json"
        hide_empty: false
        use_shell: true
      callbacks:
        on_left: "exec cmd /c start https://www.last.fm/user/<___CHANGE_USERNAME_HERE___>"
        on_middle: "toggle_label"
```

## 3. In YASB's styles.css
If you’d like to color the icon using Last.fm’s signature red, add this to your styles.css

```
.lastfm-widget .widget-container .icon {
    color: #D92323;
}
```
