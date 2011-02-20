# README

## How-to

    > require 'crowd-auth'
    
    > c = Crowd::Auth.new
    > c.crowd_url = "http://your.crowd.url:8095"
    > c.crowd_app_name = "app_name"
    > c.crowd_app_pass = "app_password"
    
    > resp = c.authenticate('username', 'password')
    
    > puts resp.code
    200
    
Anything but a 200 means authorization failed.

Overload `crowd_auth_uri` with your crowd's rest url.

By default, that is `/crowd/rest/usermanagement/latest/authentication`

## Thanks

[Kastner](http://metaatem.net "Kastner"), as always for the insight and help making things cleaner.
