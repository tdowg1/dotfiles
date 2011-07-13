<?php
/*********************** ***************************/
$SELFWWW = $_SERVER["PHP_SELF"];
//^^ SELFFILEWWW ?
$SELFFULLYQUALIFIED = $_SERVER["SCRIPT_FILENAME"];
$SELFDIRFULLYQUALIFIED = dirname($SELFFULLYQUALIFIED) . "/";

/*********************** ***************************/

$protocol = "http";
//^^how to tell if https or not?  oh well, use http for now.
$hostname = $_SERVER["HTTP_HOST"];
$path = dirname($_SERVER["PHP_SELF"]);
$file = basename($_SERVER["PHP_SELF"]);

// like http://host.com/some/path/
$SELFDIRWWW = $protocol . "://$hostname" . $path;

// like http://host.com/some/path/someFile.php
$SELFFILEWWW = $SELFDIRWWW . "/" . $file;

/*********************** ***************************/

$INCLUDES = "include/";
/* public upload directory */
$UPLOAD = "../dotfiles/";
	// couldn't find anywhere, where $UPLOADDIRFULLYQUALIFIED was being used...
	// remove it if it's not needed.......
$UPLOADDIRFULLYQUALIFIED = $SELFDIRFULLYQUALIFIED . "/" . $UPLOAD;
//	$longFilename = dirname($SELFFULLYQUALIFIED) . "/" . $UPLOAD . "/" . $file;
/** ??? **/
//$PUBLICFULLYQUALIFIED = dirname($SELFFULLYQUALIFIED) . "/" . $UPLOAD . "/";
//^^^want to do this???


/*********************** ***************************/
// NOT FOR PRODUCTION
/*********************** ***************************/
include $INCLUDES . "cfdump.php";
/*********************** ***************************/


/*********************** ***************************/
// production
/*********************** ***************************/


include $INCLUDES . "cfparam.php";
include $INCLUDES . "println.php";
include $INCLUDES . "list_directory_contents.php";
include $INCLUDES . "umbc-mime-type-fix.php";
/*********************** ***************************/
?>