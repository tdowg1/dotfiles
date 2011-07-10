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
}

coutr(){
	echo "cc recursive checkout..."
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

