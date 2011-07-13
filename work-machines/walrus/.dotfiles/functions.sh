#!/bin/bash
#

helpmd5(){
	echo "cd $DIR ; find . -type f -exec md5sum '{}' \; > dir.md5"
	echo "cd $DIR ; md5sum --check dir.md5 | grep -v ' FAILED'"
}
helpclearcase(){
	echo "	recursive CHECKOUT"
	echo "cleartool find . -version 'version(/main/LATEST)' -exec 'cleartool co -nc \$CLEARCASE_PN'"
	echo "	recursive CHECKIN"
	echo "cleartool find . -version 'version(/main/LATEST)' -exec 'cleartool ci -nc \$CLEARCASE_PN'"
	echo "	recursive UNCHECKOUT"
	echo "cleartool find . -version 'version(/main/LATEST)' -exec 'cleartool unco -rm \$CLEARCASE_PN'"
	echo "	recursive LIST CHECKOUTS"
	echo "cleartool lsco -r ."
	echo "	create and check in a new folder"
	echo "cleartool mkdir -nc FOLDERNAME"
}






_clearcase_recursive_HANDLER(){
	#echo "\$#[${#}]"
	what_to_do=$1
	shift
	#echo "shift; \$#[${#}]"


	# setup list of File System Objects to operate on...
	FSO="${*}"
	if [[ $# = 0 ]] || [[ $# = 1 ]] && [[ "$1" = "" ]] ; then
		echo "No argument given! ... starting at current working directory"
		FSO="`pwd`"
	fi


	# ... operate on.
	for x in ${FSO}; do
		echo "[${x}] cc recursive ${what_to_do}..."

		if [[ -d "${x}" ]] ; then
			#
			# interpolate function call
			eval "_clearcase_recursive_${what_to_do}" "${x}"
		elif [[ -f "${x}" ]] ; then
			echo "	IS A FILE: use cout (alias cout='$CT checkout -nc ')!"
			echo "	IS A FILE: use cin (alias cin='$CT checkin -nc ')!"
			echo "	IS A FILE: use uncout (alias uncout='$CT uncheckout -rm ')!"
			echo "		Dev-decidE::should I automatically call cout on a file for you?"
		else
			echo "	expected ${x} to be a directory"
			return
		fi
	done
	return
}

_clearcase_recursive_checkin(){
	if [[ $# = 1 ]] ; then
		cleartool find "$1" -version 'version(/main/LATEST)' -exec 'cleartool ci -nc $CLEARCASE_PN'
	fi
}
_clearcase_recursive_checkout(){
	if [[ $# = 1 ]] ; then
		cleartool find "$1" -version 'version(/main/LATEST)' -exec 'cleartool co -nc $CLEARCASE_PN'
	fi
}
_clearcase_recursive_uncheckout(){
	if [[ $# = 1 ]] ; then
		cleartool find "$1" -version 'version(/main/LATEST)' -exec 'cleartool unco -rm $CLEARCASE_PN'
	fi
}
_clearcase_recursive_mkelem(){
	if [[ $# = 1 ]] ; then
		find "$1" -type f -exec cleartool mkelem -ci -nc '{}' \;
	fi
}

cinr(){
	_clearcase_recursive_HANDLER "checkin" "${*}"
}
coutr(){
	_clearcase_recursive_HANDLER "checkout" "${*}"
}
uncoutr(){
	_clearcase_recursive_HANDLER "uncheckout" "${*}"
}
mkelemr(){
	_clearcase_recursive_HANDLER "mkelem" "${*}"
}













OLDcoutr(){
	echo "cc recursive checkout..."
	_clearcase_recursive_HANDLER "coutr" "${*}"

	return



	if [[ $# = 0 ]] ; then
		echo "start at current working directory"
		cleartool find . -version 'version(/main/LATEST)' -exec 'cleartool co -nc $CLEARCASE_PN'
		return
	fi

#	for x in "${*}"; do
	for x in ${*}; do
		echo "[${x}]"


		if [[ -d "${x}" ]] ; then
			cleartool find "${x}" -version 'version(/main/LATEST)' -exec 'cleartool co -nc $CLEARCASE_PN'
		elif [[ -f "${x}" ]] ; then
			echo "	IS A FILE: use cout (alias cout='$CT checkout -nc ')!"
			echo "		Dev-decidE::should I automatically call cout on a file for you?"
		else
			echo "	expected ${x} to be a directory"
			return
		fi
	done

return

	echo "$1"
	echo "in 3 seconds"
	sleep 3

	if [[ $? = 0 ]] ; then
		cleartool find "$1" -version 'version(/main/LATEST)' -exec 'cleartool co -nc $CLEARCASE_PN'
	fi
}

NEVERcoutr(){
		case $what_to_do in

			cinr)
			;;
			coutr)
				dir_zip_unzip_and_rename "$SUBDIR"
				RC=$?;
			;;
			uncoutr)
				_clearcase_recursive_HANDLER "${*}"
			;;
			*) # ...
				echo "expected 1 of"
				echo "cinr coutr uncoutr"
			;;
		esac
}
