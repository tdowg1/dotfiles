<?php
/**
 * COPIED FROM
 * svn://svn/de/trunk/lang/php
 */
/**
 * NOTES
 */
//for some reason: not able to upload a 7.5MB bitmap file......? why not?
//	may need to create an .htaccess file within the directory where te script is
//	exectued, and place this in it:
//		php_value upload_max_filesize 10M
//
//	may need to create an php.ini file within the directory where te script is
//	exectued, and place this in it:
//		upload_max_filesize = 2M
//		max_execution_time = 120
//		post_max_size = 8M
//
//	also found...
//		<IfModule mod_php4.c>
//		php_value upload_max_filesize 8M
//		</IfModule>

/*********************** ***************************/
include "include.php";
/*********************** ***************************/





/*********************** ***************************/
//file upload error (really STATUS) codes
/*********************** ***************************/
echo <<<STOP
<pre>
<a href="http://us3.php.net/manual/en/features.file-upload.errors.php">
	Error Messages Explained
</a>
<h3>========= file upload ERROR (really STATUS) CODES</h3>
 * NOTE: there is no error with Value 5

STOP;

function file_upload_error_message($error_code) {
	switch ($error_code) {
		case UPLOAD_ERR_OK:
			return "UPLOAD_ERR_OK There is no error, the file upload succeeded";
		case UPLOAD_ERR_INI_SIZE:
			return 'UPLOAD_ERR_INI_SIZE The uploaded file exceeds the upload_max_filesize directive in php.ini';
		case UPLOAD_ERR_FORM_SIZE:
			return 'UPLOAD_ERR_FORM_SIZE The uploaded file exceeds the MAX_FILE_SIZE directive that was specified in the HTML form';
		case UPLOAD_ERR_PARTIAL:
			return 'UPLOAD_ERR_PARTIAL The uploaded file was only partially uploaded';
		case UPLOAD_ERR_NO_FILE:
			return 'UPLOAD_ERR_NO_FILE No file was uploaded';
		case UPLOAD_ERR_NO_TMP_DIR:
			return 'UPLOAD_ERR_NO_TMP_DIR Missing a temporary folder';
		case UPLOAD_ERR_CANT_WRITE:
			return 'UPLOAD_ERR_CANT_WRITE Failed to write file to disk';
		case UPLOAD_ERR_EXTENSION:
			return 'UPLOAD_ERR_EXTENSION File upload stopped by extension';
		default:
			return 'Unknown upload error. Expected integer within [0,8]';
	}
}

$error_code_range = range(0, 8);
foreach ($error_code_range as $currError) {
	println($currError . ":" . file_upload_error_message($currError));
}




/*********************** ***************************/
//ini directives to assist debugging
/*********************** ***************************/
echo <<<STOP
<br/>
<a href="http://us3.php.net/manual/en/ini.list.php">
	List of <em>php.ini</em> directives
</a>
<a href="http://us3.php.net/manual/en/ini.core.php">
	Description of core <em>php.ini</em> directives
</a>
<h3>========= INI directives to assist debugging</h3>
STOP;

$ini_directives = "";
$ini_directives[] = "php_ini_loaded_file";
$ini_directives[] = "php_ini_scanned_files";

foreach ($ini_directives as $key => $curIni) {
	println($curIni . ":" . ini_get($curIni));
}


/*********************** ***************************/
//ini directives related to file upload configuration options
/*********************** ***************************/
echo <<<STOP
<br/>
<h3>========= INI directives related to file upload configuration options</h3>
STOP;

$ini_directives = "";
$ini_directives[] = "file_uploads";
$ini_directives[] = "memory_limit";
$ini_directives[] = "max_execution_time";
$ini_directives[] = "max_input_time";
$ini_directives[] = "post_max_size";
$ini_directives[] = "upload_tmp_dir";
$ini_directives[] = "upload_max_filesize";

foreach ($ini_directives as $key => $curIni) {
	println($curIni . ":" . ini_get($curIni));
}

println("original upload_max_filesize:" . ini_get("upload_max_filesize"));
if(ini_set("upload_max_filesize", "8M") == FALSE){
	println("could not " . 'ini_set("upload_max_filesize", "8M") == FALSE){');

} else {
	println("success");
}

println("after supposed to change upload_max_filesize:" . ini_get("upload_max_filesize"));


die();


/*********************** ***************************/
//
/*********************** ***************************/
echo <<<STOP
</pre>
STOP;



?>