<?php


// $path : path to browse
// $mode : "FULL"|"DIRS"|"FILES"
//if($mode != "FILES"){ $dirlist[] = $path; }
function list_directory_contents($path, $mode = "FILES"){
	if(substr($path, strlen($path) - 1) != '/'){ $path .= '/'; }
	$dirlist = array();

	if($handle = opendir($path)){
		while(false !== ($file = readdir($handle))){
			if($file != '.' && $file != '..'){
				$dirlist[] = $file;
			}
		}
		closedir($handle);
	}
	natcasesort($dirlist);
	return($dirlist);
}

?>