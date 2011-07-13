#
# me
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
# put most recently touched at bottom
alias lr='ls -ltr'
alias ltr='ls -ltr'
alias lta='ls -lta'
alias ltra='ls -ltra'

# make human readable
alias lh='ls -lh'
alias lld='ls -ld'

alias cdb='cd ~/bin ; ls -l'
alias cdt='cd ~/tmp ; ls -l'

alias vib='vi /etc/profile'
alias cdd='cd ~/.dotfiles ; ls -l'

alias sudohack='~/bin/sudohack.sh &'
alias hacksudo='~/bin/sudohack.sh &'


#
# ARINC

#
# previously defined in bash_user_dev.env
#
#alias cout='$CT checkout -nc '
#alias cin='$CT checkin -nc '
alias uncout='$CT uncheckout -rm '
alias lsco='$CT lsco -me -recurse '
alias mkelem='$CT mkelem -ci -nc '


# change into view directory
alias cdv='cd ${CRBASE} ; pwd'


unalias vib
alias vib='vi ~/.bash_user'


alias proj='echo "launching ClearCase project explorer / clearprojexp" ; clearprojexp &'
alias explorer='use *expl* instead!  ... (dummy)'
alias expl='echo "launching ClearCase file browser / explorer" ; xclearcase &'
alias nv='netview &'


alias rmmedia='sudo rm -rf ~/media*'
