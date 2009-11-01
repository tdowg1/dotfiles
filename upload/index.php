<?php
					/*********************** ***************************RUN AND LOAD TIME*/
					$starttime = microtime();
					$startarray = explode(" ", $starttime);
					$starttime = $startarray[1] + $startarray[0];
						/** COMMENT SWITCH **/
					//$endtime = microtime();
					//$endarray = explode(" ", $endtime);
					//$endtime = $endarray[1] + $endarray[0];
					//$totaltime = $endtime - $starttime;
					//$totaltime = round($totaltime,5);
					////echo "This page loaded in $totaltime seconds.";
					//$ret .= "This page loaded in $totaltime seconds.";
/*********************** *************************** /RUN AND LOAD TIME*/
/*********************** ***************************/
include "include.php";
/*********************** ***************************/


function cbarray_prepend_string(&$array, $key, $string_to_prepend){
	$array = $string_to_prepend . $array;
}
/*********************** ***************************/



/**
 * Takes an array generated by 1 or more <input type="file"... elements in a form.
 * These <input... elements are setup like
 * 	<input type="file" name="upload_file[]"/>
 * 	<input type="file" name="upload_file[]"/>
 * 	...
 *
 * @param string $relativeDirectoryName where to store file uploads
 * @param array $_FILES_upload_file the $_FILES['upload_file'] array
 * @return unknown_type
 */
function handle_upload($relativeDirectoryName, $_FILES_upload_file){
	$html[] = "";
	$filenameTemp = $relativeDirectoryName . "uploaded_file.tmp";

	foreach($_FILES_upload_file["error"] as $key => $error) {
		/**
		 * only continue if no errors
		 */
		if ($error == UPLOAD_ERR_OK) {
			if (move_uploaded_file($_FILES_upload_file['tmp_name'][$key], $filenameTemp)) {

				$filenameTemp_relative = $relativeDirectoryName . basename($filenameTemp);
				$filenameActual = $relativeDirectoryName . $_FILES_upload_file['name'][$key];

				$html[] = "[" . basename($filenameActual) . "]";
				if(is_file($filenameActual)){
					$html[] = "UPDATE";
					$html[] = "\t" . md5_file($filenameActual) . " (old md5)";
				} else {
					$html[] = "CREATE";
				}


				if(rename($filenameTemp_relative, $filenameActual)){
					$html[] = "\t" . md5_file($filenameActual) . " (new md5)";
//					$html[] = "<p>Upload Successful - file is " . basename($filenameActual) . "</p>";
				} else {
					$html[] = "<p>Rename UnSuccessful - file was " . basename($filenameActual) . "</p>";
				}

			} else {
				$html[] = "<p>An error occurred</p>";
			}
		}
	}
	return implode("\n", $html);
}





cfparam($_REQUEST["request"], "formUploadFiles");
$htmlBody[] = "";


switch (strtoupper($_REQUEST["request"])) {
	case "HANDLE_UPLOAD":
		$htmlBody[] = handle_upload($UPLOAD, $_FILES['upload_file']);
		break;

	case "FORMUPLOADFILES":
//		$fp = fopen($INCLUDES . "body-formUploadFiles.html", "r");
//		$htmlBody[] = fread($fp, filesize($INCLUDES . "body-formUploadFiles.html"));
//		fclose($fp);
//		break;

	default:
//		$fp = fopen($INCLUDES . "body-formViewFiles-open.html", "r");
//		$htmlBody[] = fread($fp, filesize($INCLUDES . "body-formViewFiles-open.html"));
//		fclose($fp);
//
//		$htmlBody[] = formViewFiles($UPLOAD);
//
//		$fp = fopen($INCLUDES . "body-formViewFiles-close.html", "r");
//		$htmlBody[] = fread($fp, filesize($INCLUDES . "body-formViewFiles-close.html"));
//		fclose($fp);

		$htmlBody[] = "hi from " . $_SERVER["PHP_SELF"];
		$htmlBody[] = "<h2>how to upload here</h2>";
		$htmlBody[] = "<p>for each file, specifiy like this</p>";
		$htmlBody[] = 'curl -F "upload_file[]==@FILE" -F "request=HANDLE_UPLOAD" ' . $SELFFILEWWW;


}


/**
 * html header and footer text
 */
$fp = fopen($INCLUDES . "header.html", "r");
$HEADER = fread($fp, filesize($INCLUDES . "header.html"));
fclose($fp);

$fp = fopen($INCLUDES . "footer.html", "r");
$FOOTER= fread($fp, filesize($INCLUDES . "footer.html"));
fclose($fp);


/**
 * output page content
 */
//echo $HEADER;
echo implode("\n", $htmlBody);
echo "\n";
//echo $FOOTER;




					/*********************** ***************************RUN AND LOAD TIME*/
					//$starttime = microtime();
					//$startarray = explode(" ", $starttime);
					//$starttime = $startarray[1] + $startarray[0];
						/** COMMENT SWITCH **/
					$endtime = microtime();
					$endarray = explode(" ", $endtime);
					$endtime = $endarray[1] + $endarray[0];
					$totaltime = $endtime - $starttime;
					$totaltime = round($totaltime,5);
//					echo "\nThis page loaded in $totaltime seconds.\n";
					//$ret .= "This page loaded in $totaltime seconds.";
					/*********************** ***************************RUN AND LOAD TIME*/

?>