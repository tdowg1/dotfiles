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
REMOTE_HOST='http://svn/muzik-work/mvin/mvin'

#
# all the dot files / custom configurations to work with
dot_files='myaliases myvariables myfunctions'
dot_files='inputrc zshrc'


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
# Im not sure what this should be
PARENT_PROFILE=~/.bashrc

# check if calling parent profile needs to be "patched" (really updated) so that
# it'll source custom profiles upon login



fPROMPT_USER_stub "Update $PARENT_PROFILE to source custom profiles? [y]"
if [ $? = 0 ] ; then
	# patch profile
fi





#
# MOVE IN
for dotfile in $dot_files ; do
	fPROMPT_USER_stub "Move in $dotfile ~/.${dotfile}? [y]"
	if [ $? = 0 ] ; then
		cp -v $dotfile ~/.${dotfile}
	fi
done


