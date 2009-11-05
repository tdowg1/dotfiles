#!/bin/sh
#
# TODO
# should be prompting user for each dotfile
#	see how see tahoe installer handled default values
#	see how other people are handling default values in their user promts
# rename string: replace all WORK with WORKING
#			^^tmp?  cause... it's really a temp directory...
#
#


#
# ARGUMENT PARSING AND SANITY CHECKING
#===================================================================
#

if [ $USER = 'root' ] ; then
	echo "no root user"
	f_usage
	exit 1;
fi


f_usage(){
	local _USAGE=$(cat <<__HEREDOC__
${0}: designed to assist in keeping your dotfiles portable and
synchronized. Default behavior is to pull dotfiles from remote
server and put under home directory.

usage: ${0} [--mvout] [--downloadonly]
	--mvout
		Move out.
		Reverses default "move in" behavior. Pushes or uploads
		dotfiles (from home directory) to remote server
	--downloadonly
		Same as default behavior except dotfiles are not
		put under home directory, but are left under the
		"tmp.mvin" folder that this script uses as its
		working directory.

misc/notes:
	lynx
	curl
__HEREDOC__
)

	echo "$_USAGE"
	exit 1;
}

# check that $# is one in (0, 1, 2)
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
# source conf file, which should be sibling to curr script
source "$(dirname $0)/mvin.conf"



#
# VARIABLE PARAMS/INITIALIZATION
#===================================================================
#
# like cfparam=* required=yes
#: ${TEMPDIR2:?ERROR: not specified}
: ${HOME:?ERROR: HOME variable must be set}

#
# like cfparam=*
: ${isMvIn:="YES"}
: ${isDownloadonly:="NO"}

#
# the mvin program home directory
: ${mvinHOME:="${HOME}/.mvin"}
#
# mvin's temp directory.  between when files are up/downloaded and
# copied to the home directory, each one is copied here first.
: ${mvinTMP:="${mvinHOME}/tmp"}

#
# remote server address
: ${REMOTE_HOST:="http://bdavies522276/mvin"}
REMOTE_HOST='http://svn/muzik-work/mvin/dotfiles'
REMOTE_HOST='http://svn/intel_duo/mvin/dotfiles'
#REMOTE_HOST='http://svn/intel_duo/online-file-manager/'


REEEEEL_REMOTE_HOST='http://svn/intel_duo/mvin'
REMOTE_HOST="${REEEEEL_REMOTE_HOST}/dotfiles"


#
# the set of all dot files to work with
#: ${dot_files:="myaliases myvariables myfunctions"}
: ${dot_files:=".inputrc .mvinrc .zshrc"}






#
# FUNCTIONS
#===================================================================
#
fCreateWorkingDirectory(){
	if [ ! -d $mvinHOME ] ; then
		echo "creating $mvinTMP directory"
		mkdir -p "${mvinTMP}"
#DEVEL	else
#DEVEL		echo "ERROR: $mvinHOME already exists! ...I want to be the one to create it"
#DEVEL		exit 2
	fi
}


fCopyFromHomeToWorkingDirectory(){
	#must copy from $HOME into tmp.mvin and rename to omit leading dot, then re-run:
	echo "CALLED STUB FUNCTION:fCopyFromHomeToWorkingDirectory"
}


fUploadFiles(){
	echo "Move out..."
	echo "==========="
	for dotfile in $dot_files ; do
		echo "${HOME}/${dotfile}"
	done
	echo "==========="
	echo "...from your HOME directory? ...in 4 seconds..."
	sleep 4
	#
	# MOVE OUT
	for dotfile in $dot_files ; do

		if [ $? = 0 ] ; then
			curl -F "upload_file[]=@${HOME}/${dotfile}" -F "request=HANDLE_UPLOAD" "${REEEEEL_REMOTE_HOST}/upload/"
		fi
	done
#	curl -F "upload_file[]=@e-muzik.list" -F "request=HANDLE_UPLOAD" http://svn/intel_duo/online-file-manager/
#	curl -F "upload_file[]=@e-muzik.list" -F "request=HANDLE_UPLOAD" $REMOTE_HOST


}

fForeachDotfileDoDownload(){
	remoteSourceDirectory="$1"
	localDestinationDirectory="$2"

	for dotfile in $dot_files ; do
		fDownload "$remoteSourceDirectory/${dotfile}" "$localDestinationDirectory/${dotfile}"
	done
}

fDownload(){
	remoteSource="$1"
	localDestination="$2"

#DEVEL		wget --no-verbose --directory-prefix="${mvinHOME}" "$REMOTE_HOST/$dotfile"
	wget --no-verbose --output-document="$localDestination" "$remoteSource"
}

fForeachDotfileDoCopy(){
	sourceDirectory="$1"
	destinationDirectory="$2"

	for dotfile in $dot_files ; do
		fCopy "$sourceDirectory/${dotfile}" "$destinationDirectory/${dotfile}"
	done
}

fCopy(){
	# simply a wrapper for cp
	cp -v "$1" "$2"
}




#
# MAIN
#===================================================================
#
SLEEPTIME=1

if [ "$isMvIn" = "YES" -o "$isDownloadOnly" = "YES" ] ; then
	fCreateWorkingDirectory

	echo "Retrieve dot files from remote host?... in $SLEEPTIME seconds..."
	sleep $SLEEPTIME
	fForeachDotfileDoDownload "$REMOTE_HOST" "$mvinTMP"

	[[ "$isDownloadOnly" = "YES" ]] && break


	echo "Move downloaded dotfiles into HOME (HOME files overwritten"
	echo "if they exist)? ...in $SLEEPTIME seconds..."
	sleep $SLEEPTIME
	fForeachDotfileDoCopy "$mvinTMP" "$HOME"


else
	fCopyFromHomeToWorkingDirectory
	fUploadFiles

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
	echo "$PARENT_PROFILE is patched; nothing to do"

else
	echo "Updating $PARENT_PROFILE to source custom profiles"

	tmpSourcingProfile="[[ -f $MVIN_PROFILE_MVINRC ]] && . $MVIN_PROFILE_MVINRC"

	echo "" >> $PARENT_PROFILE
	echo "# mvin.sh adds sourcing code" >> $PARENT_PROFILE
	echo "$tmpSourcingProfile" >> $PARENT_PROFILE
fi

