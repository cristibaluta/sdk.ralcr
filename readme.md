About
=====
This framework is for Haxe application development.

Getting started
===============

Most of the classes in this framework are prefixed with **RC** (which stands for RalCr) and can be used without writing imports and worrying about name clashes. However, you do need to let your project know about this classes with -cp

One way to do this is to place the framework at a stable location and create a hxml in the same location with this content:

* -cp /Users/Cristi/Documents/sdk.ralcr/CoreAnimation
* -cp /Users/Cristi/Documents/sdk.ralcr/CoreAnimation/Transitions
* -cp /Users/Cristi/Documents/sdk.ralcr/DrawKit
* -cp /Users/Cristi/Documents/sdk.ralcr/Events
* -cp /Users/Cristi/Documents/sdk.ralcr/Foundation
* -cp /Users/Cristi/Documents/sdk.ralcr/GameKit
* -cp /Users/Cristi/Documents/sdk.ralcr/IOKit
* -cp /Users/Cristi/Documents/sdk.ralcr/MediaKit
* -cp /Users/Cristi/Documents/sdk.ralcr/Network
* -cp /Users/Cristi/Documents/sdk.ralcr/Physics
* -cp /Users/Cristi/Documents/sdk.ralcr/Services
* -cp /Users/Cristi/Documents/sdk.ralcr/Skins
* -cp /Users/Cristi/Documents/sdk.ralcr/UIKit
* -cp /Users/Cristi/Documents/sdk.ralcr/Utils

The paths should reflect your absolute paths. Then in you application hxml you write the path to this hxml without any keyword. For example:
`sdk.ralcr.hxml`