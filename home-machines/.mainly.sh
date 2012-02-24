#!/bin/bash

#
# This file to be sourced at shell login.  Here is the expected call hierarchy:
# .bash_profile
#   |-- .bashrc
#     `-- .mainly.sh        CURR FILE
#         |-- .aliases.sh
#         |-- .functions.sh
#         `-- .variables.sh
#
# Currently, this file is sourced by these machines, from specified file : 
#	phisata: by .bashrc
#	svn: by .bashrc
#	vm-f112: nil
#

## ### #### ###################################################################
# Path to diretory containing dotfiles...
# ...containing *revision controlled* dotfiles.
# So, this could be the working directory, NOT $HOME !
#
# 2011-09-10: currently in a period of... "transision".  This the reason for
#   absurd names... so ZOMG gimme a break! :D
ZOMG_DOTFILES="$HOME/dotfiles/home-machines"
## ### #### ###################################################################


fSourceIfThere(){
	local fileToSource="${1}"

	if [[ -f "${fileToSource}" ]] ; then
		if tty -s ; then
			echo "${fileToSource}"
		fi
		source "${fileToSource}"
	else
		if tty -s ; then
			echo "NO ${fileToSource}!"
		fi
	fi
}


##
## teelah customs -- THINGS
## ### #### ###################################################################
export MAIL=/var/spool/mail/$USER




# tell svn to show log messages of the 2 most recent commits
alias svnlog='svn log -r PREV:COMMITTED'
#alias svnloghead='svn log -r HEAD'
svnloghead(){
	headRev=$( svn info | grep 'Last Changed Rev' | awk '{ print $NF }' )
	numberOfRevsBack=2

	svn log -r $(( $headRev - $numberOfRevsBack )):HEAD
}




#mansearch
#       whatis
#       apropos


alias tu='cd /opt/teelah-utils/bin/; pwd'








##
# only display text on interactive sessions
# (need to do this because, for instance, scp will fail for remote user)
#
if tty -s ; then
	#echo "still todo: separate vib / .mainly.sh into alias,func, and var profiles"

	if false ; then
		echo "check out the default screen profile under ubuntu904 (see also:live cd I have)"

		echo "[MESSAGES FROM SVN.HOME]"
		echo "[helpful message wrt configuring dotfiles]"
		echo "  vim flashes (try ESC, ESC), but that's about it"
		echo "  for user smbmuzik:"
		echo "          pretty cool setup, uses zsh, vi colors are nice, etc."
		echo "          vi tab: think I just realied this, but Im guessing Tim's vi profile has it inserting spaces FOR TABS, which is reel annoying.  if I want a tab char, I type tab damnit."
		echo "          flashing happens everywhere, pretty annoything"
	fi

fi


#
# makes anything defined automatically exported
set -o allexport
#






IS_I_ON_INTELDUO='false'
IS_I_ON_LAPTOP='false'
IS_I_ON_MAGNIFICENT='false'
IS_I_ON_PHISATA='false'
IS_I_ON_SVN='false'
#
#if [[ x"${IS_I_ON_PHISATA}" = x"true" ]] ; then
#
if [ x"${HOSTNAME}" = x"intelduo"  -o  x"${HOSTNAME}" = x"intelduo.home" ] ; then
	IS_I_ON_INTELDUO='true'

elif [ x"${HOSTNAME}" = x"laptop"  -o  x"${HOSTNAME}" = x"laptop.home" ] ; then
	IS_I_ON_LAPTOP='true'

elif [ x"${HOSTNAME}" = x"magnificent"  -o  x"${HOSTNAME}" = x"magnificent.home" ] ; then
	IS_I_ON_MAGNIFICENT='true'

elif [ x"${HOSTNAME}" = x"phisata"  -o  x"${HOSTNAME}" = x"phisata.home" ] ; then
	IS_I_ON_PHISATA='true'

elif [ x"${HOSTNAME}" = x"svn"  -o  x"${HOSTNAME}" = x"svn.home" ] ; then
	IS_I_ON_SVN='true'

fi



# ~/.gitconfig special case:
# If (this script) executing on work machine, use work email.
# Else use the personal email which is specified in my .gitconfig.
#if [[ x"$(hostname)" = x"magnificent" ]] ; then
if [[ x"${IS_I_ON_MAGNIFICENT}" = x"true" ]] ; then
	GIT_COMMITTER_EMAIL="bdavies@spryinc.com"
	GIT_AUTHOR_EMAIL="$GIT_COMMITTER_EMAIL"
	#if [[ $( tty -s ) = 0 ]] ; then
	if tty -s ; then
		echo "NOTE: global git config variable 'user.email' is overridden: ${GIT_COMMITTER_EMAIL}"
	fi
fi


## smbclient -L bdavies522276
# smbmount

fSourceIfThere ~/.aliases.sh
fSourceIfThere ~/.functions.sh
fSourceIfThere ~/.variables.sh

