#!/bin/bash
#
##
# HOWTO setup quickly on a remote machine...
#
#scp -r walrus:.bash_user .
#scp -r walrus:.dotfiles .
#scp -r walrus:.screenrc .
# now, create new shell to apply settings
# also, now, in the future, all must do is issue this cmd to get most up2date
#mvinpull
#pull
#
##
# on the walrus gnms machine, here is NFO regarding how
# this and other files are sourced.  They are done so according 
# to the following hierarchy
#
# .bash_profile
#   |-- .bashrc
# ~~ `-- .bash_user ~~
#     `-- .dotfiles/mainly        CURR FILE
#         |-- .dotfiles/bash_user_dev.env
#         |-- .dotfiles/aliases.sh
#         |-- .dotfiles/functions.sh
#         `-- .dotfiles/variables.sh
#

fSourceIfThere(){
	local fileToSource="${1}"

	if [[ -f "${fileToSource}" ]] ; then
		echo "${fileToSource}"
		source "${fileToSource}"
	else
		echo "NO ${fileToSource}!"
	fi
}



# (fix due to gnms .bash_user_dev) BACKUP ps1
myPS1=$PS1

# original located at /usr/mgr/env/anp_cc/bash_user_dev.env
#source ~/.dotfiles/bash_user_dev.env
fSourceIfThere ~/.dotfiles/bash_user_dev.env.0

# (fix due to gnms .bash_user_dev) RESTORE ps1
export PS1=$myPS1

# (fix due to gnms .bash_user_dev) reset shell option
set -o emacs

# (fix due to gnms .bash_profile)
# make backspace not output ^? in vi when remotely connected (via PuTTy)
/bin/stty erase \^?


#
# makes anything defined automatically exported
set -o allexport
#


if [[ "$(hostname)" = "walrus" ]] ; then
	# do walrus-sy things...
	test "dummy test" = "camera's ready prepare the flash"
fi


## smbclient -L bdavies522276
# smbmount

fSourceIfThere ~/.dotfiles/aliases.sh
fSourceIfThere ~/.dotfiles/functions.sh
fSourceIfThere ~/.dotfiles/variables.sh

