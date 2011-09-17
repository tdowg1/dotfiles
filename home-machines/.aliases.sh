# .aliases.sh

## ### #### ###################################################################
##
## teelah customs -- 'general' ALIASES
## ### #### ###################################################################
#alias vib='vim ~/.mainly.sh'    # edit this file easily+quickly!
alias vib='vim $ZOMG_DOTFILES/.mainly.sh'    # edit this file easily+quickly!

##### THERE IS AN ISSUE WHEREBY each successfive call will make the PATH variable
##### grow expnentially.  I'm guessing this is a bad thing... but dont know how
##### to get around it
alias reloadenv='echo ". ~/.bashrc" ; . ~/.bashrc'


#
# `ls' customs
##
# (at least for phisata-#8-F13_2010-06-30_02:59:17-0400)
# `ls' already aliased to:
#   [teelah@phisata ~]$ date
#   Sat Aug 13 01:49:48 EDT 2011
#   [teelah@phisata ~]$ alias ls
#   alias ls='ls --color=auto'
#   [teelah@phisata ~]$
#
unalias ls
#
alias ls='ls --color=auto --time-style=iso'
#
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias l.='ls -la'
alias li='ls -li'
alias lh='ls -lh'
alias lt='ls -lt'
alias ltr='ls -ltr'
alias trll='ls -ltr'    # same as ltr
alias ltrr='ls -lt'     # same as alias lt
alias ltra='ls -ltra'
alias lld='ls -ld'
##
# /`ls' customs


alias df='df -hT'
alias mountdev='mount | grep /dev'
alias mdstat='more /proc/mdstat'
alias sshsvn='ssh -2XC tyler@svn'
# dont need this any more:; is in /etc/fstab.  just say sudo mount /mnt/sshfssvn
#alias sshfssvn='sshfs root@svn:/ /mnt/svn ; echo "mounted host[svn] at[/mnt/svn]"'


# git shtuff
alias g='git'
alias gh='git help'
alias log='git log'
alias loghead='git log | head'
alias loghead='git plog | head'
alias st='git status'
alias di='git diff'
alias dic='git diff --cached'
alias br='git branch'
alias bra='git branch --verbose'
alias tag='git tag'
alias taga='git tag -l -n'



##
## teelah customs -- PLACES
## ### #### ###################################################################
alias cdb='cd ~/bin ; pwd'
alias lb='ls -l ~/bin'
alias cdt='cd ~/tmp ; pwd'










## 
## PHISATA-specific places...
#alias cdh='cd /mnt/a14-h/hA4-465 ; pwd'
alias cdp='cd /mnt/a14-h/hA4-465 ; pwd'
#alias cdr='cd /mnt/a14-h/hA4-465/root/ ; ls -l'
#alias r='cd /mnt/a14-h/hA4-465/root ; pwd'      # like the win 'Run...' alias ===
alias r='echo "try cdr"'
alias cdr='cd /mnt/a14-h/hA4-465/root ; pwd'

alias life='cd /mnt/a14-h/hA4-465/root/LIFE ; pwd'
alias dork='cd /mnt/a14-h/hA4-465/root/LIFE.dork ; pwd'
alias hdd='cd /mnt/a14-h/hA4-465/root/LIFE/hdd ; pwd'
alias hddsmart='cd /mnt/a14-h/hA4-465/root/LIFE/hdd/smartctl.logs ; pwd'
alias proj='cd /mnt/a14-h/hA4-465/root/proj ; pwd'

alias a32='cd /mnt/a32-555 ; pwd'

alias t='cd /mnt/a32-555/t ; pwd'
alias cdrsnapshot='cd /mnt/rsnapshot/r ; ls -ltr && date'
## /PHISATA-specific places...
##


# if less than a page of output, stop it.
#alias less='less --QUIT-AT-EOF'









##
## SVN.HOME-specific places...
alias p1='cd /mnt/physical465.i ; echo "cd "`pwd`'
alias pi='cd /mnt/physical465.i ; echo "cd "`pwd`'
alias p2='cd /mnt/physical465.ii ; echo "cd "`pwd`'
alias pii='cd /mnt/physical465.ii ; echo "cd "`pwd`'
alias tmp='cd /tmp ; echo "cd "`pwd`'

# need this so that when I create shtuff, other users in same group can manipulate them
umask 0002

# message to user
#echo "[reminder of essential aliases...]"
#echo "alias | grep -i phy"
#alias | grep -i phy

## /SVN.HOME-specific places...
##




##
## VM-F121-specific places
alias wiki='cd /var/www/html/wiki ; pwd'


## /VM-F121-specific places
##

