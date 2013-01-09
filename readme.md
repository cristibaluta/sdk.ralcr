## Overview

sdk.ralcr is a framework for building Haxe applications for Mac, iOS, Android, Flash or Javascript. It's syntax and structure is similar with the Apple frameworks, so:
* The classes are grouped into categories which are physical folders on the disk
* The classes do not require imports because they are all on the root level with very few exceptions. The name collisions with possible custom classes is avoided by few prefixes: RC for most of the classes, CA for the Animation engine, EV for Signal events, SK for skins

## Installation

sdk.ralcr is in the process of becoming a haxelib, but in the meantime you can clone this repository

	git clone git@github.com:ralcr/sdk.ralcr.git

## Getting started

Because the framework is a collection of organised root level classes it is not possible to use it from haxelib with -lib, you need to add each collection path as a classpath in your hxml. This can be done by the Run script provided. Go to the sdk root and type

	neko run

This will produce a sdk.ralcr.hxml file in the same location. Copy this file to your project and include it's name on a new line in your hxml. By doing this your project will have the classpaths to the sdk.ralcr framework.
The run script for haxelib has a new command to build a template with all the basic files in the right place. So, go into your sistem and create a folder for you project

	mkdir MyProject
	cd MyProject
	haxelib run new
	
Voila, open the project with your preferred editor and compile. By now you should be able to compile for flash and javascript by running compile.hxml, and for Mac, iOS and Android by running compile.nmml with nme

	haxe compile.hxml
	nme test mac
	nme test ios
	nme test android

The framework can be compiled to flash or javascript, but is also compatible with the NME library which makes possible to compile for mac, ios, android.

