# .variables.sh


update_PATH_with_teelah_utils=:/opt/teelah-utils/bin:/opt/teelah-utils/bin/sys-config:/opt/teelah-utils/bin/sys-config/trac:/opt/teelah-utils/bin/sys-config/svn:/opt/teelah-utils/bin/trac:/opt/teelah-utils/bin/muzik:/opt/teelah-utils/bin/svn:/opt/teelah-utils/bin/filename_transformations:/opt/teelah-utils/bin/filemanagement:/opt/teelah-utils/bin/custom:/opt/teelah-utils/bin/php:/opt/teelah-utils/bin/in-development:/opt/teelah-utils/bin/in-development/tmp
export PATH=${PATH}:${update_PATH_with_teelah_utils}

export PYTHON_EXTERNALS_PATH=/opt/python-externals
export PYTHONPATH=/opt/teelah-utils/bin:$PYTHON_EXTERNALS_PATH
export EDITOR=vim
export SVN_EDITOR=vim




##
## FROM SVN.HOME MACHINE...
export PATH=$PATH:/sbin:/usr/sbin

# BASIX
#not sure if need these...
   #set -o emacs
   #bind -f /etc/inputrc

# PROGS
export PAGER="less"







##
## teelah customs -- ------- VARIABLES ---------------
## ### #### ###################################################################

# 2011-07-09: tweaks for a git working directory (/etc/bash_completion.d/git)
if [[ -f /etc/bash_completion.d/git ]] ; then
	PREV_PS1="$PS1"
	PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

	GIT_PS1_SHOWDIRTYSTATE=true
	GIT_PS1_SHOWSTASHSTATE=true
	GIT_PS1_SHOWUNTRACKEDFILES=true
	GIT_PS1_SHOWUPSTREAM="auto"
fi

