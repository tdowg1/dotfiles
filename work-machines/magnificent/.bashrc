
export OS=$(uname -s)
export TZ=UTC

# Source 'system' bashrc
if [[ -f /etc/bashrc ]]; then
	source /etc/bashrc
fi

######################################################################
# For NetView
######################################################################
export LANG=en_US
export LC_MESSAGES=en_US
