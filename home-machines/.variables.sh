# .variables.sh

## ### #### ###################################################################
##
## misc.
##
## ### #### ###################################################################

# Misc (again)
export MAIL=/var/spool/mail/$USER
export EDITOR=vim
export SVN_EDITOR=vim
export PAGER="less"


# Places
# dropbox folders
export db="$HOME/Dropbox"
export dbi="$HOME/Dropbox/db.inst-and-sysconfig"
export dbm="$HOME/Dropbox/db.misc-linuxish"
export dbs="$HOME/Dropbox/db.scripts-snippets"
export dbpub="$HOME/Dropbox/Public"


# PATH modifications
PATH=$PATH:/sbin:/usr/sbin

# add hostname-specific bin scripts to PATH if exists (i.e. bin/$( hostname ) )
if [[ -d "$HOME/bin" ]] ; then
	PATH=$PATH:$HOME/bin
	if [[ -d "$HOME/bin/$HOSTNAME" ]] ; then
		PATH=$PATH:$HOME/bin/$HOSTNAME
	fi
fi


# Less Colors for Man Pages
# src: http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
# disabled standout-mode bc very difficult to see.
#export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline



# Git preferences and hacks (/etc/bash_completion.d/git)
if [[ -f /etc/bash_completion.d/git ]] ; then
	source /etc/bash_completion.d/git

	# test to see if /etc/bash_completion.d/git is even being sourced
	env | grep __gitdir 2>&1 >/dev/null
	if [[ $? = 0 ]] ; then
		# ok it is.
		PREV_PS1="$PS1"
		PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

		GIT_PS1_SHOWDIRTYSTATE=true
		GIT_PS1_SHOWSTASHSTATE=true
		GIT_PS1_SHOWUNTRACKEDFILES=true
		GIT_PS1_SHOWUPSTREAM="auto"
	else
		echo "/etc/bash_completion.d/git exists but doesn't seem to have been sourced by your env"
	fi
fi


# Python interpreter tweaks
if [[ -f ~/.pystartup ]] ; then
	PYTHONSTARTUP=~/.pystartup
fi





## ### #### ###################################################################
##
## HOST-specific
##
## ### #### ###################################################################

## 
## PHISATA-specific ...........................................................
if [[ x"${IS_I_ON_PHISATA}" = x"true" ]] ; then
	[[ -f /etc/teelah-utils.conf ]] && source /etc/teelah-utils.conf
	tu="$TUTILS"
	# ya, se que esta es muy muy muy muy horribleyyy
	update_PATH_with_teelah_utils=:/opt/teelah-utils/bin:/opt/teelah-utils/bin/sys-config:/opt/teelah-utils/bin/sys-config/trac:/opt/teelah-utils/bin/sys-config/svn:/opt/teelah-utils/bin/trac:/opt/teelah-utils/bin/muzik:/opt/teelah-utils/bin/svn:/opt/teelah-utils/bin/filename_transformations:/opt/teelah-utils/bin/filemanagement:/opt/teelah-utils/bin/custom:/opt/teelah-utils/bin/php:/opt/teelah-utils/bin/in-development:/opt/teelah-utils/bin/in-development/tmp
	export PATH=${PATH}:${update_PATH_with_teelah_utils}

	export PYTHON_EXTERNALS_PATH=/opt/python-externals
	export PYTHONPATH=/opt/teelah-utils/bin:$PYTHON_EXTERNALS_PATH


	
	# 2012-04-14 bash tweakers shamelessly stolen from magnificent eshtupido.
	HISTTIMEFORMAT="%F_%T"
	#HISTCONTROL=ignoreboth
	HISTCONTROL=ignoredups:ignorespace

	# append to the history file, don't overwrite it
	shopt -s histappend

	#HISTSIZE=5000
	if tty -s ; then
		echo "NOTE: whenever you get all logged out (all screens, all sessionts, etc)"
		echo "      you maybe wanna enable this bash HISTSIZE config change"
		echo "      ahhhummmmmmmmmmmmmmmmm??????????????????!!!!!!!!!!!!!!!!   >:|   "
	#HISTSIZE=50000
	fi

	# The maximum number of lines contained in the history file.
	# If HISTFILESIZE is not set, no truncation is performed.
	#unset HISTFILESIZE
	#export HISTFILESIZE=$(( 10000 * 2 ))
	#HISTFILESIZE=10000
fi


## 
## SVN-specific ...............................................................
if [[ x"${IS_I_ON_SVN}" = x"true" ]] ; then
	[[ -f /etc/teelah-utils.conf ]] && source /etc/teelah-utils.conf
	tu="$TUTILS"
	update_PATH_with_teelah_utils=:/opt/teelah-utils/bin:/opt/teelah-utils/bin/sys-config:/opt/teelah-utils/bin/sys-config/trac:/opt/teelah-utils/bin/sys-config/svn:/opt/teelah-utils/bin/trac:/opt/teelah-utils/bin/muzik:/opt/teelah-utils/bin/svn:/opt/teelah-utils/bin/filename_transformations:/opt/teelah-utils/bin/filemanagement:/opt/teelah-utils/bin/custom:/opt/teelah-utils/bin/php:/opt/teelah-utils/bin/in-development:/opt/teelah-utils/bin/in-development/tmp
	export PATH=${PATH}:${update_PATH_with_teelah_utils}
	
	export PYTHONPATH=/opt/teelah-utils/bin
