#!/bin/bash
#
helpsed(){
	echo "perform find/replace on files"
	echo ' sed -i "s/192.168.8.3/bryn-pc/" file1 [fileN]'
	echo 'PREVIEW file/replace on files'
	echo ' sed -n "s/192.168.8.3/bryn-pc/p" file1 [fileN]'
}

helpsvn(){
	echo "svn propset svn:keywords \"Id\" FILE"
}

helpmd5(){
	echo "cd \$DIR ; find . -type f -exec md5sum '{}' \; > dir.md5"
	echo "cd \$DIR ; md5sum --check dir.md5 | grep -v ' FAILED'"
}

helpclearcase(){
	echo "recursive CHECKOUT"
	echo "	cleartool find . -version 'version(/main/LATEST)' -exec 'cleartool co -nc \$CLEARCASE_PN'"
	echo "recursive CHECKIN"
	echo "	cleartool find . -version 'version(/main/LATEST)' -exec 'cleartool ci -nc \$CLEARCASE_PN'"
	echo "		lscoshort \$ccPath  | xargs -n 1 --verbose \$CT checkin -nc"
	echo "recursive UNCHECKOUT"
	echo "	cleartool find . -version 'version(/main/LATEST)' -exec 'cleartool unco -rm \$CLEARCASE_PN'"
	echo "recursive LIST CHECKOUTS"
	echo "	cleartool lsco -r ."
	echo "create and check in a new folder (Parent is co||unco?)"
	echo "	cleartool mkdir -nc FOLDERNAME"
	echo "create and check in a new file (Parent is co)"
	echo "	cleartool mkelem -ci -nc FILE"
	echo "		ADD a file (if no -ci, file is added but not its content--MUST cin at some point!) (Parent is co)"
	echo "recursive create and checkin entire directory structure (PREVIEW**) (Parent is NOT co)"
	echo "	clearfsimport -preview -recurse -nsetevent ~/tmp/WORKING_DIR/ CC_DESTINATION_DIR"
	echo "clearfsimport IS YOUR FRIEND FOR SYNC'ING CHANGES BW SRC TREES!!"
	echo "	/bin/ls \$svnPath/ | xargs --verbose -i{} -n 1 clearfsimport -recurse -nsetevent -rmname \$svnPath/{}/* \$ccPath/{}  | grep -v -P -i \"skipping|unchanged\""
	echo "recursive create and checkin a new a file (Parent is co)"
	echo "	find . -type f -exec cleartool mkelem -ci -nc '{}' \;"
	echo "REMOVE a version of a file (like svn delete)"
	echo "	cleartool rmname [-force] FILENAME"
	echo "REMOVE a version of a directory"
	echo "	cleartool rmview -tag VIEW-NAME"
	echo "REMOVE a view just by its name"
	echo ""
	echo "get more HELP..."
	echo "cleartool [help|man] command"
	echo ""
	echo "mkview (dynamic)"
	echo "	mkview -tag bdavies_GMS_140_INT3 -stream stream:GMS_140_Integration@/vobs/gms_pvob -stgloc viewstore"
	echo "mkstream (development)"
	echo "	cleartool mkstream -in stream:GMS_140_Integration@/vobs/gms_pvob stream:CR10976_DevCr11733_GUI-AcquisitionBF@/vobs/gms_pvob"
	echo "	see also: bash function:: setupSymlinkToCCview()"
	echo "startview (restart stopped views (e.g. server restart))"
	echo "	cleartool lsview | grep bdavies | grep GMS_140 | awk '{ print \$1 }' | xargs -n 1  --verbose  -x cleartool startview"
	echo ""
	echo "for GMS development+CC cin's and whatnot:"
	echo "must CHANGE CURR GROUP to be anp_cc (i.e. 'nn')"
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
	echo "MVINPULL(): scp pull dotfiles from walrus...";
	scp -r bdavies@walrus:.dotfiles ~/
	scp bdavies@walrus:.screenrc ~/
	echo "MVINPULL(): now run 'fixvimrc' to mv .dotfiles/vimrc ~> .vimrc"
}



#
# creates a ClearCase view (and a folder in your home directory containing
# a way to get to it)
#
# $0 <pvob> <streamname> [<viewname>]
# ex: $0 gms_pvob CR10976_DevCr11732_GUI-RetuneBT
#
#STUB: shouldnt this function be INSTEAD CALLED:: setupCCStream ?
#...... NO!! i think it actually creates a view, to the specified stream!... (i.e. notice the `cleartool mkview' command... compare this with `cleartool mkstream').
setupCCView(){
	#echo "this function does not work... exiting."
	#BOILERPLATE
	#[[ $# != 2 ]] || [[ $# != 3 ]] && \
	#	echo "usage: $FUNCNAME <pvob> <streamname> [<viewname>] \
	#	ex: $FUNCNAME gms_pvob CR10976_DevCr11732_GUI-RetuneBT" && return;

	pvob=$1
	streamName=$2

	subsystem="${pvob%_pvob}"   # for instance, "gms_pvob" -> "gms"
	
	# auto generate the view name
	prependToView="bdavies_"
	viewName="${prependToView}${streamName}"

#	if [ $# = 3 ] ; then
#		# forget the autogenerated viewname and use what was specified
#		viewName=$3
#	fi
	#/BOILERPLATE

	
	# create the view (ClearCase operation)
	cleartool mkview \
		-tag "${viewName}" \
		-stream "stream:${streamName}@/vobs/${subsystem}_pvob" \
		-stgloc viewstore
	
	return

#STUB: not executed::
	# create a pathway to this view from $HOME directory
	OLDPWD=`pwd`
	cd
	if [ "$subsystem" = "gms" ] ; then
		# do my custom gms setup
		echo 'matched gms_pvbo'

		mkdir ${viewNAME}
		cd ${viewNAME}
		ln -s /view/${viewNAME}/vobs/gms_cvob gms_cvob

	else
		# do it the 'gnms way' (or, what I'm calling for now--the 
		# generic way
		echo 'NOT matched gms_pvob'

		ln -s "/view/${viewName}/vobs/${subsystem}_cvob/" "${viewName}"
	fi
	cd "${OLDPWD}"

}



# function to setup CC view for GMS gui for development, the way I want it to be setup.
createSymlinkTogms_pvobCCView(){
	[ $# != 1 ] && echo -e "usage: $FUNCNAME <view name>\ne.g.: $FUNCNAME bdavies_\$COMMON" && return;
	
	viewNAME=$1
	OLDPWD=`pwd`

	cd
	mkdir ${viewNAME}
	cd ${viewNAME}
	ln -s /view/${viewNAME}/vobs/gms_cvob gms_cvob

	cd "${OLDPWD}"
}


