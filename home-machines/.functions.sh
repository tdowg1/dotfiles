# .functions.sh

## ### #### ###################################################################
##
## misc. functions
##
## ### #### ###################################################################

# TODO STUB
#get that echoandexec method I wrote


findwildiname(){
	if [[ $# = 0 ]] ; then
		echo "findwildiname() [path] wildcarded_searchstring"
		return
	fi
	local path="."
	local name="$1"
	if [[ $# = 2 ]] ; then
		path="$1"
		name="$2"
	fi

	find "$path" -iname \*${name}\*
}


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
f_isip(){
	# TRUE  -> return 0 (If is an IP address)
	# FALSE -> ow
	local x="$1"

	# original src : http://www.linuxjournal.com/content/validating-ip-address-bash-script
	if [[ $x =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		OIFS=$IFS
		IFS='.'
		x=($x)
		IFS=$OIFS
		
		if [[ ${x[0]} -le 255 && ${x[1]} -le 255 \
				&& ${x[2]} -le 255 && ${x[3]} -le 255 ]] ; then
			return 0
		fi
	fi
	#echo "FALSE";
	return 1
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
grepdotfiles-original(){
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
greptxtfiles(){
	# SYNOPSYS greptxtfiles SINGLE-STRING-SEARCH-QUERY SEARCH-PATH
	# ENHANCEMENTS LIST
	#  asdf 
	#   
	#   
	#   
	#   
	local searchquery="$1"
	local searchpath="$2"
	echo "TODO STUB make me into a file so can sudo use ; implement greptxtfiles SINGLE-STRING-SEARCH-QUERY SEARCH-PATH"
	for i in $( find "$searchpath" -type f ) ; do
		file --brief  "$i"  | grep ASCII >/dev/null 2>&1
		
		if [[ $? = 0 ]] ; then
			grep --with-filename "$searchquery" "$i"
		fi
	done
}
grepdotfiles(){
	# SYNOPSYS grepdotfiles SINGLE-STRING-SEARCH-QUERY
	local searchquery="$1"
	local searchpath="$ZOMG_DOTFILES"
	#greptxtfiles SINGLE-STRING-SEARCH-QUERY SEARCH-PATH
	greptxtfiles "$searchquery" "$searchpath"
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
	# consider RENAME helpchecksumming, helpdigest, helphashdigest, etc
	cat <<'__envHEREDOC__'
CREATE1:: Filenames (from find)  may not be sorted! # cd $DIR
$ find . -type f -exec md5sum '{}' \; > md5sum.md5
$ # it may then be desirable to have hashes sorted by filename:
$ sort -k2 md5sum.md5  >  md5sum.md5.sorted

CREATE2:: Have hashes sorted by filename from the start # cd $DIR
$ find .  -type f | sort | xargs md5sum > md5sum.md5

CREATE3::
$ # cd $DIR
$ find GOTS -depth -type f -name '*.jar' -print0 | xargs -0 sha256sum >> /tmp/sha256sumGOTS.txt
$ find . -depth -path '*config/*' -type f -name '*.ttl' -print0 | xargs -0 sha256sum >> /tmp/sha256sumConfig.txt

CREATE4:: Handy when checking Linux distros that have CHECKSUM files
$ find . -name \*CHECKSUM -execdir sha256sum --check '{}' \;

VALIDATE:: (shows only failures) # cd $DIR
$ md5sum --check md5sum.md5 | grep ' FAILED'
__envHEREDOC__
}
#helpshasum(){
#	cat <<'__envHEREDOC__'
#__envHEREDOC__
#}
helpsynergy(){
	cat <<'__envHEREDOC__'
renice -14 $(ps -ef | grep /usr/bin/synergyc | grep -v grep | awk '{print $2}')
# ( ... see also (my custom): pssynergy)
__envHEREDOC__
}
helprsnapshotsnippets(){
	cat <<'__envHEREDOC__'
Handful of snippets dedicated to getting nfo about rsnapshots. (NOTE: most/all of these assume CWD is the rsnapshot_root)

EXECUTING CMDS OVER RSNAPSHOTS (most of these are designed st each rsnapshot directory appears in chronilogical order (oldest first)
# rsnapshot-diff:
$ prev=INITIAL; for i in $(ls -trd ./*) ; do if [ "$prev" = "INITIAL" ] ; then echo ; prev=$i; continue; fi; echo "prev[$prev];curr[$i]"; rsnapshot-diff $prev $i ; prev=$i; echo ; done
$ for i in `seq 7 -1 1` ; do sudo rsnapshot-diff hourly.${i}/magnificent.home/ hourly.$(( ${i} - 1))/magnificent.home/; done

# du:
$ d=$( for i in $( ls -trA ) ; do test -f "$i"  &&  continue ; echo $i; done | xargs echo  )
echo ; date --rfc-3339 seconds
sudo du -hs $d
echo ; date --rfc-3339 seconds
sudo du -hs --count-links $d
echo ; date --rfc-3339 seconds

[bdavies@magnificent r]$ for i in hourly.1/* ; do ib=$(basename $i) ; for j in ${i}/* ; do jb=$(basename $j); echo sudo rnapshot-diff hourly.1/$ib/$jb hourly.2/$ib/$jb; done; done
sudo rsnapshot-diff hourly.1/perm/home hourly.2/perm/home
sudo rsnapshot-diff hourly.1/perm/misc hourly.2/perm/misc
sudo rsnapshot-diff hourly.1/perm/opt hourly.2/perm/opt
sudo rsnapshot-diff hourly.1/ubu1010/etc hourly.2/ubu1010/etc
sudo rsnapshot-diff hourly.1/ubu1010/usr hourly.2/ubu1010/usr
sudo rsnapshot-diff hourly.1/ubu1010/var hourly.2/ubu1010/var

__envHEREDOC__
}
pssynergy(){
	#ps -ef | grep -i -P "[s]ynergyc|[s]ynergys"
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
	cat <<'__envHEREDOC__'
   svn propset svn:ignore 'instance-management.i*' .
	find /opt/svn-wc/EIW-Middleware/ -type f -name *.sh -exec svn propset svn:executable "true"  '{}' \;
__envHEREDOC__
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
for i in $devicelist ; do   sudo smartctl --test=offline /dev/sd${i};  done; sleep 300m; 

   # REALLY STUPID SNIPPET
	# dd overwrite self with self, all smart tests x2, dd again, all smart tests (x1)
DEVICE=/dev/sdb   # e.g.
sudo dd if=${DEVICE} of=${DEVICE} bs=4096 conv=notrunc,noerror  ;  date ; sleep 15m ; sudo smartctl ${DEVICE} --test=short ; sleep 5m ; sudo smartctl ${DEVICE} --test=conveyance ; sleep 5m ; sudo smartctl ${DEVICE} --test=long ; sleep 250m ; sudo smartctl ${DEVICE} --test=offline ; echo "sleep 7h or 25200s" ; date ; sleep 5h ;             sudo smartctl ${DEVICE} --test=short ; sleep 5m ; sudo smartctl ${DEVICE} --test=conveyance ; sleep 5m ; sudo smartctl ${DEVICE} --test=long ; sleep 250m ; sudo smartctl ${DEVICE} --test=offline ; echo "sleep 7h or 25200s" ; sleep 7h ;               date ; sudo dd if=${DEVICE} of=${DEVICE} bs=4096 conv=noerror ;               sudo smartctl ${DEVICE} --test=short ; sleep 5m ; sudo smartctl ${DEVICE} --test=conveyance ; sleep 5m ; sudo smartctl ${DEVICE} --test=long ; sleep 250m ; sudo smartctl ${DEVICE} --test=offline ; echo "sleep 7h or 25200s" ; date ; sleep 7h

   # REALLY STUPID SNIPPET2
sudo smartctl --test conveyance /dev/sda  && echo 'conveyance OKkKKKKKKKKKK' ; sleep 10m  ;  sudo smartctl --test short /dev/sda  && echo 'short OKkKKKKKKKKKK' ; sleep 10m   ;  sudo smartctl --test long /dev/sda  && echo 'long OKkkkkkkkkkkkKK'   ;   sleep 110m

== See also ==
smart-notifierdbus service and graphical disk health notifier
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
rewrite entire disk (with itself)
   dd if=/dev/sdc of=/dev/sdc bs=4096 conv=noerror

EXAMPLES hdd-REMAPPING ----------------------
WRITE-remap block sector (seemed to have good luck w this)"
   dd if=/dev/zero of=/dev/sdd count=1 seek=<decimal LBA block> oflag=direct conv=notrunc
WRITE-rewrite entire disk.1-trying this on a disk that has 1000+ bad sectors... im not going to remap all those _manually_ so, lets see what this will do (fyi: the disk is iA18)
   dd if=/dev/sdk of=/dev/sdk bs=4096 [oflag=direct] conv=notrunc,noerror   # I
	                # would reconsider the oflag usage of "direct"... this will
						 # make execution extremely slow... slow like ~5MiB/s for
						 # typical magnetic disk (1TB hdd, in fact).
WRITE-rewrite entire disk.2-dcfldd
$ dcfldd if=/dev/sda of=/dev/sda bs=4096 conv=notrunc,noerror  status=on sizeprobe=if
WRITE-rewrite entire disk.3-dc3dd
$ 
ALTERNATIVELY.1-smartctl offline testing should remap bad sectors, if supported
   smartctl --test offline /dev/sda
ALTERNATIVELY.2-if offline testing not supported, check out hdrecover


$ dd if=/dev/zero of=/dev/X count=1 seek=<LBA of err> conv=notrunc,noerror oflag=direct


MISC ----
MONITORING progress
   dd ... & pid=$! ; watch kill -USR1 $pid
   while [ 1 ] ; do kill -USR1 $pid ; sleep 5 ; done
	HELP!  if I obtain the pid, and then go to another terminal
	 in order to minitor progress, i always seem to end up killing
	 --actually--killing-- the dd process... what gives?!
	  ok ok.. it turns out that when you use sudo, the pid printed
	  out is not the one you should be -USR1 signaling.  I *think* 
	  thats the actual sudo process (?) and NOT the actual dd 
	  process id... which is the pid you need to signal.
LBA approximations (assumes 512-byte block size (bs) ; uses iA18 as subject disk)
   iA18 is 698GiB;
   slightly more than 12876374016 bytes (~13GB) were written before completing
   arg given to skip=1440000000
   *therefore*, 'LBA' 1440000000 is approx at the 686GiB location of the hdd.
Dump System memory to a file
   dd if=/dev/mem of=/root/system-memory.dump
Duplicate one hard disk partition to another hard disk partition
   dd if=/dev/sda2 of=/dev/sdb2 bs=4096 conv=notrunc,noerror
Dump typical MBR location in hex ; first 512-bytes of device
   dd if=/dev/sda bs=512 count=1 | hexdump -C
Backup device
   dd if=/dev/sda6 bs=4096 conv=notrunc,noerror | gzip > rsnapshot.dd.gz
TODO STUB-- howtodo^^but send thru tar instead (-z)? is a difference?
__envHEREDOC__
}
helpdd2(){
      cat <<'__envHEREDOC__'
== See Also ==
* hdrecover.sf.net

* ddrescue tries hard to rescue data in case of read errors. (Similarly, gddrescue)

* safecopy is a data recovery tool which tries to extract as much data as possible from a problematic (i.e. damaged sectors) source - like floppy drives, harddisk partitions, CDs, tape devices, ..., where other tools like dd would fail doe to I/O errors.

* ??? ddclac 	?? 

* dcfldd based on the dd program but with additional features...
** (hashing) Hashing on-the-fly - dcfldd can hash the input data as it is being transferred, helping to ensure data integrity.
** (eta status) Status output - dcfldd can update the user of its progress in terms of the amount of data transferred and how much longer operation will take.
** (pattern writing) Flexible disk wipes - dcfldd can be used to wipe disks quickly and with a known pattern if desired.
** (integrity verif) Image/wipe Verify - dcfldd can verify that a target drive is a bit-for-bit match of the specified input file or pattern.
** Multiple outputs - dcfldd can output to multiple files or disks at the same time.
** (split output) Split output - dcfldd can split output to multiple files with more configuration possibilities than the split command.
** (logging) Piped output and logs - dcfldd can send all its log data and output to commands as well as files.

* dc3dd inspired by the dcfldd, also based on dd, with addl. features...
** (pattern writing) Pattern writes. The program can write a single hexadecimal value or a text string to the output device for wiping purposes.
** (hashing) Piecewise and overall hashing with multiple algorithms and variable size windows. Supports MD5, SHA-1, SHA-256, and SHA-512. Hashes can be computed before or after conversions are made.
** (eta status) Progress meter with automatic input/output file size probing
** (logging) Combined log for hashes and errors
** Error grouping. Produces one error message for identical sequential errors
** (integrity verif) Verify mode. Able to repeat any transformations done to the input file and compare it to an output.
** (split output) Ability to split the output into chunks with numerical or alphabetic extensions
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
$ date  --rfc-3339 seconds          # GIVE ME FREAKING ISO-FORMATTED DATE
$ date  --reference=file-to-reference
TIMEZONES
$ export TZ=Europe/Stockholm; echo "Stockholm:    `date +\"%F %R (%Z)\"`"
# `--> Stockholm:    2012-05-18 20:31 (CEST)
$ export TZ=US/Central; echo "Dallas:             `date +\"%F %R (%Z)\"`"
# `--> Dallas:       2012-05-18 13:32 (CDT)

CONVERT a given locale-->to the current (iow: convert a diff-TZ into curr-TZ):
$ date --date="2012-05-24 18:08:56 UTC"   # current locale is EDT
# `--> Thu May 24 14:08:56 EDT 2012
CONVERT between locale's:
$ export TZ=Asia/Kolkata; echo "Jaisalmer, India: `date --date="2012-05-24 18:08:56 UTC"`"
# `--> Jaisalmer, India: Thu May 24 23:38:56 IST 2012

SEE ALSO
$ xclock -digital  -strftime "%Y-%m-%d %H-%M-%S" -update 1 -twentyfour
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
== ANOTHER ATTEMPT AT THE QUESTION 'use slash || not?' ==
COPY FOLDER
	rsync -av /opt/muzik /mnt/rsnapshot/
COPY FOLDER's CONTENTS
	rsync -av /opt/muzik/ /mnt/rsnapshot/
__envHEREDOC__
}
helprsyncexamples(){
cat <<'__envHEREDOC__'
Misc:
	--stats  --human-readable --progress
Opts to capture *as much as possible* (acls, hard, xatt,...):
	rsync --archive --xattrs --acls --hard-links --progress --compress    \
		/home/mydir/data/ /backups/data-20080810/
Data Integrity, at expense of: time increase, i/o increase:
	--checksum
Data Integrity:
	--inplace --ignore-times
BU an rsnapshot root/repo (hard links):
	rsync -a --hard-links --delete /mnt/rsnapshot/ /mnt/rsnapshot_bu1/
Opts to specify OpenSSH, login:
	rsync -av -e "ssh -i ~/.ssh/aaliyah.id_rsa -l aaliyah" hostname:/host/path/ /local/path/ 
	rsync -av  -e "ssh -l ssh-user-phife-dawg"  ali.shaheed.muhammad@brooklyn:. /tmp
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
rename 's/REGEX/REPLACE/' files
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
$ rpm -ihv --nodeps rpmfile # forces an rpm installation (I think)
$ rpm -qa *PACKAGE_NAME*    # search installed rpm packages for PACKAGE_NAME
$ rpm -qa --last            # gives packge & date modified
$ rpm -qip rpmfile          # display details for the rpm file rpmfile

--filesbypkg                # list all the files in package 
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
* tab/un-tab??? (witnessed in a shell script that was indented once, and was within if-stmt)
** (insert mode)
** un-tabs curr line: c-d
** tabs curr line: c-f

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
* insert timestamp: !!date                  bit.ly/I0xzvq
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
   -mt<number of threads>
	-y  # assume Yes on all queries

ARCHIVE
* ep1           Exclude base dir from names. Do not store the path entered in 
                   the cmdln. e.g.
						 rar a -ep1 -r test tmp\*
						   is === to
					    cd tmp ; rar a -r ..\test ; cd ..
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
* tk            Keep original archive time
* tl            Set archive time to latest file
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
perhaps want to archive all folders in cwd (and files too if exist in cwd) that begin with 2011 and 2012... (i.e. ff-snapshots):
   for i in 201[12]* ; do sudo rar a -m5 -r -rr4p -t -tsmca "${i}.rar" "${i}" ; done
__envHEREDOC__
}
helprar2(){
   cat <<'__envHEREDOC__'
xxxADD ARCHIVE COMMENT (these are INVALID)
   rar c rarchive "my comment oh hai111111"
   rar c rarchive "i could envision this being a little bit useful, in that you can store the cmdln options that were originally specified to create archive"

xxxMODIFY ARCHIVE1
   By removing 1 or more top level / leading directories (and moving its contents up 1
	level /prior/ to removal).
	1. use rename operation (works with files and directories):
	  rar rn <arcname> <srcname1> <destname1> ... <srcnameN> <destnameN>
	  rar rn -m5 -rr4p -t -tsmca [-tk] rarchive FROM TO

	2. re-archive ; can use extraction option to remove leading director(y|ies)
	
	3. re-archive ; can use archive option to strip leading director(y|ies)
     rar a -ep1

xxxADD/MODIFY ARCHIVE2
   By setting the path inside archive
	  rar a -apDOCS\ENG release.rar readme.txt   # add readme.txt to the directory 'DOCS\ENG'.
     rar x -apDOCS release DOCS\ENG\*.*         # extract 'ENG' to the current directory.

EXTRACT
   -kb keep broken extracted files
	-ad append archive name to destination path
   rar x archive.rar

TEST EXAMPLE0 (base case)
   rar t [v[t|b]] [-pPASSWD] archive.rar
TEST EXAMPLE1 (N+1)
(sudo access was reqd in example environment)
   for i in *.rar ; do echo $i; sudo su -c "time rar t $i > $i.test.log" ; echo ; echo ; done
TEST EXAMPLE2 (N+2) with auto-repair exec upon test failure
(sudo access was reqd in example environment)
   for i in *.rar ; do echo $i; sudo su -c "time rar t $i > $i.test.log"; rc=$? ; if [[ $rc != 0 ]] ; then echo "WARNING rc[$rc] was non-zero for rar test. calling rar repair."; sudo su -c "time rar r -y $i > $i.repair.log"; rc=$?; if [[ $rc != 0 ]] ; then  echo "ERROR rc[$rc] was non-zero for rar repair <exclamation>"; fi; fi; echo; done

REPAIR EXAMPLE0 (base case)
   rar r -y archive.rar                         # the -y(es) is important!
REPAIR EXAMPLE1 (N+1)

UPDATE EXAMPLE0 (base case)
add file to specific location within a pre-existing archive (keep orig archive time (alt. -tl : set time to latest file)).
must specify archive creation options... it doesnt seem to persist the original archive's properties--if you just add a file, for example, and it previously had a recovery record set--its lost--and the only way to get a recovery record generated for the final updated rarchive, you must define it.
   rar u   [-ap<PATH INSIDE ARCHIVE TO USE>]   -m5 -rr4p -t -tsmca   -tk   archive.rar   file1[ file2[...]]
UPDATE EXAMPLE1 (N+1)
   rar u   -ap.   -m5 -rr4p -t -tsmca   -tk   2011-09-08_23.18.01.rar   2011-09-08_23.18.01.NOTE.txt
UPDATE EXAMPLE2 (N+2)
??? do you have to say "-ep1" too in this case???? to avoid having "ARCHIVES-TESTED-FAILED/rearchived/" folders created within the archive?? that I just want to add a single stupid file to?
   rar u   -ap.   -m5 -rr4p -t -tsmca   -tk   ARCHIVES-TESTED-FAILED/rearchived/2011-09-08_23.18.01.rar   2011-09-08_23.18.01.NOTE.txt
UPDATE EXAMPLE3 (N+3)
   rar u   -apmnt/intelduo-s/tmp/rearchive/2011-09-08_23.18.01/   -m5 -rr4p -t -tsmca   -tk   rearchived/2011-09-08_23.18.01.rar  ../2011-09-08_23.18.01.NOTE.txt
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

AGENTs
$ exec ssh-agent bash
$ env | grep ^SSH           # Ensure SSH_AUTH_SOCK defined?
$ ssh-add ~/.ssh/some-key   # If so, then can add keys!
__envHEREDOC__
}
helpuseradd(){
	cat <<'__envHEREDOC__'
sudo useradd --home=/home/<username> --create-home --password=<passwd>  <username>
	NOTE value for SHELL in /etc/default/useradd
__envHEREDOC__
}
helpnetwork(){
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
nslookup ip-address               # get hostname from ip address

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
* Create a branch based on an upstream branch:
** git branch --track my_branch origin/my_branch
* Delete remote branch
** git push origin :my_branch
== branching example (create new branch, push upstream and track) ==
$ newBranchName=Environment--DEMO
newBranchName=environment--
git co -b  "${newBranchName}" \
 && git push origin  "${newBranchName}" \
 && git branch --set-upstream  "${newBranchName}"  origin/"${newBranchName}"
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
* http://austinmatzko.com/2008/04/26/sed-multi-line-search-and-replace/
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
$ sed -n "s/192.168.8.3/bryn-pc/gp" file1 [fileN]
. . . ^. . . . . . . . . . . . ^
DO find/replace on files:
$ sed -i "s/192.168.8.3/bryn-pc/g" file1 [fileN]
. . . ^
HELPFUL for changing all the [fileN]'s:
$ grep -R --files-with-match PATTERN [PATH] | xargs --verbose -n 1 <sed STUFF>
PREVIEW:
$ sed -n "s/frommmmmm/tooooooo/gp" $( grep --files-with-match frommmmmm $( find PATH -type f ) )
DO:
$ sed -i "s/frommmmmm/tooooooo/g" $( grep --files-with-match frommmmmm $( find PATH -type f ) )
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

== NOTES FOR YOU, SLACKER == http://www.cyberciti.biz/ref/apt-dpkg-ref.html
 remove        - Remove packages.
 purge         - Remove packages and their configuration files.
 search ~ahold - Show held packages

== Determine which package provides a file ==
$ dpkg --search /etc/bash_completion
bash-completion: /etc/bash_completion
$ dpkg --search `which gethostip`
syslinux: /usr/bin/gethostip

== Misc. Snippets ==
$ aptitude search .*-desktop
$ dpkg -i --force-all debfile   # forces an installation (I think)
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
-n   : Syntax Check, e.g. `bash -n shell-script-file-to-be-syntax-checked.sh'
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
# Assuming the following variable is set...:
$ kv='database_hostname=The-Hive-RRRROLOLOLOOOL'

# ...this will be the output:
#      (for more nfo::`man bash'-->'Parameter Expansion')
$ echo "${kv%%The-Hive-RRRROLOLOLOOOL}"   # get the LHS of the string, get the key
database_hostname=
$ echo "${kv##database_hostname=}"        # get the RHS of the string, get the value
The-Hive-RRRROLOLOLOOOL
$ echo ${#kv}       # ->41                # get the string length
$ echo ${kv:0: $(( ${#kv} - 1 )) }        # remove 1 char from the end
database_hostname=The-Hive-RRRROLOLOLOOO
$ echo ${kv::-1}                          # remove 1 char from the end
database_hostname=The-Hive-RRRROLOLOLOOO
$ echo ${kv:1}                            # remove 1 char from the beginning
atabase_hostname=The-Hive-RRRROLOLOLOOOL
$ echo ${kv:1: $(( ${#kv} - 1 )) }        # remove 1 char from the beginning
atabase_hostname=The-Hive-RRRROLOLOLOOOL
$ echo ${kv:1: ${#kv} }                   # remove 1 char from the beginning
atabase_hostname=The-Hive-RRRROLOLOLOOOL
__envHEREDOC__
}
helpbashcheats(){
cat <<'__envHEREDOC__'
''src : Parted Magic 2012_05_14 / file:///usr/share/doc/bash_cheats.txt with modifications and personal contribs''

Control Key combinations (CTRL+KEY)
   Ctrl + a : jump to the start of the line
   Ctrl + b : move back a char
   Ctrl + c : terminate the command
   Ctrl + d : delete from under the cursor
   Ctrl + e : jump to the end of the line
   Ctrl + f : move forward a char
   Ctrl + k : delete to EOL
   Ctrl + l : clear the screen
   Ctrl + r : search the history backwards
   Ctrl + R : search the history backwards with multi-occurrence
   Ctrl + u : delete backward from cursor
   Ctrl + w : delete backward a word
   Ctrl + xx : move between EOL and current cursor position
	Ctrl + y : undo just deleted string (inserts most recently deleted string (e.g. alt+backspace or something) at curr cursor position
   Ctrl + z : suspend/stop the command

Alt Key combinations (ALT+KEY)
   Alt + < : move to the first line in the history
   Alt + > : move to the last line in the history
   Alt + ? : show current completion list
   Alt + * : insert all possible completions
   Alt + / : attempt to complete filename
   Alt + . : yank last argument to previous command
   Alt + b : move backward
   Alt + c : capitalize the word
   Alt + d : delete word
   Alt + f : move forward
   Alt + l : make word lowercase
   Alt + n : search the history forwards non-incremental
   Alt + p : search the history backwards non-incremental
   Alt + r : recall command
   Alt + t : move words around
   Alt + u : make word uppercase
   Alt + Backspace : delete backward from cursor

Escape Key combinations (ESC+KEY)
   Esc + d : delete from cursor position to end of the word
   Esc + f : move forward a word
   Esc + b : move backward a word
   Esc + t : transpose two adjacent words

------------------------------------------------
http://cheat.errtheblog.com/s/bash
http://www.shell-tips.com
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

(ubu1204)
Reinstall of grub + RECHECK
	sudo grub-install --no-floppy --recheck /dev/sda
	sudo update-grub

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
== SKIP TESTS ==
* -Dmaven.test.skip=true

== Out of memory PermGen error ==
(maven seems to pull in this maven opts. variable definition and *applies
it to its executing shell environment*!!! ugh, so prepend garbage
text "asdf_maven_pulls_this_in_smh_" to the variable that should /really/
be used--so that it does not get pulled in during my own mvn executions)
asdf_maven_pulls_this_in_smh_MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=128m"
__envHEREDOC__
}
helprsnapshot(){
cat <<'__envHEREDOC__'
# Syntax Check rsnapshot.conf
rsnapshot configtest

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
== INSTALL ==
The Dropbox daemon works fine on all 32-bit and 64-bit Linux servers. To install, run the following command in your Linux terminal.
32-bit:
cd ~ && wget -O - http://www.dropbox.com/download?plat=lnx.x86 | tar xzf -

64-bit:
cd ~ && wget -O - http://www.dropbox.com/download?plat=lnx.x86_64 | tar xzf -

Next, run the Dropbox daemon from the newly created .dropbox-dist folder.
~/.dropbox-dist/dropboxd

== CMDLN ==
$ while true ; do dropbox status | xargs echo `date` ; sleep 4s ; done
__envHEREDOC__
}
helpgrep(){
cat <<'__envHEREDOC__'
== bash: /bin/grep: Argument list too long ==
# I wanted to grep through a pretty good count of files. However, grep 
# had other plans, apparently.  Here's the original:
$ grep --null-data --files-with-match "lolwut" $( find . -type f ! -executable -print0 )
# ...which will fail if `find` gives a lot of results. Here's an alternative:
$ find . -type f ! -executable -print0 | xargs -0 grep --null-data --files-with-match "lolwut" 

== Examples ==
# Find files that contain "dependency" pattern, while specifying a filename pattern:
$ grep dependency $( find . -name pom.xml )
# Edit pom.xml files that contain "opensocial" pattern:
$ vim $( grep --files-with-matches opensocial $( find . -name pom.xml ) )
# Find files that contain an IP address:
$ grep -P '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$' $( find . -type f )
# Find (potentially *many*) files that are less than 10M, for case-insensitive
# search of "lolumad" (useful for targeting text files):
$ find . -type f -size -10M  -print0 | xargs -0 grep --null-data --files-with-match -i "lolumad"

== Syntax ==
$ ll /dev/disk/by-label/ | grep -P "mnt|Oa|Va"  # grep with regex
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
 `--> can be used to benchmark *AN UNMOUNTED* device : hdparm -t /dev/md0
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
findfs {LABEL=label | UUID=uuid}   # identify device that matches query
blkid                              # locate/print block device attributes like UUID and LABEL
lsblk                              # **list block devices
cfdisk                             # display or manipulate disk partition table
sfdisk                             # partition table manipulator for Linux
blockdev                           # call block device ioctls from the command line
dmsetup                            # low level logical volume management
fsfreeze                           # suspend access to a filesystem (Linux Ext3/4, 
                                   # ReiserFS, JFS, XFS) (intended for hw RAID devices)
di                                 # disk information util, displays more than df
disktype                           # detect && display nfo about FS's, partition's and tables,...
hdparm - tune hard disk parameters for high performance.  Get/set device parameters for Linux SATA/IDE drives. Primary use is for enabling irq-unmasking and IDE multiplemode.
sdparm - List or change SCSI/SATA/ATAPI/CD/DVD disk parameters
gpart  - Guess PC disk partition table, find lost partitions. Gpart is a tool which tries to guess the primary partition table of a PC-type disk in case the primary partition table in sector 0 is damaged, incorrect or deleted.  It is also good at finding and listing the types, locations, and sizes of inadvertently-deleted partitions, both primary and logical. It gives you the information you need to manually re-create them (using fdisk, cfdisk, sfdisk, etc.).  The guessed table can also be written to a file or (if you firmly believe the guessed table is entirely correct) directly to a disk device.
__envHEREDOC__
}
helphdd2(){
cat <<'__envHEREDOC__'
parted                             # manage partitions

mke2fs -L label -t ext4 [-v] [-c [-c]] device  # create ext4 filesystem
tune2fs -c 5 -i 5d device                      # check every MIN(5 mounts or 5d)
tune2fs -e remount-ro device                   # change errors behaviour

mkntfs [-v] --label label --quick device       # create ntfs filesystem

mkfs -t btrfs HELP STUB            # create btrfs filesystem
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
== Ubuntu-related ==
----
chkconfig /seems/ to be workable, but isn't exactly like rhel (also, I think its just a convenience program... and probably shouldnt really be used--USE the deb shtuff instead!)... when do --list, it generates the list of services directly from the files existing under /etc/init.d (with rhel, you explicitly --add  and  --del the list of registered OS services.

see also : insserve update-rc.d
other keywords : lsb upstart lsb-header

see also2 : 
* REFUSED(buggy or obsolete) rcconf(must also manually install 'dialog') - displays a menu of all the services which could be started at boot
* sysv-rc-conf(or ksysv for KDE)
* sysvconfig

==== upstart commands ====
initctl - can use in place of "service" with the commands bellow. Run initctl help. 
start - start a service
stop - stop a service
reload - sends a SIGHUP signal to running process
restart - restarts a service without reloading its job config file
status - requests status of service 


== See also ==
* https://help.ubuntu.com/community/UbuntuBootupHowto
__envHEREDOC__
}
helprenice(){
cat <<'__envHEREDOC__'
$ sudo renice -2 23871     # increase scheduling favorability
   `--> 23871: old priority 0, new priority -2
$ sudo renice 2 23871      # decrease scheduling favorability
   `--> 23871: old priority -2, new priority 2
$ sudo renice 9 23871      # decrease scheduling favorability
   `--> 23871: old priority 2, new priority 9
$ sudo renice 11 23871     # decrease scheduling favorability
   `--> 23871: old priority 9, new priority 11

== See also ==
* getprocesspriority() slowdown() unslowdown() helpsudo()
__envHEREDOC__
#$ sudo su -c "source /home/bdavies/dotfiles/home-machines/.functions.sh ; 
#i.e.
## sudo su -c "source /home/bdavies/dotfiles/home-machines/.functions.sh ; slowdown 808"
cat <<'__envHEREDOC__'
sudo su -c "source $ZOMG_DOTFILES/.functions.sh ; <insert name of function to call>
i.e.
sudo su -c "source $ZOMG_DOTFILES/.functions.sh ; slowdown 808"
__envHEREDOC__
}
helppasswd(){
cat <<'__envHEREDOC__'
passwd -d USERNAME   # BAD!!! this allows *anyone* to become USERNAME (literally puts the empty string in /etc/shadow)
passwd -l USERNAME   # BETTER. this "locks" the account (this is what you want if you use ssh keys for authentication--puts "!!" or "!" in /etc/shadow)
__envHEREDOC__
}
helpmail(){
cat <<'__envHEREDOC__'
# Send an email message to Guru (using the mailx package):
$ echo 'message body... oh hai11111111 on:' `date --rfc-3339=ns` `who -m`  |  mail -s "message subject from `who -m | cut -d"(" -f2 | cut -d")" -f1`"  guru@rip.com

#^^TODO STUB uhuhg this doesn't look right on the reciever's side... fixup the stdout string crap thats going on here
__envHEREDOC__
}
helpshred(){
cat <<'__envHEREDOC__'
shred [--interations=3] --remove --verbose --zero  file
__envHEREDOC__
}
helpjava(){
cat <<'__envHEREDOC__'
bsh - Java scripting environment (BeanShell) Version 2
__envHEREDOC__
}
helpenv(){
cat <<'__envHEREDOC__'
/calling helpgetconf()/
__envHEREDOC__
	helpgetconf
}
helpgetconf(){
cat <<'__envHEREDOC__'
getconf (1)          - Query system configuration variables
env (1)              - run a program in a modified environment

== See also ==
$ apropos getconf env   # gives a bunch of interesting env, variable, etc. programs
__envHEREDOC__
}
helpnotify-send(){
	# helpnotify-send alert gnome popup pop up message
cat <<'__envHEREDOC__'
notify-send (1)      - a program to send desktop notifications
notify-send [OPTION...] <SUMMARY> [BODY] - create a notification
__envHEREDOC__
}






_help6(){
cat <<'__envHEREDOC__'

__envHEREDOC__
}







#
# mergeconflictavoiddothismeow : here add from phisata ONLY
helpwHOA_wtf_cmd__u_blow_my_mind(){
	# whoa
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
helptar(){
cat <<'__envHEREDOC__'
$ tar zcfW a.tar.gz  a/    # -W attempt to verify the archive after writing it
# Exclude the file "snoop-lion" and/or anything within "snoop-lion" directory:
$ tar zcfv a.tar.gz  /home/calvin-broadus/  --exclude=/home/calvin-broadus/snoop-lion
__envHEREDOC__
}
helparchive(){
cat <<'__envHEREDOC__'
HELP     helptar helpgunzip helprar help7zip helpzip helpunzip helparchivesnippets
SEE ALSO dtrx
__envHEREDOC__
}
helpgunzip(){
cat <<'__envHEREDOC__'
gunzip --stdout 2012-05-17.gz > some-file
__envHEREDOC__
}
helparchivesnippets(){
cat <<'__envHEREDOC__'
CONVERT ZIP ARCHIVES TO RAR
Convert stupid zip files with their stupid 4GB limit with their getting usable as backups to do with their... erm... JUST 	kill yourself, zip archives!!!  TWICE!
$ cd <directory containing stupid 4GB-limit-reachy-fied zip files>
$ destdir=/mnt/intelduo-s/tmp/rearchive    # use my fast sas'ies
$ for izip in *.zip ; do echo $izip; i="${izip%.zip}" ; sudo unzip -d "${destdir}/${i}" "$izip"  ;  sudo rardefault.sh "${destdir}/${i}"  ;  echo ; done

CONVERT TARBALLED ARCHIVES TO RAR
$ cd <directory containing tarballs>
$ destdir=/mnt/intelduo-s/tmp/rearchive
$ # '--strip-components=1' says to strip the one (1) leading component (the top-level directory, for instance) off the file names of all extracted content.  So, in this snippet, a directory is created keyed off the source archive.  Contents of the archive are extracted into said directory, with each filename of the extracted contents having its leading directory removed.
$ for curr in *.tar.gz ; do echo $curr; i="${curr%.tar.gz}" ; mkdir "$i" ; cd "$i" ; tar -z -x --strip-components=1 -f "../$curr" ;  cd - ; rar a -m5 -r -rr4p -t -tsmca "${i}.rar"  "${i}"  ;       echo ; done
__envHEREDOC__
}
helpcatfish(){
cat <<'__envHEREDOC__'
A handy file search tool using different backends which is configurable via the command line.
__envHEREDOC__
}
helplocate(){
cat <<'__envHEREDOC__'
== OPTIONS ==
--existing

== EXAMPLES ==
$ locate --limit 2 --database /var/lib/mlocate/mlocate-all.db  -r  the/blah/blah/dir/file.txt.[123]
$ for i in `locate --limit 2 --database /var/lib/mlocate/mlocate-all.db  -r  the/blah/blah/dir/file.txt.[123]` ; do   echo rm $i blah; done 
$ for i in `locate -r /mnt/rsnapshot/.*/Downloads/NVIDIA-Linux-x86_64-295.33.run` ; do   echo rm $i blah; done
$ locate -r home.*aesop-rock.*bash_history
__envHEREDOC__
}
helpapplekeyboard(){
cat <<'__envHEREDOC__'
== F1-F12 KEYS VIA F{1-12} (typical keyboard behaviour) ==
# alias: keyboardBeNormal
$ sudo su -c "echo '2' > /sys/module/hid_apple/parameters/fnmode"

== F1-F12 KEYS VIA fn+F{1-12} (Apple keyboard default) ==
# alias: keyboardBeFruity
$ sudo su -c "echo '1' > /sys/module/hid_apple/parameters/fnmode"

== Swapping (LHS) Alt with Win keys ==
from /usr/share/X11/xkb/rules/xorg.lst ...
	altwin:swap_lalt_lwin Left Alt is swapped with Left Win
... and to have this applied automatically, add ...
	setxkbmap -option   altwin:swap_lalt_lwin
... to ...
	~/.xinitrc
... for user-specific configuration. For system-wide configuration, probably
need to edit some file within ...
	/etc/X11/Default
__envHEREDOC__
}






_help6(){
cat <<'__envHEREDOC__'

__envHEREDOC__
}

# mergeconflictavoiddothismeow : here add from phisata ONLY
#





#
# mergeconflictavoiddothismeow : here add from lap ONLY
helpmount(){
cat <<'__envHEREDOC__'
== sshfs /etc/fstab ==
sshfs#t@phisata:/mnt/a14-h/h/  /mnt/phisata   fuse  user,allow_other,nonempty,follow_symlinks,noauto   0 0
sshfs#b@demoportal:/usr/local/tomcat/  /home/b/mnt/demoportal  fuse  user,allow_other,nonempty,follow_symlinks,noauto   0 0
==== sshfs use pre-requirements ====
* need package
$ <package manager> install sshfs
* if want to mount without root priviledges, add user to fuse group
$ sudo usermod --groups fuse --append USER
* set 'user_allow_other' in /etc/fuse.conf
* mount resource by specifying the absolute path. e.g.
$ sshfs phisata:/mnt/a14-h/h/ /home/teelah/rsnapshot-ignore/phisata/ -o allow_other -o follow_symlinks
* unmount the resource using:
$ fusermount -u $absolute_path

== ext4 default mount opts ==
Jun  7 21:07:26 intelduo ntfs-3g[15480]: Cmdline options: rw,nosuid,nodev,uhelper=udisks,uid=1000,gid=1000,dmask=0077,fmask=0177
Jun  7 21:07:26 intelduo ntfs-3g[15480]: Mount options: rw,nosuid,nodev,uhelper=udisks,allow_other,nonempty,relatime,default_permissions,fsname=/dev/sdg3,blkdev,blksize=4096

== NTFS default mount opts ==
~~Jan 31 21:02:52 laptop kernel: [86704.202069] sd 4:0:0:0: [sdc] Attached SCSI disk
~~Jan 31 21:02:53 laptop ntfs-3g[3689]: Version 2010.8.8 external FUSE 28
~~Jan 31 21:02:53 laptop ntfs-3g[3689]: Mounted /dev/sdc1 (Read-Write, label "a58-458", NTFS 3.1)
Jan 31 21:02:53 laptop ntfs-3g[3689]: Cmdline options: rw,nosuid,nodev,uhelper=udisks,uid=1000,gid=1000,dmask=0077,fmask=0177
Jan 31 21:02:53 laptop ntfs-3g[3689]: Mount options: rw,nosuid,nodev,uhelper=udisks,allow_other,nonempty,relatime,fsname=/dev/sdc1,blkdev,blksize=4096,default_permissions

== Mount NTFS volume with full user write permission ==
  sudo mkdir /media/mraid0a2244_ad/  &&  \
  sudo mount -v /dev/sdg1 /media/mraid0a2244_ad/ -t ntfs o rw,allow_other,blocksize=4096,default_permissions

== Mount FAT* volume with full user write permission ==
  sudo mount -t vfat /dev/sdb1 /media/external -o uid=1000,gid=1000,utf8,dmask=027,fmask=137

== Various mount options ==
=== options-set-1 (man ntfs-3g) ===
Options:  ro (read-only mount), remove_hiberfile, uid=, gid=,
          umask=, fmask=, dmask=, streams_interface=.
__envHEREDOC__
}


# mergeconflictavoiddothismeow : here add from lap ONLY
#
helpsudo(){
	local pathToFunctionsDotfile="$( echo $ZOMG_DOTFILES/.functions.sh )"
	if [[ ! -f "$pathToFunctionsDotfile" ]] ; then
		# just set a default. it doesnt really matter since this is just example
		pathToFunctionsDotfile="/home/bdavies/dotfiles/home-machines/.functions.sh"
	fi

#$ sudo su -c "source /home/bdavies/dotfiles/home-machines/.functions.sh ; 
#i.e.
## sudo su -c "source /home/bdavies/dotfiles/home-machines/.functions.sh ; slowdown 808"
cat <<'__envHEREDOC__'
sudo su -c "source $ZOMG_DOTFILES/.functions.sh ; <insert name of function to call>
i.e.
sudo su -c "source $ZOMG_DOTFILES/.functions.sh ; slowdown 808"
__envHEREDOC__
}
helpusermod(){
cat <<'__envHEREDOC__'
$ usermod -a -G GROUPNAME USER
$ usermod -a -G ilike devborrat

Now, can just put entry into sudoers file that allows the 'ilike' 
group to do shtuffs...  e.g.
## Allows people in group wheel to run all commands
# %wheel        ALL=(ALL)       ALL
## Same thing without a password
%ilike ALL=(ALL)      NOPASSWD: ALL
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

