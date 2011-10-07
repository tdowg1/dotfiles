#!/bin/bash
#
# DESCRIPTION
#===================================================================
# This is a simple script to assist with managing my dotfiles.
# 
# This script is intended to be used to operate on 2 different
# directories. For me, these 2 directories are:
# * the (git repo) directory that contains dotfiles
# * $HOME directory
# 
# This script can do 3 diff operations.
# * diff
# ** compare contents of cwd vs. $HOME
# * install
# ** copy contents of cwd into $HOME
#

#
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
		Compare dotfiles in cwd with those in HOME.
install
push-out
		Copy dotfiles in cwd to HOME.
pull-in
		Copy dotfiles in HOME to cwd.
		Note: the set of dotfiles to be copied is determined by
		analyzing dotfiles in cwd.
help
		Show this help message and exit.
List of options:
nil
__HEREDOC__
)
	echo "$_USAGE"
	exit 1
}

if [ $# != 1 ] ; then
	echo "ERROR: not sure what to do (expected one command)"
	f_usage
fi

while [[ $# != 0 ]] ; do
  case "$1" in
    diff) COMMAND='DIFF';;
    install|push-out) COMMAND='PUSH_OUT';;
    pull-in) COMMAND='PULL_IN';;
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
: ${ISFORCED:='FALSE'}

# like cfparam=* required=yes
: ${HOME:?ERROR: HOME variable must be set}



#
# FUNCTIONS
#===================================================================
#
fIsIgnored(){
	file="$1"
	grep "$file" ignore  >/dev/null  2>&1
	[[ $? = 0 ]] && echo 'true' && return
	echo 'false'
}



#
# MAIN
#===================================================================
#
case "$COMMAND" in
	DIFF)
		for i in `/bin/ls -A` ; do
			isIgnored=$( fIsIgnored "$i" )

			# if currFile is not ignored:
			if [[ x"$isIgnored" != x'true' ]] ; then
				diff --brief --recursive  "$i" "$HOME/$i"
			fi
		done
		;;
	
	PUSH_OUT) # formerly, "INSTALL"
		for i in `/bin/ls -A` ; do
			isIgnored=$( fIsIgnored "$i" )

			# if currFile is not ignored:
			if [[ x"$isIgnored" != x'true' ]] ; then
				#echo cp --verbose "$i" $HOME   # DRY-RUN
				cp --verbose "$i" $HOME;
			fi
		done
		;;

	PULL_IN)
		for i in `/bin/ls -A` ; do
			isIgnored=$( fIsIgnored "$i" )

			# if currFile is not ignored:
			if [[ x"$isIgnored" != x'true' ]] ; then
				#echo cp --verbose "$HOME/$i" .    # DRY-RUN
				cp --verbose "$HOME/$i" .
			fi
		done
		;;

	*) echo "ERROR: unsupported COMMAND[$1] (case matched wildcard)" ;;
esac


