# .aliases.sh

## ### #### ###################################################################
##
## misc.
##
## ### #### ###################################################################

## 
## TEMPORARY
#alias vibo='vim $dbi/collection-of-essential-packages/ongoing.txt'
alias dbdnb='vim $db/db.dox/next.Buy.txt'
alias dbdnba='vim $db/db.dox/next.Buy.txt.archive.txt'
alias dbiceo='vim $dbi/collection-of-essential-packages/ongoing.txt'
alias dbicio='vim $dbi/collection-of-interesting-packages/ongoing.txt'
##



##
## rc, config, dotfile-related
alias vib='vim "$ZOMG_DOTFILES/.mainly.sh"'
#alias vib='vim ~/.mainly.sh'

alias viba='vim "$ZOMG_DOTFILES/.aliases.sh"'
alias vibf='vim "$ZOMG_DOTFILES/.functions.sh"'
alias vibv='vim "$ZOMG_DOTFILES/.variables.sh"'

alias cdd='cd $ZOMG_DOTFILES ; lla'

##### THERE IS AN ISSUE WHEREBY each successfive call will make the PATH variable
##### grow humongously.  I'm guessing this is a bad thing?
##### Is opening a new terminal /really/ the ONLY way to realize any env/ changes?
alias reloadenv='echo ". ~/.bashrc" ; . ~/.bashrc'
## /rc, config, dotfile-related
##



##
## misc
#alias epwd='echo `pwd`/'
alias grep >/dev/null 2>&1  ||  alias grep='grep --color'
alias kill9='kill -9'
alias k9='kill -9'
alias kn='kill -9'
#STUB alias pgr='ps -ef | grep'
alias psaxfww='ps axfww'
alias df='df --human-readable --print-type'
alias du='du --human-readable --summarize'
# how about also including sshfs and cifs mounts?
alias mountdev='mount -l | grep -P "\/dev|\[|\]"'
alias mountdev2='mount -l | sort | grep -P "^\/dev|\[|\]"'
alias mdstat='more /proc/mdstat'
alias sshsvn='ssh -2XC tyler@svn'
# dont need this any more:; is in /etc/fstab.  just say sudo mount /mnt/sshfssvn
#alias sshfssvn='sshfs root@svn:/ /mnt/svn ; echo "mounted host[svn] at[/mnt/svn]"'

alias Less='less'
#alias less='less -FX --tabs=3'
#alias less='less --quit-if-one-screen --no-init --tabs=3'   # no-init sometimes prevents clearing of display
#alias less='less --quit-if-one-screen --tabs=3'
alias less='less --tabs=3'
#alias le=' ... '

# Quickly change behaviour of the Apple keyboard's [F]unction keys:
# TODO STUB: I'm pretty ignorant about this shtuff... methinks there's another,
#   perhaps better, way to do this with "modifiers" and "levels" and all diff
#   sorts of keyboard black magical hackerys... Investigate.
alias keyboardBenormal="sudo su -c \"echo '2' > /sys/module/hid_apple/parameters/fnmode\""
alias keyboardBefruity="sudo su -c \"echo '1' > /sys/module/hid_apple/parameters/fnmode\""


alias runvmware="vmware-gksu  --user root  --preserve-env  vmware"
alias vmwarerunvmware="vmware-gksu  --user root  --preserve-env  vmware"
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
alias lla='ls -la'      # show everything, sort by name [asc.]
alias llar='ls -lar'    # show everything, sort by name desc.
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
## Places (`cd'-related)
#alias cdb='cd ~/bin ; ls -l'
alias cdb='cd ~/bin ; pwd'
#alias cdt='cd ~/tmp ; ls -l'
alias cdt='cd ~/tmp ; pwd'
alias tmp='cd /tmp ; echo "cd "`pwd`'


# TODO STUB convert to the $variable scheme way:
#alias cdrsnapshot='cd /mnt/rsnapshot/r ; ltra'
alias cdrsnapshot='cd /mnt/rsnapshot/r ; ls -ltra && date'


