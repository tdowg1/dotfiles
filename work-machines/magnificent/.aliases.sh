#
# me... bdavies!
#
# according to man pages, tty is not a valid option to --color argument, only
# never, always or auto
unalias ls
alias ls='ls --color=always'
#
#
alias l='ls --color=always -lF'
alias ll='ls --color=always -lF'
alias la='ls --color=always -aF'
alias lla='ls --color=always -alF'
# put most recently touched at bottom
alias lr='ls --color=always -ltrF'
alias ltr='ls --color=always -ltrF'
alias lta='ls --color=always -ltaF'
alias ltra='ls --color=always -ltraF'

# make human readable
alias lh='ls --color=always -lh'
alias lsd='ls --color=always -d' # ha! lsd, that's funny.
alias lld='ls --color=always -ld'

alias cdb='cd ~/bin ; ls --color=always -l'
alias cdt='cd ~/tmp ; ls --color=always -l'

#alias vib='vi /etc/profile'
alias cdd='cd ~/.dotfiles ; ls --color=always -l'

alias cdrsnapshot='cd /mnt/rsnapshot/r ; ls --color=always -ltraF'
alias cdgit='cd $HOME/dev/git'
alias cdsvn='cd $HOME/dev/svn'


#
# ARINC
export CT=/opt/rational/clearcase/bin/cleartool
#
# previously defined in bash_user_dev.env
#
#alias cout='$CT checkout -nc '
#alias cin='$CT checkin -nc '
alias uncout='$CT uncheckout -rm '
alias lsco='$CT lsco -me -recurse -cview '
alias lscoshort='$CT lsco -me -recurse -short -cview '
alias mkelem='$CT mkelem -ci -nc '


# change into view directory
alias cdv='cd ${CRBASE} ; pwd'


#alias vib && unalias vib
alias vib='vi ~/.mainly.sh'
alias viba='vi ~/.aliases.sh'
alias vibf='vi ~/.functions.sh'
alias vibv='vi ~/.variables.sh'


alias proj='clearprojexp'
alias explorer='use *expl* instead!  ... (dummy)'
alias expl='xclearcase &'
alias nv='netview'


alias rmmedia='sudo rm -rf ~/media*'


alias df='df -hT | grep -v vobs'

#alias reloadenv='. ~/.bash_user'
alias reloadenv='. ~/.bash_profile'


# accurev-related
alias ah='achelp'
alias ac='accurev'
alias acinfo='accurev info ; accurev secinfo'
alias acnf='accurev info ; accurev secinfo'
# /accurev-related

# /ARINC
#


# git
alias g='git'
#
alias gh='git help'
#
alias st='git status'
alias sts='git status --short'
alias di='git diff'
alias dic='git diff --cached'
alias br='git branch'
alias ta='git tag'
alias log='git log'
#alias plog='git plog'
alias loghead='git log | head'
alias gitcommittxt='clear ; git config --list | grep remote.origin.url ; git log | head'


