#!/bin/sh
#
# this program is designed to assist in keeping your dotfiles portable and
# synchronized.
#
#
# $Id$
# $HeadURL$
#


#
# the only "safe" user-configurable option.
# set CONF_FILE to where I can find the configuration file
#===================================================================
CONF_FILE=~/mvin.conf

#===================================================================
#
# conf file sanity checking
#===================================================================
: ${CONF_FILE:?ERROR: CONF_FILE variable must be set}



#
# ARGUMENT PARSING AND SANITY CHECKING
#===================================================================
#
f_usage(){
	local _me=$(basename ${0})
	local _USAGE=$(cat <<__HEREDOC__
Usage: ${_me} [OPTIONS] COMMAND

List of commands:
diff
		compare local dotfiles with those from remote
help
		show this help message and exit
pull
		get dotfiles from remote
		Probably the most common.
		Download dotfiles from remote server (see mvin.conf) and put them under
		your HOME.
		Do this when you want to get the "latest" dotfile copy set. This will
		obviously overwrite the dotfiles in your home directory.
push
		send dotfiles to remote
		Upload changed dotfiles from your HOME directory to remote server.
		Reverses default "move in" behavior. Pushes or uploads
		dotfiles (from home directory) to remote server.

		Do this after you have: (1) performed a --download and subsequently
		(2) updated dotfile(s) content and wish to OVERWRITE whatever is on
		remote server.
		|----> If youve forgotten what content is actually on the remote
		server and wish to know whats about to be overwriten, see --downloadonly
		option.

List of options:
--force
		sometimes pull or push operations will require this given certain
		conditions
__HEREDOC__
)
	echo "$_USAGE"
	exit 1
}



if [ $USER = 'root' ] ; then
	echo "ERROR: no root user"
	f_usage
fi
if [ $# = 0 ] ; then
	echo "ERROR: not sure what to do (no command given)"
	f_usage
fi



while [[ $# != 0 ]] ; do
  case "$1" in
#    --shellrc=?*) # specified like: --shellrc=FILE

    pull) COMMAND='PULL';;
    push) COMMAND='PUSH';;
    diff) COMMAND='DIFF';;
    --force) ISFORCED='TRUE' ;;
    --help|-h|help) f_usage ;;
    *)
		echo "ERROR: unsupported COMMAND[$1] (case matched wildcard)"
		f_usage
		;;
  esac
  shift
done



#
# VARIABLE PARAMS/INITIALIZATION AND SANITY CHECKING
#===================================================================
#
#: ${cfparam__required_no:="example of cfparam=* where required=no"}
# like cfparam=* required=yes
: ${HOME:?ERROR: HOME variable must be set}
: ${COMMAND:?ERROR: dont know what you want me to do (COMMAND not set)}
: ${ISFORCED:='FALSE'}


#
# source conf file, then sanity check variables that are expected to be
# defined within the conf file
if [ ! -f "$CONF_FILE" ] ; then
	echo "ERROR: $CONF_FILE does not exist"
	f_usage
fi

echo "using config file[$CONF_FILE]"
source "$CONF_FILE"

: ${SLEEPTIME:?ERROR: SLEEPTIME variable must be set}
: ${REMOTE_HOST_MVIN_ADDRESS:?ERROR: REMOTE_HOST_MVIN_ADDRESS variable must be set}
: ${dot_files:?ERROR: dot_files variable must be set}
: ${dot_filesHOME:?ERROR: dot_filesHOME variable must be set}
: ${MVINTMPPREFIX:?ERROR: MVINTMPPREFIX variable must be set}

if [ ! -d "$MVINTMPPREFIX" ] ; then
	echo "ERROR: $MVINTMPPREFIX does not exist"
	f_usage
fi

#
# remote directories
echo "using remote host [$REMOTE_HOST_MVIN_ADDRESS]"
REMOTE_DOWNLOAD_DIRECTORY="${REMOTE_HOST_MVIN_ADDRESS}/dotfiles"
REMOTE_UPLOAD_DIRECTORY="${REMOTE_HOST_MVIN_ADDRESS}/upload/"




#
# FUNCTIONS
#===================================================================
#
fDownload(){
	remoteSource="$1"
	localDestination="$2"
	
	WGET_OPTIONS='' # very verbose
	WGET_OPTIONS='--no-verbose' # less verbose
	WGET_OPTIONS='--quiet' # silent; not even 404 errors
	
	wget $WGET_OPTIONS --output-document="$localDestination" "$remoteSource"
}


fUpload(){
	localSource="$1"
	remoteDestination="$2"
	curl -F "upload_file[]=@${localSource}" -F "request=HANDLE_UPLOAD" "${remoteDestination}"
}


fCopy(){
	# simply a wrapper for cp
	cp -v "$1" "$2"
}


