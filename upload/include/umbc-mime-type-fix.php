<?php

/**
 * Adds a function called mime_content_type which
 * emulates the standard PHP function if not present.
 *
 * args:
 *   $f - the full path to the file
 * returns:
 *   the mime type (with optional character encoding)
 */
if (!function_exists('mime_content_type')) {
	function mime_content_type ($f) {
		return trim(exec('file -bi ' . escapeshellarg ($f)));
	}
}

/**
 * Adds a function called human_mime_content_type which
 * returns a human readable description of the file type.
 *
 * args:
 *   $f - the full path to the file
 * returns:
 *   a human readable description of the file type
 */
if (!function_exists('human_mime_content_type')) {
	function human_mime_content_type ($f) {
		return trim(exec('file -b ' . escapeshellarg ($f)));
	}
}

?>