# .functions.sh

## ### #### ###################################################################
##
## misc. functions
##
## ### #### ###################################################################

# TODO STUB
#get that echoandexec method I wrote


## WARNING!  these 2 functions NOT tested
slowdown(){
	local pid=$1
	ionice -c3 -p $pid
	renice -n 20 $pid
}
unslowdown(){
	local pid=$1
	# best-effort io class
	ionice -c 2 -p $pid
	renice -n -19 $pid
}
## /WARNING!  these 2 functions NOT tested


getprocesspriority(){
	# print the current niceness and io priority of pid
	local pid=$1

	## psstats
	#intpri		(\$niceness + 80?) slowest 99 or 100, highest 1 or 0 internal kernel sheduling priority
	#pri			priority (\$niceness + 20?--NO!  this is not how get the number... its weird tho)     kernel scheduling priority
	#ni			slowest 19 or 20, fastest -19 or -20
	local psformat="intpri,pri,nice"
	local psformatforprintf="%6d,%3d,%4d"
	local psnoheader="h"
	local psstats="$( ps -o "$psformat" "$psnoheader" -p $pid )"

	## iostats
	# io scheduling class and io priority
	local ioformat="classio[: prio]"
	local ioformatforprintf="%15s"
	local iostats="$( ionice -p $pid )"
	
	echo "$psformat,$ioformat"
	printf "$psformatforprintf,$ioformatforprintf\n" $psstats "$iostats"
}

