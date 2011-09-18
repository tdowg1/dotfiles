#
#BDAVIESPC=bdavies522276

export EDITOR='vim'

# 2011-06-08: NOTE JAVA_HOME already set in /etc/profile
#export JAVA_HOME=/opt/jdk1.6.0_25
# 2011-06-24: NOTE M2_HOME already set in /etc/profile
export M2_HOME=/usr/share/maven2
###
#^^^^CAN PROB RE-COMMENT THIS OUT AFTER AN OS BOUNCE???
##
## (AND WHEN DO THIS, remove maven config entered for IntelliJ
## for project gadget-hr-fed, and ensure IntelliJ still builds
## after removing)
##

PATH=$PATH:$HOME/bin:$HOME/opt/bin

# 2011-06-08: sbin's already set somewhere else! wtf?
#PATH=$PATH:/sbin:/usr/sbin

PATH=$JAVA_HOME/bin:$PATH
export PATH=$PATH



export HISTTIMEFORMAT="%F_%T"

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
HISTSIZE=5000

# The maximum number of lines contained in the history file.
# If HISTFILESIZE is not set, no truncation is performed.
#unset HISTFILESIZE
#export HISTFILESIZE=$(( 10000 * 2 ))
HISTFILESIZE=10000




# 2011-06-23: seeing if can save screen sessions
# src: http://superuser.com/questions/117000/tell-gnu-screen-where-to-save-the-sessions
export SCREENDIR=$HOME/.screen

export TOMCAT_HOME=/opt/apache-tomcat-6.0.26/


# 2011-06-24: git
# for nfo, see: /etc/bash.completion.d/git 
PREV_PS1="$PS1"
PS1='\u@\h \W$(__git_ps1 " (%s)")\$ '

# unstaged (*) and staged (+) changes will be shown next to the branch name
GIT_PS1_SHOWDIRTYSTATE=true

# if something is stashed, a '$' will be shown next to the branch name
GIT_PS1_SHOWSTASHSTATE=

# if there're untracked files, a '%' will be shown next to the branch name
GIT_PS1_SHOWUNTRACKEDFILES=true



# 2011-09-01: 
# src: http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
# disabled standout-mode bc very difficult to see.
#export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
###SWEET!!! it works!