fi


##
## [com.spryinc.]MAGNIFICENT-specific .........................................
if [[ x"${IS_I_ON_MAGNIFICENT}" = x"true" ]] ; then
	
	# 2012-03-29: removing this jdk (and maybe re-installing 6u31?), so
	# in the meantime, use the openjdk joint.
	#JAVA_HOME=/opt/jdk1.6.0_25
	#PATH=/opt/jdk1.6.0_25/bin:$PATH

	# ~2011-10-00: added for nss ssl development
	# 2011-11-16: disabled
	#LD_LIBRARY_PATH=/usr/lib:/usr/lib/nss

	#
	# 2011-06-08: NOTE JAVA_HOME already set in /etc/profile
	#export JAVA_HOME=/opt/jdk1.6.0_25

	
	# Git-preferences:
	# If (this script) executing on work machine, use work email.
	# Else use the personal email which is specified in my .gitconfig.
	if [[ x"${IS_I_ON_MAGNIFICENT}" = x"true" ]] ; then
		GIT_COMMITTER_EMAIL="bdavies@spryinc.com"
		GIT_AUTHOR_EMAIL="$GIT_COMMITTER_EMAIL"
		#if [[ $( tty -s ) = 0 ]] ; then
		if tty -s ; then
			echo "NOTE: global git config variable 'user.email' is overridden: ${GIT_COMMITTER_EMAIL}"
		fi
	fi


	# 2011-06-24: NOTE M2_HOME already set in /etc/profile
	# 2011-11-15: do not set M2_HOME to be /usr/share/maven2 because it conflicts with mvn3
	#M2_HOME=/usr/share/maven2
	# 2012-01-27: not using maven2; haven't in a while.  set M2_HOME because you're supposed to
	M2_HOME=/usr/local/share/maven3
	if [[ -z "$MAVEN_REPOSITORY" ]] ; then
		M2_REPO="$HOME/.m2/repository"
	else
		M2_REPO="$MAVEN_REPOSITORY"
	fi
	###
	#^^^^CAN PROB RE-COMMENT THIS OUT AFTER AN OS BOUNCE???
	##
	## (AND WHEN DO THIS, remove maven config entered for IntelliJ
	## for project gadget-hr-fed, and ensure IntelliJ still builds
	## after removing)
	##

	PATH=$PATH:$HOME/opt/bin

	# 2011-10-05: move PATH update for JAVA_HOME into /etc/profile
	#PATH=$JAVA_HOME/bin:$PATH


	# %F     Equivalent to %Y-%m-%d (the ISO 8601 date format). (C99)
	# %T     The time in 24-hour notation (%H:%M:%S). (SU)
	#
	# this variable assignment makes `history' output be like
	#:space::space:182:space::space:2012-03-20_19:15:06____pwd
	HISTTIMEFORMAT="%F_%T____"

	#HISTCONTROL=ignoreboth
	HISTCONTROL=ignoredups:ignorespace

	# append to the history file, don't overwrite it
	shopt -s histappend

	# 2011-06-17: tweak bash history
	# 2011-08-24: OK, IDK why these aren't working...
	### trying without using bash math operators and without 'exporting'
	### if /that/ doesn't even seem to work, maybe these are special? for 
	### some reason?? =---maybe they ACTUALLY HAVE TO BE set in the .bashrc
	### and/or /etc/bash.bashrc file?...
	# 2011-08-25: ZOMFG: .bashrc (the default that was installed to my
	### home by ubu, is diff than fedora's.  HIST*SIZE's are all set there!
	### freak me.

	#unset HISTSIZE  # the number of commands to save in a history list.
	#export HISTSIZE=$(( 5000 * 20 ))
	HISTSIZE=50000

	# The maximum number of lines contained in the history file.
	# If HISTFILESIZE is not set, no truncation is performed.
	#unset HISTFILESIZE
	#export HISTFILESIZE=$(( 10000 * 2 ))
	HISTFILESIZE=100000




	# 2011-06-23: seeing if can save screen sessions.
	# 2011-09-21: ^^NO YOU CANT, BUT YOU CAN HAVE IT AUTOCREATE TABSS
	# src: http://superuser.com/questions/117000/tell-gnu-screen-where-to-save-the-sessions
	#export SCREENDIR=$HOME/.screen

	export TOMCAT_HOME="/opt/tomcat/"
	export tc="/opt/tomcat/"


	##
	## git-related

	# 2011-06-24: git
	# for nfo, see: /etc/bash.completion.d/git 
	#PREV_PS1="$PS1"
	#PS1='\u@\h \W$(__git_ps1 " (%s)")\$ '
	#
	## unstaged (*) and staged (+) changes will be shown next to the branch name
	#GIT_PS1_SHOWDIRTYSTATE=true
	#
	## if something is stashed, a '$' will be shown next to the branch name
	#GIT_PS1_SHOWSTASHSTATE=
	#
	## if there're untracked files, a '%' will be shown next to the branch name
	#GIT_PS1_SHOWUNTRACKEDFILES=true
	## /git-related
	##

fi # /IS_I_ON_MAGNIFICENT

