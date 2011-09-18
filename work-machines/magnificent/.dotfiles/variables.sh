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

# 2011-06-17: tweak bash history
unset HISTSIZE
export HISTSIZE=5000
unset HISTFILESIZE
export HISTFILESIZE=10000

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