# dropbox places
alias db='cd "$db"'        # TODO STUB : all of these alias defs could be defined dynamically... e.g. in variables defn area, define a variable containing all variables to be dynamically aliased out-to give the equivalent of these:
alias dbbkmks='cd "$dbbkmks"'
alias dbi='cd "$dbi"'
alias dbl='cd "$dbl"'
alias dblkde='cd "$dbl/.kde/share/"'
alias dbm='cd "$dbm"'
alias dbpub='cd "$dbpub"'
alias dbpubpics='cd "$dbpubpics"'
alias dbs='cd "$dbs"'
alias dbsedu='cd "$dbsedu"'

# misc places
alias x11='cd "$x11"'
alias cdx='cd "$x11"'

# dswww places
alias dswww='cd "$dswww" ; pwd'
alias hdd='cd "$hdd" ; pwd'
alias hddsmart='cd $hddsmart ; pwd'

alias dswwwr='cd "$dswww/root" ; pwd'
alias cdr='cd "$dswww/root" ; pwd'

alias life='cd "$life" ; pwd'
alias lifedork='cd "$lifedork" ; pwd'
alias dork='cd "$lifedork" ; pwd'
alias proj='cd "$proj" ; pwd'

alias ri='cd "$ri"'
alias rim='cd "$rim"'

alias installsoft='cd "$installsoft"'
alias installsoftos='cd "$installsoftos"'
alias installsoftos2='cd "$installsoftos2"'
## /Places (`cd'-related)
##


## 
## Things (`vim'-file-editing-related)
alias vibx='sudo vim "$xorg"'
alias vibuy='vim "$db/db.dox/next.Buy.txt"'
alias vibuyarchive='vim "$db/db.dox/next.Buy.txt.archive.txt"'
## /Things (`vim'-file-editing-related)
## 


##
## git-related
alias gitcommitauto='git commit -m "auto commit"'
alias gitcommitautoa='git commit -m -a "auto commit"'
alias gitcommitmisc='git commit -m "misc dotfile changes ($HOSTNAME)"'
alias gitcommitmisca='git commit -m -a "misc dotfile changes ($HOSTNAME)"'
alias pps='git pull ; git push ; git status'
alias gitupstreamUrl='git config --list | grep remote.origin.url'

alias br='git branch'
alias bra='git branch --verbose'
alias brm='git branch --merged'
alias merged='git branch --merged'      # same as above
alias brnm='git branch --no-merged'
alias nomerged='git branch --no-merged' # same as above
alias nom='git branch --no-merged'      # same as above
alias cop='git checkout --patch'  # interactively discard changes in working directory
alias gdi='git diff'
alias gdic='git diff --cached'
alias g='git'
alias gh='git help'
alias gitcommittxt='clear ; git config --list | grep remote.origin.url ; git log | head'
alias list='git stash list'
alias log='git log'
alias logp='git log -p'
alias logs='git log --stat'
alias logps='git log -p --stat'
alias logsp='git log -p --stat'   # same as the above
alias logf='git log --follow'     # Continue listing the history of a file beyond renames (works only for a single file).
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



##
## HDFS/YARN/Hadoop-related
alias            hcat='hdfs dfs -cat'
alias          hchgrp='hdfs dfs -chgrp'
alias          hchmod='hdfs dfs -chmod'
alias          hchown='hdfs dfs -chown'
alias          hcount='hdfs dfs -count'
alias             hcp='hdfs dfs -cp'
alias             hdf='hdfs dfs -df'
alias             hdu='hdfs dfs -du'
alias           hfind='hdfs dfs -find'
alias             hls='hdfs dfs -ls'
alias          hmkdir='hdfs dfs -mkdir'
alias             hmv='hdfs dfs -mv'
alias             hrm='hdfs dfs -rm'
alias            hrmr='hdfs dfs -rm -r'
alias           hrmrs='hdfs dfs -rm -r -skipTrash'
alias           hstat='hdfs dfs -stat'
alias hstatreplication='hdfs dfs -stat %r'
alias hstat555cmonnow='hdfs dfs -stat "       file %n
  blocksize %o
     blocks %b
       type %F
replication %r
        uid %u
        gid %g
     modify %y"'
