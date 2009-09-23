#!/bin/sh -x
#
# TODO
# should be prompting user for each dotfile
#	see how see tahoe installer handled default values
#	see how other people are handling default values in their user promts
#
#
#

fPROMPT_USER_stub(){
	return 0
}

if [ $USER = 'root' ] ; then
	echo "no root user"
	exit 1;
fi


WORKING_DIR='tmp.mvin'
#REMOTE_HOST='http://bdavies522276/mvin'
REMOTE_HOST='http://svn/muzik-work/mvin/dotfiles'

#
# all the dot files / custom configurations to work with
dot_files='myaliases myvariables myfunctions'
dot_files='inputrc mvinrc zshrc'


#
# go HOME
cd


#
# create MY working directory
mkdir $WORKING_DIR
if [ $? != 0 ] ; then
	# TODO: the logic here could get bad if user enters in NOT 'n'
	echo "~/$WORKING_DIR already exists, but I need it.  Ok to delete? ([y]/n)"
	read isOkToDelete

	if [[ $isOkToDelete = "n" ]]; then
		echo "ERROR that directory must not exist"
		exit 1
	fi

	rm -rf ~/"$WORKING_DIR"
	mkdir $WORKING_DIR
fi


cd $WORKING_DIR


#
# DOWNLOAD
fPROMPT_USER_stub "Retrieve dot files from remote host? [y]"
if [ $? = 0 ] ; then
	for dotfile in $dot_files ; do
		wget $REMOTE_HOST/$dotfile
	done
fi



#
# PROFILE SOURCING
#
# the calling parent profile (i.e. .bashrc should source .mvinrc)
PARENT_PROFILE=~/.bashrc
MVIN_PROFILE_MVINRC='~/.mvinrc'

#
# check if calling parent profile needs to be "patched" (really updated) so that
# it'll source .mvinrc (which in turn will source custom profiles)
grep -n ". $MVIN_PROFILE_MVINRC" "$PARENT_PROFILE"

if [ $? = 0 ] ; then
	echo $PARENT_PROFILE is patched; nothing to do

else
	echo "Updating $PARENT_PROFILE to source custom profiles"

	tmpSourcingProfile="[[ -f $MVIN_PROFILE_MVINRC ]] && . $MVIN_PROFILE_MVINRC"

	echo "" >> $PARENT_PROFILE
	echo "# mvin.sh adds sourcing code" >> $PARENT_PROFILE
	echo "$tmpSourcingProfile" >> $PARENT_PROFILE
fi




#
# MOVE IN
for dotfile in $dot_files ; do
	fPROMPT_USER_stub "Move in $dotfile ~/.${dotfile}? [y]"
	if [ $? = 0 ] ; then
		cp -v $dotfile ~/.${dotfile}
	fi
done
