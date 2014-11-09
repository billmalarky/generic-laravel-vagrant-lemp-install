<?php

/*
|--------------------------------------------------------------------------
| Register The Artisan Commands
|--------------------------------------------------------------------------
|
| Each available Artisan command must be registered with the console so
| that it is available to be called. We'll register every command so
| the console gets access to each of the command object instances.
|
*/

/* Example command
//DatasiftKeywordStream
//Connects to datasift and begins streaming active keywords.
$configVariable = new ConfigVariable();
$datasiftCsdl = new Datasift_csdl();
$datasiftInteractionKeyword = new Datasiftinteractionkeyword();
$datasiftInteraction = new Datasiftinteraction();
$interactionFollowup = new Interactionfollowup();

Artisan::add(new DatasiftKeywordStream($configVariable, $datasiftCsdl, $datasiftInteractionKeyword, $datasiftInteraction, $interactionFollowup));
*/