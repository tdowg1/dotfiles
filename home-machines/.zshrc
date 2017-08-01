#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
HISTFILE=~/.zsh-histfile
HISTSIZE=2000
SAVEHIST=2000
setopt APPEND_HISTORY
## for sharing history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY


## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# dont clear screen at logout
setopt norcs



update_auth_sock () 
{ 
    local socket_path="$(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')";
    if ! [[ -n "$socket_path" ]]; then
        echo 'no socket path' 1>&2;
        return 1;
    else
        export SSH_AUTH_SOCK="$socket_path";
    fi
}




# stupid HDFS craps:
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


# key bindings
bindkey -M vicmd '?' history-incremental-search-backward
bindkey '^R' history-incremental-pattern-search-backward


