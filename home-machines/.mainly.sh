#!/bin/bash

#
# This file to be sourced at shell login.  Here is the expected call hierarchy:
# .bash_profile
#   |-- .bashrc
#     `-- /etc/bashrc
#     `-- .mainly.sh        CURR FILE
#         |-- .aliases.sh
#         |-- .functions.sh
#         `-- .variables.sh
#

## ### #### ###################################################################
# Path to diretory containing dotfiles...
# ...containing *revision controlled* dotfiles.
# So, this could be the working directory, NOT $HOME !
#
# Here, only define a _default_value_ for DOTFILES_HOME
: ${DOTFILES_HOME:="$HOME/dotfiles/home-machines"}
# 2011-09-10: currently in a period of... "transision".  This the reason for
#   absurd names... so ZOMG gimme a break! :D
ZOMG_DOTFILES="$DOTFILES_HOME"
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
## smbclient -L bdavies522276
# smbmount






# 
# [Re-]Sets hostname portion of terminal prompt to the contents of ~/.whereami
#if [[ -f ~/.whereami ]]; then
#        where="$(cat ~/.whereami)"
#        TITLEBAR='\[\e]0;\u@'${where}'\a\]'
#        PS1="${TITLEBAR}[\u@${where} \W] "
#fi


# 
# [Re-]Sets title of whichever terminal program you're using.
# Obviously, the ~/.whereami file is unnecessary.
# Usually, could put this in ~/.bash_profile like so...
#
## User specific environment and startup programs
#if [[ -f ~/.whereami ]]; then
#        where="$(cat ~/.whereami)"
#        #export TITLEBAR='\[\e]0;\u@\h\a\]'
#        TITLEBAR='\[\e]0;\u@'${where}'\a\]'
#        #export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$'
#        #export PS1="${TITLEBAR}[\u@\h \W] "
#        #export PS1="${TITLEBAR}[\u@\h \W] "
#        PS1="${TITLEBAR}[\u@${where} \W] "
#fi
#
##resettitlebar(){
##	export TITLEBAR='\[\e]0;\u@\h\a\]'
##	export PS1="${TITLEBAR}${PS1}"
##}


##
# only display text on interactive sessions
# (need to do this because, for instance, scp will fail for remote user)
#
if tty -s ; then
	#echo "still todo: separate vib / .mainly.sh into alias,func, and var profiles"

	
	## THEN--ITS OKAY TO TALK!  HOORAY FISH! (IS_I_CAN_TALK
	##MAKE FUNCTION:
	#echoifok()


	if false ; then
		echo "check out the default screen profile under ubuntu904 (see also:live cd I have)"

		echo "[MESSAGES FROM SVN.HOME]"
		echo "  for user smbmuzik:"
		echo "          pretty cool setup, uses zsh, vi colors are nice, etc."
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



fSourceIfThere "$ZOMG_DOTFILES/.aliases.sh"
fSourceIfThere "$ZOMG_DOTFILES/.functions.sh"
fSourceIfThere "$ZOMG_DOTFILES/.variables.sh"

