<?php

function println($string_message = '') {
	return isset($_SERVER['SERVER_PROTOCOL']) ? print "$string_message<br />" . PHP_EOL:
	print $string_message . PHP_EOL;
}

?>