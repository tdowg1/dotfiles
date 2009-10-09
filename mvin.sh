#!/bin/sh
#
# TODO
# should be prompting user for each dotfile
#	see how see tahoe installer handled default values
#	see how other people are handling default values in their user promts
#
#
#

fPROMPT_USER_stub(){
	return 0
}


f_usage(){
	local _USAGE=$(cat <<__HEREDOC__
${0}: designed to assist in keeping your dotfiles portable and synchronized.
Default behavior is to pull dotfiles from remote server and put under home directory.

usage: ${0} [--mvout] [--downloadonly]
	--mvout
		Reverse the default "move in" behavior (and "move out").  Push dotfiles
		from home directory to remote server.
	--downloadonly
		Same as default behavior except dotfiles are not put under home directory,
		but are left under the "tmp.mvin" folder that this script uses as its
		work directory.

misc/notes:
	lynx
	curl
__HEREDOC__
)

	echo "$_USAGE"
	exit 1;
}


#
# ARGUMENT PARSING AND SANITY CHECKING
#===================================================================
#

if [ $USER = 'root' ] ; then
	echo "no root user"
	f_usage
	exit 1;
fi


# check that $# one in (0, 1, 2)
#[ $# != 1 ] && f_usage


while [[ "$1" = -* ]] ; do
  case "$1" in
    --mvout) # no-value arg
			isMvIn="NO"
			shift
			;;
    --downloadonly) # no-value arg
			isDownloadOnly="YES"
			shift
			;;

    *)
		echo "ERROR case matched wildcard"
		f_usage
		;;
  esac
done




#
# VARIABLE PARAMS/CHECKING (see TEMPLATE.sh for more)
#===================================================================
#
# like cfparam=* required=yes
#: ${TEMPDIR2:?ERROR: not specified}
: ${HOME:?ERROR: HOME variable must be set}

#
# like cfparam=*
#: ${isMvout:="NO"}
: ${isMvIn:="YES"}
: ${isDownloadonly:="NO"}

#
# this programs scratch or work directory
: ${WORK_DIR:="${HOME}/tmp.mvin"}
#
# remote server address
: ${REMOTE_HOST:="http://bdavies522276/mvin"}
REMOTE_HOST='http://svn/muzik-work/mvin/dotfiles'
REMOTE_HOST='http://svn/intel_duo/mvin/dotfiles'
#REMOTE_HOST='http://svn/intel_duo/online-file-manager/'

#
# the set of all dot files to work with
: ${dot_files:="myaliases myvariables myfunctions"}
dot_files="inputrc mvinrc zshrc"





#
# FUNCTIONS
#===================================================================
#
fCreateWorkDirectory(){
	if [ ! -d $WORK_DIR ] ; then
		mkdir -p "${WORK_DIR}"
	else
		echo "ERROR: $WORK_DIR already exists! ...I want to be the one to create it"
		exit 2
	fi
}

fDownloadFiles(){
	echo "Retrieve dot files from remote host?... in 4 seconds..."
	sleep 4

	for dotfile in $dot_files ; do
		wget --no-verbose --directory-prefix="${WORK_DIR}" "$REMOTE_HOST/$dotfile"
	done
}

fInstallFiles(){
	echo "Move in $(ls ${WORK_DIR}/*) to your HOME? ...in 4 seconds..."
	sleep 4
	#
	# MOVE IN
	for dotfile in $dot_files ; do
		if [ $? = 0 ] ; then
			cp -v "${WORK_DIR}/${dotfile}" "${HOME}/.${dotfile}"
		fi
	done
}

fUploadFiles(){
	echo "?... in 4 seconds..."
	sleep 4
	#
	# MOVE IN
	curl -F "upload_file[]=@e-muzik.list" -F "request=HANDLE_UPLOAD" http://svn/intel_duo/online-file-manager/
	curl -F "upload_file[]=@e-muzik.list" -F "request=HANDLE_UPLOAD" $REMOTE_HOST

}



#
# MAIN
#===================================================================
#

# always...
fCreateWorkDirectory

if [ "$isDownloadOnly" = "YES" ] ; then
	fDownloadFiles
	
elif [ "$isMvIn" = "YES" ] ; then
	fDownloadFiles
	fInstallFiles
	
else
	echo "do MvOut... (NOT IMPLEMENTED)"
fi



exit $?

########### MAYBE LATER............

#
# PROFILE SOURCING
#
# the calling parent profile (i.e. .bashrc should source .mvinrc)
PARENT_PROFILE=~/.bashrc
MVIN_PROFILE_MVINRC='~/.mvinrc'

#
# check if calling parent profile needs to be "patched" (really updated) so that
# it'll source .mvinrc (which in turn will source custom profiles)
grep -n ". $MVIN_PROFILE_MVINRC" "$PARENT_PROFILE"

if [ $? = 0 ] ; then
	echo $PARENT_PROFILE is patched; nothing to do

else
	echo "Updating $PARENT_PROFILE to source custom profiles"

	tmpSourcingProfile="[[ -f $MVIN_PROFILE_MVINRC ]] && . $MVIN_PROFILE_MVINRC"

	echo "" >> $PARENT_PROFILE
	echo "# mvin.sh adds sourcing code" >> $PARENT_PROFILE
	echo "$tmpSourcingProfile" >> $PARENT_PROFILE
fi
