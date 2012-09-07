# .bash_profile
if tty -s ; then
   echo .bash_profile
fi


# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs
#TOMCAT_HOME="/usr/local/tomcat"
#export TOMCAT_HOME
#tc="$TOMCAT_HOME"

where=''
if [[ -f ~/.whereami ]]; then
	where="@$(cat ~/.whereami)"
#	TITLEBAR='\[\e]0;\u@'${where}'\a\]'
#	PS1="${TITLEBAR}[\u@${where} \W] "
fi

TITLEBAR='\[\e]0;\u'${where}'\a\]'
#PS1="${TITLEBAR}[\u${where} \w]$ "   # \w = full path
PS1="${TITLEBAR}[\u${where} \W]$ "   # \W = basename( full path )


