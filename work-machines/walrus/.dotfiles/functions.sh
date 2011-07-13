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
	echo "	create and check in a new file"
	echo "cleartool mkelem -ci -nc FILE"
	echo "	add a file (if no -ci, file is added but not its content--MUST cin at some point!)"
	echo "cleartool mkelem -ci -nc FILENAME"
	echo "	recursive add a file"
	echo "find . -type f -exec cleartool mkelem -ci -nc '{}' \;"
	echo "	checkin entire directory structure (PREVIEW**)"
	echo "clearfsimport -preview -recurse -nsetevent ~/tmp/* aerothai/"
	echo "	REMOVE a version of a file (like svn delete)"
	echo "cleartool rmname FILENAME"
	echo "	REMOVE a version of a directory"
	echo ""
	echo "	get more HELP..."
	echo "cleartool [help|man] command"
}


############## ALTERNATIVE ways to recursive checkin
#http://stackoverflow.com/questions/973956/recursive-checkin-using-clearcase
#ct lsco -r -cvi -fmt "ci -nc \"%n\"\n" | ct
#ct lsco -r -cvi -fmt "unco -rm %n\n" | ct  

############## ALTERNATIVE way to recursive checkin/mkelem/--add new files
#clearfsimport -preview -rec -nset c:\sourceDir\* m:\MyView\MyVob\MyDestinationDirectory
#clearfsimport -preview -recurse -nsetevent ~/tmp/interop-vnms-configs/* aqp_iop/




_clearcase_recursive_HANDLER(){
	#echo "\$#[${#}]"
	what_to_do=$1
	shift
	#echo "shift; \$#[${#}]"


	# setup list of File System Objects (FSO) to operate on...
	FSO="${*}"
	if [[ $# = 0 ]] || [[ $# = 1 ]] && [[ "$1" = "" ]] ; then
		echo "No argument given! ... starting at current working directory"
		FSO="`pwd`"
	fi


	# ... operate on.
	for x in ${FSO}; do
		echo "[${x}] cc recursive ${what_to_do}..."

		if [[ -d "${x}" || -f "${x}" ]] ; then
			#
			# interpolate function call
			eval "_clearcase_recursive_${what_to_do}" "${x}"
			
#		elif [[ -f "${x}" ]] ; then
#			echo "	IS A FILE: use cout (alias cout='$CT checkout -nc ')!"
#			echo "	IS A FILE: use cin (alias cin='$CT checkin -nc ')!"
#			echo "	IS A FILE: use uncout (alias uncout='$CT uncheckout -rm ')!"
#			echo "		Dev-decidE::should I automatically call cout on a file for you?"
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






fixvimrc(){
	echo "attempt remove .vimrc symlink into production... that's in my home"
	rm -i ~/.vimrc
	[ $? != 0 ] && return

	echo "attempt to recreate my own .vimrc..."
	cp -i ~/.dotfiles/vimrc ~/.vimrc
}

# make accurev help paginate politely
achelp(){
	accurev help $* | less -FX
}

# this function helps w/ searching through a same set of files
grepdotfiles(){
	local filesToGrep=$(cat <<__HEREDOC__
		$HOME/.bash_[pu]*
		$HOME/.bashrc
		$HOME/.dotfiles/*
__HEREDOC__
	)

	for f in $filesToGrep ; do
		echo "[$f]:"
		grep -n "${*}" ${f}
	done
}

# function to pull files from walrus
alias pull='mvinpull'
mvinpull(){
	echo "scp pull dotfiles from walrus...";
	scp -r bdavies@walrus:.dotfiles ~/
	scp bdavies@walrus:.screenrc ~/
	scp bdavies@walrus:.vimrc ~/
}


