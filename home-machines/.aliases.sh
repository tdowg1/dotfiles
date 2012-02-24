# .aliases.sh

## ### #### ###################################################################
##
## misc.
##
## ### #### ###################################################################

##
## rc, config, dotfile-related
#alias vib='vim $ZOMG_DOTFILES/.mainly.sh'
alias vib='vim ~/.mainly.sh'

alias viba='vim ~/.aliases.sh'
alias vibf='vim ~/.functions.sh'
alias vibv='vim ~/.variables.sh'

alias pushvibftogit='cp --verbose ~/.functions.sh $ZOMG_DOTFILES'
#alias cdd='cd ~/.dotfiles ; ls -l'  # !!! want this.... STUB
alias cdd='cd $ZOMG_DOTFILES ; lla'

##### THERE IS AN ISSUE WHEREBY each successfive call will make the PATH variable
##### grow humongously.  I'm guessing this is a bad thing?
##### Is opening a new terminal /really/ the ONLY way to realize any env/ changes?
alias reloadenv='echo ". ~/.bashrc" ; . ~/.bashrc'
## /rc, config, dotfile-related
##



##
## misc
alias epwd='echo `pwd`/'
alias kill9='kill -9'
alias k9='kill -9'
alias kn='kill -9'
#STUB alias pgr='ps -ef | grep'
alias psaxfww='ps axfww'
alias df='df -hT'
alias mountdev='mount | grep /dev'
alias mdstat='more /proc/mdstat'
alias sshsvn='ssh -2XC tyler@svn'
# dont need this any more:; is in /etc/fstab.  just say sudo mount /mnt/sshfssvn
#alias sshfssvn='sshfs root@svn:/ /mnt/svn ; echo "mounted host[svn] at[/mnt/svn]"'

# if less than a page of output, stop it.
#alias less='less --QUIT-AT-EOF'
alias less='less -FX --tabs=3'

alias gitcommitmisc='git commit -m "misc dotfile changes ($HOSTNAME)"'


alias cdb='cd ~/bin ; pwd'
#alias cdb='cd ~/bin ; ls -l'
#alias lb='ls -l ~/bin'
alias cdt='cd ~/tmp ; pwd'
#alias cdt='cd ~/tmp ; ls -l'
## /misc
##



##
## ls-related
# (at least for phisata-#8-F13_2010-06-30_02:59:17-0400)
# `ls' already aliased to:
#   [teelah@phisata ~]$ date
#   Sat Aug 13 01:49:48 EDT 2011
#   [teelah@phisata ~]$ alias ls
#   alias ls='ls --color=auto'
#   [teelah@phisata ~]$
#
# valid options to --color argument: never, always or auto
# unalias ls if if it's already been defined
#unalias ls
alias ls  >/dev/null  2>&1 \
	&& unalias ls
########## STUB FIX THIS ABOVE bc get error when do...
#teelah@intelduo:~$ scp -r phisata:/bin .
#/home/usrs.cp/teelah/.aliases.sh
#teelah@intelduo:~$ /home/usrs.cp/teelah/.aliases.sh: line 63: unalias: ls: not found
######### /STUB
alias ls='ls --classify --color=auto --time-style=iso'

alias ll  >/dev/null  2>&1 \
	&& unalias ll
alias ll='ls -lF'
#
# --time-style=iso examples:
#  04-30 23:57  <-- refers to a recent file
#  2009-10-21   <-- refers to a non-recent file
#
alias l.='ls -la'
alias l='ls -l'
alias la='ls -a'
alias lsa='ls -a'
alias lh='ls -lh'
alias li='ls -li'
alias lla='ls -la'
alias lld='ls -ld'
alias lsd='ls -d'       # orly?
alias lt='ls -lt'
alias lta='ls -lta'
#alias lr='ls -ltr'
alias ltr='ls -ltr'
alias ltra='ls -ltra'
alias ltrr='ls -lt'     # same as alias lt
alias trll='ls -ltr'    # same as ltr
## /ls-related
##



