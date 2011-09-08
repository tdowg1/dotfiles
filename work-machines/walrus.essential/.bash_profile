# .bash_profile
#
######################################################################
# Source local .bashrc get the entire NMS setup
######################################################################
if [[ -f ~/.bashrc ]]; then
	printf "Sourcing ~/.bashrc \n" 
	source ~/.bashrc
fi

# Set the default editor
export EDITOR=vi

# Set the default umask
umask 002

############################################################
# Depending upon the terminal type, set-up the backspace
# key to behave properly
############################################################
printf "Terminal type is $TERM\n"
if [[ ($TERM = xterm ) || ($TERM = dtterm) || 
      ($TERM = vt100) || ($TERM = vt220) ]]; then
	/bin/stty erase \^?
else # xterms, aixterms
	/bin/stty erase \^H
fi



#####################################################################
# User aliases, development environment
######################################################################
if [ -f ~/.bash_user ]; then
	source ~/.bash_user
fi

######################################################################
# Print some good info to screen
######################################################################
printf "DISPLAY is $DISPLAY\n\n"


######################################################################
# Finally, let the world see the path.
######################################################################
export PATH