chdotfiles(){
	# A stupid function that takes a path to dotfiles folder and re-sets up
	# bash environment by sourcing the '.mainly.sh' file in said path.
	# Think: chroot
	# Basically, its a shortcut to using and setting up a bash environment
	# that is NOT the default one that may already be set up.
	# For example, this would be useful if need to work on a bug or different
	# dotfiles src code, but don't want this work to impact the default
	# "production" shell. (you could also achieve this by creating another
	# user on the box i.e. dotfiles-development-user and having that user
	# set up to use the desired dotfiles to be worked on, but that doesn't
	# really scale, probably, and: no.
	if [[ $# != 1 ]] || [[ x"$1" = x"--help" ]] ; then
		echo "$FUNCNAME - setup curr shell with special dotfiles directory"
		echo "Usage: $FUNCNAME NEWDOTFILESHOME"
		return 1
	fi
	
	local newdotfileshome="$1"
	cd "$newdotfileshome"
	export DOTFILES_HOME=`pwd`
	source .mainly.sh
	echo $ZOMG_DOTFILES ;
	#/home/bdavies/tmp/dotfiles.2/home-machines/ ; export DOTFILES_HOME=`pwd` ; source .mainly.sh ; echo $ZOMG_DOTFILES ;
}

#getfullpath(){
#	# Example invocations
#	#  $ getfullpath .functions.sh
#	#  /home/bdavies/tmp/dotfiles.2/home-machines/.functions.sh
#	#  $ getfullpath ~/../../dev/tty50
#	#  /dev/tty50
#	#  $ getfullpath ~/
#	#  /home/bdavies
#	local fso="${1}"  # file system object
#	echo "$( readlink -f "$( dirname "$fso" )" )/$( basename "$fso" )"
#}



f_isinteger(){
	# TRUE  -> return 0 (If is able to parse to integer)
	# FALSE -> ow
	local x="$1"
	if ! [[ "${x}" =~ ^-?[0-9]+$ ]] ; then
		exec >&2;
		#echo "error: Not a number";
		return 1
	fi
	return 0
}
f_isfloat(){
	# TRUE  -> return 0 (If is able to parse to float)
	# FALSE -> ow
	local x="$1"
	if ! [[ "${x}" =~ ^-?[0-9]+([.][0-9]+)?$ ]] ; then
		exec >&2;
		#echo "FALSE";
		return 1
	fi
	return 0
}



gitgetcurrentbranch(){
	git branch >/dev/null 2>&1  ||  return $?
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

#gitbranchpushandtrackupstream(){
gitbranchcREATEpushupstreamandtrack(){
	local description="Pushes an untracked, local branch, upstream, then sets 
	the local branch to track the upstream.
	"
	if [[ x"$1" = x"--help" ]] ; then
		echo $description
		return
	fi
	local branch="$1"
	if [[ -z "$branch" ]] ; then
		echo "ATTENTION: you did not specify the branch to push; defaulting to current."
		branch="$( gitgetcurrentbranch )" || return $?
		echo "current branch: $branch"
	fi

	git push origin  "$branch"  ||  return $?
	git branch --set-upstream  "$branch"  "origin/${branch}"
}




# TODO STUB
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
	cat <<'__envHEREDOC__'
CREATE1:: filenames (from find)  may not be sorted! # cd $DIR
 find . -type f -exec md5sum '{}' \; > md5sum.md5
 # it may then be desirable to have hashes sorted by filename:
 sort -k2 md5sum.md5  >  md5sum.md5.sorted

CREATE2:: have hashes sorted by filename from the start # cd $DIR
 find .  -type f | sort | xargs md5sum > md5sum.md5

VALIDATE:: (shows only failures) # cd $DIR
 md5sum --check md5sum.md5 | grep ' FAILED'
__envHEREDOC__
}
helpshasum(){
	cat <<'__envHEREDOC__'
		  Handy when checking Linux distros that have CHECKSUM files
find . -name \*CHECKSUM -execdir sha256sum --check '{}' \;
__envHEREDOC__
}
helpsynergy(){
	cat <<'__envHEREDOC__'
renice -14 $(ps -ef | grep /usr/bin/synergyc | grep -v grep | awk '{print $2}')
# ( ... see also (my custom): pssynergy)
__envHEREDOC__
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
	echo '	svn propset svn:keywords "Id HeadURL LastChangedBy LastChangedDate LastChangedRevision" FILE'
	echo '   svn propset svn:executable "true" FILE'

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
devicelist="a b c"
for i in $devicelist ; do   sudo smartctl --all  /dev/sd${i} | less ; done
for i in $devicelist ; do   sudo smartctl --test=short /dev/sd${i};  done; sleep 15m;
for i in $devicelist ; do   sudo smartctl --test=conveyance /dev/sd${i};  done; sleep 30m;
for i in $devicelist ; do   sudo smartctl --test=long /dev/sd${i};  done; sleep 300m; 

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
*  dd if=/dev/zero of=/some/path/to/the.img bs=1M count=600  # **create 600 Meg image file**
rewrite disk (with itself)
   dd if=/dev/sdc of=/dev/sdc bs=4096 conv=noerror

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
Dump System memory to a file
   dd if=/dev/mem of=/root/system-memory.dump
Duplicate one hard disk partition to another hard disk partition
   dd if=/dev/sda2 of=/dev/sdb2 bs=4096 conv=notrunc,noerror
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

cat <<'__envHEREDOC__'

date  --reference=file-to-reference
__envHEREDOC__
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
PRINT 2nd COLUMN and ALL REMAINING COLUMNS
	# _note_ prob better off using `cut'
	$ echo 'one two three and to the fo' |  awk '{ for(i = 2; i <= NF; i++) { printf("%s ", $i) }
printf("\n") }' 
	> two three and to the fo
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
COPY wrt HARDLINKS
	rsync -a --hard-links --delete "${src}/" "${dest}/"

GIVE SSH OPTIONS
	rsync -av  -e "ssh -l ssh-user-phife-dawg"  ali.shaheed.muhammad@brooklyn:. /tmp
		--stats  --human-readable --progress

DATA INTEGRITY (at expense of : time increase, i/o increase)
	--checksum
DATA INTEGRITY (cont.) (SEE ALSO)
	 --inplace --ignore-times
__envHEREDOC__
}
helprsyncexamples(){
cat <<'__envHEREDOC__'
BU an rsnapshot root (or "repository")
	rsync -a --hard-links --delete /mnt/rsnapshot/ /mnt/rsnapshot_bu1/
rsync using public-private openssh keys
	rsync -av -e "ssh -i ~/.ssh/aaliyah.id_rsa -l aaliyah" hostname:/host/path/ /local/path/ 
__envHEREDOC__
}
helprename(){
cat <<'__envHEREDOC__'
== rename v1 (non-regex) ==
GENERAL USAGE
rename "intel_duo" "intelduo" intel*

PAD CERTAIN DIRECTORIES WITH ZEROS
disk="${TOP_LEVEL_DIRECTORY}/${CHILD_DIR_PREFIX}"
rename "$disk" "$disk"0 "$disk"?
[[ $diskCount > 99 ]] && rename "$disk" "$disk"0 "$disk"??

== rename v2 (regex) ==
rename 's/REGEX/REPLACE' files
__envHEREDOC__
}
helprenameexamples(){
cat <<'__envHEREDOC__'
== rename v1 (non-regex) ==
$ rename "" 0"" [0-9]     # desired behaviour: mv [0, 1, 2] => [00, 01, 02]

== rename v2 (regex) ==
$ rename -n  's/\ HEAD//'  intelduo\ bookmarks-201*
intelduo bookmarks-2012-01-12 HEAD.json renamed as intelduo bookmarks-2012-01-12.json
intelduo bookmarks-2012-01-13 HEAD.json renamed as intelduo bookmarks-2012-01-13.json
__envHEREDOC__
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
:set nonu                           # disable line numbering
:%s/foo/bar/g                       # Find each occurrence of 'foo', and replace it with 'bar'
:[range]s/foo/bar/gc                # Change each 'foo' to 'bar', but ask for confirmation first
http://www.thegeekstuff.com/2009/04/vi-vim-editor-search-and-replace-examples/
http://www.worldtimzone.com/res/vi.html   Nice cheat sheet

:colorscheme slate
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
* c-X  ; where X is the desired control character
** e.g. c-v  ; to insert

[RE-]FORMATTING TEXT
* make length of each line auto-trimmed to fit
** :se textwidth=72
* reformat too long and too short lines according to curr textwidth
** globally: gggqG
** curr paragraph: gqap
** {VISUAL}gq
* reformat src code
** :se filetype=xml
** gg=G
** {VISUAL} STUB-----------WANTED 

VISUAL / BLOCK EDIT MODE : c-v (to go into mode), then select cols/rows where want to...
* I - Insert Text
** I
** type in text want to enter
** ESC (or c-c) to apply
* d - Delete Text
* > - Shift right / Indent Text
** indent once: >
** indent thrice: 3>
* < - Shift left / UnIndent Text
* ~ - Switch Case

INSTANT MANPAGE DOCUMENTATION FOR CURR CMD CURSOR IS ON
	K
UPPER && LOWER CASING
* toUpper convert visual selection: gU
* toLower convert visual selection: gu
* toUpper until the end of the word: gUw
* toUpper until the end of 2 words: gU2w
* toUpper until the end of the line: gU$
* toUpper until the end of 10 characters: gU10l
* toUpper the entire curr line: gUU
* toLower the entire curr line: guu
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
* hp[PASSWORD]
* m<0..5>       Set compression level (0-store...3-default...5-maximal)
* r             Recurse subdirectories
* rr            Add data recovery record; recovery record size will be selected
						 automatically according to the archive size: a size of the 
						 recovery information will be about 1% of the total archive 
						 size, usually allowing the recovery of up to 0.6% of the 
						 total archive size of continuously damaged data.
* rr<N>         Add data recovery record; N = 1, 2 .. 524288 recovery sectors.
						 A recovery record contains up to 524288 recovery sectors.
* rr<N>%%       Add data recovery record; N = 1, 2 .. 100 percent.
* rr<N>p        Add data recovery record; N = 1, 2 .. 100 percent.
* rv            Add data recovery volumes
* t             Test files after archiving
* ts<m,c,a>[N]  Save or restore file time (modification, creation, access).
                   just say: -tsmca to get everything.

ARCHIVE EXAMPLE0
* rar a -m5 -r -rr4p -t -tsmca  "rarchive.rar"  "<path to file or directory>"

ARCHIVE EXAMPLE1
	* timestamps: save as much as possible
	* recovery record: 9%
	* compression: NONE / 'store'
	* recursive
	* volume size: 200863744b[YTES] ~= 191MB
	* save symlinks as links (not the file they point to)
	* save owner/group metadata
$ sudo /usr/local/bin/rar  a  -tsmca -hpPASSWD -rr9p -m0  -r  -v200863744b  -ol -ow   /tmp/optical/rt2011-08-03/archives/rt2011-08-03.rar .

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
   rar a -m5 -r -rr4p -t -tsmca

ARCHIVE EXAMPLE3 (**NOTE this snippet has been known to go outside of
		snippet land and screw up my bash environment, therefore, extra
		spaces have been inserted)
	create archives of folders in curr directory; space-character: OK
-ifsbak=$I F S
-I F S = $ ( e c h o - e n "__backslash-ENN____backslash-bee__" )
-for i in $( find ./  -maxdepth 1 -mindepth 1 -type d  ) ; do
-       echo rar a -m5 -r -rr4p -t -tsmca  "${i}.rar" "${i}";
-done
-I F S = $ i f s b a k



ARCHIVE EXAMPLE4
	Perhaps want to archive all folders in cwd (and files too if exist in cwd) that begin with 2011 and 2012... (i.e. ff-snapshots):
for i in 201[12]* ; do sudo /usr/local/bin/rar a -m5 -r -rr4p -t -tsmca "${i}.rar" "${i}" ; done

EXTRACT
   rar x
REPAIR
   rar r <archive-to-repair>
TEST
   rar t [v] [pPASSWD]
__envHEREDOC__
}
helpless(){
      cat <<'__envHEREDOC__'
* show nfo: ^G
* jump to line number, "N", with: Ng
** ex: ln88 : 88g
__envHEREDOC__
}
helptune2fs(){
      cat <<'__envHEREDOC__'
MOUNT COUNTS && CHECKS
	tune2fs -l /dev/sda4 | grep -iP 'mount|check'
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

FINGERPRINTs
	ssh-keygen -l -f  private-open-ssh-key
__envHEREDOC__
}
helpuseradd(){
	cat <<'__envHEREDOC__'
sudo useradd --home=/home/<username> --create-home --password=<passwd>  <username>
	NOTE value for SHELL in /etc/default/useradd
__envHEREDOC__
}
_help6(){
cat <<'__envHEREDOC__'
helpnetstat
helpnslookup
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
Sort of like a "top" for network connections made (is not actively refreshed, new output is generated every so many seconds)
	netstat -tcp -apc 10
__envHEREDOC__
}
helpnslookup(){
cat <<'__envHEREDOC__'
nslookup - query Internet name servers interactively
nslookup( hostname ) : ipaddr
nslookup some-host.example.com    # get ip address for some-host.example.com

== See also ==
==== From man Page ====
/etc/resolv.conf
dig(1)
host(1)
named(8)
__envHEREDOC__
}

helpgit(){
	cat <<'__envHEREDOC__'
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
** git push origin e1999eternal-branch
* Make local branch track an upstream branch
** git branch --set-upstream e1999eternal-branch origin/e1999eternal-branch
* Create a branch based on an upstream branch (v1) (and check it out):
** git checkout --track origin/e1999eternal-branch
* Create a branch based on an upstream branch (v2):
** git branch --track my_branch origin/my_branch
* Delete remote branch
** git push origin :my_branch
== branching example (create new branch, push upstream and track) ==
* git co -b  Environment--DEMO
* git push origin  Environment--DEMO
* git branch --set-upstream Environment--DEMO origin/Environment--DEMO
=== branching example example :) ===
for i in Environment--DEMO environment--dev ; do
 git co -b $i
 git push origin $i
 git branch --set-upstream $i origin/${i}
done

= TAGs =
* Create
** git tag -m <msg> <tagname> [<commit>]
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
^^ya I think this workd
__envHEREDOC__
}
helpgit2(){
      cat <<'__envHEREDOC__'
= STASHes =
* respect staged,unstaged when <pop|apply>
** git stash <pop|apply> --index

= Undocumented (from git help) =
* git ls-files --directory --others --exclude-from=.git/info/exclude
* git update-index # Modifies the index or directory cache.
* gitattributes (see git-log --help --> merge.renormalize)

= MERGEs and Conflict Resolution-related =
=== 'MERGING'-mode.1 : post-merge ===

* Just performed a merge and want to undo it -> for most cases, you'll want this(^1)...
** git reset --hard                # THINK: --dry-run option for `git merge'
* ... as opposed to this(^1):
** git revert
* (^1) := from `git help merge':
 Reverting a merge commit declares that __you will never want__ the tree changes
 brought in by the merge. As a result, later merges will only bring in tree
 changes introduced by commits that are not ancestors of the previously reverted
 merge. __This may or may not be what you want__.
 See the revert-a-faulty-merge How-To[1] for more details.

=== 'MERGING'-mode.2 : post-resolution && pre-commit ===
* when in 'MERGING' mode, and /after/ merge conflict resolution has been done, execute the following to indicate that conflicts have been resolved in the files (afterwards, just commit and youre done):
** git update-index <file(s) in question>
* PRE-commit : delete any ''*.orig'' files
** git mergetool saves the merge-conflict version of the file with a ''.orig''
suffix.  Make sure to delete it before adding and committing the merge or add *.orig
to your .gitignore.

=== 'MERGING' : post-commit ===
* Since reviewing git log ONLY shows the merge commit entry and makes it difficult to get at the /actual/ change _content_, HERES SOME WAYS TO get at that content:
** BRIEF
*** git show --raw              # gives file listing, some hashes
** VERBOSE
*** git show -c                 # shows changes introduced by the merge
*** git di HEAD^^ HEAD^         # something I tried out, not sure if I'm in cloudland || !.
*** git di <2nd newest commit> <newest commit>  # diff FROM 2nd newest commit
                                                #        TO newest commit.
**** e.g.: git di 3f13e..2721c  # diff FROM 3f13e TO 2721c
 *   2721caf (HEAD, phisata-conflicts, master) Merge branch 'master' into phisata-conflicts (18m ago)
 |\
 | * 3f13ede (origin/master, origin/HEAD) misc dotfile changes (vm-ubu10041) (13h ago)

= DIFFs =
* git diff <from> <to>          # diff FROM <from> commit TO <to> commit
* Useful when want to review the actual content brought in i.e. MERGED IN from a branch.
** git di <2nd newest commit> <newest commit>   # (see example-above)
* git di <branch1 name> <branch2 name>
* git di <branch name> <current branch>
* git di <branch name>          # same as above ("TO" branch implied to be current branch)
__envHEREDOC__
}
helpgit3(){
      cat <<'__envHEREDOC__'
= COMMIT MODIFICATION =
== modify last commit ==
a. $ git reset --soft HEAD^
b. make desired modifications
c. $ git commit -c ORIG_HEAD  # or use -C to indicate you do NOT want to edit commit msg

== modify any commit ==
Using the commit hash prior to the commit you want to modify, run:
a. $ git rebase --interactive ${parent_commit_of_commit_to_be_modified}
b. change leading text to edit for each commit you want to modify
c. make desired changes. then change your commit history with:
d. $ git commit -a --amend
e. once committed, you want git to re-apply the history that's in front of the commit you just over wrote, so run:
f. $ git rebase --continue
g. if you're modifying >1 commit (specified in b.),
g1. GOTO c.
g2. ELSE finished

== revert hunk of any commit ==
* src && see also http://bit.ly/GVnJWt
** http://bit.ly/HevPZ9  http://bit.ly/GVYk3l
* $ git checkout --patch [<tree-ish>] [--] [<paths>...]
__envHEREDOC__
}
helpgitsvn(){
cat <<'__envHEREDOC__'
Creates (new git repo) folder: trunk
$ git svn clone svn://svn/de/trunk/ -T proj/mvin -b proj-branches/mvin -t proj-tags/mvin
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
== Misc ==
$ ps L | sort -k2       # list format codes, sorted by rhs (rhs
                        # has many dupes, lhs has none)
== Examples ==
$ ps axfww              # exec str nfo, in tree form
$ ps -f -p PID...       # nfo for PID(s)
                        # nfo in user-defined formats
$ ps -p PID... -o pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:14,comm
$ ps -p PID... -o stat,euid,ruid,tty,tpgid,sess,pgrp,ppid,pid,pcpu,comm
$ ps -p PID... -o pid,tt,user,fname,tmout,f,wchan

__envHEREDOC__
}
helppatch(){
      cat <<'__envHEREDOC__'
= v1 =
# create patch: to apply changes going from 'INITIAL' -> to 'FINAL' content
diff -c START_FILE END_FILE > patch
diff -c INITIAL_FILE FINAL_FILE > patch
diff -c OLD_FILE NEW_FILE > patch
	diff -c bash_user_dev.env.production bash_user_dev.env > bash_user_dev.env.patch

# apply patch
patch --input=patch
	patch --input=bash_user_dev.env.patch
	patch --verbose --input web.xml.patch $TOMCAT_HOME/webapps/portal/WEB-INF/web.xml

= v2 (svn) =
(src: http://incubator.apache.org/jena/getting_involved/index.html)
# create patch
svn diff > JENA-XYZ.patch
# apply patch
patch -p0 < JENA-XYZ.patch
__envHEREDOC__
}
helpsed(){
cat <<'__envHEREDOC__'
== MISC ==
$ sed -n -e "<LINE NUMBER>p"        # print a specific line
$ sed -n -e "3p" -e "3p" /etc/hosts # print /etc/hosts:ln3, twice
$ sed 's/[ \t]*$//'         # trim trailing whitespace
$ sed '/^$/d'               # delete blank lines
$ echo /e/s/conf | sed "y/\//|/"    # transliterate src to dest
  `--> |e|s|conf

== SNIPPETS ==
COPY SYSTEM FILE (e.g. rsyslog) and rename by dotifying the original
files' full path (1: repeat path; 2: "/" -> "."; 3: remove leading "." (if E)):
$ echo /etc/sysconfig/rsyslog | \
>  sed   -e 1p   -e "s/\//./g"   -e "s/\//./g" | \  # <-- 1,2,3
>  xargs --verbose  cp --preserve --no-clobber --verbose
  `--> $ cp --no-clobber --preserve --verbose /etc/sysconfig/rsyslog etc.sysconfig.rsyslog
         `--> `/etc/sysconfig/rsyslog' -> `etc.sysconfig.rsyslog'

== FIND/REPLACE ==
PREVIEW find/replace on files:
 sed -n "s/192.168.8.3/bryn-pc/gp" file1 [fileN]
. . . ^. . . . . . . . . . . . ^
DO find/replace on files:
 sed -i "s/192.168.8.3/bryn-pc/g" file1 [fileN]
. . . ^
HELPFUL for changing all the [fileN]'s:
 grep -R --files-with-match PATTERN [PATH] | xargs --verbose -n 1 <sed STUFF>
__envHEREDOC__
}
helpaptitude(){
cat <<'__envHEREDOC__'
== PACKAGE DISPLAY NFOs ==
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

== NOTES FOR YOU, SLACKER ==
 remove       - Remove packages.
 purge        - Remove packages and their configuration files.
__envHEREDOC__
}
helpbash(){
cat <<'__envHEREDOC__'
== shopt ==
TODO STUB pretty cool... lots of options... should spend some time playing with this.

== typeset ==
-f [function name] : display [specific] function(s) and its defn
-F [function name] : display [specific] function(s)

== Misc ==
-n   : syntax check, e.g. `bash -n shell-script-file-to-be-syntax-checked.sh'
-x   : xtrace
-o option-name : enable option-name, e.g. `set -o xtrace'
+o option-name : disable option-name, e.g. `set +o xtrace'

== man-Page-Massiveness Shortcuts (GNU Bash-4.1) ==
* ~ln3050: section:: SHELL BUILTIN COMMANDS
* ~ln3900: buildin cmd:: set
* ~ln4400: end section:: SHELL BUILTIN COMMANDS
* ~ln
__envHEREDOC__
}
helpbashstrings(){
cat <<'__envHEREDOC__'
$ kv='database_hostname=asdf'
$ echo "${kv%%asdf}"
database_hostname=
$ echo "${kv##database_hostname=}"
asdf
__envHEREDOC__
}
helpsort(){
cat <<'__envHEREDOC__'
SORT A FILE OF FILE HASHES (md5sum output)
 sort -k 2 path/to/input-file > output-file
 sort -k2 path/to/input-file > output-file

SORT A SINGLE LINE
 echo "b t n h" | sort                              # invalid.
 echo "n y a n" | tr ' ' '\n' | sort                # get sorted characters, 1-per-line
 echo "n y a n" | tr ' ' '\n' | sort | xargs echo   # get sorted characters, SINGLE line
__envHEREDOC__
}
helpzip(){
cat <<'__envHEREDOC__'
STUB!!! THERES NOTHING HERE :(

zip -sf|--show-files archive.zip   # list or [S]how [F]iles ; === tar tfv archive.tar
zip -T|--test        archive.zip
__envHEREDOC__
}
helptcpdump(){
cat <<'__envHEREDOC__'
tcpdump  -A -i eth1 -q
__envHEREDOC__
}


##
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

vbeinfo         # nfo about display capabilities (for grub, that is)

== misc ==
set pager=1     # /really/ grub guys? this couldn't have been enabled by default?
__envHEREDOC__
}
helpaptitude2(){
cat <<'__envHEREDOC__'
SEARCH + SHOW PACKAGE(S) GIVEN A SEARCH STRING
aptitude search PACKAGE | awk '{ print $2 }' | xargs --verbose  aptitude show | less
__envHEREDOC__
}
helpionice(){
cat <<'__envHEREDOC__'
EXAMPLES
* nice ionice -c 3 svn up
** run svn with low priority (+10 (`nice -10') is default (+20 being lowest priority)) and as an idle io process.
* nice -12 ionice -c 3 svn up
* ionice -c 3 -p 89
** Sets process with PID 89 as an idle io process.
__envHEREDOC__
}
helpmvn(){
cat <<'__envHEREDOC__'
SKIP TESTS
* -Dmaven.test.skip=true
__envHEREDOC__
}
helprsnapshot(){
cat <<'__envHEREDOC__'
== STUB FIGURES OUT / DO ==
* shortcut to replace the most recent bu (hourly.0), with one taken right _meow_;;.... overwrite latest rsnapshot with current disk state;; useful when know have good curr disk state want to rsnap, and is OK to delete most recent rsnap.
__envHEREDOC__
}
help7zip(){
cat <<'__envHEREDOC__'
p7zip -d Tomato_1_28.7z      # decompress
p7zip file-to-be-compressed  # compress

# adds all files from "dir1" to archive.7z using 'ultra settings':
7za a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on  archive.7z  dir1
__envHEREDOC__
}
helpp7zip(){
	help7zip
}
helpcut(){
cat <<'__envHEREDOC__'
PRINT 2nd COLUMN and ALL REMAINING COLUMNS
	$ echo a,b,c,d | cut --delimiter=, --fields=1 --complement
	> b,c,d
__envHEREDOC__
}
helpIFS(){
cat <<'__envHEREDOC__'
$ # This IFS stuff allows to handle file names with spaces in them:
$ SAVEIFS=$IFS
$ IFS=$(echo -en "\n\b")
$ #
$ i=0 ; for f in $( find . -maxdepth 1 -type f ) ; do    echo "$i $f";    let i=$i+1;     done
$ # ... output from looping over echo...
$ #
$ IFS=$SAVEIFS
__envHEREDOC__
}
helpdropbox(){
cat <<'__envHEREDOC__'
INSTALL
The Dropbox daemon works fine on all 32-bit and 64-bit Linux servers. To install, run the following command in your Linux terminal.
32-bit:
cd ~ && wget -O - http://www.dropbox.com/download?plat=lnx.x86 | tar xzf -

64-bit:
cd ~ && wget -O - http://www.dropbox.com/download?plat=lnx.x86_64 | tar xzf -

Next, run the Dropbox daemon from the newly created .dropbox-dist folder.
~/.dropbox-dist/dropboxd
__envHEREDOC__
}
helpgrep(){
cat <<'__envHEREDOC__'
== Examples ==
* recursively find "dependency" pattern, while specifying a filename pattern:
 grep dependency $( find . -name pom.xml )
* edit pom.xml files that contain "opensocial" pattern:
 vim $( grep --files-with-matches opensocial $( find . -name pom.xml ) )

== Syntax ==

__envHEREDOC__
}
helpcurl(){
cat <<'__envHEREDOC__'
curl --data @<file-containing-POST-data> <URL>  # Perform POST request
curl --silent whatismyip.org | xargs echo   # display WAN ipaddr
__envHEREDOC__
}
helpgeditmultieditmode(){
cat <<'__envHEREDOC__'
* c-Shift-c         # beginmode
* c-e               # insert edit point
* c-Home            # insert edit point at beginning of line
* c-End             # insert edit point at end of line
* select text+Enter # column editing
* esc               # endmode
__envHEREDOC__
}
helpscp(){
cat <<'__envHEREDOC__'
* -l LIMIT # in kbits/s; 2000 ~= 250KiB/s
* -p       # preserve times
__envHEREDOC__
}
helphdd(){
cat <<'__envHEREDOC__'
== Lesser Known hdd-related cmds ==
hdparm : A utility for displaying and/or setting hard disk parameters,
       : for instance, to spin down hard drives, tweak performance.
sdparm : List or change SCSI/SATA disk parameters

== Partition-related ==
=== What kind of partition is it? ===
==== EXTENDED ('logical' in the stupid windows realm) ====
$ sudo tune2fs -l /dev/sdc2    # /dev/sdc2 is an extended partition
tune2fs 1.41.12 (17-May-2010)
tune2fs: Attempt to read block from filesystem resulted in short read while trying to open /dev/sdc2
Couldn't find valid filesystem superblock.

==== NOT-ext[234] ====
$ sudo tune2fs -l /dev/sdc5    # /dev/sdc5 is an ntfs partition
tune2fs 1.41.12 (17-May-2010)
tune2fs: Bad magic number in super-block while trying to open /dev/sdc5
Couldn't find valid filesystem superblock.

==== DNE ====
$ sudo tune2fs -l /dev/sdc3    # /dev/sdc3 there is no such device
tune2fs 1.41.12 (17-May-2010)
tune2fs: No such file or directory while trying to open /dev/sdc3
Couldn't find valid filesystem superblock.

=== What is the filesystem volume name (its label)? ===
$ ntfslabel <device>
$ tune2fs -l <device> | grep name
	$ tune2fs -l <device> | grep 'Filesystem volume name' | sed 's/Filesystem volume name://' | sed 's/^[ \t]*//'
	^^alternatively, COULD JUST LOOK HERE : /dev/disk/by-label

=== Get Nfo (intelduo machine) ===
==== which devices are seen? ====
$ ll /dev/disk/by-label/ | grep -P "mnt|Oa|Va"

==== what are block sizes? ====
$ cat /proc/partitions

==== misc ====
findfs {LABEL=label | UUID=uuid}               # identify device that matches query
blkid                                          # locate/print block device attributes like UUID and LABEL
sfdisk                                         # Partition table manipulator for Linux
__envHEREDOC__
}
helphdd2(){
cat <<'__envHEREDOC__'
parted                                         # manage partitions

mke2fs -L label -t ext4 [-v] [-c [-c]] device  # create ext4 filesystem
tune2fs -c 5 -i 5d device                      # check every MIN(5 mounts or 5d)
tune2fs -e remount-ro device                   # change errors behaviour

mkntfs [-v] --label label --quick device       # create ntfs filesystem

mkfs -t btrfs HELP STUB                        # create btrfs filesystem
__envHEREDOC__
}





