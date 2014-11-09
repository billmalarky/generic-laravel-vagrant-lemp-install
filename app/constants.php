<?php

/**
 * This is where we define all of the application constants.
 * 
 */

//BR
//Defined as the newline tag. Either <br> for html, or \n for command line.
if (PHP_SAPI == 'cli'){
    define("BR", "\n");
}
else{
    define("BR", "<br>");
}
