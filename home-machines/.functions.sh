# .functions.sh

## ### #### ###################################################################
##
## misc. functions
##
## ### #### ###################################################################

# this function helps w/ searching through a same set of files
grepdotfiles(){
	local filesToGrep=$(cat <<__HEREDOC__
		$HOME/.bash_[pu]*
		$HOME/.bashrc
		$ZOMG_DOTFILES/*
		$ZOMG_DOTFILES/.*
__HEREDOC__
	)

	for f in $filesToGrep ; do
		echo "[$f]:"
		grep -n "${*}" ${f}
	done
}



# make svn help paginate politely
svnhelp(){
	svn help $* | less -FX
}
# make accurev help paginate politely
achelp(){
	accurev help $* | less -FX
}

aptitudesns(){
	aptitude search "$1" | awk '{ print $2 }' | xargs --verbose  aptitude show | less -FX
}


##
## pulled from ARINC

## CLEARCASE-RELATED
############## ALTERNATIVE ways to recursive checkin
#http://stackoverflow.com/questions/973956/recursive-checkin-using-clearcase
#ct lsco -r -cvi -fmt "ci -nc \"%n\"\n" | ct
#ct lsco -r -cvi -fmt "unco -rm %n\n" | ct  

############## ALTERNATIVE way to recursive checkin/mkelem/--add new files
#clearfsimport -preview -rec -nset c:\sourceDir\* m:\MyView\MyVob\MyDestinationDirectory
#clearfsimport -preview -recurse -nsetevent ~/tmp/interop-vnms-configs/* aqp_iop/

_clearcase_recursive_HANDLER(){
	#echo "\$#[${#}]"
	what_to_do=$1
	shift
	#echo "shift; \$#[${#}]"


	# setup list of File System Objects (FSO) to operate on...
	FSO="${*}"
	if [[ $# = 0 ]] || [[ $# = 1 ]] && [[ "$1" = "" ]] ; then
		echo "No argument given! ... starting at current working directory"
		FSO="`pwd`"
	fi


	# ... operate on.
	for x in ${FSO}; do
		echo "[${x}] cc recursive ${what_to_do}..."

		if [[ -d "${x}" || -f "${x}" ]] ; then
			#
			# interpolate function call
			eval "_clearcase_recursive_${what_to_do}" "${x}"
			
#		elif [[ -f "${x}" ]] ; then
#			echo "	IS A FILE: use cout (alias cout='$CT checkout -nc ')!"
#			echo "	IS A FILE: use cin (alias cin='$CT checkin -nc ')!"
#			echo "	IS A FILE: use uncout (alias uncout='$CT uncheckout -rm ')!"
#			echo "		Dev-decidE::should I automatically call cout on a file for you?"
		else
			echo "	expected ${x} to be a directory"
			return
		fi
	done
	return
}
_clearcase_recursive_checkin(){
	if [[ $# = 1 ]] ; then
		cleartool find "$1" -version 'version(/main/LATEST)' -exec 'cleartool ci -nc $CLEARCASE_PN'
	fi
}
_clearcase_recursive_checkout(){
	if [[ $# = 1 ]] ; then
		cleartool find "$1" -version 'version(/main/LATEST)' -exec 'cleartool co -nc $CLEARCASE_PN'
	fi
}
_clearcase_recursive_uncheckout(){
	if [[ $# = 1 ]] ; then
		cleartool find "$1" -version 'version(/main/LATEST)' -exec 'cleartool unco -rm $CLEARCASE_PN'
	fi
}
_clearcase_recursive_mkelem(){
	if [[ $# = 1 ]] ; then
		find "$1" -type f -exec cleartool mkelem -ci -nc '{}' \;
	fi
}
cinr(){
	_clearcase_recursive_HANDLER "checkin" "${*}"
}
coutr(){
	_clearcase_recursive_HANDLER "checkout" "${*}"
}
uncoutr(){
	_clearcase_recursive_HANDLER "uncheckout" "${*}"
}
mkelemr(){
	_clearcase_recursive_HANDLER "mkelem" "${*}"
}
#
# creates a ClearCase view (and a folder in your home directory containing
# a way to get to it)
#
# $0 <pvob> <streamname> [<viewname>]
# ex: $0 gms_pvob CR10976_DevCr11732_GUI-RetuneBT
#
#STUB: shouldnt this function be INSTEAD CALLED:: setupCCStream ?
#...... NO!! i think it actually creates a view, to the specified stream!... (i.e. notice the `cleartool mkview' command... compare this with `cleartool mkstream').
setupCCView(){
	#echo "this function does not work... exiting."
	#BOILERPLATE
	#[[ $# != 2 ]] || [[ $# != 3 ]] && \
	#	echo "usage: $FUNCNAME <pvob> <streamname> [<viewname>] \
	#	ex: $FUNCNAME gms_pvob CR10976_DevCr11732_GUI-RetuneBT" && return;

	pvob=$1
	streamName=$2

	subsystem="${pvob%_pvob}"   # for instance, "gms_pvob" -> "gms"
	
	# auto generate the view name
	prependToView="bdavies_"
	viewName="${prependToView}${streamName}"

#	if [ $# = 3 ] ; then
#		# forget the autogenerated viewname and use what was specified
#		viewName=$3
#	fi
	#/BOILERPLATE

	
	# create the view (ClearCase operation)
	cleartool mkview \
		-tag "${viewName}" \
		-stream "stream:${streamName}@/vobs/${subsystem}_pvob" \
		-stgloc viewstore
	
	return

#STUB: not executed::
	# create a pathway to this view from $HOME directory
	OLDPWD=`pwd`
	cd
	if [ "$subsystem" = "gms" ] ; then
		# do my custom gms setup
		echo 'matched gms_pvbo'

		mkdir ${viewNAME}
		cd ${viewNAME}
		ln -s /view/${viewNAME}/vobs/gms_cvob gms_cvob

	else
		# do it the 'gnms way' (or, what I'm calling for now--the 
		# generic way
		echo 'NOT matched gms_pvob'

		ln -s "/view/${viewName}/vobs/${subsystem}_cvob/" "${viewName}"
	fi
	cd "${OLDPWD}"

}
# function to setup CC view for GMS gui for development, the way I want it to be setup.
createSymlinkTogms_pvobCCView(){
	[ $# != 1 ] && echo -e "usage: $FUNCNAME <view name>\ne.g.: $FUNCNAME bdavies_\$COMMON" && return;
	
	viewNAME=$1
	OLDPWD=`pwd`

	cd
	mkdir ${viewNAME}
	cd ${viewNAME}
	ln -s /view/${viewNAME}/vobs/gms_cvob gms_cvob

	cd "${OLDPWD}"
}
## /CLEARCASE-RELATED


#fixvimrc(){
#	echo "attempt remove .vimrc symlink into production... that's in my home"
#	rm -i ~/.vimrc
#	[ $? != 0 ] && return
#
#	echo "attempt to recreate my own .vimrc..."
#	cp -i ~/.dotfiles/vimrc ~/.vimrc
#}
## function to pull files from walrus
#alias pull='mvinpull'
#mvinpull(){
#	echo "MVINPULL(): scp pull dotfiles from walrus...";
#	scp -r bdavies@walrus:.dotfiles ~/
#	scp bdavies@walrus:.screenrc ~/
#	echo "MVINPULL(): now run 'fixvimrc' to mv .dotfiles/vimrc ~> .vimrc"
#}
## /pulled from ARINC
##














## ### #### ###################################################################
##
## help text functions
##
##  These functions do nothing but print helpful/hintful text regarding various
##  commands, etc.
##
## ### #### ###################################################################

helpmd5(){
(
        cat <<'__HERE__'
CREATE1:: filenames (from find)  may not be sorted! # cd $DIR
 find . -type f -exec md5sum '{}' \; > md5sum.md5
 # it may then be desirable to have hashes sorted by filename:
 sort -k2 md5sum.md5
CREATE2:: have hashes sorted by filename from the start # cd $DIR
 find .  -type f | sort | xargs md5sum > md5sum.md5
VALIDATE:: (shows only failures) # cd $DIR
 md5sum --check md5sum.md5 | grep ' FAILED'
__HERE__
)
}
helpshasum(){
(
        cat <<'__HERE__'
		  Handy when checking Linux distros that have CHECKSUM files
find . -name \*CHECKSUM -execdir sha256sum --check '{}' \;
__HERE__
)
}

helpsynergy(){
(
        cat <<'__HERE__'
renice -14 $(ps -ef | grep /usr/bin/synergyc | grep -v grep | awk '{print $2}')
# ( ... see also (my custom): pssynergy)
__HERE__
)
}

helprsnapshotdiffall(){
cat <<'__envHEREDOC__'
YOU MUST BE IN RSNAPSHOT DIRECTORY (see hourly.0, hourly.1, etc.)
prev=INITIAL; for i in $(ls -trd ./*) ; do if [ "$prev" = "INITIAL" ] ; then echo ; prev=$i; continue; fi; echo "prev[$prev];curr[$i]"; rsnapshot-diff $prev $i ; prev=$i; echo ; done

for i in `seq 7 -1 1` ; do sudo rsnapshot-diff hourly.${i}/magnificent.home/ hourly.$(( ${i} - 1))/magnificent.home/; done
__envHEREDOC__
}

pssynergy(){
        echo '  PID TTY          TIME  NI COMMAND'
        ps -eo "%p %y %x %n %c" | grep synergy
}


helphardinfo(){
	echo 'hardinfo --load-module devices.so --load-module computer.so --report-format text --generate-report | grep Sensors --after-context=20'
}

helphardinfo2(){
	echo 'while [ true ] ; do hardinfo --load-module devices.so --load-module computer.so --report-format text --generate-report | grep Sensors --after-context=20; date; sleep 30; echo ; echo ; done'
}

helppar2(){
	echo 'par2 create -v -v -r5 -l -f0 -- BASEname.par2 BASEname.part*  > ../par2-create.log'
	echo '... for example'
	echo '	par2 create -v -v -r10 -l -f0 -- dswww2009-12-12.par2 dswww2009-12-12.part* > ../par2-create.log'
}

helpmdadm(){
	echo 'sudo mdadm --assemble --scan'
}

helpsvnpropset(){
	echo 'svn propset svn propval proppath'
	echo 'example'
	echo '	svn propset svn executable fileToMakeExecutable'
	echo '	svn propset svn:keywords "Id HeadURL LastChangedBy LastChangedDate LastChangedRevision FILE"'
}



##
## pulled from SVN.HOME
helpsmartctl(){
   echo
   echo "   # LIST ATTRIBUTES"
   echo 'smartctl -a /dev/sda ; echo ; echo ; smartctl -a /dev/sdb ; echo ; echo;  echo; smartctl -a /dev/sdc'
   echo '   # LONG TEST'
   echo 'smartctl -t long /dev/sda'
   echo 'echo "sleep for 45 minutes" && sleep 45m'
   echo 'smartctl -t long /dev/sdb'
   echo 'echo "sleep for 175 minutes" && sleep 175m'
   echo 'smartctl -t long /dev/sdc'
   echo 'echo "sleep for 175 minutes" && sleep 175m'

cat <<'__envHEREDOC__'
   # LOOPS
for i in a b c ; do   sudo smartctl --all  /dev/sd${i} | less ; done
for i in a b c ; do   sudo smartctl --test=short /dev/sd${i};  done; date; echo

__envHEREDOC__
}
helpsvn(){
	echo "svn propset svn:keywords \"Id\" FILE"
}
helpsvnadmin(){
   echo '   # svnadmin RECOVER, VERIFY, DUMP all muzik-repos'
   echo 'svnadmin recover /srv/svn/muzik-repos/muzik3'
   echo 'svnadmin verify /srv/svn/muzik-repos/muzik3'
   echo 'svnadmin dump /srv/svn/muzik-repos/muzik3 > muzik3.dump'
   echo
   echo 'svnadmin recover /srv/svn/muzik-repos/muzik1'
   echo 'svnadmin verify /srv/svn/muzik-repos/muzik1'
   echo 'svnadmin dump /srv/svn/muzik-repos/muzik1 > muzik1.dump'
   echo
   echo 'svnadmin recover /srv/svn/muzik-repos/muzik1'
   echo 'svnadmin verify /srv/svn/muzik-repos/muzik1'
   echo 'svnadmin dump /srv/svn/muzik-repos/muzik1 > muzik1.dump'
}
helpsamba(){
cat <<'__envHEREDOC__'
$ nmblookup HOSTNAME
querying HOSTNAME on w.x.y.255
__envHEREDOC__
}

helpdmddevel(){
cat <<'__envHEREDOC__'
for syncing thumb drive changes (intel_duo) onto svn webserver:
   watch -n 5 'rsync -av /mnt/intel_duo-q/usr/eclipse/eclipse-SDK-3.4.svn-ws.home/dmd.www-trunk--webroot/ /home/tyler/html/webroot2/'

for updating PUBLIC dmd.com web server w changes from svn:
   first EXPORT
      svn export svn://svn/svn-dev-repo/dmd.inherited/trunk/webroot webroot2.x/

   second COPY
   rsync -n -rt -v --delete  webroot2.x/ gregory.isaacs@dmd.com:./public_html/
(^^and remove the "-n" to do it for reel
__envHEREDOC__
}
## /pulled from SVN.HOME
##










helpdd(){
cat <<'__envHEREDOC__'
READ (use SKIP) from disk
   dd if=/dev/sdk of=/dev/null skip=1440000000
WRITE (use SEEK) to disk
   dd if=/dev/zero of=/dev/sdd count=1 seek=1849566775
EXAMPLES --------
   dd if=/dev/zero of=/tmp/a-7-gig-file count=7 bs=1G
   dd if=/dev/sda | hexdump -C | grep [^00]   # to ensure device is really zeroed
   dd if=/dev/urandom of=/tmp/quickly-generated-random-file.dd bs=1M count=1
EXAMPLES hdd-REMAPPING ----------------------
WRITE-remap block sector (seemed to have good luck w this)"
   dd if=/dev/zero of=/dev/sdd count=1 seek=<decimal LBA block> oflag=direct conv=notrunc
WRITE-rewrite entire disk (trying this on a disk that has 1000+ bad sectors... im not going to remap all those _manually_ so, lets see what this will do (fyi: the disk is iA18))
   dd if=/dev/sdk of=/dev/sdk bs=4096 oflag=direct conv=notrunc,noerror
MISC ----
MONITORING progress
   dd ... & pid=$! ; watch kill -USR1 $pid
   while [ 1 ] ; do kill -USR1 $pid ; sleep 5 ; done
LBA approximations (assumes 512-byte block size (bs) ; uses iA18 as subject disk)
   iA18 is 698GiB;
   slightly more than 12876374016 bytes (~13GB) were written before completing
   arg given to skip=1440000000
   *therefore*, 'LBA' 1440000000 is approx at the 686GiB location of the hdd.
__envHEREDOC__
}
helpdd2(){
      cat <<'__envHEREDOC__'
See Also
* ddrescue tries hard to rescue data in case of read errors
* safecopy is a data recovery tool which tries to extract as much data as possible from a problematic (i.e. damaged sectors) source - like floppy drives, harddisk partitions, CDs, tape devices, ..., where other tools like dd would fail doe to I/O errors.
__envHEREDOC__
}

helpdate(){
	#local useThisDate="2010/06/05 16:15:15"
	local useThisDate=`date`
	echo "using date $useThisDate"
	echo -e "[OUTPUT]\t\t[CMDLN]"
	
	cmdln="date +\"%Y-%m-%d %H-%M-%S\"  --date=\"$(eval echo ${useThisDate})\""
	echo -e "$(eval $cmdln)\t$cmdln"
	
	cmdln="date +\"%Y%m%d_%H%M%S\"      --date=\"$(eval echo ${useThisDate})\""
	echo -e "$(eval $cmdln)\t\t$cmdln"
	
	cmdln="date +\"%Y-%m-%d_%H,%M,%S\"  --date=\"$(eval echo ${useThisDate})\""
	echo -e "$(eval $cmdln)\t$cmdln"
}
helpawk(){
cat <<'__envHEREDOC__'
PRINT LAST COLUMN
	$ svn info | grep 'Last Changed Rev:' | awk '{ print $NF }'
	> 1200
PRINT LAST COLUMN and DO MATH
	$ svn info | grep 'Last Changed Rev:' | awk '{ print $NF-5 }'
	> 1195
PRINT 2rd TO-LAST COLUMN
	$ svn info | grep 'Last Changed Rev:' | awk '{ print $(NF-1) }'
	> Rev:
PRINT VARIOUS
	$ echo 'one t z' | awk '{ print $2 " " $1 }'
	> t one
ltrim( rtrim( $1 ) )
	awk  '{ gsub(/^[ \t]+|[ \t]+$/, "", $1); print $1 }'
__envHEREDOC__
}
helpsetuid(){
	echo "from stat /muzik-work/: Access: (2775/drwxrwsr-x)"
}

helprsync(){
	echo "** copy -r DIR amadedir into another_dir (post-op: another_dir/amadedir)"
	echo "	rsync -av path/to/amadedir /path/to/another_dir/"
	echo "	rsync -av path/to/amadedir /path/to/another_dir"
	echo "... copy -r DIR amadedir __contents!!__ (post-op: another_dir contains amadedir/*)"
	echo "... this is awkward-typically, something I wouldn't do"
	echo "	rsync -av path/to/amadedir/ /path/to/another_dir/"
	echo
	echo "IOW, these 2 cmdln's are equivalent:"
	echo "	* cp -rf /tmp/some/folder /tmp     # --> new \`/tmp/folder'"
	echo "	* rsync -av /tmp/some/folder /tmp  # --> new \`/tmp/folder'"
	echo ""
	echo "rsync -av beres.hammond@xbryn:. /mnt/a32-555/xbryn --exclude=em-200* --dry-run"
	echo 
	echo "--checksum : used this to detect xls differences that weren't detected, ow"

cat <<'__envHEREDOC__'
ANOTHER ATTEMPT AT THE QUESTION 'use slash || not?'::
COPY FOLDER
	rsync -av /opt/muzik /mnt/rsnapshot/
COPY FOLDER's CONTENTS
	rsync -av /opt/muzik/ /mnt/rsnapshot/
__envHEREDOC__
}
helprsyncexamples(){
cat <<'__envHEREDOC__'
BU an rsnapshot root (or "repository")
	rsync -a --hard-links --delete /mnt/rsnapshot/ /mnt/rsnapshot_bu1/
__envHEREDOC__
}

helprename(){
	echo "# pad certain directories with zeros"
	echo 'disk="${TOP_LEVEL_DIRECTORY}/${CHILD_DIR_PREFIX}"'
	echo 'rename "$disk" "$disk"0 "$disk"?'
	echo '[[ $diskCount > 99 ]] && rename "$disk" "$disk"0 "$disk"??'
}
helprenameexamples(){
	echo "mv [0, 1, 2] => [00, 01, 02]"
	echo '	rename "" 0"" [0-9]'
}
helpe2fsck(){
	echo "gParted uses:"
	echo "	e2fsck -f -y -v /dev/DEV"
	echo "others:"
	echo "	e2fsck -f -y -v -C 0 -c /dev/DEV"
	echo "		Force, assume Yes, Verbosity, C=progress bar, c=badblock check+add"
}
helprpm(){
cat <<'__envHEREDOC__'
	rpm -qa --last # gives pkg and date modified
	    --filesbypkg # List all the files in package 
__envHEREDOC__
}
helpvim(){
	cat <<'__envHEREDOC__'
http://vim.wikia.com
:set nonu #disables line numbering
:%s/foo/bar/g #Find each occurrence of 'foo', and replace it with 'bar'
:%s/foo/bar/gc #Change each 'foo' to 'bar', but ask for confirmation first
UNDO REDO (:help undo)
Note that (somewhat confusingly) U is undo-able with u.
undo last change (can be repeated to undo preceding cmds)
	u
return the line to its orig state (undo all changes in curr line)
	U
Redo changes which were undo (undo the undos). Compare to '.' to /repeat/ a
prev change, at the curr cursor position. c-R will redo a previously undone
change, wherever the change occurred.
	c-R
ENTER A CONTROL CHARACTER (e.g. CTRL+M ('^M'))
	c-v c-X
		where X is the desired character
[RE-]FORMATTING TEXT
* make length of each line auto-trimmed to fit
** :se textwidth=72
* reformat too long and too short lines according to curr textwidth
** globally: gggqG
** curr paragraph: gqap
BLOCK EDIT MODE
* c-v (to ggo into col mode)
* select columns and rows where want to enter text
* shift+i (to go into insert mode in column modea0
* type in text want to enter
* ESC (or c-c) to apply
INSTANT MANPAGE DOCUMENTATION FOR CURR CMD CURSOR IS ON
	K
SHTUFF
* delete from cursor to end of 'word': dw
* delete from cursor to end of line: D
* delete from cursor to end of file: dG
__envHEREDOC__
}
helpvimdiff(){
      cat <<'__envHEREDOC__'
COPY LEFT / RIGHT
* do - Get changes from other window into the current window.
* dp - Put the changes from current window into the other window.
NEXT/PREVIOUS CHANGE
* ]c - Jump to the next change.
* [c - Jump to the previous change.
CHANGE WINDOW
* C-w + C-w - Switch to the other split window.

MISC
* :diffupdate - diff update
* :syntax off - syntax off
* zo - open folded text
* zc - close folded text
* C-w= - make window width equal
__envHEREDOC__
}
helpxargs(){
	cat <<'__envHEREDOC__'
ex:
   echo bluetooth iscsi iscsid lvm2-monitor notExecuted |\
	xargs --verbose -n 1 -i{} --delimiter=' ' chkconfig --levels 123456 {} off
EXECUTE LINES FROM A FILE
	cat /some/FILE | xargs --verbose -L 1 -i{} bash -c {} --another-optional-arg
__envHEREDOC__
}
helpirb(){
      cat <<'__envHEREDOC__'
Martin Fowler once tweeted
      when I need a calculator, I fire up irb.
Pretty shweet!  interactive ruby can do decimals and all sorts of shtuff!
__envHEREDOC__
}
helprar(){
      cat <<'__envHEREDOC__'
ALL
	-ol # save symbolic link as the link instead of the file
	-ow # save || restore file owner and group

ARCHIVE
	rar a \
		-tsmca \ # timstamps 
		-hpPASSWORD \
		-rrRECOVERY_RECORD_AMT \ # AVOID making amount > 9 (specified 10 one time which produced 1% recovery)
		-r \ # recurse
		RAR_OUTPUT_FILE
		RAR_INPUT_SRC

ARCHIVE EXAMPLE1
	* timestamps: save as much as possible
	* recovery record: 9%
	* compression: NONE / 'store'
	* recursive
	* volume size: 200863744b[YTES] ~= 191MB
	* save symlinks as links (not the file they point to)
	* save owner/group metadata
$ sudo /usr/local/bin/rar  a  -tsmca -hpPASSWD -rr9 -m0  -r  -v200863744b  -ol -ow   /tmp/optical/rt2011-08-03/archives/rt2011-08-03.rar .

ARCHIVE EXAMPLE2
	* ep1 Exclude base directory from names
	* m5 compression level 5/5; "maximal" highest
	* m1 compression level 1/5; "lowest" none
	* m0 compression level 0/5; "store" none
	* r recurse subdirectories
	* rr4 add 4% recovery record

	* t test after archive
	* tsmca save file time file time (modification, creation, access)
	* v<size>[k,b] where size=size*1000 and k,b=[*1024,*1]
	* -hp[password] to encrypt file header and data using given password string
   rar a -m5 -r -rr4 -t -tsmca

EXTRACT
	rar x
TEST
	rar t [v] [pPASSWD]
__envHEREDOC__
}
helpless(){
      cat <<'__envHEREDOC__'
SHOW NFO
	^G
__envHEREDOC__
}
helptune2fs(){
      cat <<'__envHEREDOC__'
MOUNT COUNTS && CHECKS
	tune2fs -l /dev/sda4 | grep -iP 'mount|check'
__envHEREDOC__
}
helpblkid(){
      cat <<'__envHEREDOC__'
!!!! -- locate/print block device attributes!!!
blkid
	prints things like UUID, LABEL, etc.

__envHEREDOC__
}
helpssh(){
	cat <<'__envHEREDOC__'
ssh
	[-N (Do not execute a remote command; useful when forwarding ports)]
	[-p ssh-server-port-to-connect-with]
	[-D localhost-SOCKS-proxy-to-use]
	[-i identity_file (NOTE:should be 400)]
	[user@]ssh-server
__envHEREDOC__
}
helpuseradd(){
	cat <<'__envHEREDOC__'
sudo useradd --home=/home/<username> --create-home --password=<passwd>  <username>
	NOTE value for SHELL in /etc/default/useradd
__envHEREDOC__
}
helpnetstat(){
	cat <<'__envHEREDOC__'
Show open connections
	netstat -e
Show open connections specifically for ftp
	netstat -e | grep ftp
Show all *T*cp ports being *L*istened to
	netstat -tl
__envHEREDOC__
}

helpgit(){
	cat <<'__envHEREDOC__'
= STATUS =
	STUB: figure out howto list files disregarding any git ignore defs that would otherwise be in effect

= LOGs =
$ git log --format=oneline
$ git log v2.5..        # commits since (not reachable from) v2.5
$ git log test..master  # commits reachable from master but not test
$ git log master..test  # commits reachable from test but not master
$ git log master...test # commits reachable from either test or
= LOGs ORDERing =
* [default]: start with most recent commit, working backwards through the parents.
** IOW: commits appear in reverse chronological order.
* --topo-order: descendant commits show before their parents.
** IOW: commits appear in topological order.
* --date-order: similar to --topo-order in that no parent comes before all of its children, ow commits ordered in the commit timestamp order.
** IOW: commits appear primarily by commit date.

= BRANCHes =
* Push local branch to upstream branch / remote origin (creates remote branch if DNE):
** git push origin east1999eternal-branch
* Create a branch based on an upstream branch (v1):
** git fetch origin
** git checkout --track origin/east1999eternal-branch
* Create a branch based on an upstream branch (v2):
** git branch --track my_branch origin/my_branch
** git checkout my_branch
* Delete remote branch
** git push origin :my_branch

= TAGs =
* Push local tags upstream
** git push --verbose --tags
* Delete remote tag named 12345
** git push origin :refs/tags/12345

* Print most recent tag
** git describe

= IGNOREing =
http://www.randallkent.com/development/gitignore-not-working
or?
git update-index --assume-unchanged
__envHEREDOC__
}
helpgit2(){
      cat <<'__envHEREDOC__'
= Undocumented (from git help) =
* git ls-files --directory --others --exclude-from=.git/info/exclude
* git update-index # Modifies the index or directory cache.

= External Links =
* git_remote_branch : A tool to simplify working with remote branches (http://github.com/webmat/git_remote_branch)
__envHEREDOC__
}
helptree(){
      cat <<'__envHEREDOC__'
tree --charset=${LANG} # works
tree --charset=en_US.UTF-8 # perhaps more portable?  idk both have worked when tree is exec'd via putty (wo '--charset', putty displays garbage)
__envHEREDOC__
}
helpps(){
      cat <<'__envHEREDOC__'
ps axfww # shows complete exec str and in tree form
__envHEREDOC__
}
helppatch(){
      cat <<'__envHEREDOC__'
# create patch: to apply changes going from 'INITIAL' -> to 'FINAL' content
diff -c START_FILE END_FILE > patch
diff -c INITIAL_FILE FINAL_FILE > patch
diff -c OLD_FILE NEW_FILE > patch
	diff -c bash_user_dev.env.production bash_user_dev.env > bash_user_dev.env.patch

# apply patch
patch --input=patch
	patch --input=bash_user_dev.env.patch
__envHEREDOC__
}
helpsed(){
cat <<'__envHEREDOC__'
PREVIEW file/replace on files:
 sed -n "s/192.168.8.3/bryn-pc/p" file1 [fileN]
. . . ^. . . . . . . . . . . . ^
perform CHANGE find/replace on files:
 sed -i "s/192.168.8.3/bryn-pc/" file1 [fileN]
. . . ^
HELPFUL for changing all the [fileN]'s:
 grep -R --files-with-match PATTERN [PATH] | xargs --verbose -n 1 <sed STUFF>
__envHEREDOC__
}
helpaptitude(){
cat <<'__envHEREDOC__'
The first character
of each line indicates the current state of the package: the most
common states are 
p, meaning that no trace of the package exists on the system, 
c, meaning that the package was deleted but its configuration 
 files remain on the system, 
i, meaning that the package is installed, and 
v, meaning that the package is virtual.

The second
character indicates the stored action (if any; otherwise a blank
space is displayed) to be performed on the package, with the most
common actions being 
i, meaning that the package will be installed,
d, meaning that the package will be deleted, and 
p, meaning that the
package and its configuration files will be removed.

If the third character is 
A, the package was automatically installed.
__envHEREDOC__
}
helpbash(){
cat <<'__envHEREDOC__'
-n   : syntax check
__envHEREDOC__
}
helpsort(){
cat <<'__envHEREDOC__'
SORT A FILE OF FILE HASHES (md5sum output)
 sort -k 2 path/to/input-file

__envHEREDOC__
}
helpzip(){
cat <<'__envHEREDOC__'
STUB!!! THERES NOTHING HERE :(
__envHEREDOC__
}
helptcpdump(){
cat <<'__envHEREDOC__'
tcpdump  -A -i eth1 -q
__envHEREDOC__
}


##
## pulled from ARINC
helpclearcase(){
	echo "recursive CHECKOUT"
	echo "	cleartool find . -version 'version(/main/LATEST)' -exec 'cleartool co -nc \$CLEARCASE_PN'"
	echo "recursive CHECKIN"
	echo "	cleartool find . -version 'version(/main/LATEST)' -exec 'cleartool ci -nc \$CLEARCASE_PN'"
	echo "		lscoshort \$ccPath  | xargs -n 1 --verbose \$CT checkin -nc"
	echo "recursive UNCHECKOUT"
	echo "	cleartool find . -version 'version(/main/LATEST)' -exec 'cleartool unco -rm \$CLEARCASE_PN'"
	echo "recursive LIST CHECKOUTS"
	echo "	cleartool lsco -r ."
	echo "create and check in a new folder (Parent is co||unco?)"
	echo "	cleartool mkdir -nc FOLDERNAME"
	echo "create and check in a new file (Parent is co)"
	echo "	cleartool mkelem -ci -nc FILE"
	echo "		ADD a file (if no -ci, file is added but not its content--MUST cin at some point!) (Parent is co)"
	echo "recursive create and checkin entire directory structure (PREVIEW**) (Parent is NOT co)"
	echo "	clearfsimport -preview -recurse -nsetevent ~/tmp/WORKING_DIR/ CC_DESTINATION_DIR"
	echo "clearfsimport IS YOUR FRIEND FOR SYNC'ING CHANGES BW SRC TREES!!"
	echo "	/bin/ls \$svnPath/ | xargs --verbose -i{} -n 1 clearfsimport -recurse -nsetevent -rmname \$svnPath/{}/* \$ccPath/{}  | grep -v -P -i \"skipping|unchanged\""
	echo "recursive create and checkin a new a file (Parent is co)"
	echo "	find . -type f -exec cleartool mkelem -ci -nc '{}' \;"
	echo "REMOVE a version of a file (like svn delete)"
	echo "	cleartool rmname [-force] FILENAME"
	echo "REMOVE a version of a directory"
	echo "	cleartool rmview -tag VIEW-NAME"
	echo "REMOVE a view just by its name"
	echo ""
	echo "get more HELP..."
	echo "cleartool [help|man] command"
	echo ""
	echo "mkview (dynamic)"
	echo "	mkview -tag bdavies_GMS_140_INT3 -stream stream:GMS_140_Integration@/vobs/gms_pvob -stgloc viewstore"
	echo "mkstream (development)"
	echo "	cleartool mkstream -in stream:GMS_140_Integration@/vobs/gms_pvob stream:CR10976_DevCr11733_GUI-AcquisitionBF@/vobs/gms_pvob"
	echo "	see also: bash function:: setupSymlinkToCCview()"
	echo "startview (restart stopped views (e.g. server restart))"
	echo "	cleartool lsview | grep bdavies | grep GMS_140 | awk '{ print \$1 }' | xargs -n 1  --verbose  -x cleartool startview"
	echo ""
	echo "for GMS development+CC cin's and whatnot:"
	echo "must CHANGE CURR GROUP to be anp_cc (i.e. 'nn')"
}
## /pulled from ARINC
##
helpgrub(){
cat <<'__envHEREDOC__'
== GRUB V0.9x ==
(fedora13, 8, etc.)

== GRUB V1.99 ==
(ubu1104)
FREAKING DOCUMENTATION IS HERE... pain in my arse.
	info -f grub -n 'Simple configuration'
Config:
	/etc/default/grub
Apply / Install any config changes made:
	update-grub  # which is esentially an alias for `grub-install > $BOOT/grub.cfg`
__envHEREDOC__
}
helpaptitude2(){
cat <<'__envHEREDOC__'
SEARCH + SHOW PACKAGE(S) GIVEN A SEARCH STRING
aptitude search PACKAGE | awk '{ print $2 }' | xargs --verbose  aptitude show | less
__envHEREDOC__
}

_help6(){
cat <<'__envHEREDOC__'

__envHEREDOC__
}


## ### #### ###################################################################
##
## /help text functions
##
## ### #### ###################################################################