##
## git-related
alias br='git branch'
alias bra='git branch --verbose'
alias brm='git branch --merged'
alias brnm='git branch --no-merged'
alias cop='git checkout --patch'  # interactively discard changes in working directory
alias di='git diff'
alias dic='git diff --cached'
alias g='git'
alias gh='git help'
alias gitcommittxt='clear ; git config --list | grep remote.origin.url ; git log | head'
alias list='git stash list'
alias log='git log'
alias logp='git log -p'
alias logs='git log --stat'
alias logps='git log -p --stat'
alias logsp='git log -p --stat'   # same as the above
alias loghead='git log | head'
alias loghead2='git log | head -20'
alias logheadp='git plog | head'
alias logheadp2='git plog | head -20'
#alias plog='git plog'
alias sta='git stash'
alias st='git status'
alias sts='git status --short'
alias tag='git tag'
alias taga='git tag -l -n'
## git-related
##



## ### #### ###################################################################
##
## HOST-specific
##
## ### #### ###################################################################

## 
## PHISATA-specific
if [[ x"${IS_I_ON_PHISATA}" = x"true" ]] ; then
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
fi
## /PHISATA-specific
##



##
## SVN.HOME-specific
if [[ x"${IS_I_ON_SVN}" = x"true" ]] ; then
	alias p1='cd /mnt/physical465.i ; echo "cd "`pwd`'
	alias pi='cd /mnt/physical465.i ; echo "cd "`pwd`'
	alias p2='cd /mnt/physical465.ii ; echo "cd "`pwd`'
	alias pii='cd /mnt/physical465.ii ; echo "cd "`pwd`'
	alias tmp='cd /tmp ; echo "cd "`pwd`'

	# need this so that when I create shtuff, other users in same group can manipulate them
	umask 0002
	# ^^STUB this is not an alias.

	# message to user
	#echo "[reminder of essential aliases...]"
	#echo "alias | grep -i phy"
	#alias | grep -i phy
fi
## /SVN.HOME-specific
##



##
## VM-F121-specific; vm-f121
alias wiki='cd /var/www/html/wiki ; pwd'
alias mwstart='dropbox start ; sudo service mysqld start ; sudo service httpd start'
alias mwstop='dropbox stop ; sudo service mysqld stop ; sudo service httpd stop'
alias mwstatus='dropbox status ; sudo service mysqld status ; sudo service httpd status'
## /VM-F121-specific
##



##
## ARINC-specific
export CT=/opt/rational/clearcase/bin/cleartool
#^^STUB this not an alias

alias nv='netview'
#alias df='df -hT | grep -v vobs'

# Rational, ClearCase-related
#alias cout='$CT checkout -nc '
#alias cin='$CT checkin -nc '
alias uncout='$CT uncheckout -rm '
alias lsco='$CT lsco -me -recurse -cview '
alias lscoshort='$CT lsco -me -recurse -short -cview '
alias mkelem='$CT mkelem -ci -nc '
alias cdv='cd ${CRBASE} ; pwd'  # change into view directory
alias proj='clearprojexp'
alias explorer='use *expl* instead!  ... (dummy)'
alias expl='xclearcase &'

# AccuRev-related
alias ah='achelp'
alias ac='accurev'
alias acinfo='accurev info ; accurev secinfo'
alias acnf='accurev info ; accurev secinfo'
## /ARINC-specific
##



##
## [com.spryinc.]MAGNIFICENT-specific
alias cdrsnapshot='cd /mnt/rsnapshot/r ; ltra'
alias cdgit='cd $HOME/dev/git'
alias cdsvn='cd $HOME/dev/svn'


if [[ x"${IS_I_ON_MAGNIFICENT}" = x"true" ]] ; then
	alias cdsuper='cd $HOME/dev/git/sprySuperGitRepo'

fi
## /[com.spryinc.]MAGNIFICENT-specific
##