helpdevices(){
cat <<'__envHEREDOC__'
== Device and Driver and Hardware-related commands ==
$ udevadm trigger --verbose --dry-run
$ modprobe --list
$ lsusb --verbose ; lspci, lscpu, etc.

# Find all mounted USB CD-ROM's
awk '$1 ~ /\/dev\/sr[0-9]+$/ { print $2 }' < /proc/mounts
__envHEREDOC__
}
helpchkconfig(){
cat <<'__envHEREDOC__'
== ubuntu-related ==
chkconfig /seems/ to be workable, but isn't exactly like rhel... when do --list, it generates the list of services directly from the files existing under /etc/init.d (with rhel, you explicitly --add  and  --del the list of registered OS services.

see also : insserve
other keywords : lsb upstart lsb-header
__envHEREDOC__
}
helprenice(){
cat <<'__envHEREDOC__'
$ sudo renice -2 23871     # increase scheduling favorability
23871: old priority 0, new priority -2
$ sudo renice 2 23871      # decrease scheduling favorability
23871: old priority -2, new priority 2
$ sudo renice 9 23871      # decrease scheduling favorability
23871: old priority 2, new priority 9
$ sudo renice 11 23871     # decrease scheduling favorability
23871: old priority 9, new priority 11
__envHEREDOC__
}
helppasswd(){
cat <<'__envHEREDOC__'
passwd -d USERNAME   # BAD!!! this allows *anyone* to become USERNAME (literally puts the empty string in /etc/shadow)
passwd -l USERNAME   # BETTER. this "locks" the account (this is what you want if you use ssh keys for authentication--puts "!!" or "!" in /etc/shadow)
__envHEREDOC__
}







