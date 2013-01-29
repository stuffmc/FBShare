FBShare Demo App
===

This is a sample code to show the different ways of posting to Facebook.

One simple way is using `SLComposeViewController` but it's not very powerfull.

The `SLRequest` way required a little bit of digging in Facebook's docs and [this post on SO](T: http://facebook.stackoverflow.com/questions/12644229/ios-6-facebook-posting-procedure-ends-up-with-remote-app-id-does-not-match-stor) helped me a lot!

It's a 2 step process though the first time (which, given, can be done in one):

1. An initial step is for the user to "allow the app" to post for him
2. Then, on each "post" it's asked again

It means the very first time it's required to show 2 steps (the first one could done in some settings or else, but since you don't need a setting with the Facebook credentials in your app...)

Enjoy!