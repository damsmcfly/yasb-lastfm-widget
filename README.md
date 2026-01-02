# yasb-lastfm-widget
Last.fm widget for YASB

![YASB - lastfm-widget](https://raw.githubusercontent.com/damsmcfly/yasb-lastfm-widget/refs/heads/main/lastfm-widget.png)


## 1.  lastfm-widget.ps1
Save this file to a folder, it will be needed for step 3.  
Be sure to replace:  
- ```<CHANGE_API_KEY_HERE>``` with your [last.fm API key](https://www.last.fm/api/account/create)
- ```<CHANGE_USERNAME_HERE>``` with your Last.fm username.

## 2.  lastfm-widget.cmd
Save this file to the same folder.  

## 3. YASB's config.yaml
Copy/Paste the code of ```config.yaml``` in your own ```config.yaml``` file.  
Make sure to replace:  
- ```<___CHANGE_PATH_HERE___>``` with the full path to the ```lastfm-widget.cmd``` file you just saved  
- ```<___CHANGE_USERNAME_HERE___>``` with your Last.fm username

Then in your ```config.yaml```, chose the position of the ```lastfm``` widget (```left[]```, ```center[]```, ```right[]```), like in this example:
```
bars:
  primary-bar:
    widgets:
      center:
      - "lastfm"
```

## 3. YASB's styles.css
If you’d like to color the icon using Last.fm’s signature red, add the content of ```styles.css``` to your own ```styles.css```