#
# mergeconflictavoiddothismeow : here add from phisata ONLY
helpwHOA_wtf_cmd__u_blow_my_mind(){
cat <<'__envHEREDOC__'
List of cmds I just happen to randomly come across and make me say "WHOA! WTF!! :) cmd, u blow my mind..."
smbtar backup/restore a Windows PC directories to a local tape file
smbtar - shell script for backing up SMB/CIFS shares directly to UNIX tape drives
smbget - wget-like utility for download files over SMB

fuser - identify processes using files or sockets (similar to lsof)
   fuser -v -m /
__envHEREDOC__
}
helpfdupes(){
cat <<'__envHEREDOC__'
fdupes --recurse .                  # initial
fdupes --size --recurse .           # again, but show sizes
fdupes --size --delete --noprompt --recurse .   # delete!
__envHEREDOC__
}
helpunzip(){
cat <<'__envHEREDOC__'
unzip -d extractiondirectory zipfile
__envHEREDOC__
}




# mergeconflictavoiddothismeow : here add from phisata ONLY
#





#
# mergeconflictavoiddothismeow : here add from lap ONLY
helpmount(){
cat <<'__envHEREDOC__'
== Notice mount options used by default after plugging in an NTFS USB drive ==
Jan 31 21:02:52 laptop kernel: [86704.202069] sd 4:0:0:0: [sdc] Attached SCSI disk
Jan 31 21:02:53 laptop ntfs-3g[3689]: Version 2010.8.8 external FUSE 28
Jan 31 21:02:53 laptop ntfs-3g[3689]: Mounted /dev/sdc1 (Read-Write, label "a58-458", NTFS 3.1)
Jan 31 21:02:53 laptop ntfs-3g[3689]: Cmdline options: rw,nosuid,nodev,uhelper=udisks,uid=1000,gid=1000,dmask=0077,fmask=0177
Jan 31 21:02:53 laptop ntfs-3g[3689]: Mount options: rw,nosuid,nodev,uhelper=udisks,allow_other,nonempty,relatime,fsname=/dev/sdc1,blkdev,blksize=4096,default_permissions
== Mount NTFS volume with full user write permission ==
  sudo mkdir /media/mraid0a2244_ad/  &&  \
  sudo mount -v /dev/sdg1 /media/mraid0a2244_ad/ -t ntfs o rw,allow_other,blocksize=4096,default_permissions
__envHEREDOC__
}


# mergeconflictavoiddothismeow : here add from lap ONLY
#


_help6(){
cat <<'__envHEREDOC__'

__envHEREDOC__
}


## ### #### ###################################################################
##
## /help text functions
##
## ### #### ###################################################################