alias        hgetfacl='hdfs dfs -getfacl'
alias        hsetfacl='hdfs dfs -setfacl'
alias           htest='hdfs dfs -test'
alias          htouch='hdfs dfs -touchz'
alias hcreatesnapshot='hdfs dfs -createSnapshot'
alias hdeletesnapshot='hdfs dfs -deleteSnapshot'
alias hrenamesnapshot='hdfs dfs -renameSnapshot'

alias        hgetconf='hdfs getconf -confKey'
alias         hreport='hdfs dfsadmin -report'
alias       hsafemode='hdfs dfsadmin -safemode'
alias    hsafemodeget='hdfs dfsadmin -safemode get'
alias  hsafemodeleave='hdfs dfsadmin -safemode leave'
alias           ylist='yarn application -list'
alias           ykill='yarn application -kill'
## HDFS/YARN/Hadoop-related
##




## ### #### ###################################################################
##
## HOST-specific
##
## ### #### ###################################################################

## 
## PHISATA-specific
if [[ x"${IS_I_ON_PHISATA}" = x"true" ]] ; then
	alias a32='cd /mnt/a32-555 ; pwd'
	alias t='cd /mnt/a32-555/t ; pwd'
	
	alias tu='$TUTILS'
	alias cdtu='cd /opt/teelah-utils/bin/; pwd'
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

	# need this so that when I create shtuff, other users in same group can manipulate them
	umask 0002
	# ^^STUB this is not an alias.

	# message to user
	#echo "[reminder of essential aliases...]"
	#echo "alias | grep -i phy"
	#alias | grep -i phy
	
	alias tu='$TUTILS'
	alias cdtu='cd /opt/teelah-utils/bin/; pwd'
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
# (correct, this is the alias file, but this is not an alias. It's 1 defn.  DEAL.)
#export CT=/opt/rational/clearcase/bin/cleartool
#
#alias nv='netview'
#alias df='df -hT | grep -v vobs'
#
## Rational, ClearCase-related
#alias cout='$CT checkout -nc '
#alias cin='$CT checkin -nc '
#alias uncout='$CT uncheckout -rm '
#alias lsco='$CT lsco -me -recurse -cview '
#alias lscoshort='$CT lsco -me -recurse -short -cview '
#alias mkelem='$CT mkelem -ci -nc '
#alias cdv='cd ${CRBASE} ; pwd'  # change into view directory
#alias proj='clearprojexp'
#alias explorer='use *expl* instead!  ... (dummy)'
#alias expl='xclearcase &'
#
## AccuRev-related
#alias ah='achelp'
#alias ac='accurev'
#alias acinfo='accurev info ; accurev secinfo'
#alias acnf='accurev info ; accurev secinfo'
## /ARINC-specific
##



##
## [com.spryinc.]MAGNIFICENT-specific
## [com.spryinc.]SHAZAM-specific
# ... I'm thinking I might like these. So, at least for now, define
# for all host machines.
alias cddev='cd $HOME/dev'
alias cdgit='cd $HOME/dev/git'
alias cdsvn='cd $HOME/dev/svn'
alias cdmisc='cd $HOME/dev/misc'
alias cdwork='cd $HOME/work'
alias cdw='cd $HOME/work'
alias cdwaa='cd $HOME/work/ansible/ansible/misc-playbooks'
# NOW, it's getting pretty HOST-specific...
alias cdwa1='cd $HOME/work/_ark.1-2011'
alias cdwa2='cd $HOME/work/_ark.2-2012'

## /[com.spryinc.]MAGNIFICENT-specific
##



## SoC environments. Busybox is used.
which_ls=$( readlink $( which ls ) )
if [[ -n "$which_ls" ]] ; then
   actual_ls=$( basename $( readlink $( which ls ) ) )
   if [[ "$actual_ls" = "busybox" ]] ; then
      unalias ls
      #alias ls='ls --classify --color=auto --time-style=iso'
      alias ls='ls -F --color=auto'

      #alias grep >/dev/null 2>&1  ||  alias grep='grep --color'
      unalias grep

      #alias df='df --human-readable --print-type'
      unalias df
      #alias du='du --human-readable --summarize'
      unalias du
   fi
fi
## /SoC environments. Busybox is used.
##

