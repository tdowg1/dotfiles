<?php
/*********************** ***************************/
$SELFWWW = $_SERVER['PHP_SELF'];
//^^ SELFFILEWWW ?
$SELFFULLYQUALIFIED = $_SERVER["SCRIPT_FILENAME"];
$SELFDIRFULLYQUALIFIED = dirname($SELFFULLYQUALIFIED) . "/";

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