#
# me
#
# according to man pages, tty is not a valid option to --color argument, only
# never, always or auto
unalias ls
alias ls='ls --color=always'
#
#
alias l='ls --color=always -l'
alias ll='ls --color=always -l'
alias la='ls --color=always -a'
alias lla='ls --color=always -la'
# put most recently touched at bottom
alias lr='ls --color=always -ltr'
alias ltr='ls --color=always -ltr'
alias lta='ls --color=always -lta'
alias ltra='ls --color=always -ltra'

# make human readable
alias lh='ls --color=always -lh'
alias lsd='ls --color=always -d' # ha! lsd, that's funny.
alias lld='ls --color=always -ld'

alias cdb='cd ~/bin ; ls --color=always -l'
alias cdt='cd ~/tmp ; ls --color=always -l'

#alias vib='vi /etc/profile'
alias cdd='cd ~/.dotfiles ; ls --color=always -l'

alias sudohack='~/bin/sudohack.sh &'
alias hacksudo='~/bin/sudohack.sh &'


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
alias vib='vi ~/.dotfiles/mainly'
alias viba='vi ~/.dotfiles/aliases.sh'
alias vibf='vi ~/.dotfiles/functions.sh'
alias vibv='vi ~/.dotfiles/variables.sh'


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

