<?php
/** <!--
	$Rev: 879 $
	$Id: cfparam.php 879 2009-10-04 01:36:31Z tdowg1 $

	@desc (
		mimic behavior of the ColdFusion <cfparam... tag
	)@

	@parameters (

	)@

	@notes (

	)@

	@author	( tdowg1 )@
	@date	( May 09, 2008 )@
--> **/
/**
 * @desc parameterize a variable--set variable, $name, to a value, $default, if it is
 * not set.
 * @example
cfparam($a, "variable, a, is set by the cfparam() function!");
echo $a;
$b = "variable b is NOT set by the cfparam() function";
cfparam($b, "variable b ***IS*** set by the cfparam() function!!!!");
echo $b;
// ^^WILL OUTPUT:
variable, a, is set by the cfparam() function!
variable b is NOT set by the cfparam() function
 *
 * @category coldfusion
 * @param $name variable to parameterize
 * @param $default parameterization value
 * @return nothing
 */
function cfparam(&$name, $default){
	if(!isset($name)){
		$name = $default;
	}
}

?>