fComputeDigest(){
	md5sum "$1" | awk '{ print $1 }'
}


fPrintFileNfo(){
	who=$1
	metadata=$2
	file=$3
	
	# give output like
	#---> yours: $(md5sum FILE) /home/par/.mvin-myprofile
	#---> theirs: $(md5sum FILE) /home/par/.mvin-myprofile
	echo "---> $who $metadata $file"
}


fGetFileSize(){
	stat --format=%b "$1"
}


fExecute_PULL(){
	dotfile="$1"

	cmd="fCopy $mvinTMP/${dotfile} $dot_filesHOME/${dotfile}"
	echo "Executing[$cmd] in $SLEEPTIME seconds..."
	sleep $SLEEPTIME
	eval "$cmd"
}


fExecute_PUSH(){
	dotfile="$1"
	
	cmd="fUpload $dot_filesHOME/${dotfile} $REMOTE_UPLOAD_DIRECTORY"
	echo "Executing[$cmd] in $SLEEPTIME seconds..."
	sleep $SLEEPTIME
	echo "===== (web server response content block...)"
	eval "$cmd"
	echo "===== (... END web server response content)"
}


fExecute_DIFF(){
	dotfile="$1"
	cmd="diff $dot_filesHOME/${dotfile} $mvinTMP/${dotfile}"
	echo "Executing[$cmd]"
	eval "$cmd"
}




#
# MAIN
#===================================================================
#
mvinTMP="$(mktemp -d -p $MVINTMPPREFIX)"
echo "using temp directory [$mvinTMP]"

isForceRequired='TRUE'


for df in $dot_files ; do
	echo "--> [$df]"
	
	
	#
	# get metadata on your dotfile
	yourDf="$dot_filesHOME/${df}"
	yourDfHash=
	yourDfIsForceRequired='TRUE'
	
	if [ ! -f "$yourDf" ] ; then
		yourFileNfo="DNE"
		
	elif [ "$( fGetFileSize "$yourDf" )" = 0 ] ; then
		yourFileNfo="ZERO FILE SIZE"
		
	else
		yourDfIsForceRequired='FALSE'
		
		yourFileNfo=$( fComputeDigest "$yourDf" )
		yourDfHash="$yourFileNfo"
	fi
	
	fPrintFileNfo " yours:" "$yourFileNfo" "$yourDf"
	
	
	
	#
	# get metadata on their dotfile
	fDownload "$REMOTE_DOWNLOAD_DIRECTORY/${df}" "$mvinTMP/${df}"
	
	theirDf="$mvinTMP/${df}"
	theirDfHash=
	theirDfIsForceRequired='TRUE'
	
	if [ ! -f "$theirDf" ] ; then
		theirFileNfo="DNE"
		#THIS WILL NEVER HAPPEN
			echo "\n\nERRORR:somethings wrong with my logic-thought somehting's"
			echo "would's never happen's but's its does\n\n\n"
			exit 9
		
	elif [ "$( fGetFileSize "$theirDf" )" = 0 ] ; then
		theirFileNfo="ZERO FILE SIZE"
		
	else
		theirDfIsForceRequired='FALSE'
		
		theirFileNfo=$( fComputeDigest "$theirDf" )
		theirDfHash="$theirFileNfo"
	fi
	
	fPrintFileNfo "theirs:" "$theirFileNfo" "$theirDf"
	
	
	#
	# operate on dotfile
	case "$COMMAND" in
		PULL|PUSH)
			#
			# next few lines are just simplifying a bit of logic so that 1
			# variable is used (instead of 2) during a later comparison
			isForceRequired='FALSE'
			[[ "$yourDfIsForceRequired" = "TRUE" ]] && isForceRequired='TRUE'
			[[ "$theirDfIsForceRequired" = "TRUE" ]] && isForceRequired='TRUE'
			
			
			# determine if operation should be performed or not
			if [ "$yourDfHash" != "$theirDfHash" ] ; then
				if [ "$isForceRequired" = "FALSE" \
						-o \
					"$isForceRequired" = "TRUE" -a "$ISFORCED" = "TRUE" ] ; then
				
					eval "fExecute_${COMMAND}" "$df"
				else
					echo "----> SKIPPED... (--force not specified)"
				fi
			fi ;;
			
		DIFF)
			#
			# only execute a diff when both files actually have content
			# to be diffed... "when it makes sense" (i.e. if one file is empty, 
			# it doesn't make sense to print out a diff)
			if [ -n "$yourDfHash" -a -n "$theirDfHash"  \
					-a \
				"$yourDfHash" != "$theirDfHash" ] ; then
				
				eval "fExecute_${COMMAND}" "$df"
			fi ;;
		
		*) echo "ERROR: unsupported COMMAND[$1] (case matched wildcard)" ;;
	esac
	
done

exit $?

