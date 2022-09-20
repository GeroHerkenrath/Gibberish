# Materials for Gero's "Swift & iOS Intro" held at HDI #

This repository holds some demo code I used to give a very condensed intro into the Swift programming language and iOS programming.
This was basically a talk for a "Dev-Friday" session at work.

I do not provide all materials to hold such a talk here (no presentation slides or presenter notes) as I mostly do these things on the fly.
Instead, this is basically a collection of code I slowly "unveiled" piece-wise to explain some concepts.

## Outline ##

The repo basically contains three things:
* `Gibberish.xcodeproj` and `Gibberish.xcworkplace`: A complete, small iOS app to illustrate loading data from a URL and displaying it in a SwiftUI driven user interface.
* `GibberishFirstDemoMaster.playground`: A playground "master file", see below.
* `listElement.php` and `listElement.yaml`. The PHP file used for the API from the example code and its OpenAPI specification.

The idea of the intro was the following:

I opened a new Swift playground first to show in screen and explain some very basic things.
Then I copied parts of the `GibberishFirstDemoMaster.playground` file (which I had on a secondary screen) over to the new playground and demonstrate what the new code does.
I mostly followed the pragma marks and comments from the "master playground", but not 100%.
Note that after a very brief syntax description (the target audience was developers, so I assumed knowledge of loops, ifs and so on) I began showing the power of extensions before detailing out more classical OOP concepts.
The reason for that was that I wanted to put a focus on protocol-oriented programming, an important concept in Swift that in a way deviates from more traditional OOP concepts in some aspects.

Once all that code was demonstrated and explained (which included some breaks, btw), I showed the actual iOS project, i.e. `Gibberish.xcodeproj` (the workspace was just included for convenience, there's nothing else in it). 
The rationale behind that was to show simpler Swift code first and not start with SwiftUI, which, being a DSL, is confusing for people unfamiliar with the basic language.

## The Demo-API ##

The `listElement.php` currently runs on my webspace (i.e. the URL in the demo code still works as I am writing this), but I might eventually remove it.
For this reason I included the code that drives the API in here as well.
Excuse anything egregious in terms of PHP, I virtually never programmed in that language (and I have "opinions" on it...). 
For the demo it works well enough I'd say. 
I also included a short spec to explain how it works in `listElement.yaml`.

~~To actually generate the random gibberish the API delivers I used another API, [https://www.randomtext.me/](https://www.randomtext.me/), by [Dale Davies](https://www.daledavies.co.uk). Thanks!~~

Unfortunately Dale's API seems to no longer work, so I switched to [Dino Ipsum](https://dinoipsum.com).
That had the best fit for me, although "Gibberish" now seems a bit odd, considering the text I provide is exclusively dinosaur names.
Oh well, it's fun and still serves its purpose. :smiley:

## Code signing ##

If this is the first time you play around with Swift and iOS (and Xcode) I should probably include a word about code signing here.
As `Gibberish.xcodeproj` is an iOS project and can theoretically run on a device it has code signing activated.
The development team is currently set to my personal team and, surprise, surprise, you will not be a part of that.

That means depending on what you do with the demo code, you might have to change that.
To do so, in Xcode, select the `Gibberish.xcodeproj` in the Project Navigator (the left side bar), then select the 'Gibberish' target and then the 'Signing & Capabilities' tab.
There you can change the team to your own personal one.

To get such a team you need to have an Apple developer acccount (i.e. an Apple ID that you use to log in [here](https://developer.apple.com/account/). 
You do NOT have to be enroled in the 100 $/year Developer program!

## Additional resources ##

* First and foremost, there is obviously [https://swift.org](https://swift.org).
* Also check out Apple's [Start Developing iOS Apps (Swift)](https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/) (I hope the link won't change...). It's small steps also for non-developers, but they do a great job so far I think.
* If you are interested in protocol-oroented programming and value types vs reference types I highly recommend these two WWDC talks (in that order): [Protocol-Oriented Programming in Swift](https://developer.apple.com/videos/play/wwdc2015/408/) and [Building Better Apps with Value Types in Swift](https://web.archive.org/web/20160423092250/https://developer.apple.com/videos/play/wwdc2015/414/) (note: this video has strangely disappeared from Apple's own site, so this is a web-archive link. You can download it from there, live watching is too slow, though).