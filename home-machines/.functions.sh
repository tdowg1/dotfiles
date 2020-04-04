# .functions.sh

## ### #### ###################################################################
##
## misc. functions
##
## ### #### ###################################################################

# TODO STUB
#get that echoandexec method I wrote


# TODO function to slow down a (decidedly non-interactive) program by continually suspending and unsuspending it  ...
# local pgrepprogram="$1"
# ...itll need to gracefully handle a c-c... by ensuring program is left in the unsuspended state.  e.g.:
# while true ; do kill -SIGSTOP  $( pgrep "$pgrepprogram" ); sleep 5s; kill -SIGCONT  $( pgrep "$pgrepprogram" ); sleep 2s; done

# TODO function to slow down a (decidedly non-interactive) program by continually suspending and unsuspending it  ...
# round-robin the given process 20% of the real(human) time
function rr20percent(){
   # TODO  : ...itll need to gracefully handle a c-c... by ensuring program is left in the unsuspended state.  e.g.:
   local pgrepprogram="$1"
   pgrep "$pgrepprogram" >/dev/null
   if [[ $? = 0 ]] ; then
      while true ; do
         kill -SIGSTOP  $( pgrep "$pgrepprogram" )
         sleep 5s
         kill -SIGCONT  $( pgrep "$pgrepprogram" )
         sleep 1s
      done
   else
      return 44
   fi
}


function gy-in-quotes {
    [ -z "$1" ] && printf '%s\n' "Usage:        $FUNCNAME 'URL' (must be in single quotes!)
        strips the google prefix (up to url=) and suffix (from &usg=) from the argument,
        translates various common %nn sequences in the URL, and retrieves it." >&2 && return 1
    echo youtube-dl $(sed -e 's/http.*url=//;s/&usg=.*$//;s/%2F/\//g;s/%3A/:/g;s/%3D/=/g;s/%3F/?/g;s/%25/%/g' <<<"$1") # % characters must be edited last
}

function wg-in-quotes {
    [ -z "$1" ] && printf '%s\n' "Usage:        $FUNCNAME 'URL' (must be in single quotes!)
        strips the google prefix (up to url=) and suffix (from &usg=) from the argument,
        translates various common %nn sequences in the URL, and retrieves it." >&2 && return 1
    echo wget $(sed -e 's/http.*url=//;s/&usg=.*$//;s/%2F/\//g;s/%3A/:/g;s/%3D/=/g;s/%3F/?/g;s/%25/%/g' <<<"$1") # % characters must be edited last
}

locateAcrossAllDatabases(){
   local query="$1"
   local databases=""
   for i in /var/lib/mlocate/* ; do
      databases="$databases -d $i"
   done
   sudo locate $databases -i "$query"
}

cdzfs(){
   local idNumber=$1
   cd /mnt/a${idNumber}/fs1
}

# print out in unambiguous IEC as well as traditional SI amounts.
lba2IECandSI(){
   local lba=$1
   local bytes=$( lba2bytes $lba )
   # print out in MiB
   echo $( bytes2MiB $bytes )MiB

   # print out in GiB / GB
   echo $( bytes2GiB $bytes )GiB/$( bytes2GB $bytes )GB

   # print out in TiB / TB
   echo $( bytes2TiB $bytes )TiB/$( bytes2TB $bytes )TB
}
# likewise, except lba sector size is 4096 bytes instead of 512
4klba2IECandSI(){
   local lba=$1
   local bytes=$(( 13107200 * 4096 ))
   # print out in MiB
   echo $( bytes2MiB $bytes )MiB

   # print out in GiB / GB
   echo $( bytes2GiB $bytes )GiB/$( bytes2GB $bytes )GB

   # print out in TiB / TB
   echo $( bytes2TiB $bytes )TiB/$( bytes2TB $bytes )TB
}
lba2bytes(){
   local lba=$1
   echo "$lba * 512" | bc
}
lba2MiB(){
   local lba=$1
   local bytes=$( lba2bytes $lba )
   bytes2MiB $bytes
}
bytes2MiB(){
   local bytes=$1
   echo "$bytes / 1024 / 1024" | bc
}
bytes2GiB(){
   local bytes=$1

   echo "$bytes / 1024 / 1024 / 1024" | bc
}
bytes2TiB(){
   local bytes=$1

   echo "scale = 2
   $bytes / 1024 / 1024 / 1024 / 1024" | bc
   #clac.py "$bytes / 1024 / 1024 / 1024 / 1024"
}
bytes2GB(){
   local bytes=$1

   echo "$bytes / 1000 / 1000 / 1000" | bc
}
bytes2TB(){
   local bytes=$1

   echo "scale = 2
   $bytes / 1000 / 1000 / 1000 / 1000" | bc
   #clac.py "$bytes / 1000 / 1000 / 1000 / 1000"
}
bytes2lba(){
   local bytes=$1
   echo "scale = 2
   $bytes / 512" | bc
}
GB2lba(){
   local gb=$1
   echo "scale = 2
   $gb * 1000 * 1000 * 1000 / 512" | bc
}
GiB2lba(){
   local gib=$1
   local bytes=$( GiB2bytes $gib )
   echo "scale = 2
   $bytes / 512" | bc
}
# likewise, except lba sector size is 4096 bytes instead of 512
GiB24klba(){
   local gib=$1
   local lba512=$( GiB2lba $gib )
   echo "scale = 2
   $lba512 / 8" | bc
   # trim trailing zeros, if there's a decimal point:
   # | sed '/\./ s/\.\{0,1\}0\{1,\}$//'
}
GiB2bytes(){
   local gib=$1
   echo "$gib * 1024 * 1024 * 1024" | bc
}








update_auth_sock() {
    local socket_path="$(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')"

    if ! [[ "$socket_path" ]]; then
        echo 'no socket path' >&2
        return 1
    else
        export SSH_AUTH_SOCK="$socket_path"
    fi
}




timevariouslyformattedtoseconds(){
	#in; out
	#-------
	# 80m51.230s
	# 7m51.030s
	#
	# 4h19m17s
	#
	# 4hrs, 35mins, 39sec
	# 8mins, 59sec

	# Create function that can take the human-readable form of time measurments
	# and convert to seconds.
	echo
}
decimal2characterTODO(){
	#in; out
	#-------
	#0; nil
	#1; a
	#2; b
	#3; c
	#...

	#Create function to go the other way too.
	#For documentation verbage and ideas on improved naming, vars, etc. check out
	#the `seq' program.
	#Actually, I've showed how to use printf to use ascii chart to get ascii characters in a bash loop on [[Shell ASCII]]


	#Somewhat related--basically, want to be able to say something like:
	# seq a d
	#and have it do similarly what it does for decimal numbers... so would give:
	# a b c d.
	#i havent found a program to do this. shouldnt be hard to write. just use ascii table.
	echo
	#uppercase A =
	printf "\x$(printf %x 65)"
	#lowercase a =
	printf "\x$(printf %x 97)"
}

getReservedBlockCount(){
	if [[ $# != 1 ]] || [[ x"$1" = x"--help" ]] ; then
		echo "$FUNCNAME - too lazy to look at tune2fs output? Call me now for your free analysis!"
		# future unknown: default to using "$d" if it's non-empty and no argument passed.
		echo "Usage: $FUNCNAME ext4-device"
		return 1
	fi

	local device="$1"
	# example tune2fs output:
	#Block count:              487579392
	#Reserved block count:     0
}

mkdosurlfrominputurlstring(){
	if [[ $# = 0 ]] ; then
		echo "Example: mkdosurlfrominputurlstring() http://example.org/ > link-to-example.org.URL"
		return
	fi
	local inputurlstring="$1"

   #[InternetShortcut]
   #URL=http://www.altavista.com/
   cat <<__HEREDOC__
[InternetShortcut]
URL=$inputurlstring
__HEREDOC__
}
createurl(){
	mkdosurlfrominputurlstring "$@"
}
mkurl(){
	mkdosurlfrominputurlstring "$@"
}

findwildiname(){
	if [[ $# = 0 ]] ; then
		#echo "findwildiname() [path] wildcarded_searchstring"
		echo "${FUNCNAME}() [path] wildcarded_searchstring"
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

chmodchownchgrp(){
   if [[ $# = 0 ]] ; then
      echo "Usage: $FUNCNAME args-to-call-chmod-chown-and-chgrp-with"
      echo "Example: $FUNCNAME --reference=/etc/hosts newhostsfile"
      return
   fi
   echo sudo chmod "${*}"
   echo sudo chown "${*}"
   echo sudo chgrp "${*}"
}


snippetCreateEthernetDeviceIfcfgFile1(){
	# This snippet creates an ifcfg- file in the CWD for the specified *ETHERNET* slave
	# device (passed in), handling the setting of its HWADDR and DEVICE key values.
	#
	# Here's an example ifcfg file, ifcfg-p3p1, if p3p1 was passed in:
   #   HWADDR="a0:36:9f:4b:50:e8"
   #   DEVICE="p3p1"
   #   BOOTPROTO="none"
   #   NM_CONTROLLED="no"
   #   ONBOOT="yes"
   #   TYPE="Ethernet"
   #   SLAVE=yes
   #   MASTER=bond0
   #   MTU=9000


	#d=eth0
	local d="$1"


	echo -n 'HWADDR="' >> ifcfg-${d}

	ip -oneline link show $d  |  awk  '{ ORS=""; print $(NF-2) }' >> ifcfg-${d}

	echo -n '"
	DEVICE="' >> ifcfg-${d}

	echo -n $d  >> ifcfg-${d}

	echo '"
	BOOTPROTO="none"
	NM_CONTROLLED="no"
	ONBOOT="yes"
	TYPE="Ethernet"
	SLAVE=yes
	MASTER=bond0
	MTU=9000' >> ifcfg-${d}
}



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
grepdotfiles_original(){
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
	#  - ability to optionally pass standard grep option(s)
	#
	#
	local searchquery="$1"
	local searchpath="$2"

	echo "greptxtfiles() -> TODO STUB make me into a file so can sudo use ; implement greptxtfiles SINGLE-STRING-SEARCH-QUERY SEARCH-PATH"
	local specialignorecase="--exclude=script-names.vim-scripts.org.json"
	echo "greptxtfiles() -> NOTICE! the following is being passed to grep: $specialignorecase"


	for i in $( find "$searchpath" -type f ) ; do
		# limit resultset to files appearing to only contain text:
		#file -b  "$i"  |  grep -i ASCII >/dev/null 2>&1  # WONT MATCH : UTF-8 Unicode text, with very long lines
		file -b --mime-type "$i"  |  grep "text/plain"  >/dev/null 2>&1

		if [[ $? = 0 ]] ; then
			grep --with-filename -i $specialignorecase "$searchquery" "$i"
		fi
	done
}
grepdotfiles(){
   # bug is exhibited between these two: grepdotfiles cifs ; VS ; grep -i cifs -R ~/dotfiles
   echo THIS FUNCTION IS BUGGY
	# SYNOPSYS grepdotfiles SINGLE-STRING-SEARCH-QUERY
	local searchquery="$1"
        # TODO STUB: exclude files with trailing ~ characters as well as things within a git repo's .git/ directory.
	local searchpath="$ZOMG_DOTFILES"

	#greptxtfiles SINGLE-STRING-SEARCH-QUERY SEARCH-PATH
	greptxtfiles "$searchquery" "$searchpath"
	#greptxtfiles "$searchquery" "$searchpath"  |  grep -v "$( basename "$specialignorecase" )" | grep "$searchquery"
}
grepinstfiles(){
	# SYNOPSYS grepinstfiles SINGLE-STRING-SEARCH-QUERY
	local searchquery="$1"
	local searchpath="$dbi"

	#greptxtfiles SINGLE-STRING-SEARCH-QUERY SEARCH-PATH
	#greptxtfiles "$searchquery" "$searchpath"
        # try limit search to just text files:
        find "$searchpath" -type f -size -10M  -print0 | xargs -0 grep --with-filename -i "$searchquery" | grep -i "$searchquery"
}




##
## HDD-related
function grepbylabel(){
   # bylabelgrep, or...
   # grepbylabel
   # grepbylbl
   # grepbylbl
   # grepbylabl
   local greppattern="$1"
   ll /dev/disk/by-label/ | grep -i "$greppattern"
}

function ddBadLbaAndSurrounding1000Sectors(){
	local device=$1
	local lba=$2
	local plusorminusamount=1000
	for i in `seq $( clac.py "$lba - $plusorminusamount" ) $( clac.py "$lba + $plusorminusamount" )` ; do
		sudo dd if=/dev/zero of=$device count=1 seek=$i conv=notrunc,noerror oflag=direct | xargs echo $i;
	done
}

function smartctllogger(){
	# Example: $0 /dev/sdb a96-931 [smartctl options [to passthrough]]
	#
	# What does this function do?
	# 1. smartctl option '--all' and '--xall' will be called.
	# 2. log file generated to CWD.
	if [[ $# -lt 2 ]] ; then
		echo "$FUNCNAME - logs 'smartctl --(x)all' for device to a consistenly named log file. (invokes sudo)"
		echo "Usage:   $FUNCNAME device   volume-name"
		echo "Example: $FUNCNAME /dev/sdb a96-931"
		echo "Example: $FUNCNAME /dev/sdb a96-931 -d sat,12"
		return 1
	fi

	local devicepath=$1
	local devicename=$2
	shift 2
	local extraopts="$*"
	local commontime="$( date +"%Y-%m-%d_%H.%M.%S" )"

	local nextcmd="smartctl_--all"
	local logfilename="${devicename}_${commontime}_cmd-${nextcmd}.log"
	sudo smartctl ${extraopts} --all "${devicepath}"  >  "${logfilename}"

	nextcmd="smartctl_--xall"
	logfilename="${devicename}_${commontime}_cmd-${nextcmd}.log"
	sudo smartctl ${extraopts} --xall "${devicepath}"  >  "${logfilename}"
}

## /HDD-related
##



svnhelp(){
	# Make svn help paginate politely.
	svn help $* | less -FX
}
achelp(){
	# Make accurev help paginate politely.
	accurev help $* | less -FX
}

#aptitudesns(){
aptitudesearchandshow(){
	# Foreach package returned from the `aptitude search` user-specified query,
	# perform an `aptitude show`.  Note that the actual `aptitude show` cmdln
	# that gets executed will be printed out to the very first line prior
	# to any subsequent output coming from `aptitude show`.
   local aptitudeSearchPattern="$1"
	aptitude -F "%p" search "$aptitudeSearchPattern" | xargs --verbose  aptitude show
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
##


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









setSparksServersVariablesForLocal(){
   export sparksMajorServers="stardust voyager vega2 phobos"
   export sparksMinorServers="remote print-server"
   export sparksVmwareHosts="stardust voyager phobos"
}
setSparksServersVariablesForRemote(){
   local remote_string=""
   remote_string="remote-"
   remote_string="proxy-"
   export sparksMajorServers="${remote_string}stardust ${remote_string}voyager ${remote_string}vega2 ${remote_string}phobos"
   export sparksMinorServers="${remote_string}remote ${remote_string}print-server"
   export sparksVmwareHosts="$sparksMajorServers"
}
# the Local vs Remote thing was more applicable in the past, prior to the network presence steps taken ~2015.
# going to just enable the _Local_ mode now since that's what's usually needed:
setSparksServersVariablesForLocal



listAllRunningSparksVmguests(){
   printhostnamesonly=$1
   export sparksVmwareGuests=""

   for i in $sparksVmwareHosts ; do
      #echo -e "\e[0;32m${i}\e[0m" >/dev/stderr
      echo -e "\e[0;32m${i}\e[0m"
      #ssh -A $i  'ps fwww $(pgrep -f /usr/lib/vmware/bin/vmware-vmx)'
      currlist=$( ssh -A $i  'sudo vmrun list' | grep -v "Total running VMs" )
      if [[ -z "$currlist" ]] ; then continue; fi
      if [[ -z "$printhostnamesonly" ]] ; then
         ssh -A $i  'sudo vmrun list' | grep -v "Total running VMs"
      else
         ssh -A $i  'sudo vmrun list' | grep -v "Total running VMs" | xargs -n 1 basename | sed 's/.vmx//'
         tempcapture=$( ssh -A $i  'sudo vmrun list' | grep -v "Total running VMs" | xargs -n 1 basename | sed 's/.vmx//' )
         sparksVmwareGuests="$tempcapture $sparksVmwareGuests"
      fi
   done
}
listAllSparksVmguests(){
   # shows the vmguests that are present on a vmhosts filesystem.
   local defaultVmguestFilesLocation="/opt/vms/"
   for i in $sparksVmwareHosts; do
      echo -e "\e[0;32m${i}\e[0m" >/dev/stderr
      ssh -A $i  "ls -1 $defaultVmguestFilesLocation" | grep -v ^archive$ | grep -v ^bu$
   done
}
locateAcrossSparksMajors(){
   local matchstring="$1"
   for i in $sparksMajorServers ; do
      echo -e "\e[0;32m${i}\e[0m" >/dev/stderr
      ssh -A $i  'sudo locate '${matchstring}''
   done
}
updatedbAcrossSparksMajors(){
   local matchstring="$1"
   for i in $sparksMajorServers ; do
      echo -e "\e[0;32m${i}\e[0m" >/dev/stderr
      ssh -A $i  'sudo updatedb'
   done
}




awshelp(){
   local args="$*"
   aws $args help
}
# enable shell bash_completion as if awshelp were the same as aws:
complete -C aws_completer awshelp




## ### #### ###################################################################
##
## help text functions
##
##  These functions do nothing but print helpful/hintful text regarding various
##  commands, etc.
##
## ### #### ###################################################################
helpsparks(){
cat <<'__envHEREDOC__'
# call...
setSparksServersVariablesForLocal
#   ^^^this is set by default.
# or
setSparksServersVariablesForRemote
# in order to set the sparksMajorServers and sparksMinorServers variables appropriately.

= Notes =
# To get a list of vm's and shut them down, could do like
# choose local or remote:
setSparksServersVariablesForRemote | setSparksServersVariablesForLocal
listAllRunningSparksVmguests justhostnames

# takes care of windows boxes: (youll probably have to run this from the ansible machine since it's the only one that can connect to windows on the WinRM port or whatever:
time ansible \*sparks_ms\* -m raw -a "shutdown.exe /s /t 4" --list-hosts
time ansible $( echo $sparksVmwareGuests | tr ' ' ':' ) -m raw -a "shutdown.exe /s /t 4" --list-hosts

# takes care of linux boxes (on stardust): (youll probably have to run this from the ansible machine if local)
time ansible \*sparks\*shared\*:net\*:\!proxy\*:\!vm-ubu1404-ansible\!vm-ubu-3 -m command -a "init 0" --sudo --list-hosts

time ansible $( echo $sparksVmwareGuests | sed 's/vm-ubu1404-ansible//' | tr ' ' ':' ) -m command -a "init 0" --sudo


= See also =
$sparksMajorServers
$sparksMinorServers
$sparksVmwareHosts=

locateAcrossSparksMajors
updatedbAcrossSparksMajors
listAllRunningSparksVmguests [justhostnames]  # when justhostnames arg is supplied, a new global variable, sparksVmwareGuests , will also be set containing a space delimited string of running machines hostnames.
listAllSparksVmguests [justhostnames]
__envHEREDOC__
}
helpvmware(){
#cat <<'__envHEREDOC__'
#__envHEREDOC__
set -x
alias | grep vmware
set +x

cat <<'__envHEREDOC__'
= Renaming vmware vm files =
cd vm-centos6-bamboo/
sudo rename  "s/vm-centos6-bamboo/vm-centos6-yubikey-storage/" -v *
sudo sed -i "s/vm-centos6-bamboo/vm-centos6-yubikey-storage/g" vm-centos6-yubikey-storage.*
cd ..
mv vm-centos6-bamboo vm-centos6-yubikey-storage

= Installing vmware-tools =
* Assumes the requisite packages (e.g. kernel-headers, build tools, make) are already installed...
** build-essential     # for Debian-based OS's
** linux-kernel-headers
** "Development Tools" # a groupinstall for RHEL-based OS's

* Attach the ROM to the vm, then execute..
sudo mount -t iso9660 /dev/sr0 /media
df
cd /tmp/
tar zxfv /media/VMwareTools-*.tar.gz
cd /tmp/vmware-tools-distrib/  &&  sudo ./vmware-install.pl
* if all is ok, restart the machine to test.
* the vmtoolsd process should be running.

= See also =
helpvmrun
__envHEREDOC__
}
helpvmrun(){
cat <<'__envHEREDOC__'
# Lists all running vm's, does include __VMWARE__ "paused" (__NOT__ "suspended") machines:
suspended machines are not included in this listing:
machines in a state of "paused" which is transparent to the guest ARE listed:
sudo vmrun list


suspend - Suspends a virtual machine. The guest OS can be made aware of the suspend command by passing the soft parameter, allowing it to sleep/hibernate (if supported).
suspend vmxfile hard
suspend vmxfile soft  # USE THIS TO suspend/pause a vm

start vmxfile nogui   # USE THIS TO unsuspend/unpause/start a previously suspended/paused vm

__envHEREDOC__
}

helpmd5(){
	# consider RENAME helpchecksumming, helpdigest, helphashdigest, etc
	cat <<'__envHEREDOC__'
CREATE1:: Filenames (from find)  may not be sorted! # cd $DIR
~~$ find . -type f -exec md5sum '{}' \; > md5sum.md5~~
$ find . -type f ! -name md5sum.md5  -exec md5sum '{}' \; > md5sum.md5
$ # it may then be desirable to have hashes sorted by filename:
$ sort -k2 md5sum.md5  >  md5sum.md5.sorted

CREATE2:: Have hashes sorted by filename from the start # cd $DIR
$ find .  -type f | sort | xargs md5sum > md5sum.md5
or...
$ find .  -type f -print0 | sort | xargs -0 md5sum > md5sum.md5

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
time sudo du -hs $d
echo ; date --rfc-3339 seconds
time sudo du -hs --count-links $d
echo ; date --rfc-3339 seconds

# du: (same thing as above but on 1 line)
d=$( for i in $( ls -trA ) ; do test -f "$i"  &&  continue ; echo $i; done | xargs echo  ) ;  echo ; date --rfc-3339 seconds; time sudo du -hs $d ; echo ; date --rfc-3339 seconds ; time sudo du -hs --count-links $d ; echo ; date --rfc-3339 seconds



[bdavies@magnificent r]$ for i in hourly.1/* ; do ib=$(basename $i) ; for j in ${i}/* ; do jb=$(basename $j); echo sudo rnapshot-diff hourly.1/$ib/$jb hourly.2/$ib/$jb; done; done
sudo rsnapshot-diff hourly.1/perm/home hourly.2/perm/home
sudo rsnapshot-diff hourly.1/perm/misc hourly.2/perm/misc
sudo rsnapshot-diff hourly.1/perm/opt hourly.2/perm/opt
sudo rsnapshot-diff hourly.1/ubu1010/etc hourly.2/ubu1010/etc
sudo rsnapshot-diff hourly.1/ubu1010/usr hourly.2/ubu1010/usr
sudo rsnapshot-diff hourly.1/ubu1010/var hourly.2/ubu1010/var

File count of each rsnapshot, from oldest to newest:
$ for i in $(ls -trd ./*) ; do  echo $i $( sudo find $i | wc -l); done

Delete a directory within all snapshots (or some, but want to test all):
# within rsnapshot directory, you can see where it exists:
$ for i in * .*  ; do echo $i; toremove=$i/path/to/removal-fso ; sudo test -d $toremove && echo ' ->^^EXISTS' ; done
# and then do the deletion:
$ for i in * .* ; do echo $i; toremove=$i/path/to/removal-fso ; sudo test -d $toremove && sudo rm -rf $toremove ; done

Upon modifying all the rsnapshots (e.g. like with previous cmdln), all the last modified
times may reflect times that are not desired.  If noatime was enabled, this can be fixed with:
for i in hourly.* daily.* weekly.* monthly.* ; do echo $i ; sudo touch -m --date="$( stat   --printf "%x\n" $i )"  $i ; sleep 1s; done
__envHEREDOC__
}


pssynergy(){
   #ps -ef | grep -i -P "[s]ynergyc|[s]ynergys"

   #echo '  PID TTY          TIME  NI COMMAND'
   #ps -eo "%p %y %x %n %c" | grep synergy

   ps -o "%p %y %x %n %c" -p $( pgrep synergy )
}
pswsynergy(){
   # and remove only the first line
   ps www -o "%a" $( pgrep synergy ) | sed -e '1,1d'
}
synergycmdln(){
   pswsynergy
}
restartsynergy(){
   runningprocs=$( pswsynergy | wc -l )
   if [[ $runningprocs != 1 ]] ; then
      echo "multiple synergy processes running... you probably need to deal with that first"
      return
   fi

   prevcmdln="$( pswsynergy )"
   pkill synergy
   eval "$( echo $prevcmdln )"
}


# TODO STUB:: TEST THESE 2 FUNCTIONS
startsynergyserver(){
   #synergys --address 192.168.1.77:24800 --config /home/teelah/Dropbox/synergy-active-configs/server-newjack-wireless/newjack.conf --name newjack  --no-restart  --log /var/log/synergy.log
   networkmedium=$1
   [[ -z $networkmedium ]] && networkmedium=wired
   systemtype="server"
   eval "$( cat /home/teelah/Dropbox/synergy-active-configs/${systemtype}-$( hostname -s )-${networkmedium}/cmdln.txt )"
}

startsynergyclient(){
   [[ -z $networkmedium ]] && networkmedium=wired
   systemtype="client"
   eval "$( cat /home/teelah/Dropbox/synergy-active-configs/${systemtype}-$( hostname -s )-${networkmedium}/cmdln.txt )"
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
	cat <<'__envHEREDOC__'
sudo mdadm --assemble --scan
sudo mdadm --detail /dev/md0
cat /proc/mdstat
ls /sys/block/md0/md/

= Create a JBOD / linear device across 2 drives =
# edit /etc/raidtab:
raiddev /dev/md0
        raid-level      linear
        nr-raid-disks   2
        persistent-superblock 1
        device          /dev/sdd
        raid-disk       0
        device          /dev/sde
        raid-disk       1

mdadm --create --verbose /dev/md0 --level=linear --raid-device=2 /dev/sdd /dev/sde
mkfs.xfs -L md0 /dev/md0
mkdir /mnt/md0
# edit /etc/fstab:
LABEL=md0             /mnt/md0              xfs     defaults,nofail        0 0
LABEL=md0             /mnt/md0              xfs     defaults,nofail,noatime,nodiratime        0 0

sudo su -c "echo \"LABEL=md0             /mnt/md0              xfs     defaults,nofail,noatime,nodiratime        0 0\" >> /etc/fstab"

= Create a RAID-0 device across 2 drives =
Follow the above instructions for JBOD, except instead of specifying "linear", specify
"stripe".

= See also =
helpsysfs
__envHEREDOC__
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
# reader be warned, this isn't exactly help text..... is basically garbage...
helpsmartctl(){
cat <<'__envHEREDOC__'
== List attributes ==
smartctl -a /dev/sda ; echo ; echo ; smartctl -a /dev/sdb ; echo ; echo;  echo; smartctl -a /dev/sdc

== Long test ==
sudo smartctl -t long /dev/sda && sleep 45m
sudo smartctl -t long /dev/sdb && sleep 175m
sudo smartctl -t long /dev/sdc && sleep 175m
sudo smartctl -t long /dev/sdd && sleep 175m

# Enable as much monitoring and testing as possible:
smartctl $d --smart=on --offlineauto=on --saveauto=on

# Example Solaris / Illumos / OmniOS cmdln:
smartctl --all -d sat,12 /dev/rdsk/c4t0d0

d=${DEVICE}
DEVICE=${d}
OPTS=""
OPTS="-d sat,12"

sudo smartctl ${OPTS} --all ${d} > ${dname}_$( date +"%Y%m%d%H%M%S" )_smartctl_all.log
sudo smartctl ${OPTS} --xall ${d} > ${dname}_$( date +"%Y%m%d%H%M%S" )_smartctl_xall.log
sudo smartctl ${OPTS} --all ${d} > /media/smb-phisata-mnt/a14-h/h/root/LIFE/hdd/${dname}_$( date +"%Y%m%d%H%M%S" )_smartctl_all.log
sudo smartctl ${OPTS} --xall ${d} > /media/smb-phisata-mnt/a14-h/h/root/LIFE/hdd/${dname}_$( date +"%Y%m%d%H%M%S" )_smartctl_xall.log

   # LOOPS
devicelist="a b c"
for i in $devicelist ; do   sudo smartctl ${OPTS} --all  /dev/sd${i} | less ; done
for i in $devicelist ; do   sudo smartctl ${OPTS} --test=short /dev/sd${i};  done; sleep 15m;
for i in $devicelist ; do   sudo smartctl ${OPTS} --test=conveyance /dev/sd${i};  done; sleep 30m;
for i in $devicelist ; do   sudo smartctl ${OPTS} --test=long /dev/sd${i};  done; sleep 300m;
for i in $devicelist ; do   sudo smartctl ${OPTS} --test=offline /dev/sd${i};  done; sleep 300m;

   # REALLY STUPID SNIPPET
	# dd overwrite self with self, all smart tests x2, dd again, all smart tests (x1)
DEVICE=/dev/sdb   # e.g.
sudo dd if=${DEVICE} of=${DEVICE} bs=4096 conv=notrunc,noerror  ;  date ; sleep 15m ; sudo smartctl ${DEVICE} --test=short ; sleep 5m ; sudo smartctl ${DEVICE} --test=conveyance ; sleep 5m ; sudo smartctl ${DEVICE} --test=long ; sleep 250m ; sudo smartctl ${DEVICE} --test=offline ; echo "sleep 7h or 25200s" ; date ; sleep 5h ;             sudo smartctl ${DEVICE} --test=short ; sleep 5m ; sudo smartctl ${DEVICE} --test=conveyance ; sleep 5m ; sudo smartctl ${DEVICE} --test=long ; sleep 250m ; sudo smartctl ${DEVICE} --test=offline ; echo "sleep 7h or 25200s" ; sleep 7h ;               date ; sudo dd if=${DEVICE} of=${DEVICE} bs=4096 conv=noerror ;               sudo smartctl ${DEVICE} --test=short ; sleep 5m ; sudo smartctl ${DEVICE} --test=conveyance ; sleep 5m ; sudo smartctl ${DEVICE} --test=long ; sleep 250m ; sudo smartctl ${DEVICE} --test=offline ; echo "sleep 7h or 25200s" ; date ; sleep 7h

   # REALLY STUPID SNIPPET2
sudo smartctl --test conveyance ${DEVICE}  && echo 'conveyance OKkKKKKKKKKKK' ; sleep 10m  ;  sudo smartctl --test short ${DEVICE}  && echo 'short OKkKKKKKKKKKK' ; sleep 10m   ;  sudo smartctl --test long ${DEVICE}  && echo 'long OKkkkkkkkkkkkKK'   ;   sleep 255m ; sleep 9m ;    sudo smartctl --test offline ${DEVICE}   ;  sleep 10000s

sudo smartctl $OPTS $DEVICE --attributes > attributes ; sudo smartctl $OPTS $DEVICE --log selftest > selftest ; git diff
sudo smartctl $OPTS $DEVICE --attributes > $( date +"%F_%T")_a143-smartctl-attrs.txt; diff -d $( ls -tr *.txt | tail -2 )

== SEE ALSO ==
smart-notifierdbus - service and graphical disk health notifier
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
== Misc ==
$ nmblookup HOSTNAME - querying HOSTNAME on w.x.y.255

# `apropos smb' :
$ cupsaddsmb (8)       - export printers to samba for windows clients
$ findsmb (1)          - list info about machines that respond to SMB name queries on a subnet
$ mksmbpasswd (8)      - formats a /etc/passwd entry for a smbpasswd file
$ mount.smbfs (8)      - mount using the Common Internet File System (CIFS)
$ samba (7)            - A Windows SMB/CIFS fileserver for UNIX
$ smb.conf (5)         - The configuration file for the Samba suite
$ smbcacls (1)         - Set or get ACLs on an NT file or directory names
$ smbclient (1)        - ftp-like client to access SMB/CIFS resources on servers
$ smbcontrol (1)       - send messages to smbd, nmbd or winbindd processes
$ smbcquotas (1)       - Set or get QUOTAs of NTFS 5 shares
$ smbd (8)             - server to provide SMB/CIFS services to clients
$ smbget (1)           - wget-like utility for download files over SMB
$ smbgetrc (5)         - configuration file for smbget
$ smbmount (8)         - mount using the Common Internet File System (CIFS)
$ smbpasswd (5)        - The Samba encrypted password file
$ smbpasswd (8)        - change a user's SMB password
$ smbspool (8)         - send a print file to an SMB printer
$ smbstatus (1)        - report on current Samba connections
$ smbstatus.samba3 (1) - report on current Samba connections
$ smbtar (1)           - shell script for backing up SMB/CIFS shares directly to UNIX tape drives
$ smbtar backup/restore a Windows PC directories to a local tape file
$ smbtree (1)          - A text based smb network browser
$ testparm (1)         - check an smb.conf configuration file for internal correctness
$ testparm.samba3 (1)  - check an smb.conf configuration file for internal correctness

# vfs_* things
vfs_acl_tdb         vfs_commit          vfs_linux_xfs_sgid  vfs_shell_snap
vfs_acl_xattr       vfs_crossrename     vfs_media_harmony   vfs_snapper
vfs_aio_fork        vfs_default_quota   vfs_netatalk        vfs_streams_depot
vfs_aio_linux       vfs_dirsort         vfs_offline         vfs_streams_xattr
vfs_aio_pthread     vfs_extd_audit      vfs_prealloc        vfs_syncops
vfs_audit           vfs_fake_perms      vfs_preopen         vfs_time_audit
vfs_btrfs           vfs_fileid          vfs_readahead       vfs_tsmsm
vfs_cacheprime      vfs_fruit           vfs_readonly        vfs_unityed_media
vfs_cap             vfs_full_audit      vfs_recycle         vfs_worm
vfs_catia           vfs_glusterfs       vfs_shadow_copy     vfs_xattr_td

== net USERSHARE ==
# net USERSHARE ADD sharename path [comment] [acl] [guest_ok=[y|n]] - to add or change a user defined share.
# net usershare add sharename path [comment  [acl] [guest_ok=[y|n]]]
#    The default if no "acl" is given is "Everyone:R", which means any authenticated user has read-only access.
net usershare add <share name> <share path> guest_ok=y
net usershare list
# FINALLY!  Thank you samba project!  An easy way to create a share from the cmdln
# that is fully usable by some user:
net usershare add doctor-dooms-share /mnt/share/ "half cocked and half baked" doctor-doom:F guest_ok=n
net usershare add MF-DOOMs-share /mnt/share/ "later for the date than the hadron collider" vaudeville-villain:F guest_ok=n

KDE/Dolphin share nfo not in smb.conf but in:
 /var/lib/samba/usershares/
More nfo:
* http://askubuntu.com/questions/520891/samba-share-not-in-smb-conf
* https://help.ubuntu.com/community/Samba/SambaServerGuide

== See also ==
helpmount()
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
     600+0 records in
     600+0 records out
     629145600 bytes (629 MB) copied, 15.4169 s, 40.8 MB/s
rewrite entire disk (with itself)
   dd if=/dev/sdc of=/dev/sdc bs=4096 conv=noerror
      ehhh... had disastrous results after doing this with a microSD card that had been acting up.

EXAMPLES hdd-REMAPPING.1 ----------------------
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
$ dc3dd if=/dev/sda of=/dev/sda rec=off

ALTERNATIVELY.1-smartctl offline testing should remap bad sectors, if supported
   smartctl --test offline /dev/sda
ALTERNATIVELY.2-if offline testing not supported, check out hdrecover

EXAMPLES hdd-REMAPPING.2 ----------------------
 http://smartmontools.sourceforge.net/badblockhowto.html

See also
* fddBadLbaAndSurrounding1000Sectors


dd if=/dev/zero of=/dev/X count=1 seek=<LBA of err> conv=notrunc,noerror oflag=direct
dd < /dev/zero >/dev/sdXX
pv -pterb < /dev/zero | dd of=zerofile.dd count=1                  # 512-byte file with zeros (in bin)
tr '\0' '\377' < /dev/zero | pv -pterb | dd of=onefile.dd count=1  # likewise, but with ones; 377(8) == 255(10) == 0xFF == 1111 1111
tr '\0' '\377' < /dev/zero | pv -pterb | dd of=/some/device count=1 iflag=fullblock oflag=sync conv=notrunc  # likewise, but for sector remapping


MISC ----
MONITORING progress
   dd ... & pid=$! ; watch kill -USR1 $pid
   while [ 1 ] ; do kill -USR1 $pid ; sleep 5 ; done
      when you use sudo, the $pid is that of the sudo process!!
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
Shorthand
   dd if=/dev/zero of=/swap bs=1MiB count=$((4*1024))  # 4GiB swapfile
Combine >1 incomplete torrent files where they have different parts of the data: binary file merge torrent::
   # src : https://unix.stackexchange.com/a/549966
   # blocksize should be whatever the configured torrent file defined as
   # foo is file1
   # bar is file2
   # out is the new "union"'ed(if you will) combined file.
   dd conv=sparse,notrunc if="$foo" of="$out" bs=$torrent_peices_size
   dd conv=sparse,notrunc if="$bar" of="$out" bs=$torrent_peices_size
      # something else im thinking of... generate cksums for each peice of the two torrent files... out
      # to txt file, and compare... could line up the files like that if having trouble with the above two dd cmdlns.

__envHEREDOC__
}
helpdd2(){
cat <<'__envHEREDOC__'
== Examples ==
Ripping bootable knoppix disk to iso file:
$ dcfldd if=/dev/sr0 of=knoppix.iso   md5log=md5sum status=on sizeprobe=if
Hexdump of first 64 sectors of DEVICE (this is relevant to grub shtuffs):
$ dd if=DEVICE count=64 | hexdump -Cv > dd-DEVICE-64.txt
  ^^and after running grub-install, for instance, the contents of this area will be modified.

Create a 100G sparse file:
$ dd if=/dev/zero of=MY_FILE count=0 bs=1G seek=100


== See Also ==
* truncate - sparse files

* hdrecover.sf.net

* ddrescue / dd_rescue tries hard to rescue data in case of read errors. (Similarly, gddrescue)
** ddrescue is newest

* dd_rhelp - http://www.kalysto.org/utilities/dd_rhelp/index.en.html
** tries to recover as much as possible, as fast as possible, using ddrescue / dd_rescue
*** In short, dd_rhelp will use dd_rescue on your entire disc, BUT it will try to gather the maximum valid data before trying for ages on bunches
*** of badsectors.
*** So if you leave dd_rhelp work for infinite time, it'll have the same effect as a simple dd_rescue.
*** But because you might not have this infinite time (this could indeed take really long in some cases... ), dd_rhelp will come to help.
*** It works by "jumping" to another part of the disk whenever it encounters too much read errors in a row.
*** Of course, it keeps a map of what have been parsed, and in the long run, it garantees you that dd_rescue will be used to parse all the surface of your device.
** GNU ddrescue is a newer tool doing the same thing as dd_rhelp without needing dd_rescue.

* safecopy is a data recovery tool which tries to extract as much data as possible from a problematic (i.e. damaged sectors) source - like floppy drives, harddisk partitions, CDs, tape devices, ..., where other tools like dd would fail doe to I/O errors.

* ??? ddclac 	??

* dcfldd based on the dd program but with additional features...
** "enhanced version of dd for forensics and security"
** (hashing) Hashing on-the-fly - dcfldd can hash the input data as it is being transferred, helping to ensure data integrity.
** (eta status) Status output - dcfldd can update the user of its progress in terms of the amount of data transferred and how much longer operation will take.
** (pattern writing) Flexible disk wipes - dcfldd can be used to wipe disks quickly and with a known pattern if desired.
** (integrity verif) Image/wipe Verify - dcfldd can verify that a target drive is a bit-for-bit match of the specified input file or pattern.
dcfldd if=/dev/sr0 vf=kubuntu-18.04-desktop-amd64.iso
** Multiple outputs - dcfldd can output to multiple files or disks at the same time.
** (split output) Split output - dcfldd can split output to multiple files with more configuration possibilities than the split command.
** (logging) Piped output and logs - dcfldd can send all its log data and output to commands as well as files.
** !!! NOTE: THE SIZE DESIGNATION OF UNITS ARE COMPLETELY WRONG... e.g. it outputs "Mb" which should be MiB
*** MORE NOTE: honestly, this program seems to say outright bizzaire things... sizes are ALL out of wack... it also doesnt output current throughput or final throughput.  not great.

* dc3dd inspired by the dcfldd, also based on dd, with addl. features...
** "patched version of GNU dd with forensic features"
** (pattern writing) Pattern writes. The program can write a single hexadecimal value or a text string to the output device for wiping purposes.
** (hashing) Piecewise and overall hashing with multiple algorithms and variable size windows. Supports MD5, SHA-1, SHA-256, and SHA-512. Hashes can be computed before or after conversions are made.
** (eta status) Progress meter with automatic input/output file size probing
** (logging) Combined log for hashes and errors
** Error grouping. Produces one error message for identical sequential errors
** (integrity verif) Verify mode. Able to repeat any transformations done to the input file and compare it to an output.
** (split output) Ability to split the output into chunks with numerical or alphabetic extensions
** EXAMPLE: raw copy a partition to regular file, fail if read errors occur (rec=off), and log md5 hash of input output
dc3dd if=/dev/sdb2 hof=sdb2.dd.img  log=sdb2.dd.img.dc3dd.log rec=off hash=md5
dc3dd wipe=/dev/sdd
dc3dd if=/dev/sdc of=/dev/sdd log=sdc-to-sdd.dc3dd.log rec=off hash=md5 ssz=4096

* ddpt copies data between files and storage devices. Support for devices that understand the SCSI command set.
** can issue SCSI commands in pass-through ("pt") mode.
__envHEREDOC__
}



#utc2local(){
# TODO STUB: make func st
#  in: date and/or time (allow loosely defined e.g. 2014-04-04 00:00) which is in UTC
#  out: prints what the date and time was at that time, but for curr locale.
# so basically want a wrapper around date.
#what was the current locales date and time at 2014-04-23T00:00-0000 ?

#[toki-wartooth@mordhaus ]$ TZ=US/Eastern ; date --date=2014-04-23T00:00:00-0000
#Tue Apr 22 20:00:00 EDT 2014

#}
helpdate(){
	local useThisDate=`date`
	echo "using date $useThisDate"
	echo -e "[OUTPUT]\t\t[CMDLN]"

	# Stupid F%^&*(! "day light savings" crap.
# TZ=GMT+0
# TZ=UTC
# TZ=EST
# TZ=EST5EDT
	cmdln="TZ=GMT+0;         date +\"%Y-%m-%d %H-%M-%S\" --date=\"$(eval echo ${useThisDate})\"" ; echo -e "$(eval $cmdln)\t$cmdln"
	cmdln="TZ=UTC;           date +\"%Y-%m-%d %H-%M-%S\" --date=\"$(eval echo ${useThisDate})\"" ; echo -e "$(eval $cmdln)\t$cmdln"
	cmdln="TZ=EST;           date +\"%Y-%m-%d %H-%M-%S\" --date=\"$(eval echo ${useThisDate})\"" ; echo -e "$(eval $cmdln)\t$cmdln"
	cmdln="TZ=EST5EDT;       date +\"%Y-%m-%d %H-%M-%S\" --date=\"$(eval echo ${useThisDate})\"" ; echo -e "$(eval $cmdln)\t$cmdln"

	echo
# TZ=Europe/London
# TZ=US/Eastern
	cmdln="TZ=Europe/London; date +\"%Y-%m-%d %H-%M-%S\" --date=\"$(eval echo ${useThisDate})\"" ; echo -e "$(eval $cmdln)\t$cmdln"
	cmdln="TZ=US/Eastern;    date +\"%Y-%m-%d %H-%M-%S\" --date=\"$(eval echo ${useThisDate})\"" ; echo -e "$(eval $cmdln)\t$cmdln"
	echo


	cmdln="date +\"%Y-%m-%d_%H-%M-%S\"  --date=\"$(eval echo ${useThisDate})\""
	echo -e "$(eval $cmdln)\t$cmdln"

	cmdln="date +\"%Y-%m-%d %H-%M-%S\"  --date=\"$(eval echo ${useThisDate})\""
	echo -e "$(eval $cmdln)\t$cmdln"

	cmdln="date +\"%Y%m%d_%H%M%S\"      --date=\"$(eval echo ${useThisDate})\""
	echo -e "$(eval $cmdln)\t\t$cmdln"

	cmdln="date +\"%Y%m%d-%H%M%S\"      --date=\"$(eval echo ${useThisDate})\""
	echo -e "$(eval $cmdln)\t\t$cmdln"

	cmdln="date +\"%Y-%m-%d_%H,%M,%S\"  --date=\"$(eval echo ${useThisDate})\""
	echo -e "$(eval $cmdln)\t$cmdln"

	cmdln="date +\"%Y-%m-%d_%H.%M.%S\"  --date=\"$(eval echo ${useThisDate})\""
	echo -e "$(eval $cmdln)\t$cmdln"

cat <<'__envHEREDOC__'

date  --rfc-3339 seconds          # GIVE ME ISO-FORMATTED DATE
date  --reference=file-to-reference
$( date +"%Y%m%d%H%M%S" )

TIMEZONES | /usr/share/zoneinfo
$ export TZ=Europe/Stockholm; echo "Stockholm:    `date +\"%F %R (%Z)\"`"
# `--> Stockholm:    2012-05-18 20:31 (CEST)
$ export TZ=US/Central; echo "Dallas:             `date +\"%F %R (%Z)\"`"
# `--> Dallas:       2012-05-18 13:32 (CDT)
#
# TZ=Europe/London
# TZ=GMT+0
# TZ=UTC
# TZ=EST
# TZ=EST5EDT
# TZ=US/Eastern

TIMEZONE CHANGE | /etc/localtime (binary TZ file)
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
ln -sf /usr/share/zoneinfo/UTC   /etc/localtime
 note: this works for RHEL and deb-based machines.

CONVERT a given locale-->to the current locale (e.g.: convert a diff-TZ into curr-TZ):
$ TZ=US/Eastern  date --date="2012-05-24 18:08:56 UTC"   # current locale is set to TZ
# `--> Thu May 24 14:08:56 EDT 2012

   ¿ what this do, exactly?
   ¿ CONVERT between locale's: ???
   ¿ $ export TZ=Asia/Kolkata; echo "Jaisalmer, India: `date --date="2012-05-24 18:08:56 UTC"`"
   ¿ # `--> Jaisalmer, India: Thu May 24 23:38:56 IST 2012

   ¿ currently there is a usage of UTC+0... you can have it to do math for you I think...
   ¿    TZ variable is set to force to be in -0400: UTC+4  (yes, "UTC+4" means -0400 for some reason)
   ¿ im not sure what trying to get at here lol... just start listing off use cases for datetime stuff and go from there.

CONVERT the current locale-->to a given different locale (e.g.: convert curr-TZ into a diff-TZ):
$ TZ=UTC  date                 --date="2018-06-30T21:37:51-04:00"
$ TZ=UTC  date                 --date="2018-06-30T21:37:51 EDT"
$ TZ=UTC  date --date='TZ="US/Eastern" 2018-06-30T21:37:51'

START AND END TIME VARIABLES
t1=$( date --rfc-3339 sec )
t2=$( date --rfc-3339 sec )
echo "starttime: $t1"
echo " stoptime: $t2"

= SEE ALSO =
xclock -digital  -strftime "%Y-%m-%d %H-%M-%S" -update 1 -twentyfour
helplogrotate_of_files()
helpbackup[singlefiles]
man localedef    # - compile locale definition files
man locale       # - get locale-specific information
man 5 locale     # - describes a locale definition file
__envHEREDOC__
}
helpawk(){
cat <<'__envHEREDOC__'
SPECIFY FIELD SEPARATOR
        awk --field-separator x '{ print $1 }'
PRINT LAST COLUMN
	$ svn info | grep 'Last Changed Rev:' | awk '{ print $NF }'
	> 1200
PRINT 11th TO-LAST COLUMN and __DO MATH__
   $ svn info | grep 'Last Changed Rev:' | awk '{ print $(NF-11)-5 }'
	> 1195
PRINT 2rd TO-LAST COLUMN
	$ svn info | grep 'Last Changed Rev:' | awk '{ print $(NF-1) }'
	> Rev:
PRINT 2nd COLUMN and ALL REMAINING COLUMNS
	# _note_ prob better off using `cut'
	$ echo 'one two three and to the fo' |  awk '{ for(i = 2; i <= NF; i++) { printf("%s ", $i) } printf("\n") }'
	> two three and to the fo
PRINT VARIOUS
	$ echo 'one t z' | awk '{ print $2 " " $1 }'
	> t one
ltrim( rtrim( $1 ) )
	awk  '{ gsub(/^[ \t]+|[ \t]+$/, "", $1); print $1 }'

prints "sector" followed by the next word(usually, a sector number) of an inputfile:
   e.g. : Feb 01 23:41:20 kernel: mmcblk0: error -110 transferring data, sector 91072737, nr 7, cmd response 0x900, card status 0x0
      would print "sector 91072737,"
        awk '{for(i=1;i<=NF;i++) if($i~"sector") printf $i" " $(i+1)"\n"}' inputfile
DELETE REMOVE LAST COLUMN
	awk 'NF{--NF};1'  < in
        awk 'NF{NF-=1};1' < in
        awk 'NF{NF--};1'  < in
__envHEREDOC__
}
helpawk2_isodatetime(){
cat <<'__envHEREDOC__'
Assume logfile like:
$ echo 'vm-hdp21-e1 2014-11-15 00:17:49 cpu  833884 0 194692 31984819 71236 4690 4618 24413 0
vm-hdp21-e1 2014-11-15 00:17:50 cpu  833896 0 194705 31985973 71247 4691 4619 24415 0
vm-hdp21-e1 2014-11-15 00:17:51 cpu  833915 0 194729 31987118 71247 4691 4619 24416 0
vm-hdp21-e1 2014-11-15 00:17:52 cpu  833930 0 194750 31988276 71248 4691 4619 24416 0
vm-hdp21-e1 2014-11-15 00:17:53 cpu  833992 0 194774 31989387 71248 4691 4619 24416 0
vm-hdp21-e1 2014-11-15 00:17:54 cpu  834028 0 194800 31990515 71248 4692 4620 24417 0
vm-hdp21-e1 2014-11-15 00:17:55 cpu  834114 0 194840 31991575 71253 4692 4620 24419 0
vm-hdp21-e1 2014-11-15 00:17:56 cpu  834220 0 194879 31992620 71253 4693 4620 24420 0
vm-hdp21-e1 2014-11-15 00:17:57 cpu  834328 0 194919 31993660 71253 4694 4621 24421 0
vm-hdp21-e1 2014-11-15 00:17:58 cpu  834415 0 194947 31994738 71253 4694 4621 24421 0
vm-hdp21-e1 2014-11-15 00:17:59 cpu  834507 0 194984 31995797 71256 4694 4621 24422 0
vm-hdp21-e1 2014-11-15 00:18:00 cpu  834578 0 195018 31996883 71303 4694 4622 24423 0
vm-hdp21-e1 2014-11-15 00:18:01 cpu  834631 0 195047 31997986 71311 4695 4622 24423 0
vm-hdp21-e1 2014-11-15 00:18:02 cpu  834650 0 195069 31999136 71311 4695 4622 24425 0
vm-hdp21-e1 2014-11-15 00:18:03 cpu  834693 0 195093 32000261 71311 4695 4622 24425 0
vm-hdp21-e1 2014-11-15 00:18:04 cpu  834714 0 195117 32001401 71311 4698 4623 24430 0
vm-hdp21-e1 2014-11-15 00:18:05 cpu  834749 0 195141 32002526 71316 4698 4624 24431 0
vm-hdp21-e1 2014-11-15 00:18:06 cpu  834765 0 195160 32003680 71316 4699 4625 24432 0
vm-hdp21-e1 2014-11-15 00:18:07 cpu  834775 0 195171 32004853 71316 4699 4625 24435 0
vm-hdp21-e1 2014-11-15 00:18:09 cpu  834784 0 195191 32006009 71322 4699 4625 24435 0
vm-hdp21-e1 2014-11-15 00:18:10 cpu  834811 0 195212 32007159 71322 4699 4625 24437 0
vm-hdp21-e1 2014-11-15 00:18:11 cpu  834823 0 195231 32008312 71328 4699 4625 24438 0
vm-hdp21-e1 2014-11-15 00:18:12 cpu  834836 0 195249 32009473 71328 4699 4625 24438 0' >logfile

and want to parse out only the lines that apply to the following timeframe:
* 2014-11-15 00:17:59 (start time)
* 2014-11-15 00:18:08 (ending time; ! NOTICE ! this exact timestamp DNE in log data!)

could use awk to do this with:
$ cat logfile | \
	awk '{ if ( ( $2 " " $3 >= "2014-11-15 00:17:59" ) && ( $2 " " $3 <= "2014-11-15 00:18:08" ) ) { print $0 } }'

= See also =
* http://stackoverflow.com/questions/17557377/do-a-grep-of-a-group-of-files-about-a-range-of-dates-in-bash
__envHEREDOC__
}
helpsetuid(){
	echo "from stat /muzik-work/: Access: (2775/drwxrwsr-x)"
}

helprsync(){
cat <<'__envHEREDOC__'
--itemize-changes : ( see also : --info=FLAGS ) produces that splendid little LHS of hashing applicability marks representing some attribute that has [not] changed for each file syustem object.
   UPDATE TYPES
      ~ A < means that a file is being transferred to the remote host (sent).
      ~ A > means that a file is being transferred to the local host (received).
      ~ A c means that a local change/creation is occurring for the item.
      ~ A h means that the item is a hard link to another item (requires --hard-links).
      ~ A . means that the item is not being updated (though it might have modified attributes).
      ~ A * means that the rest of the itemized-output area contains a message (e.g. "deleting").

   ATTRIBUTES
      ~ A c means either that a regular file has a different checksum (requires --checksum).
      ~ A s means the size of a regular file is different and will be updated by the file transfer.
      ~ A  t means the modification time is different and is being updated to the senders value (requires --times). (see man page regarding times and symlink issues).
      ~ A  T means that the modification time will be set to the transfer time.
      ~ A p means the permissions are different and are being updated to the senders value (requires --perms).
      ~ An o means the owner is different and is being updated to the senders value (requires --owner).
      ~ A g means the group is different and is being updated to the senders value (requires --group)
      ~ The u slot is reserved for future use.
      ~ The a means that the ACL information changed.
      ~ The x means that the Extended Attribute information changed.

--checksum : have used this to detect file differences (especially in xls / Excel
    Spreadsheet files) that werent detected, otherwise.

== Dont Forget... ==
AFAIK, when --stats, --human-readable are reported, it is done so using SI-notation (base-10) (uses powers of 1000).
as opposed to (e.g.)
how the _du_ command measures and reports --human-readable, which is in base-2 (uses powers of 1024).

== -E, --executability ==
Does the -a, --archive option implicitly do this or not?

* -a is supposed to preserve -p, --permissions (or access bits), which is what defines
a files executability, so Im not sure what the purpose of -E is... if only to
say like rsync -E: to preserve ONLY the executability and not -p, --perms, for
instance.... idk.
* man page also says -a performs some kind of compression, but doesnt
mention --compress as one of the options that -a is an alias for....
__envHEREDOC__
}

helprsyncexamples(){
cat <<'__envHEREDOC__'
Misc:
        --omit-dir-times
	--stats --human-readable --progress
Opts to capture *as much as possible* (acls, hard, xatt,...):
	rsync --archive --xattrs --acls --hard-links  \
		/home/mydir/data/ /backups/data-20080810/
Data Integrity, at expense of: time increase, i/o increase:
	--checksum
Data Integrity:
	--inplace --ignore-times
BU an rsnapshot root/repo (hard links):
	rsync -a --hard-links --delete /mnt/rsnapshot/ /mnt/rsnapshot_bu1/
Common; useful for diffing:
 Slow. Use when want to be sure data is exact, bit for bit.
	rsync -av --delete --stats --progress --human-readable --xattrs --hard-links /le/src/ /and/dest/ --checksum    --dry-run
Common-2; useful for diffing;
 Fast. Use when want quick results.
 When permissions (own,grp,access) and modification times can be ignored.
 Rsync basically just looks at file sizes.
	rsync -av --delete --stats --progress --human-readable --xattrs --hard-links /le/src/ /and/dest/ --no-checksum --dry-run --no-owner --no-group --no-perms --no-times
Opts to specify OpenSSH, login:
	rsync -av -e "ssh -i ~/.ssh/aaliyah.id_rsa -l aaliyah" hostname:/host/path/ /local/path/
	rsync -av -e "ssh -l phife-dawg"  phife-dawg@queens-server:. /tmp
Opts to OpenSSH to machine as yourself while executing rsync with sudo so can e.g. update an /etc/ file:
   SUDO LOCALLY REQUIRED:
	sudo rsync -av -e "ssh -i /home/phife-dawg/.ssh/id_rsa" [phife-dawg@]queens-server:/etc/ansible/hosts /etc/ansible/hosts
   SUDO REMOTELY REQUIRED:
	rsync --rsync-path='sudo rsync' -av KeyStore.jks [phife-dawg@]queens-server:/etc/pki/java/KeyStore.jks
Copy all dirs ONLY (i.e. exclude everything that is not a directory):
   rsync -av   -f"+ */"   -f"- *"   src  dest

Opts to OpenSSH running on custom port 443:
	rsync -av -e "ssh -p 443 -l phife-dawg"  phife-dawg@queens-server:. /tmp
Synchronize Last Modified times for Directories, e.g. from previous Dropbox.off/ (which has times want to transfer) to new Dropbox/ (which has, presumably, all the same exact times, that is, times that Dropbox created them, which would all be the same and probably very recent):
# first, generate a list of directories under Dropbox.off:
find ~/Dropbox.off -type d | sed -e 's/Dropbox.off\///' > Dropbox.off-directory-listing.log
rsync -t  --files-from=Dropbox.off-directory-listing.log  Dropbox.off/ Dropbox/ -i --existing -n
__envHEREDOC__
}
helprename(){
cat <<'__envHEREDOC__'
GENERAL USAGE : rename [ -v|--verbose ] [ -n|--no-act ] [ -f|--force ] perlexpr [ files ]

== rename v1 (non-regex) ==
$ rename "intel_duo" "intelduo" intel*

== rename v2 (regex) ==
$ rename 's/REGEX/REPLACE/' files
__envHEREDOC__
}
helprenameexamples(){
cat <<'__envHEREDOC__'
== Rename v1 (non-regex) ==
---------------------------
# Insert to the beginning: zero padding::
$ rename "" 0"" [0-9]     # desired behaviour: mv [0, 1, 2] => [00, 01, 02]

$ disk="${TOP_LEVEL_DIRECTORY}/${CHILD_DIR_PREFIX}"
$ rename "$disk" "$disk"0 "$disk"?
$ [[ $diskCount > 99 ]] && rename "$disk" "$disk"0 "$disk"??


== Rename v2 (regex) ==
-----------------------
$ rename -v 's/\ HEAD//' intelduo\ bookmarks-201*
intelduo bookmarks-2012-01-12 HEAD.json RENAMED AS intelduo bookmarks-2012-01-12.json
intelduo bookmarks-2012-01-13 HEAD.json RENAMED AS intelduo bookmarks-2012-01-13.json

$ rename -v 's/2005/2005 [ISBN 159159159X]/' book\ of\ eli\ 2005.pdf
book of eli 2005.pdf RENAMED AS book of eli 2005 [ISBN 159159159X].pdf

$ rename -v 's/\.bak$//' *.bak    # Strips the extension from all "*.bak" files.
le-file.txt.bak RENAMED AS le-file.txt

$ rename -v 'y/A-Z/a-z/' *           # Translate uppercase names to lower.

$ rename -v 's/(\....$)/__insert-txt-at-4-positions-from-the-end__$1/' le-file.txt
le-file.txt RENAMED AS le-file__insert-txt-at-4-positions-from-the-end__.txt

# Zero-pad image files:
$ rename -v 's/-(\d)-/-00$1-/' *.jpg
wasacomadago232-9-lg.jpg RENAMED AS wasacomadago232-009-lg.jpg

# Insert todays (ISO) date to the beginning (of all matching file names):
$ rename -v "s//$( date +'%Y-%m-%d' ) /" [0-9]*.*
127.18 RENAMED AS 2013-05-31 127.18
17.94  RENAMED AS 2013-05-31 17.94

# Append '.pdf' to the end (of all matching file names):
$ rename -v 's/(.*)/$1.pdf/' [0-9]*.*
2013-05-31 127.18 RENAMED AS 2013-05-31 127.18.pdf
2013-05-31 17.94  RENAMED AS 2013-05-31 17.94.pdf

# Move text from end to beginning:
$ rename -v -n 's/^(.*)-(2013-\d\d-\d\d)$/$2-$1/' the-name-2013-10-29
the-name-2013-10-29 RENAMED AS 2013-10-29-the-name

$ rename -v 's/^(.*)(2013-\d\d-\d\d).pdf$/$2_bge.$1$2.pdf/' -n *pdf  # for monthly statements

# Replace auto-enumerated filename with absolute filename:
$ rename -n -v 's/hdp13-a./hdp13-a1/' *-a[^1]\).png
2013-06-25-CHOSEN)_(on_vm-centos6-hdp13-a2).png RENAMED AS 2013-06-25-CHOSEN)_(on_vm-centos6-hdp13-a1).png
2013-06-25-n_vm-centos6-hdp13-a3).png           RENAMED AS 2013-06-25-n_vm-centos6-hdp13-a1).png
2013-06-25-on_vm-centos6-hdp13-a7).png          RENAMED AS 2013-06-25-on_vm-centos6-hdp13-a1).png
__envHEREDOC__
}



helpe2fsck(){
	cat <<'__envHEREDOC__'
$ e2fsck -f -y -v /dev/DEV        # what gParted uses.
$ e2fsck -f -y -v -C 0 -c device  #	Force, assume Yes, Verbosity, C=progress bar, c=badblock check+add
$ e2fsck -f -y -v -C 0 -D device  # Optimize directories in filesystem.
__envHEREDOC__
}



helprpm(){
cat <<'__envHEREDOC__'
$ rpm -ihv --nodeps rpmfile # forces an rpm installation (I think)
$ rpm -qa *PACKAGE_NAME*    # search installed rpm packages for PACKAGE_NAME
$ rpm -qa --last            # gives packge & date modified
$ rpm -qip rpmfile          # display details for the rpm file rpmfile (use -p for file)
      --filesbypkg          # list all the files in package (use -qi for package)
$ rpm --erase rpm

Extract rpm contents:
$ rpm2cpio rpm | cpio -idmv

= See also =
helpyum
__envHEREDOC__
}
helpyum(){
cat <<'__envHEREDOC__'
== Misc ==
yum --releasever=6.3 update  # update to minor release 3, of major release 6.

yum deplist package       # returns what is needed by package.

# If have list of packages/rpms and want to know the dependencies of each package,
echo 'list-of-packages.rpm
some-other-package.rpm
another-rpm-package.rpm' | sed 's/.rpm//' | xargs --verbose -n 1 -I {} yum deplist {} [>> deplist.log 2>&1]

# EPEL repo
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# To hold (to use deb terminology) or lock a package from being updated, append the following line
# to /etc/yum.conf under [main] section to lock e.g. php and nginx:
exclude=php* nginx*

== Determine which package provides a file ==
Find which package provides a file that is already on system (or not on the system):
$ yum provides /etc/hadoop/conf.empty/mapred-site.xml
hadoop-1.2.0.1.3.0.0-107.el6.x86_64 : Hadoop is a software platform for processing vast amounts of data
Repo        : HDP-1.3.0
Matched from:
Filename    : /etc/hadoop/conf.empty/mapred-site.xml

hadoop-1.2.0.1.3.0.0-107.el6.x86_64 : Hadoop is a software platform for processing vast amounts of data
Repo        : installed
Matched from:
Other       : Provides-match: /etc/hadoop/conf.empty/mapred-site.xml

== Troubleshooting ==
Error: Cannot retrieve metalink for repository: epel. Please verify its path and try again
1. use HTTP (not HTTPS):
sudo sed -i "s/mirrorlist=https/mirrorlist=http/" /etc/yum.repos.d/epel.repo
2. dont use mirror list:
uncomment first line beginning like "baseurl"
comment first line beginning like "mirrorlist"

TODO STUB: whats the path to the files that should be deleted when yum db or whtaever gets corrupted???

== Specific version of a package, Install ==
yum --showduplicates list httpd | expand
yum install <package name>-<version info>
yum install java-1.8.0-openjdk-headless-1.8.0.65-2.b17.7.amzn1.x86_64

== yum history ==
# list transaction id's for previous yum operations:
yum history
# undo a previous yum operation
yum history undo <transaction id>

= See also =
helprpm
__envHEREDOC__
}

helpvim(){
   (
	cat <<'__envHEREDOC__'
STOP IT, NANO! (use vim by default (see also: helpvisudo)): couple of options::
$ select-editor
$ sudo apt-get purge nano

SITES && CHEATSHEETS
http://vim.wikia.com
http://www.worldtimzone.com/res/vi.html

NOTES
:<c-d>                              # shows all of the available options that you can set
:se nonu                           # disable line numbering
:se relativenumbering               # enable relative line numbering
:set                                 # show ALL The Things that are set'ted in curr vim env
:map                                 # show ALL The Things that are map'ped in curr vim env
:se mouse=                          # stop vim from taking OS clipboard (was probably :se mouse=a)

# http://www.thegeekstuff.com/2009/04/vi-vim-editor-search-and-replace-examples/
# '%' is a shortcut for '1,$' (beginning to start). .
:[range]s/foo/bar/gc                # Change each 'foo' to 'bar', but ask for confirmation first
:%s/foo/bar/g                       # Find each occurrence of 'foo', and replace it with 'bar' starting at ln1
:.,$s/foo/bar/g                     # Find each occurrence of 'foo', and replace it with 'bar' starting from curr location
\c                                  # CASE INSENSITIVE searching
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

UNDO/REDO CURSOR MOVE
* c-o/c-i

VISUAL / BLOCK EDIT MODE : c-v (to go into mode), then select cols/rows where want to...
* I - Insert Text
** I
** type in text want to enter
** ESC (or c-c) to apply
* d - Delete Text
* D - Cuts text... in an Overwrite-kind of mode... (lines are not deleted)
** similarly, when time to paste, it does so like Overwrite
* > - Shift right / Indent Text
** indent once: >
** indent thrice: 3>
* < - Shift left / UnIndent Text
* ~ - Switch Case
* U - toUpper convert visual selection: gU
* u - toLower convert visual selection: gu

INSTANT MANPAGE DOCUMENTATION FOR CURR CMD CURSOR IS ON
	K
UPPER && LOWER CASING
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

:se completefunc=     # disable autocompletion
__envHEREDOC__
) | less --no-init
#) |& less -F;
}
helpvim2(){
      cat <<'__envHEREDOC__'
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
__envHEREDOC__
}
helpvim3(){
      cat <<'__envHEREDOC__'
* ~/dotfiles/home-machines/.vim/bundle/.vundle/script-names.vim-scripts.org.json
** GINORMOUS list (JSON) of what looks like various COOL functionality enabling vim scripts!
** ( calling `grepdotfiles collection' used to dump it to the screen hhehe... took screenshot ~/Dropbox/db.misc-linuxish/2012-10-05_script-names.vim* )

* ~/.ssh/other-ppls-pubs/ark
* Filesystem Path Autocompletion:
** start off with an absolute or valid relative path such as:
*** /e
*** ~/.
** then, while still in insert mode, do c-x c-f and a menu list of files appears>
** c-n will advance selection.
__envHEREDOC__
}
helpvim4(){
      cat <<'__envHEREDOC__'
* zz  - center vim display about the cursor
* c-y - scroll up 1 line without moving the cursor

* Trim trailing whitespace
** :%s/\s\+$//
** :%s/\s\+$     (substitution text can be limitted if blank)
* Search[/Replace]: show more context when reviewing matches
** :se scrolloff=5 - prior to searching or put to vimrc
* Effectively insert "|-" in between every other line:
** :%s/\n/\r|-\r/gc
* Insert at beginning of every line:
** :%s/^/aaatttt begininnnnnnning /gc
* Insert at end of line:
** :%s/$/ endddddd aattttt/gc
* Work with ^ control characters
** c-v (which modifies/prepares the next input...) then, the control character desired.
*** e.g. control M : c-v c-m

* Misc regex
** escapes some commas and does stuff with quotes (csv-related):
*** :%s/^\(.[^,]*\),\(.[^,]*\)/\1,"\2"/gc
** joins a line onto the previous one if it doesnt start with a pipe (mediawiki table-related):
*** :%s/\n\([^|].*\)\+$/\; \1/gc
** Converts '$key<TAB>description with spaces' into MediaWiki hyperlink:
*** :%s/^\(.[^\s]*\)\t\(.*\)$/[\/\/le-wiki-domain.org\/wiki\/\1\/ \2]/gc
*** e.g. "GUAC<tab>Get the guacamole out of your ears"
           -> [//le-wiki-domain.com/wiki/GUAC/ Get the guacamole out of your ears]
** :%s/^\([^p]\|p\([^r]\|r\([^o]\|$\)\|$\)\|$\).\+$/#####\0/gc
*** matches (and comments out) all lines NOT beginning with "pro" (which is short for proxy)
__envHEREDOC__
}
helpvim5_macros(){
      cat <<'__envHEREDOC__'
* Select all and then put into OS's clipboard (copy) (this also puts content into the "yank" buffer--as if you said 'y' instead of '"+y'):
** ggVG
** "+y
* Macro Recording:
** qq   	- start recording to register q
** ...   - your complex series of commands
** q     - stop recording
** @q    - execute your macro
** @@    - execute your macro again
__envHEREDOC__
}
helpvim6(){
      cat <<'__envHEREDOC__'
Tim:  fancy
was making a list in vim, wanted to prefix a bunch of items with a nice number
like
1. Blah
...
then i got to 10
now i want it to do nice spacing like
9.  Blah
10. Barf
turns out vim can do variable and function interpolation in its commands
so say you want to number the visually higlighted region, can do
:let i=1
:'<'>g/^/s//\=printf('%-4s',printf('%d. ',i))/ | let i+=1
not exactly "simple"
like it's a bit lengthy but not too tough if you do it only once in a while
__envHEREDOC__
}
helpvim7(){
      cat <<'__envHEREDOC__'
# WINDOW SPLITTING AND EDITING
c-w    - switch between splits.
:S     - splits curr screen and (!) presents view of cwd... which you can scroll(!) through and hit enter to open the desired file!
:Se    - splits curr screen and i guess _e_ means edit the curr opened file.
c-shift-9 - split vertically
__envHEREDOC__
}
helpvim8_bashlikecodecompletion(){
      cat <<'__envHEREDOC__'
src : https://superuser.com/questions/575085/bash-like-code-completion-in-vim
:se completeopt=menu,longest

while in Insert mode, can do variable completion with c-n
__envHEREDOC__
}
helpvimdiff(){
      cat <<'__envHEREDOC__'
COPY LEFT / RIGHT
* do - Get BLOCK changes from other window into the current window.
* dp - Put the BLOCK changes from current window into the other window.

* c-v - to make NON BLOCK changes (more granular) go into visual mode to select the line(s) desired, followed by ":diffput" or ":diffget".

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
* :se diffopt+=iwhite - ignore whitespace
** vimdiff -c 'se diffopt+=iwhite'
__envHEREDOC__
}
helpxargs(){
	cat <<'__envHEREDOC__'
== Examples ==
Execute chkconfig for a bunch of services at once:
$ echo bluetooth iscsi iscsid lvm2-monitor notExecuted |\
	xargs --verbose -n 1 -i{} --delimiter=' ' chkconfig --levels 123456 {} off

Execute lines from a file:
$ cat /some/FILE | xargs --verbose -L 1 -i{} bash -c {} --another-optional-arg

Join a BUNCH of lines together that has new lines, leading spaces, etc. to a SINGLE line:
$ echo "
  mtr combines the functionality of the 'traceroute' and 'ping' programs
  in a single network diagnostic tool.

  As mtr starts, it investigates the network connection between the host
  mtr runs on and a user-specified destination host." | xargs echo
mtr combines the functionality of the traceroute and ping programs in a single network diagnostic tool. As mtr starts, it investigates the network connection between the host mtr runs on and a user-specified destination host.

Busy the processor:
seq 1 | xargs -n1 -P1 yes > /dev/null

Busy the processor that can execute 8 threads (e.g. 8 cores):
seq 8 | xargs -n1 -P8 yes > /dev/null
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
   (
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

ARCHIVE EXAMPLE5
perhaps want to exclude some huge directory:
   rar a -m5 -r -rr4p -t -tsmca -ep1 -x/mnt/tmp/rhapsody/ 2011-08-03_cell-phone-backup.rar /mnt/tmp/
__envHEREDOC__
) | less --no-init
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
	  rar a -apDOCS\ENG release.rar readme.txt   # Add readme.txt to the directory 'DOCS\ENG'.
     rar x -apDOCS release DOCS\ENG\*.*         # Extract 'ENG' to the current directory.

EXTRACT
   -kb keep broken extracted files
	-ad append archive name to destination path
   rar x archive.rar

EXTRACT TO STDOUT
   rar p archive.rar                            # "Print file to stdout".

EXTRACT EXAMPLE0
Generate checksum based on rarchive's contents.  by default, rar prints out bunch of other cruft, so simply doing the following will result in an invalid checksum:
   rar p fsimg.ext4.dd.rar | pv -pterab | sha1sum         # BAD.
Here's some ways to get the checksum you probably intend to get (i.e. 'tar zxfO x.tar.gz | sha1sum'):
   rar p -ierr fsimg.ext4.dd.rar | pv -pterab | sha1sum   # Send all msgs to stderr (actual archive content goes to stdout).
   rar p -idcdpq fsimg.ext4.dd.rar | pv -pterab | sha1sum # Disables all types of messages ; -id[c,d,p,q].
   rar p -inul fsimg.ext4.dd.rar | pv -pterab | sha1sum   # Disables all messages.

TEST EXAMPLE0 (base case)
   rar t [v[t|b]] [-pPASSWD] archive.rar
TEST EXAMPLE1 (N+1)
(sudo access was reqd in example environment)
   for i in *.rar ; do echo $i; sudo su -c "time rar t $i > $i.test.log" ; echo ; echo ; done
TEST EXAMPLE2 (N+2) with auto-repair exec upon test failure
(sudo access was reqd in example environment)
   for i in *.rar ; do echo $i; sudo su -c "time rar t $i > $i.test.log"; rc=$? ; if [[ $rc != 0 ]] ; then echo "WARNING rc[$rc] was non-zero for rar test. calling rar repair."; sudo su -c "time rar r -y $i > $i.repair.log"; rc=$?; if [[ $rc != 0 ]] ; then  echo "ERROR rc[$rc] was non-zero for rar repair <exclamation>"; fi; fi; echo; done

REPAIR EXAMPLE0 (base case)
   rar r -y archive.rar                         # The -y(es) is important!
REPAIR EXAMPLE1 (N+1)

UPDATE EXAMPLE0 (base case)
add file to specific location within a pre-existing archive (keep orig archive time (alt. -tl : set time to latest file)).
must specify archive creation options... it doesnt seem to persist the original archive's properties--if you just add a file, for example, and it previously had a recovery record set--its lost--and the only way to get a recovery record generated for the final updated rarchive, you must define it.
   rar u   [-ap<PATH INSIDE ARCHIVE TO USE>]   -m5 -rr4p -t -tsmca   -tk   archive.rar   file1[ file2[...]]
UPDATE EXAMPLE1 (N+1)
   rar u   -ap.   -m5 -rr4p -t -tsmca   -tk   2011-08-03_23.18.01.rar   2011-08-03_23.18.01.NOTE.txt
UPDATE EXAMPLE2 (N+2)
??? do you have to say "-ep1" too in this case???? to avoid having "ARCHIVES-TESTED-FAILED/rearchived/" folders created within the archive?? that I just want to add a single stupid file to?
   rar u   -ap.   -m5 -rr4p -t -tsmca   -tk   ARCHIVES-TESTED-FAILED/rearchived/2011-08-03_23.18.01.rar   2011-08-03_23.18.01.NOTE.txt
UPDATE EXAMPLE3 (N+3)
   rar u   -apmnt/intelduo-s/tmp/rearchive/2011-08-03_23.18.01/   -m5 -rr4p -t -tsmca   -tk   rearchived/2011-08-03_23.18.01.rar  ../2011-08-03_23.18.01.NOTE.txt
__envHEREDOC__
}
helpless(){
	cat <<'__envHEREDOC__'
less -r      # dont drop any colors.

== Keyboard usage ==
* show nfo: ^G
* jump to line number, "N", with: Ng
** ex: ln88 : 88g

== Customizing coloring ==
Show the effective __values__ of the TERMCAP variables...
$ env | grep LESS_TERMCAP | cat

Show the effective __color(ing)__ of the TERMCAP variables...
$ env | grep LESS_TERMCAP | cat

Capture the values of the TERMCAP variables:
$ env | grep LESS_TERMCAP >/tmp/values-of-termcap-variables.txt

Notable configs:
* /etc/profile.d/less.sh

== See also ==
* goog"less termcap"
* helptail
__envHEREDOC__
}



helptune2fs(){
	cat <<'__envHEREDOC__'
tune2fs $DEVICE -l | grep -iP 'mount|check'  # Display mount counts && checks info.
tune2fs $DEVICE -m 0                # Set %'age of reserved FS space to 0 (default=5).
tune2fs -c 5 -i 5d $DEVICE          # Check every MIN(5 mounts or 5d).
tune2fs -C 5 $DEVICE                # Sets mount count to 5 so that check is at least forced, soon.
tune2fs -e remount-ro $DEVICE       # Change errors behaviour.
tune2fs -c 5 -i 5d -e remount-ro -m 1 -L LBL $DEVICE

== SNIPPETS ==
gives only ext4 filesystem subdevice fs meta:  df --type=ext4 | sed "1d"
gives only ext4 filesystem subdevices:         df --type=ext4 | sed "1d" | awk '{ print $1 }'

for DEVICE in $( df --type=ext4 | sed "1d" | awk '{ print $1 }' ); do
   echo $DEVICE
   sudo tune2fs -c 5 -i 5d $DEVICE
   sudo tune2fs -C 5 $DEVICE
done
__envHEREDOC__
}



helpssh(){
	cat <<'__envHEREDOC__'
$ ssh
	[-D localhost-proxy-port-to-use]
	[-N] # Do not execute a remote command; useful when forwarding ports; use with -D
	[-p ssh-server-port-to-connect-with]
	[-i identity_file]   # NOTE: file mode bits should be 400
	[user@]host1

== FINGERPRINTs ==
ssh-keygen -l -f  private-OpenSSH-key
# get fingerprint of each line of public key:
cat ~/.ssh/authorized_keys | xargs -n1 -I% bash -c 'ssh-keygen -l -f /dev/stdin <<<"%"'


== Convert putty-formatted public key to OpenSSH ==
ssh-keygen -i -f ssh2.pub > openssh.pub

== AGENTs ==
$ exec ssh-agent bash
or
$ eval $(ssh-agent)
$ env | grep ^SSH           # Ensure SSH_AUTH_SOCK defined?
$ ssh-add ~/.ssh/some-key   # If so, then can add keys!

== Faster X-forwarding ==
Instead of
$ ssh -2XC  host
do...
$ ssh -XC -c blowfish-cbc,arcfour  host

== Keyboard shortcuts / hotkeys pertaining to the terminal ==
(ya I know this is not to do with ssh, but thought this was best place to put this note)
* c-s pauses the terminal
* c-q resumes the terminal

== Escape character sequences (defaults) ==
NOTE: the following escapes are only recognized  ¡¡immediately!!  after a  NEWLINE / ENTER.
  ~.  - terminate session (thats: enter, squigly, and then dot) http://superuser.com/a/98565
  ~#  - list forwarded connections
  ~B  - send a BREAK to the remote system
  ~R  - Request rekey (SSH protocol 2 only)
  ~?  - this message
  ~~  - send the escape character by typing it twice
== ControlMaster and multiplexing ==
Sometimes a want to connect to a machine with a brand new connection, i.e. not using the existing connection
that may exist if already connected to said machine and have ControlMaster'ing enabled.

To force a brand new, fresh connection, use:
  -S none
__envHEREDOC__
}
helpsshX(){
cat <<'__envHEREDOC__'
== RHEL-based systems ==
: src : http://serverfault.com/a/425413
1) Install the following:
xorg-x11-xauth
xorg-x11-fonts-*
xorg-x11-utils
2) Enable the following in the sshd_config file
X11Forwarding yes
3) Use an appropriate X-Server on your desktop
__envHEREDOC__
}
helpssh2(){
cat <<'__envHEREDOC__'
$ ssh -o "ForwardAgent=yes" remote.local
$ ssh -D 9797 remote.local  # set up a proxy on localhost using port 9797.
$ cssh --options "-o ForwardAgent=yes" host1 [host2 [hostN]]

Connect to a commonly accessible server from a non-commonly accessable server in order to allow for creation of a tunnel:
( -R : Specifies that the given port on the remote (server) host is to be forwarded to the given host and port on the local side. )
[you@non-commonly-accessable-server] $ ssh -A common.server.com [-p 443] -R 7777:localhost:22
Now can connect to non-commonly accessible server from a third machine via common.server.com with:
$ ssh -Aq common.server.com nc localhost 7777

Setup a local port that connects to a remote machine:
( -L : Specifies that the given port on the local (client) host is to be forwarded to the given host and port on the remote side. )
ssh -A remote-machine  -L 7780:localhost:22

Setup a local port that RDP's to a machine only accessible on the same network as the machine to which youve ssh'd to:
ssh -A network1-machine1  -L 7778:network1-machine2-w7:3389
... then can RDP to: localhost:7778
__envHEREDOC__
}
helpsshconfig(){
cat <<'__envHEREDOC__'
Host dethklok-cluster-server216
User nathan-explosion
StrictHostKeyChecking no

If wish to disable hosts key checking globally for a machine, adding
StrictHostKeyChecking no
to /etc/ssh/ssh_config works mmkay.
__envHEREDOC__
}
helpuseradd(){
	cat <<'__envHEREDOC__'
sudo useradd [--home=/home/<username>] --create-home [--password=<passwd>]  <username>
	NOTE value for SHELL in /etc/default/useradd

Create users on a machine with pre-defined uid, gids (esp. useful if restoring
files from a tar backup or need to explicitly define such things):
# assume uid=gid=1003 and login is mfdoom::
$ sudo groupadd --gid 1003 mfdoom
$ sudo useradd --create-home --uid 1003 --gid 1003 mfdoom
__envHEREDOC__
}
helpnetwork(){
cat <<'__envHEREDOC__'
arp -v                              # get mac address from ip address. ping it first. only works if both hosts are on the same network, if it is in a virtual network for example it will not work.

ip neigh                     # useful little summary of network neighborhood.

"You can add that network ip address (thats not in the networks range) to
another machine on the network and try to get at it... i forget how to do
it in linux but you can do like
  ifconfig eth0 172.27.8.13 alias
to get on a second network with the same interface."

# what is my ip?
dig +short myip.opendns.com @resolver1.opendns.com
curl ifconfig.me             # whatismyip?
curl icanhazip.com           # whatismyip?
curl ident.me                # whatismyip?
curl ipecho.net/plain        # whatismyip?
curl whatismyip.akamai.com   # whatismyip?
curl tnx.nl/ip               # whatismyip?
curl myip.dnsomatic.com      # whatismyip?
curl ip.appspot.com    	     # whatismyip?
curl ip.telize.com     	     # whatismyip?
curl curlmyip.com      	     # whatismyip?
curl -s checkip.dyndns.org | sed 's/.*IP Address: \([0-9\.]*\).*/\1/g'   # what is my ip?

== iperf ==
Do 16 simultaneous transfer streams to $client for 10s:
[server] iperf -s                       # Server-side
[client] iperf -c $client -P 16 -t 10   # Client-side

Validate dual-10gigabit bonded bridge on server gives a summed total thruput near 20Gb/s:
[server1] iperf -s                      # Server-side
[client1] iperf -c $client -P 16 -t 10  # Client-side
[server1] iperf -s --port 7001          # Server-side
[client2] iperf -c $client --port 7001 -P 16 -t 10  # Client-side; NOTICE this is different client!

Measure time to (TCP) transmit 124GiB:
[server] iperf -s                       # Server-side
[client] iperf -c $client --num 133143986176  # Client-side

== See also ==
helpnetwork2
helpnetstat
helpnslookup
helpnmap
helparping
helpreversetunnel
helpip
/etc/udev/rules.d/70-persistent-net.rules
helpsysfs
helppktstat nmcli iptraf nethogs vnstat nmon
http://ubuntuforums.org/showthread.php?t=2172359 - noteworthy troubleshooting cmdlns.
__envHEREDOC__
}
helpip(){
	cat <<'__envHEREDOC__'
ip a [sh eth0]        # like ifconfig -a [eth0]
ip maddr show [eth0]  # ~~show associated mac addresses [corresponding to this interface, eth0]~~
                      # ^^lol, no. idk what this is showing.
ip link show [eth0]   # show mac address among other nfo [corresponding to this interface, eth0]
ip -f link addr show    # (same)
ip -family link addr show  # (same)
ip addr show [eth0]
ip -family inet addr show

ip l                  # show link level information for all devices
ip -o[neline] l       # show link level information for all devices, one device per line.
ip link show [eth0]   # show link level information [for eth0]


# Get MAC address for eth0 device:
ip -oneline link show eth0  |  awk '{ print $(NF-2) }'
# lol which can also be expressed like:
ip -o l sh eth0  |  awk '{ print $(NF-2) }'

# Get Subnet mask for eth0 device:
ip a sh eth0 | sed -n -e "3p" | awk '{ print $2 }'
or
ip -o a sh eth0 | sed -n -e "2p" | awk '{ print $4 }'
# ...get for all devices [excluding IPv6]:
ip -o a sh | grep inet[^6]

# Get list of all devices/interfaces (ONLY)
ip -o l | awk '{ print $2 }' |  sed -e 's/://'

# Get route table:
ip route list

# Delete an entry in the route table:
sudo ip route delete 192.168.0.0/16

# Create a direct connection between two nics: an example::
   first:
      ip ad add 10.0.0.1/24 dev eth1
      sudo ifdown eth1 ; sudo ifup eth1
   second:
      ip ad add 10.0.0.2/24 dev eth1
      sudo ifdown eth1 ; sudo ifup eth1

# Disassociate an ip from ethernet device: an example::
ip ad del 192.168.0.70/24 dev eth1

# to resolve issues around ifup and ifdown'ing, e.g.:
   $ sudo ifdown br0
   ifdown: interface br0 not configured
   $ sudo ifup br0
   RTNETLINK answers: File exists
   Failed to bring up br0.
# try this instead:
sudo ip link set br0 down
__envHEREDOC__
}
helpnetwork2(){
cat <<'__envHEREDOC__'
/usr/share/doc/bridge-utils/README.Debian
interfaces(5)
bridge-utils-interfaces(5)

/etc/network/interfaces  an example
   iface eth0 inet static
      address 10.100.10.200
      netmask 255.255.255.0
      network 10.100.10.0
      gateway 10.100.10.1

/etc/network/run/ifstate
/etc/network/run/ifup.br0

sudo ifdown br0
sudo service network-manager restart

sudo ifconfig up eth0
sudo ip link delete br0

= When system is idiot and denies network restart =
# for me, this generally seems to be caused by the same thing. I think the solution is:
# realize that the system is in funky state. Fix it by changing the eth in question (eth1)
# in /etc/network/devices like:
   auto eth1
   iface eth1 inet dhcp
# then run:
   sudo ifup [-v] eth1
# now can go back into /etc/network/interfaces and modify eth1 defn as desired. then can run:
   sudo ifdown eth1 ; sudo ifup eth1

= Not sure if this is still relevant =
# Seems that if you dont do the following when doing funky stuff with hardline ethernet
# wires, network, have to hard stop machine so that the eth card can reset:
sudo ifconfig eth0 down
# <funk, it is safe to do some at this time>
sudo ifconfig eth0 up

= See also =
http://unix.stackexchange.com/questions/50602/cant-ifdown-eth0-main-interface
helpip
__envHEREDOC__
}
helpreversetunnel(){
	cat <<'__envHEREDOC__'
Killing a previously created reverse tunnel connection which now has State=CLOSE_WAIT:
* sudo netstat -e -p --protocol=inet   # only interested in Active Internet connections (w/o servers).
* look for entries where Local Address is localhost:8051 (which is what I commonly use as the reverse tunnel connection port).
** and where State=CLOSE_WAIT
** note the pid given in the PID/Program column
** kill this pid.
* return to where reverse tunnel is initiated (i.e. remote machine) and re-create connection.
__envHEREDOC__
}
helpnetstat(){
	cat <<'__envHEREDOC__'
# Show open connections
netstat -e
# Show open connections specifically for ftp
netstat -e | grep ftp
# Show *T*cp ports being *L*istened to
netstat -tl
# Sort of like a "top" for network connections made (is not actively refreshed, new output is generated every so many seconds):
netstat -tcp -apc 10

# Show *N*umeric *T*cp ports being *L*istened to along with responsible *P*ID:
sudo netstat -tlnp

# Show *A*ll opened *N*umeric *T*cp ports:
netstat -ant
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
helpnmap(){
cat <<'__envHEREDOC__'
Listing all Linux servers which are up in a network:
$ nmap [-v] -sP <Network info>  # <nw nfo> can be a whole network (say 10.10.22.0/24) or range (say 10.10.22.1-40).
NOTE: this cmdln didn't seem to pick up my Fedora machine...
 is RHEL set to not respond or something?
 --> SEE helparping() for locating firewalled hosts.

Scan the entire network (.1/24), trying the specified port:
$ nmap [-v] -p 623 192.168.1.1/24


HTTPS/SSL/TLS-related things ( works with at least nmap-7.25BETA1-1.x86_64.rpm )
Shows copious infomation about certificate, encryption protocols, and ciphers in use:
$ nmap --script ssl-cert,ssl-enum-ciphers -p 6182,443,55-100 host

# Test UDP port 123 ( NTP ) is open on a host:
sudo nmap -v -sU -p 123 host
# Test UDP port 53 ( DNS ) is open on a host:
sudo nmap -v -sU -p 53 host
# Test UDP port 53 ( DNS ) is open on a host, which currently looks closed:
# : "Note: Host seems down. If it is really up, but blocking our ping probes, try -Pn"
sudo nmap -v -sU -p 53 host -Pn
# Test that NTP is running on UDP port 123:
nmap -sU 10.10.10.10 -p 123            ==> port 123 is for NTP and '-sU' is for scanning UDP ports.

# Scan a host for UDP services
nmap -sU <host/ipaddr>


Find probable Linux machines on the network:
for i in $( nmap -sP -n --osscan-guess 10.100.10.0-199 | grep "report for" | awk '{print $NF}' ) ; do
   nc -vnw 1 $i 22 >/dev/null 2>&1
   [[ $? = 0 ]] && echo $i is a linux box
don

= See also =
helpopenssl helpnc
__envHEREDOC__
}
helparping(){
cat <<'__envHEREDOC__'
$ arping 192.168.1.1          # Useful for locating / pinging/ firewalled hosts.
__envHEREDOC__
}
helppktstat(){
cat <<'__envHEREDOC__'
# basic usage
sudo pktstat -i eth0

# increases refresh rate
sudo pktstat -i eth0 -w 1

# a single-shot mode which runs without screenoutput for -w seconds, quits and displays overview of connections
sudo pktstat -i eth0 -1 -w 10

== See also ==
iftop trafshow
__envHEREDOC__
}


helpgit(){
	cat <<'__envHEREDOC__'
# git-clean - Remove untracked files from the working tree (useful when working in a src code directory and want to clean it all up)
git clean -fx
git ls-files --directory --others --exclude-from=.git/info/exclude
find . -name \*.deps\*   # in some circumstances, might find some garbage.

= CONFIG =
git config --local               # read and write from the repo's .git/config (DEFAULT).
git config --list                # show all settings.
git config --list --show-origin  # ~ + their originations.
git config --global user.name [] # show [or set] this.
git config --global user.email

git config --replace-all ...
git config --unset ...
git config --unset-all ...

git config --add user.email "nobody@some-bodys.domain"
git config --add user.name "some body"

= LOGs =
* There are separate fields for ppl...
** "Author" - the person who created the change, and
** "Committer" - the person who committed the change into the repository.
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
* Create and checkout temp branch based on <start point>
** git checkout -b temp 5af8b9e

* Push local branch to upstream branch / remote origin (creates remote branch if DNE):
** git push origin e1999eternal-branch

* Make local branch track an upstream branch
** git branch --set-upstream e1999eternal-branch origin/e1999eternal-branch
   git push   --set-upstream origin e1999eternal-branch

* Create a local branch based on an upstream branch:
** ~~~~git branch --track my_branch origin/my_branch
** git checkout --track origin/REL1_30

* Delete remote branch
** git push origin :my_branch

* rename (... MOVE) local branch (implies: + the corresponding reflog):
** git branch -m

== branching example (create new branch, push upstream and track) ==
newBranchName=
git co -b  "${newBranchName}" \
 && git push origin  "${newBranchName}" \
 && git push --set-upstream origin "$newBranchName"
# && git branch --set-upstream  "${newBranchName}"  origin/"${newBranchName}"


= TAGs =
* Create
** git tag -m <msg> <tagname> [<commit>]
* Push local tags upstream
** git push --verbose --tags
* Delete remote tag named 12345
** git push origin :refs/tags/12345

* Print most recent tag
** git describe

* Print tags along with date
** git log --tags --simplify-by-decoration --pretty="format:%ai %d"
* Print tags along with date plus pretty ascii graphy!
** git log --tags --simplify-by-decoration --pretty=format:'%ai %h %d'  --date-order --graph
* Print tags along with date and sha1 AND commit comment:
** git log --decorate=full --all --pretty=format:'%h %d %s %cr %ae' --abbrev-commit|grep 'refs/tags'
* Print tags along with date and sha1:
** git log --date-order --tags --simplify-by-decoration --pretty='format:%C(green)%ad %C(red)%h %C(reset)%D' --date=short

= IGNOREing =
http://www.randallkent.com/development/gitignore-not-working
or?
git update-index --assume-unchanged
^^ya I think this workd

= Cloning over ssh port 443 =
git clone ssh://user@host:443/absolute/path/to/repo.git

= Get a patch/diff file for a single commit / applying some random commit elsewhere =
# The following approach came in handy when I wanted to __backport__ a small
# but very important change in a codebase...
#   First, identified the sha of very important change, then supplied it:
git format-patch -1 1f5c1872
#   ^^This will generate a new file, a patch file.
#   Second, apply the patch to the code that needs it:
git apply --verbose <previously generated patch file>
# Patch wont apply if there were any prior patch errors.
# check out --exclude option to ignore possible fail files and have it keep trying.

== Similarly, for a stash... ==
git stash show -p
git stash show -p  stash@{1} > patch.txt  # e.g. ... .

# but also note, git actually creates commit objects when you stash.
# They are commits like everything else. You can check them out in a branch:
git checkout -b with_stash  stash@{0}
__envHEREDOC__
}
helpgit2(){
      cat <<'__envHEREDOC__'
= STASHes =
Respect staged and unstaged shtuff

: src : http://mikemabey.blogspot.com/2016/03/using-git-stash-without-losing-staged.html
# stash unstaged:
git stash save --keep-index "Un-staged changes"
# stash staged:
git stash save "Staged"

# Now is when you want to do any work you need to while the other changes are
# stashed. NOTE: If you need to make changes that are based on a file in the
# "Un-staged changes" stash, you will of course need to pop that stash specifically
# with git stash pop stash@{1}. But, in order to get the staged changes back,
# you'll need to do another git stash save to do things in the correct order.

# unstash stuff that BELONGS IN STAGED:
git stash apply
# All the changes you just popped AREN'T STAGED at this point but should
# be, so go ahead and add all of them to the index with git add file1 file2 ...
git status --short | grep -P '^ M' | sed -e 's/^ M//' | xargs -n 1 -I{}  git add "{}"
   TODO STUB : ^^test this on file set that has one or more files with spaces or weird characters.
# similarly, for removed files:
git status --short | grep -P '^ D' | sed -e 's/^ D//' | xargs -n 1 -I{}  git rm "{}"

# if stash applied correctly, delete it:
git stash drop
# unstash stuff unstaged stuff (stuff stashed in the very first step):
git stash apply
# if stash applied correctly, delete it:
git stash drop

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

= DIFFs, important =
* git diff <from> <to>          # diff FROM <from> commit TO <to> commit
* Useful when want to review the actual content brought in i.e. MERGED IN from a branch.
** git di <2nd newest commit> <newest commit>   # (see example-above)
* git di <branch1 name> <branch2 name>
* git di <branch name> <current branch>
* git di <branch name>          # same as above ("TO" branch implied to be current branch)

= DIFFs, less important =
Override the default diff context...
... surrounding functions of changes:
$ git diff [-W, --function-context]
... between two chunks:
$ git diff --inter-hunk-context=<lines>
... overall:
$ git diff --unified=33
__envHEREDOC__
}
helpgit3(){
      cat <<'__envHEREDOC__'
= COMMIT MODIFICATION =
== modify last commit ==
a.  $ git reset --soft HEAD^
b.  Make desired modifications.
b2. Do a `git add' to pull in modifications made in step b., if needed. (step c. does not stage anything "for" you!)
c.  $ git commit -C ORIG_HEAD  # or use -c to indicate you DO want to edit commit msg

== modify any commit ==
Using the commit hash prior to the commit you want to modify, run:
m=         # sha of commit you want to modify.

a. $   git rebase --interactive ${m}^ # ${parent_commit_of_commit_to_be_modified}

b. change leading text to  edit  for each commit you want to modify, or
   change leading text to reword for each commit MESSAGE you want to modify.

c. make desired changes. (do a git add to stage it, if thats what youre doing). then change your commit history with:
      c. make desired changes. (~~~~do a git add to stage it, if thats what youre doing~~~~). then change your commit history with:

d. $   git commit -a --amend
      AFTER git add FILE THAT WANTED TO BE MODIFIED...
      d. $   git commit -a --amend   # ? not sure if behaviour of "-a" has changed in newer versions of git ? gives empty commit prompt.
      or
      d. $   git commit --amend      # gives expect prepopulated commit prompt.

e. once committed, you want git to re-apply the history that's in front of the commit you just over wrote, so run:

f. $   git rebase --continue

g. if you're modifying >1 commit (which you would have specified in b.),
g1. GOTO c.
g2. ELSE finished

== revert hunk of any commit ==
* src && see also http://bit.ly/GVnJWt
** http://bit.ly/HevPZ9  http://bit.ly/GVYk3l
* $ git checkout --patch [<tree-ish>] [--] [<paths>...]
__envHEREDOC__
}
helpgit4(){
      cat <<'__envHEREDOC__'
= Get diff b/w all the commits that occured b/w two dates? =
	http://stackoverflow.com/q/1161609
$ git diff-tree -p HEAD           # INCORRECT get diff (in patch format) between unstaged and HEAD commit
$ git diff-tree -p HEAD           # get diff (in patch format) between HEAD^ and HEAD (and in that order)

= How to retrieve the last modification date of all files in a git repository? =
	http://serverfault.com/q/401437
$ git ls-tree -r --name-only HEAD | while read filename; do
  echo "$(git log -1 --format="%ad" -- $filename) $filename"
  # echo "$(git log -1 --format="%Cgreen(%ci)%Creset %d" -- $filename) $filename"  # alternative format--iso
done

= Submodules, working with =
# A repo is cloned which contains a sub-repository or sub-module.
git clone http://git.wikimedia.org/git/mediawiki/skins.git
# Notice, there is basically nothing in the "skins" repo as far as code and content goes:
find skins | head
skins
skins/DuskToDawn
skins/Tempo
skins/Dusk
skins/sync-with-gerrit.py
skins/BlueSky
skins/chameleon
skins/Empty
skins/Vector
skins/Example
# However, what is included are references to other repositories (the "submodules").
# To get *all* the top-level/current working directory's submodules content, do:
git submodule update --init *
# To get not only the top-level/current working directory's submodule content but
# if any of those submodules have-yet-their own submodules, get those as well (and
# so on):
git submodule update --init --recursive
# To get a particular submodules content, do:
git submodule update --init Dusk

== See also ==
- gitman - aims to serve as a submodules replacement and provides advanced options for managing versions of nested Git repositories.
-- https://gitman.readthedocs.io/en/latest/
__envHEREDOC__
}
helpgit5(){
      cat <<'__envHEREDOC__'
= Fix "non-bare" upstream git repo =
For instance, may be receiving this when trying to push changes upstream:
	http://stackoverflow.com/questions/2199897/how-to-convert-a-git-repository-from-normal-to-bare
		remote: error: refusing to update checked out branch: refs/heads/master
		remote: error: By default, updating the current branch in a non-bare repository
		remote: error: is denied, because it will make the index and work tree inconsistent
		remote: error: with what you pushed, and will require 'git reset --hard' to match
		remote: error: the work tree to HEAD.
		remote: error:
		remote: error: You can set 'receive.denyCurrentBranch' configuration variable to
		remote: error: 'ignore' or 'warn' in the remote repository to allow pushing into
		remote: error: its current branch; however, this is not recommended unless you
		remote: error: arranged to update its work tree to match what you pushed in some
		remote: error: other way.
		remote: error:
		remote: error: To squelch this message and still keep the default behaviour, set
		remote: error: 'receive.denyCurrentBranch' configuration variable to 'refuse'.
		To git.doctor-doom.com:./repos/ServletFilter.git
...^^it's resolvable in the following way *AND ALSO ASSUMING* that the original upstream
repo's config file holds nothing special (which i *think* is the common case):
$ git clone --bare [--no-hardlinks --verbose] /path/to/repo  [/path/to/new/repo]

The reason this happened is basically because the repo was not created like so in the first place:
$ git init --bare

General steps to fix:
$ cd repo
$ mv .git .. && rm -fr *
$ mv ../.git .
$ mv .git/* .
$ rmdir .git

$ git config --bool core.bare true
$ cd ..; mv repo repo.git # renaming just for clarity
__envHEREDOC__
}
helpgitsvn(){
cat <<'__envHEREDOC__'
Creates (new git repo) folder: trunk
$ git svn clone svn://svn/de/trunk/ -T proj/mvin -b proj-branches/mvin -t proj-tags/mvin

Creates (new git repo):
$ git svn init https://yohai.example.com/svn/Project/trunk/subproject.....
$ git svn fetch
__envHEREDOC__
}
helpgit6(){
cat <<'__envHEREDOC__'
? How to get tags from upstream repo, so I can (e.g.) check it out, if have a clean clone of (upstream) master?
List available tags:
$ git tag [-l -n]
Checkout one of the available tags
$ git checkout [TAB-TAB] <one of the tag names>

? How to list branches from upstream repo?
$ git branch -r
Alternatively:
$ git remote show origin
$ git ls-remote --heads origin  # Seems to print all remote tags
$ git ls-remote --refs origin   # Prints even more than --heads.

? How to get current git repository's root path?
: src : man git-rev-parse
git rev-parse --show-toplevel

? How to change upstream/repository URL?
git remote set-url origin <new url>
Assuming cwd is the repository root directory, can probably do:
base=$( basename $PWD ) ; git remote set-url origin git@git.bitbucket.wmanalytics.io:${base::2}/${base}.git

? How to *move* an entire unrelated git repository into another, while retaining history?
To limit the contents being moved to only a subdirectory or file within the repo to be moved check out:
   https://www.simplicidade.org/notes/2009/04/21/merging-two-unrelated-repositories/
To move *everything* from one repo to another, check out:
   http://bpeirce.me/moving-one-git-repository-into-another.html

# Get a revision log for each individual file: (the IFS part is necessary if any file has a space in it)::
SAVEIFS=$IFS ; IFS=$(echo -en "\n\b")
for i in $( find . -type f | grep -v .git) ; do
   echo "$i"
   git log --pretty=format:'%Cgreen  %s %Creset' $i
   echo
done
IFS=$SAVEIFS

__envHEREDOC__
}
helpgitterminology(){
cat <<'__envHEREDOC__'
If don't use git super often, sometimes forget what some of the basic terms mean.  Here's some topics that need notes on them...
* index
** full-index (seen in git-diff)
* tree'ish
* working tree
** ?same as? working directory
* refs
** ?same as? references
* reflog
* wip/WIP: work in progress.

* cached vs staged or unstaged (what is cached an alias for?)
__envHEREDOC__
}


helptree(){
      cat <<'__envHEREDOC__'
# Works:
$ tree --charset=${LANG}

# Perhaps more portable?  idk...  both have worked when tree is
# executed via putty. Without --charset, putty displays garbage.
$ tree --charset=en_US.UTF-8
__envHEREDOC__
}
helpps(){
	cat <<'__envHEREDOC__'
== Misc ==
$ ps L | sort -k2       # List format codes, sorted by rhs (rhs
                        # has many dupes, lhs has none).
$ ps -fp $( pgrep str ) # -fp gives relevant nfo on only PIDs you want.
$ ps fww -fp $( pgrep str ) # -fp gives relevant nfo on only PIDs you want.
$ ps fwww $( pgrep str) # use instead of -fp if want lines to wrap.

$ ps ww PID             # use if need lines to wrap.
$ ps ww $( pgrep str )  # use if need lines to wrap.

== Examples ==
$ ps axfww              # Execution str nfo, in tree form.
$ ps axl

$ ps -f -p PID...       # Nfo for PID(s).
                        # Nfo in user-defined formats:
$ ps -p PID... -o pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:14,comm
$ ps -p PID... -o stat,euid,ruid,tty,tpgid,sess,pgrp,ppid,pid,pcpu,comm
$ ps -p PID... -o pid,tt,user,fname,tmout,f,wchan

$ ps aux | awk '$8 ~ /D/   # show processes in the 'D' state.

= See also =
iostat helppidstat helprenice
http://xmodulo.com/how-to-checkpoint-and-restore-linux-process.html - uses criu, crtools
__envHEREDOC__
}
helppidstat(){
      cat <<'__envHEREDOC__'
pidstat -p pid -d -u -h 5
* for pid...
** display io statistics
** display cpu statistics
** display all on a single line
** ...every 5s

= See also =
iostat helpps helprenice
__envHEREDOC__
}
helppatch(){
      cat <<'__envHEREDOC__'
= v1 =
# Create patch: to apply changes going from "INITIAL" -> to "FINAL" content
$ diff -c START_FILE END_FILE > patch
$ diff -c INITIAL_FILE FINAL_FILE > patch
$ diff -c OLD_FILE NEW_FILE > patch
	diff -c bash_user_dev.env.production bash_user_dev.env > bash_user_dev.env.patch
# Apply patch
$ patch --input=patch
 	patch --input=bash_user_dev.env.patch
 	patch --verbose --input web.xml.patch $TOMCAT_HOME/webapps/portal/WEB-INF/web.xml
	patch --verbose --ignore-whitespace --input patch  applesmc.c

= v2 (svn) =
(src: http://incubator.apache.org/jena/getting_involved/index.html)
# Create patch
$ svn diff > JENA-XYZ.patch
# Apply patch (MAXIMUM compatibility, doesnt seem to allow line numbers to differ)
$ patch -p0 < JENA-XYZ.patch
# Apply patch ((slightly less) MAXIMUM compatibility, allows line numbers to differ)
$ patch -p1 < JENA-XYZ.patch
__envHEREDOC__
}
helpsed(){
cat <<'__envHEREDOC__'
== MISC ==
: src : http://austinmatzko.com/2008/04/26/sed-multi-line-search-and-replace/
$ sed -n -e "<LINE NUMBER>p"        # print a specific line
$ sed -n -e "<STARTING LINE NUMBER>,<ENDING LINE NUMBER>p"  # print a range of lines
$ sed -n -e "3p" -e "3p" /etc/hosts # print /etc/hosts:ln3, twice
$ sed 's/[ \t]*$//'                 # trim trailing whitespace
$ sed 's/[ \t]*$//;s/^[ \t]*//'     # trim leading and trailing whitespace
$ sed '/^$/d'               # delete blank lines
$ echo /e/s/conf | sed "y/\//|/"    # transliterate src to dest
  `--> |e|s|conf
$ sed 'N;s/\n/\t/'          # join alternate lines/join every 2 lines ( 'N' joins 2 lins.  Then replace the newline with a tab. )
$ sed 's/\(\/\w\+\/[a-z]\+\)\(.\)*/\1/'  # gives root device, /dev/xyz ( not subdevices, /dev/abc55 )
$ sed -n -e "/regex/p"              # sed like grep.

== SNIPPETS ==
# Parse text between two delimiters or markers (START and END):
sed -n "/START/,/END/{
/START/d
/END/d
p
}"  [/path/to/file]

# COPY SYSTEM FILE (e.g. rsyslog) and rename by dotifying original
# files full path (1: repeat path; 2: "/" -> "."; 3: remove leading "." (if E)):
$ echo /etc/sysconfig/rsyslog | \
>  sed   -e 1p   -e "s/\//./g"   -e "s/\//./g" | \  # <-- 1,2,3
>  xargs --verbose  cp --preserve --no-clobber --verbose
  `--> $ cp --no-clobber --preserve --verbose /etc/sysconfig/rsyslog etc.sysconfig.rsyslog
         `--> `/etc/sysconfig/rsyslog' -> `etc.sysconfig.rsyslog'

# For specified /etc/hosts line numbers and excluding lines fully commented, sort
# the ip addresses:
sed -ne '150,298p' /etc/hosts | sed -n 's/#//p' | sort

# Improves on prev by starting from a $matching_string until the EOF:
starting_line=$( grep '# This /etc/hosts entry block Last Modified:' /etc/hosts --line-number | cut -f1 -d ':' )
sed -ne ''${starting_line}',$p' /etc/hosts | sed -n 's/#//p' | sort
# or:
sed -ne "${starting_line},\$p" /etc/hosts | sed -n 's/#//p' | sort
# (depending on how you want to quote)

# To remove the line containing a pattern and print the output:
sed '/pattern to match/d' infile
# For example, removes any line containing "//":
sed "/\/\//d" infile

# Prepend/insert text/a line to a file
sed -i "1i Prepended line" /tmp/newfile

# Print the previous line for the specified matched pattern:
sed -n '/PATTERN TO MATCH/{x;p;d;}; x' infile

# Print all except the first line, except the first two lines
sed -e '1,1d'
sed -e '1,2d'

== FIND/REPLACE ==
# PREVIEW find/replace on files:
sed -n "s/192.168.8.3/bryn-pc/gp" file1 [fileN]
. . ^. . . . . . . . . . . . ^
# DO find/replace on files:
sed -i "s/192.168.8.3/bryn-pc/g" file1 [fileN]
. . ^

# HELPFUL for changing all the [fileN]'s:
grep -R --files-with-match PATTERN [PATH] | xargs --verbose -n 1 <sed STUFF>
# PREVIEW:
sed -n "s/frommmmmm/tooooooo/gp" $( grep --files-with-match frommmmmm $( find PATH -type f ) )
# DO:
sed -i "s/frommmmmm/tooooooo/g" $( grep --files-with-match frommmmmm $( find PATH -type f ) )
__envHEREDOC__
}
helpaptitude2(){
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


== NOTES FOR YOU == http://www.cyberciti.biz/tips/linux-debian-package-management-cheat-sheet.html

== MOAR NOTES FOR YOU == http://www.cyberciti.biz/ref/apt-dpkg-ref.html
aptitude remove                           # Remove packages.
aptitude purge                            # Remove packages and their configuration files.
aptitude search ~ahold                    # Show held packages
dpkg -l | grep ^h                         # Show held packages

== Misc ==
aptitude --disable-columns search zfs     # Disable automatic string formatting wrt window size.
aptitude search .*-desktop
apt-get download --download-only kino     # e.g.
dpkg -i --force-all debfile               # Forces an installation.


== See packages installed compared to whats in a clean install? ==
: src : https://askubuntu.com/q/462577

apt-show-versions | grep 'No available version'   # Show all package not coming from repo
aptitude search '~o'                              # Similar

apt-show-versions | grep -v uptodate      # All packages that are not up-to-date

apt-show-versions -a $(apt-show-versions | grep -v uptodate | sed -r 's/:.*//')

deborphan -a                              # List all packages that have no reverse dependencies

__envHEREDOC__
}
helpbash(){
cat <<'__envHEREDOC__'
== modulus/modulo to get random sleep time within 0,10s ==
sleep $(( $RANDOM % 10 ))

# Alternatively, can specify a lower bound, e.g. at least 15s but not more than 45s:
sleep $( clac.py "15 + $(( $RANDOM % 30 ))" )

loopcounter=0
while true ; do
   echo $loopcounter
   [[ $(( $loopcounter % 2 )) = 0 ]] && echo even number
   let loopcounter+=1
done

== set -o ==
allexport             histexpand            noexec                pipefail
braceexpand           history               noglob                posix
emacs                 ignoreeof             nolog                 privileged
errexit               interactive-comments  notify                verbose
errtrace              keyword               nounset               vi
functrace             monitor               onecmd                xtrace
hashall               noclobber             physical

== shopt ==
autocd                   direxpand                gnu_errfmt               nocaseglob
cdable_vars              dirspell                 histappend               nocasematch
cdspell                  dotglob                  histreedit               no_empty_cmd_completion
checkhash                execfail                 histverify               nullglob
checkjobs                expand_aliases           hostcomplete             progcomp
checkwinsize             extdebug                 huponexit                promptvars
cmdhist                  extglob                  interactive_comments     restricted_shell
compat31                 extquote                 lastpipe                 shift_verbose
compat32                 failglob                 lithist                  sourcepath
compat40                 force_fignore            login_shell              xpg_echo
compat41                 globstar                 mailwarn

== typeset ==
SEE helptypeset()  (its not 'typedef' ! lol u confused?)

== Misc ==
-n   : Syntax Check, e.g. `bash -n shell-script-file-to-be-syntax-checked.sh'
-x   : xtrace
-o option-name : enable option-name, e.g. `set -o xtrace'
+o option-name : disable option-name, e.g. `set +o xtrace'

== Shell Variables (built-in's) ==
FUNCNAME :  An array variable containing the names of all shell functions currently in the execution call stack.  The element with index 0 is the name of any currently-executing shell function.

== man-Page-Massiveness Shortcuts (GNU Bash-4.1) ==
* ~ln3050: section:: SHELL BUILTIN COMMANDS
* ~ln3900: buildin cmd:: set
* ~ln4400: end section:: SHELL BUILTIN COMMANDS
* ~ln

== Execute an already defined function within subshell and use output ==
use the "eval" command (not expr, not exec):

== See also ==
[[Shell bash]]
helpIFS
helptypeset helpcommand helpenv
vttest - program for testing the VT100 compat of terminal emulators.
vtutils - utils for testing and working with virtual terminals.
__envHEREDOC__
}
helpbashstrings(){
cat <<'__envHEREDOC__'
# Assuming the following variable is set...:


$ kv='database_hostname=The-Hive-RRRROLOLOLOOOL'


# ...this will be the output:
#      (for more nfo::`man bash'-->'Parameter Expansion')
$ echo "${kv%%The-Hive-RRRROLOLOLOOOL}"   # get the LHS of the string, get the key, silence the right side.
database_hostname=

$ echo "${kv##database_hostname=}"        # get the RHS of the string, get the value, silence the left side.
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

$ echo ${kv::1}                           # get the first character
d

$ echo ${kv: $(( ${#kv} - 1 )) : 1 }      # get the last character
L


for i in FFFFFF.txt GGGGG.txt ; do
   echo ${i%%.txt}                        # without filename extension
done
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
helpbashexamples(){
cat <<'__envHEREDOC__'
== Finer grained file listing ==
[doctor-doom@slum-village ~]$ ll vpn*.png
-rw------- 1 doctor-doom doctor-doom 311713 06-12 17:08 vpn1.png
-rw------- 1 doctor-doom doctor-doom 279958 06-12 17:08 vpn2.png
-rw------- 1 doctor-doom doctor-doom 278065 06-12 17:08 vpn3.png
-rw------- 1 doctor-doom doctor-doom 312449 06-12 17:09 vpn4.png
-rw------- 1 doctor-doom doctor-doom 312425 06-12 17:09 vpn5.png
-rw------- 1 doctor-doom doctor-doom 322594 06-12 17:09 vpn.png
What if I don't want vpn3.png in the listing?  Can also do:
[doctor-doom@slum-village ~]$ ll vpn{,1,2,3,4,5}.png
-rw------- 1 doctor-doom doctor-doom 311713 06-12 17:08 vpn1.png
-rw------- 1 doctor-doom doctor-doom 279958 06-12 17:08 vpn2.png
-rw------- 1 doctor-doom doctor-doom 278065 06-12 17:08 vpn3.png
-rw------- 1 doctor-doom doctor-doom 312449 06-12 17:09 vpn4.png
-rw------- 1 doctor-doom doctor-doom 312425 06-12 17:09 vpn5.png
-rw------- 1 doctor-doom doctor-doom 322594 06-12 17:09 vpn.png

Not limited to just file listing.  Can also do:
$ cssh hadron-collider-node{1,2,3,4}


== Variable defining ==
nodevs=$(< /proc/filesystems awk '$1 == "nodev" { print $2 }')

== In-line control structures ==
wget -qO /dev/null 'http://webserver/some_existing_short_document.html' || {
    echo "Webserver down"
    # another mailer example
    sendemail -s mailserverip -f 'from@localhost' -t 'user@localhost' -u 'Webserver down' -m 'The webserver is down'
}
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

List device labels according to device name:
$ ll /dev/disk/by-label/ | sort -k10
__envHEREDOC__
}
helpzip(){
cat <<'__envHEREDOC__'
zip zipfile file1 [file2 [...]]
unzip -d extractiondirectory zipfile

zip -sf|--show-files archive.zip   # list or [S]how [F]iles ; === tar tfv archive.tar
zip -T|--test        archive.zip
zip -o                             # always overwrite files.

# Extract a set of zipfiles, each to its own directory:
for i in zipfiles* ; do d="${i%%.zip}"; echo $d; mkdir "$d"; unzip "$i" -d "$d"; done

== See also ==
helpgpg() for info on creating an encrypted zip file.
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
helpaptitude(){
cat <<'__envHEREDOC__'
== List all installed packages ==
dpkg -l                       # all packages, including depenancies.
/var/lib/apt/extended_states  # Auto-Installed: 0 indicates that the package was expressly installed and is not just a dependency.
(zcat $(ls -tr /var/log/apt/history.log*.gz); cat /var/log/apt/history.log) 2>/dev/null |
  egrep '^(Start-Date:|Commandline:)' |
  grep -v aptdaemon |
  egrep -B1 '^Commandline:'   # To list all packages intentionally installed (not as dependencies) by apt commands
                              # This provides a reverse time based view, with older commands listed first

== Removing packages ==
The following package was automatically installed and is no longer required:
  linux-image-3.2.0-34-generic
Use 'apt-get autoremove' to remove them.

== [un]hold a Package ==
# Hold:
echo synergy hold | sudo dpkg --set-selections  # This will get applied to apt-get's db as well as aptitude's.
# Unhold:
apt-mark unhold synergy                         # This will get applied to apt-get's db as well as aptitude's.
# [Un]Hold:
aptitude [un]hold synergy                       # This will NOT get applied to apt-get's db; only aptitude's.

== hold multiple Packages ==
# If theres like 5 packages that match the query, 4.15.0-29-generic, and all should be held:
aptitude --disable-columns search  '~i4.15.0-29-generic'  | awk '{print $3}' | xargs -n 1 -I{} echo {} hold | sudo dpkg --set-selections

== SEARCH + SHOW PACKAGE(S) NFO GIVEN A SEARCH STRING ==
aptitude search PACKAGE | awk '{ print $2 }' | xargs --verbose  aptitude show | less
apt-cache madison ^apache2     # See WHICH VERSIONS of apache2 ARE AVAILABLE
apt-cache showpkg apache2
apt-cache policy apache2       # what does it want to upgrade to?
apt-get install ansible=2.2.1.0-1ppa~precise   # install a specific version
apt-get install apache2=2.2\*  # Install a specific version found in previous cmdln...
apt-get install apache2=2.2.20-1ubuntu1
dpkg -l 'apache2*' | grep ^i   # Check which version installed

==== NOTE ====
# apt-cache search also searches within package description.  aptitude does not unless search term
# prepended with ~d.

==== See also ====
* Search Term Reference : http://algebraicthunk.net/~dburrows/projects/aptitude/doc/en/ch02s03s05.html
* Cool aptitude search patterns : http://lwn.net/Articles/179754/

== Try to install package; fail if it cannot be perfectly installed ==
goldie@inst/xpra$ sudo dpkg --refuse-all --install 0.0.7.36/python-wimpiggy_0.0.7.36+dfsg-1_amd64.deb
goldie@inst/xpra$ sudo dpkg --refuse-all --install 0.0.7.36/xpra_0.0.7.36+dfsg-1_amd64.deb
goldie@inst/xpra$ echo xpra hold | sudo dpkg --set-selections
goldie@inst/xpra$ sudo aptitude hold xpra

== Package file info ( http://serverfault.com/a/96965 ) ==
# List files installed by a given package that is already on a system:
dpkg -L package
dpkg --contents package.deb

# List files installed by a given package that is _NOT_ currently on system:
apt-file list package


# Which package provides a file that is already on system:
dpkg --search /path/to/file
 ^^ !! NOTE !! if path is funky, undesired results;
         e.g. /path/to/file  matches  while  /path/to///file  does _NOT_ !!

# Which package provides a file that is _NOT_ currently on system:
apt-file search /path/to/file
__envHEREDOC__
}
helpionice(){
cat <<'__envHEREDOC__'
== EXAMPLES ==
=== Get class and priority ===
* ionice -p 89 91
** Prints the class and priority of the processes with PID 89 and 91.

=== Real time and Best effort scheduling classes ===
   This scheduling class can take a priority argument (i.e. -n [0-7]).
* ionice -c 2 [-n 7] svn up
* ionice -c2 -n7 -p $$   >/dev/null 2>&1
** Slowest in the Best effort scheduling class.
** Schedule I/O in the next best favorable manner that is one better Idle(which is the slowest).
** IOW, its just one notch above the slowest/worst.

* ionice -c 2 -n 0 svn up
** Fastest in the Best effort scheduling class.

* ionice -c 1 -n 7 svn up
** Slowest in the Real time scheduling class.
* ionice -c 1 -n 0 svn up
** Fastest in the Real time scheduling class.

=== Idle scheduling class ===
   This scheduling class doesn't take a priority argument (i.e. -n [0-7]).
* nice ionice -c 3 svn up
** run svn with low priority (+10 (`nice -10') is default (+20 being lowest priority)) and as an idle io process.

* nice -12 ionice -c 3 svn up
** nice: schedule cpu time in a somewhat unfavorble/slower manner.
** ionice: schedule io time in the absolute least favorable manner.

* ionice -c 3 -p 89
** Absolute slowest possible.
** Sets process with PID 89 as an idle io process.

== See also ==
helprenice2, helprenice
__envHEREDOC__
}
helpmvn(){
cat <<'__envHEREDOC__'
== MISC ==
$ mvn [options] [<goal(s)>] [<phase(s)>]  # Default.
$ mvn clean verify                        # Cleans, compiles, tests, zips, documents (at
                                          # least for jena-fuseki; not sure what "default" is).
$ mvn -Dmaven.test.skip=true [<goal(s)>] [<phase(s)>]  # SKIP TESTS
  $ mvn -Dmaven.test.skip=true  -Pfast  deploy
$ mvn archetype:generate                  # Generates a new project from an archetype.

$ mvn --update-plugins --update-snapshots clean install

== Using the Release plugin ==
$ mvn release:clean
$ mvn release:prepare
$ mvn release:perform

== Using other MISC plugins ==
$ mvn clean compile assembly:single

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

$ echo "dat filename..." | cut -c 1-7    # Print first 7 characters
dat fil

$ a="bind-key        C-a last-window"
.....1234567890123456789012345678901  # 0's position.
.....0000000001111111111222222222233  # 10's position.
.....________+++++++++++_+++++++++++.... # the fields to parse. the last field shoudl be parsed until EOL.
$ a="bind-key        C-a last-window"
$ echo "$a" | cut -c 1-8 # first field
$ echo "$a" | cut -c 9-19 or 20 # second field
 `--> a subsequent pipe to awk will do left and right trim:  awk '{ gsub(/^[ \t]+|[ \t]+$/, "", $1); print $1 }'
$ echo "$a" | cut -c 21- # third field

__envHEREDOC__
}
helpIFS(){
cat <<'__envHEREDOC__'
# This IFS stuff allows to handle file names with spaces in them:
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
#
i=0 ; for f in $( find . -maxdepth 1 -type f ) ; do    echo "$i $f";    let i=$i+1;     done
# ... output from looping over echo...
#
IFS=$SAVEIFS

echo -n "${IFS}" | sha1sum ; echo -n "${SAVEIFS}" | sha1sum ; echo -en "\n\b" | sha1sum
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

== CMDLN SILLIES ==
$ while true ; do dropbox status | xargs echo `date` ; sleep 4s ; done

== CRONTAB AUTOSTART ==
These are handy for headless machines.  For at least how I seem to always install Dropbox,
you must log in to a desktop environment (DE) for "autostart" features to execute. For
headless boxes, of course, Dropbox (not) autostart'ing is an issue. Here's some notes.

NOTE return status code is NOT following convension of a zero indicating success.

$ dropbox running && echo failure   - 'failure' is printed when Dropbox IS NOT running.
$ dropbox running || echo success   - 'success' is printed when Dropbox is running.

Crontab to periodically check that Dropbox is running:
# Everyday at 0830, start Dropbox if it is not already running:
30 8 * * * /home/i-accidentally/bin/dropbox running && /home/i-accidentally/bin/dropbox start  >/dev/null
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
Find files that contain "dependency" pattern, while specifying a filename pattern:
$ grep dependency $( find . -name pom.xml )

Edit pom.xml files that contain "opensocial" pattern:
$ vim $( grep --files-with-matches opensocial $( find . -name pom.xml ) )

Find files that contain an IP address:
$ grep -P '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$' $( find . -type f )

Find (potentially *many*) files that are less than 10M, for case-insensitive
search of "lolumad" (useful for targeting text files):
$ find . -type f -size -10M  -print0 | xargs -0 grep --null-data --files-with-match -i "lolumad"
  ^^if this dummy doesnt give results, I may not be using "-size" arg correctly... try this also:
$ find . -type f -not -size +10M  -print0 | xargs -0 grep --null-data --files-with-match -i "lolumad"

!!! (don't use "-size -1M" because that asks for files less than 1M which includes 0M and below) !!!

Print the line matching "lol jk....  Use it." plus the line that follows:
$ grep --after-context=1 "lol jk....  Use it."

# List all my current shell working directories:
lsof -u $USER | grep ^bash | grep cwd

== Syntax ==
$ ll /dev/disk/by-label/ | grep -P "mnt|Oa|Va"     # grep with regex.
$ yum deplist hadoop | grep --color -E 'hadoop|'   # Dear grep, Highlight, don't grep (!)

== See also ==
helpsed
the command "strings" searches binary files for strings >4 characters
__envHEREDOC__
}
helpcurl(){
cat <<'__envHEREDOC__'
curl --data @<file-containing-POST-data> <URL>  # Perform POST request
curl --silent whatismyip.org | xargs echo   # display WAN ipaddr

# --fail Fail silently (no output at all) on HTTP errors
# -o     Write output to <file> instead of stdout
curl  --connect-timeout 10  --fail  -o /dev/null www.example.org  >/dev/null 2>&1

# do a POST with the following key-value pairs:
curl x.com/some.php  -d key1=daniel  -d key4=ayyyfour

# yse cookies:
curl --cookie "key=value" url -o outfile
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
   (
cat <<'__envHEREDOC__'
== Lesser Known hdd-related cmds ==

== Is ISO File Bootable? (whether the ISO is an isohybrid) ==
# Check for the string 'Hidden HPFS/NTFS' in fdisk:
$ fdisk -l debian-testing-i386-netinst.iso
Device                          Boot      Start         End      Blocks Id  System
debian-testing-i386-netinst.iso   *           1         249      254944 17  Hidden HPFS/NTFS

== What kind of partition is it? (using tune2fs,ntfslabel) ==
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
$ dosfslabel <device> [LABEL]

== GET NFO ==
=== Which devices are seen? ===
$ ll /dev/disk/by-label/ | grep -P "mnt|Oa|Va"

=== /proc ===
/proc/partitions # Contains major and minor numbers of each partition as well as number of blocks and partition name.
/proc/scsi/scsi  # Listing of all SCSi devices known.


== MISC ==
findfs {LABEL=label | UUID=uuid}  # Identify device that matches query.
cfdisk          # Display or manipulate disk partition table.
cfdisk -P {r|s|t} # Print partition table/layout in 3 formats:
                #    r - Raw data format (exactly what would be written to disk)
                #    s - Partition table in sector order format (YOULL PROBABLY WANT THIS!)
                #    t - Partition table in raw format.
sfdisk          # Partition table manipulator for Linux.
fdisk           # Manipulate disk partition table.
gnu-fdisk       # Linux fdisk replacement based on libparted.
gdisk           # GPT fdisk text-mode partitioning tool.
parted          # Disk partition manipulator.
di              # Disk information util, displays more than df.
blockdev        # Call block device ioctls from the command line.
dmsetup         # Low level logical volume management.
fsfreeze        # Suspend access to a filesystem (Linux Ext3/4,
                # ReiserFS, JFS, XFS) (intended for hw RAID devices).

blkid           # Locate/print block device attributes like UUID and LABEL.
lsblk           # !!! List Block Devices.
findmnt         # !!! Prints all mounted FS's in tree-format by default.
disktype        # !!! Detect && display nfo about FS's, partitions, tables, etc.
hdparm          # Tune hard disk parameters for high performance.
                #   Get/set device parameters for Linux SATA/IDE drives.
                #   Primary use is for enabling irq-unmasking and IDE multiplemode.
                #   A utility for displaying and/or setting hard disk parameters,
                #   for instance, to spin down hard drives, tweak performance.
                #   Can be used to benchmark *AN UNMOUNTED* device : hdparm -t /dev/md0
sdparm          # List or change SCSI/SATA/ATAPI/CD/DVD disk parameters.
gpart           # Guess PC disk partition table, find lost partitions.
                #   Gpart is a tool which tries to guess the primary partition table
                #   of a PC-type disk in case the primary partition table in sector 0
                #   is damaged, incorrect or deleted.
                #   It is also good at finding and listing the types, locations, and
                #   sizes of inadvertently-deleted partitions, both primary and logical.
                #   It gives you the information you need to manually re-create
                #   them (using fdisk, cfdisk, sfdisk, etc.).
                #   The guessed table can also be written to a file or (if you firmly
                #    believe the guessed table is entirely correct) directly to a disk device.
partprobe -s    # Informs OS kernel of partition table changes, by requesting
                # that the OS re-read the partition table.
                #   -s Show a summary of devices and their partitions.
sginfo          # (scsi)
sg_scan [-i]    # (scsi)


== SEE ALSO ==
helplstopo helpblkid helppv helpinotify helphdparm
__envHEREDOC__
) | less --no-init
}
helphdd2_fs_related(){
cat <<'__envHEREDOC__'
Linux_disk_management wiki page    # See also : Linux_disk_management wiki page.

mkswap -L linuxswap DEVICE       # Create linux swap device.
mke2fs -L LABEL -t ext4 [-v] [-c [-c]] DEVICE  # Create ext4 filesystem.
dumpe2fs -h DEVICE               # Display info about filesystem (same as tune2fs -l).
resize2fs -p DEVICE              # Expands device to max, -p shows progress.
mkfs -t btrfs                    # Create btrfs filesystem.
mkntfs [-v] --label LABEL --quick DEVICE       # Create ntfs filesystem.
mkfs.vfat -n label DEVICE        # Create fat32 filesystem; useful for reformat thumb drive.
mkfs.exfat -n label DEVICE       # Create exFAT filesystem.
ntfscluster --info device        # NTFS info, block size (given as "bytes per cluster").

lsblk --nodeps --noheadings --output NAME      # List block devices (only) in the system.
__envHEREDOC__
}
helphdd3(){
cat <<'__envHEREDOC__'
# _disk_ block device type        vs.
# _partition_ block device type

== Device Labels Management ==
findfs (8)           - find a filesystem by label or UUID
ppmlabel (1)         - add text to a portable pixmap
mlabel (1)           - make an MSDOS volume label
dosfslabel dev lbl       - set or get MS-DOS filesystem label
e2label dev lbl           - Change the label on an ext2/ext3/ext4 filesystem
ntfslabel -v dev lbl        - display/change the label on an ntfs file system
swaplabel (8)        - print or change the label or UUID of a swap area
__envHEREDOC__
}
helphdd4(){
cat <<'__envHEREDOC__'
d=c7t1d0               # e.g. on Solaris.
d=/dev/sdc             # e.g. on Linux.
dnamefull=a107-2787
#dname=a107
dname=$( echo ${dnamefull} | cut --delimiter=- --fields=1 )

diskId=$dnamefull
subdevice=$( basename $d )1
subdevice=$( basename $d )2

== HDD Initialization Steps ==

 Important: If hdd will potentially be used on any special controller(s), IT
    MUST BE INITIALIZED NOW-on one of the controllers!!

=== Initialize / Create a Partition Table ===
==== using GPT / GUID ====
$ sudo parted $d

# Ideally, make GPT and/or EFI partition table:
#  ( !! if using ZFS, this must do !! )
(parted) mktable gpt

# Alternatively, make an mbr/dos/msdos partition table:
(parted) mktable msdos

(parted) mkpart primary ntfs 38912s 122879s

# Normally, use entire rest of hdd:
(parted) mkpart primary ext4 122880s 100%
# Alternatively, if you know there is hdd controller meta at tail end of drive:
(parted) mkpart primary ext4 118800s -5G


===== --script'ed version =====
# GPT:
sudo parted $d --script mktable gpt
# or DOS:
sudo parted $d --script mktable msdos
sudo parted $d --script mkpart primary ntfs 38912s 122879s
sudo parted $d --script mkpart primary ext4 122880s 100%

sudo parted $d --script mkpart primary ext4 122880s -5G

sudo mkfs.xfs -L ${dname} ${d}2
sudo mkfs.xfs -f -L $subdevice /dev/${subdevice}
sudo su -c "echo \"LABEL=${subdevice}             /mnt/${subdevice}              xfs     defaults,nofail,noatime,nodiratime        0 0\" >> /etc/fstab"
sudo mkdir /mnt/${subdevice}
sudo mount -v /mnt/${subdevice}



=== Create small ~30 || 39MiB partition+FS for label / disk identification
                  after about ~10 || 19MiB OR SO from the beginning of hdd
						                         to assist in hdd identification ===



==== using MBR ( <=2GiB ONLY ) ====
  //NOTE: if also create partition, skip to next section//
$ sudo fdisk $d
Command (m for help): o
 Building a new DOS disklabel with disk identifier 0xc2df6527.
 Changes will remain in memory only, until you decide to write them.
 After that, of course, the previous content won't be recoverable.

 Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

Command (m for help): w
 The partition table has been altered!

 Calling ioctl() to re-read partition table.
 Syncing disks.
$

=== Create small ~30 || 39MiB partition+FS for label / disk identification
                  after about ~10 || 19MiB OR SO from the beginning of hdd
						                         to assist in hdd identification ===
===== Typical Sizes of Disk Identification partition=====
30MiB: disktype and parted executions:
  Block device, size 30 MiB (31457280 bytes)
  Volume size 30.00 MiB (31456768 bytes, 61439 sectors)
 Number  Start           End             Size            File system  Name                          Flags
  3      2995701940224B  2995733397503B  31457280B       ntfs         Basic data partition /dev/sdg a71
  2      1997109460992B  1997140918271B  31457280B       primary  ntfs /dev/sde a81
  2      1997126238208B  1997157695487B  31457280B       primary  ntfs /dev/sdf a66
39MiB: disktype and parted executions:
  Block device, size 39 MiB (40894464 bytes)
  Volume size 39.00 MiB (40893952 bytes, 79871 sectors)
 Number  Start         End            Size           Type     File system  Flags
  1      19922944B     60817407B      40894464B      primary  ntfs /dev/sdd a21
  1      19922944B  60817407B      40894464B      primary  ntfs /dev/sdc a35
39MiB: `fdisk -l $device` execution:
    Device Boot      Start         End      Blocks   Id  System
 /dev/sdd1           38912      118783       39936    7  HPFS/NTFS/exFAT

===== Typical Sizes of 'beginning of the hdd' skippage =====
Number  Start         End            Size           Type     File system  Flags
19.00MiB: parted executions:
 1      19922944B  60817407B      40894464B      primary  ntfs    /dev/sdc a35
 1      19922944B     60817407B      40894464B      primary  ntfs /dev/sdd a21
1.00MiB: parted executions:
 1      1048576B        1997109460991B  1997108412416B  primary /dev/sde a81
 1      1048576B        1997126238207B  1997125189632B  primary  ext4 /dev/sdf a66
 1      1048576B       749990838271B  749989789696B  primary  ntfs /dev/sdh a17
 1      1048576B   41943039B   40894464B   primary  ntfs /dev/sdj sraid10
 1      1048576B       999604355071B  999603306496B  primary  ntfs /dev/sdk a49
 1      1048576B        1499251867647B  1499250819072B  primary  ntfs /dev/sdm a64
0.03MiB: parted executions:
 1      32256B         999601827839B  999601795584B  primary  ext4 /dev/sdl a42
 1      32256B          1999318809599B  1999318777344B  primary /dev/sdo a93
 1      1048576B       749418315775B  749417267200B  primary  ntfs /dev/sdq a69

===== Create (finally) =====
$ sudo fdisk $d
Command (m for help): p
 Disk /dev/sdr: 2000.4 GB, 2000398934016 bytes
 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
 Units = sectors of 1 * 512 = 512 bytes
 Sector size (logical/physical): 512 bytes / 512 bytes
 I/O size (minimum/optimal): 512 bytes / 512 bytes
 Disk identifier: 0xc2df6527

    Device Boot      Start         End      Blocks   Id  System

Command (m for help): n
 Partition type:
    p   primary (0 primary, 0 extended, 4 free)
    e   extended
Select (default p):
 Using default response p
Partition number (1-4, default 1):
 Using default value 1
First sector (2048-3907029167, default 2048): 38912
Last sector, +sectors or +size{K,M,G} (38912-3907029167, default 3907029167): 118783

Command (m for help): p
 Disk /dev/sdr: 2000.4 GB, 2000398934016 bytes
 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
 Units = sectors of 1 * 512 = 512 bytes
 Sector size (logical/physical): 512 bytes / 512 bytes
 I/O size (minimum/optimal): 512 bytes / 512 bytes
 Disk identifier: 0xc2df6527

    Device Boot      Start         End      Blocks   Id  System
 /dev/sdr1           38912      118783       39936   83  Linux

Command (m for help): t
 Selected partition 1
Hex code (type L to list codes): 7
 Changed system type of partition 1 to 7 (HPFS/NTFS/exFAT)

Command (m for help): w
 The partition table has been altered!

 Calling ioctl() to re-read partition table.
 Syncing disks.

$ sudo mkntfs -v ${d}1 --label ${dname}_nomnt
Cluster size has been automatically set to 4096 bytes.
Initializing device with zeroes: 100% - Done.



=== Create partition (for usage) ===
--> SEE `helphdd2` --> mke2fs
$ sudo fdisk $d
Command (m for help): p
 Disk /dev/sdr: 2000.4 GB, 2000398934016 bytes
 101 heads, 29 sectors/track, 1333912 cylinders, total 3907029168 sectors
 Units = sectors of 1 * 512 = 512 bytes
 Sector size (logical/physical): 512 bytes / 512 bytes
 I/O size (minimum/optimal): 512 bytes / 512 bytes
 Disk identifier: 0xc2df6527

    Device Boot      Start         End      Blocks   Id  System
 /dev/sdr1           38912      118783       39936   83  Linux

Command (m for help): n
 Partition type:
    p   primary (1 primary, 0 extended, 3 free)
    e   extended
Select (default p):
 Using default response p
Partition number (1-4, default 2):
 Using default value 2
First sector (2048-3907029167, default 2048): 118784
Last sector, +sectors or +size{K,M,G} (118784-3907029167, default 3907029167):
 Using default value 3907029167

Command (m for help): p
 Disk /dev/sdr: 2000.4 GB, 2000398934016 bytes
 101 heads, 29 sectors/track, 1333912 cylinders, total 3907029168 sectors
 Units = sectors of 1 * 512 = 512 bytes
 Sector size (logical/physical): 512 bytes / 512 bytes
 I/O size (minimum/optimal): 512 bytes / 512 bytes
 Disk identifier: 0xc2df6527

    Device Boot      Start         End      Blocks   Id  System
 /dev/sdr1           38912      118783       39936   83  Linux
 /dev/sdr2          118784  3907029167  1953455192   83  Linux

Command (m for help): w
 The partition table has been altered!

 Calling ioctl() to re-read partition table.
 Syncing disks.


==== Create, Mount, and Find Truecrypt-encrypted FS ====
$ truecrypt --create              # Follow prompts... or perform all at once:

$ truecrypt --create /dev/sdr2  \ # e.g. --create=VOLUME_PATH
	-p ""  \                       # e.g. --password=""
	-k /path/to/key(s)  \          # e.g. --keyfiles=KEYFILE1[,KEYFILE2,KEYFILE3,...]
	--random-source=/dev/urandom \ # Use specified file for entropy instead of prompting user for keyboard input.
	--quick  \                     # Quick format. Use if plan on immediately filling up entire filesystem. Does not encrypt free space when creating a new volume.

$ truecrypt --create ${d}2  \
	--volume-type=normal --encryption=AES --hash=ripemd-160 --filesystem=none  \
	-p ""  -k /path/to/key(s)


# (MOUNT *without filesystem*)
$ truecrypt --non-interactive --password= --protect-hidden=no  \
	--filesystem=none  \  # --filesystem=TYPE ; TYPE can only be (FAT|none)
	--keyfiles=/path/to/key(s)  \
	${d}2  \
	/path/to/mountpoint

# Determine which /dev/mapper/truecrypt[N] device was created for
# VOLUME_PATH (device) specified (/dev/sdr2):
$ truecrypt --list -v
# e.g. /dev/mapper/truecrypt4 is the device i need.

# FINALLY: mkfs on it!
$ mke2fs -L ${dname} -t ext4 -v /dev/mapper/truecrypt_

# Tell truecrypt to forget about everything so can perform full mount from scratch:
$ truecrypt -d /dev/sdr2
$ truecrypt -d ${d}2

# Now, just do a normal truecrypt mount to test everything went ok.


==== Create ext FS ====
$ sudo mke2fs -L ${dname} -t ext4 -v ${d}2
$ sudo tune2fs -c 5 -i 5d -e remount-ro -m 1 ${d}2

==== Create XFS ====
# mkfs.xfs ${d}1
# mkfs.xfs -L ${dname} ${d}1
$ mkfs.xfs -L ${dname} ${d}2

==== Set XFS label after the fact ====
xfs_admin -L ${dname} ${d}


== Create XFS fs, update fstab, create mountpoint, and mount ==
subdevice=sdX
sudo mkfs.xfs -L $subdevice /dev/${subdevice}
sudo su -c "echo \"LABEL=${subdevice}             /mnt/${subdevice}              xfs     defaults,nofail,noatime,nodiratime        0 0\" >> /etc/fstab"
sudo mkdir /mnt/${subdevice}
sudo mount -v /mnt/${subdevice}

= See also =
helpzfs2
__envHEREDOC__
}
helphdd5(){
cat <<'__envHEREDOC__'
== Remove HDD from the system as if physically pulled out ==
src : a response to original email "[zfs-discuss] ZFS hanging on failing drive"

This is like pulling the disk, except for the kernel knowing about it first,
also should stop ZFS from hanging:
$ echo 1 > /sys/block/<sdX>/device/delete

== HDD Burn in ==
src : https://wiki.archlinux.org/index.php/Badblocks#read-write_Test
   This test is primarily for testing new drives and is a read-write test. As the pattern is written to every accesible block the device effectively gets wiped. Default is an extensive test with four passes using four different patterns: 0xaa (10101010), 0x55 (01010101), 0xff (11111111) and 0x00 (00000000). For some devices this will take a couple of days to complete.

badblocks writes and then verifies, read-write Test:
# badblocks -wsv /dev/<device>

== System not seeing latest hotswap/hotplugged hdd ==
echo "- - -" > /sys/class/scsi_host/host*/scan

for i in /sys/class/scsi_host/host*/scan ; do
   sudo su -c "echo '- - -' > $i"
done

echo 1 > /sys/class/scsi_device/
echo 1 > /sys/devices/pc
echo 0 0 0 | tee /sys/class/scsi_host/host*/scan

__envHEREDOC__
}
helphdd6_resize2fs_and_partition_tables(){
cat <<'__envHEREDOC__'
Shrink sda1 fs to about 25GiB:
$ resize2fs /dev/sda1 6553856

Next, want to update partition table. Here's the
associated (cylinder-aligned) partition table layout, 512-byte sectors:
 sda1 2048s     52432895s
 sda2 52432896s 100%

PERSONAL NOTE: although the partitions are aligned properly, i dont think fs
 is lining up perfectly with partition table i.e. theres some extra space
 at the tail end of partition that is not in use by fs because is < 4K ?
__envHEREDOC__
}
helphdd6_ntfsresize(){
cat <<'__envHEREDOC__'
cmdln used by KDE Partition Manager
ntfsresize -P -i -f -v /dev/sdw1
__envHEREDOC__
}
helphdd7_sg_scsi_driver_and_fifo_howto(){
cat <<'__envHEREDOC__'
== man sg_dd ==
EXAMPLES
   Looks quite similar in usage to dd:

      sg_dd if=/dev/sg0 of=t bs=512 count=1MB

   This  will  copy 1 million 512 byte blocks from the device associated with /dev/sg0 (which
   should have 512 byte blocks) to a file called t.  Assuming /dev/sda and /dev/sg0  are  the
   same device then the above is equivalent to:

      dd if=/dev/sda iflag=direct of=t bs=512 count=1000000

   although  dd's  speed may improve if bs was larger and count was suitably reduced. The use
   of the 'iflag=direct' option bypasses the buffering and caching that is usually done on  a
   block device.

   Using a raw device to do something similar on a ATA disk:

      raw /dev/raw/raw1 /dev/hda
      sg_dd if=/dev/raw/raw1 of=t bs=512 count=1MB

   To copy a SCSI disk partition to an ATA disk partition:

      raw /dev/raw/raw2 /dev/hda3
      sg_dd if=/dev/sg0 skip=10123456 of=/dev/raw/raw2 bs=512

   This  assumes  a valid partition is found on the SCSI disk at the given skip block address
   (past the 5 GB point of that disk) and that the partition goes to  the  end  of  the  SCSI
   disk.  An  explicit count is probably a safer option. The partition is copied to /dev/hda3
   which is an offset into the ATA disk /dev/hda . The  exact  number  of  blocks  read  from
   /dev/sg0 are written to /dev/hda (i.e. no padding).

   To time a streaming read of the first 1 GB (2 ** 30 bytes) on a disk this utility could be
   used:

      sg_dd if=/dev/sg0 of=/dev/null bs=512 count=2m time=1

   On completion this will output a line like: "time to transfer  data  was  18.779506  secs,
   57.18 MB/sec". The "MB/sec" in this case is 1,000,000 bytes per second.

   The  'of2=' option can be used to copy data and take a md5sum of it without needing to re-
   read the data:

     mkfifo fif
     md5sum fif &
     sg_dd if=/dev/sg3 iflag=coe of=sg3.img oflag=sparse of2=fif bs=512

   This will image /dev/sg3 (e.g. an unmounted disk) and place the contents in  the  (sparse)
   file  sg3.img  .  Without re-reading the data it will also perform a md5sum calculation on
   the image.
__envHEREDOC__
}

helpiostat(){
cat <<'__envHEREDOC__'
iostat -m 1 -x  # shows disk thruput in megs along with (-x) thruput utilization estimates for the disk
__envHEREDOC__
}

helpfdisk(){
cat <<'__envHEREDOC__'
Default fdisk has units in cylinders or sectors.  Seems like it depends on which OS youre on.
* within fdisk just run the 'u' command and it will toggle+display the unit being used.
* from cmdln, i think just pass -u option to ensure units are in sectors.
** depending on which version, could additionally specify like...
*** -u=sectors   or   --units=sectors
*** -u=cylinders   or   --units=cylinders

* the Blocks column shows the number of 1K (1024 byte) blocks in the partition

= List of msdos/mbr -type partition filesystem hex codes =
 0  Empty              24  NEC DOS            81  Minix / old Lin    bf  Solaris
 1  FAT12              27  Hidden NTFS Win    82  Linux swap / So    c1  DRDOS/sec (FAT-
 2  XENIX root         39  Plan 9             83  Linux              c4  DRDOS/sec (FAT-
 3  XENIX usr          3c  PartitionMagic     84  OS/2 hidden C:     c6  DRDOS/sec (FAT-
 4  FAT16 <32M         40  Venix 80286        85  Linux extended     c7  Syrinx
 5  Extended           41  PPC PReP Boot      86  NTFS volume set    da  Non-FS data
 6  FAT16              42  SFS                87  NTFS volume set    db  CP/M / CTOS / .
 7  HPFS/NTFS/exFAT    4d  QNX4.x             88  Linux plaintext    de  Dell Utility
 8  AIX                4e  QNX4.x 2nd part    8e  Linux LVM          df  BootIt
 9  AIX bootable       4f  QNX4.x 3rd part    93  Amoeba             e1  DOS access
 a  OS/2 Boot Manag    50  OnTrack DM         94  Amoeba BBT         e3  DOS R/O
 b  W95 FAT32          51  OnTrack DM6 Aux    9f  BSD/OS             e4  SpeedStor
 c  W95 FAT32 (LBA)    52  CP/M               a0  IBM Thinkpad hi    eb  BeOS fs
 e  W95 FAT16 (LBA)    53  OnTrack DM6 Aux    a5  FreeBSD            ee  GPT
 f  W95 Ext'd (LBA)    54  OnTrackDM6         a6  OpenBSD            ef  EFI (FAT-12/16/
10  OPUS               55  EZ-Drive           a7  NeXTSTEP           f0  Linux/PA-RISC b
11  Hidden FAT12       56  Golden Bow         a8  Darwin UFS         f1  SpeedStor
12  Compaq diagnost    5c  Priam Edisk        a9  NetBSD             f4  SpeedStor
14  Hidden FAT16 <3    61  SpeedStor          ab  Darwin boot        f2  DOS secondary
16  Hidden FAT16       63  GNU HURD or Sys    af  HFS / HFS+         fb  VMware VMFS
17  Hidden HPFS/NTF    64  Novell Netware     b7  BSDI fs            fc  VMware VMKCORE
18  AST SmartSleep     65  Novell Netware     b8  BSDI swap          fd  Linux raid auto
1b  Hidden W95 FAT3    70  DiskSecure Mult    bb  Boot Wizard hid    fe  LANstep
1c  Hidden W95 FAT3    75  PC/IX              be  Solaris boot       ff  BBT
1e  Hidden W95 FAT1    80  Old Minix

= Scripting fdisk / running Non-interactively =
== print partition table ==
echo "u
p
q
" | sudo fdisk /dev/xvda


== expand the current single partion ==
# u: change units to sectors
# d: deletes partition (since there's only 1 partition on curr device, defaults to 1, no prompt.)
# n: new parition
# p: of type:: primary
# 1: with partion number 1
# 2048: is the first sector
#  : (blank) defaults to last sector
# w: writes changes to partition table

echo "u
d
n
p
1
2048

w" | fdisk /dev/xvda
# next can do resize2fs -p /dev/xvda1

= Newer fdisk disallowing certain things =
: src : http://tomas.solamail.no/2017/03/26/fdisk-force-start-sector-63/
When you try to create a partition on newer distributions you get "out of range" error
message when trying to create a new partition starting at sector 63.  To force the use
of the now deprecated "dos style":
fdisk -c=dos /dev/sda
__envHEREDOC__
}

helpparted(){
	local d=/dev/sda
	d='${d}'
	heredocWithVariables=$(cat <<__envHEREDOC__
d=/dev/sda  # For example.
== -s, --script ==
-> Print partition layout in...
parted $d --script unit UNIT print # ...UNIT.
 UNIT is one of: s, B, kB, MB, GB, TB, compact, cyl, chs, %, kiB, MiB, GiB, TiB

parted $d --script [unit compact] print # ...automatic/compact mode (Default).

parted $d --script unit s print    # ...sectors.
parted $d --script unit MiB print  # ...mibibytes.
parted $d --script unit MB print   # ...megabytes.


-> Make a new partition table:
parted $d --script mktable msdos
parted $d --script mktable gpt


-> Make a new partition entry:
parted $d --script mkpart primary zfs 23437312s 216797183s  # ...of size 99 000MB
parted $d --script mkpart primary ext4 12000MB  111000MB    # "MB" may not be allowed... nor any of the of the following guys... ... on second thought... if "unit UNIT" precedes "mkpart", all thes other unit formats may actually work... e.g.:
  -> parted $d --script unit MB mkpart primary ext4 12000MB  111000MB
parted $d --script mkpart primary ext4 11444MiB 105858MiB
parted $d --script mkpart primary ext4 12.0GB   111GB
parted $d --script mkpart primary ext4 11.2GiB  103GiB

-> make first partition bootable:
parted $d --script set 1 boot on

=== some snipplet ===
d=/dev/sdd
sudo parted ${d} --script mktable msdos
sudo parted ${d} --script mkpart primary fat32 0% 100%
sudo mkfs.exfat ${d}1 -n LABEL

=== loop for printing all machine devices ===
for d in /dev/sd[a-z] ; do  sudo parted $d --script unit s print  ; done

__envHEREDOC__
)
   echo "$heredocWithVariables"
cat <<'__envHEREDOC__'
=== random snippet(s) ===
Format two new 4TB hdd's with ext4 and set better properties:
   /dev/sdj /dev/sdk
sudo parted /dev/sdj --script mktable gpt
sudo parted /dev/sdk --script mktable gpt
sudo parted /dev/sdj --script mkpart primary ext4 2048s 100%
sudo parted /dev/sdk --script mkpart primary ext4 2048s 100%

time for i in /dev/sdj1 /dev/sdk1 ; do sudo mke2fs -t ext4 -v $i ; done

sudo tune2fs -c 5 -i 5d -e remount-ro -m 0 -L sdj1 /dev/sdj1
sudo tune2fs -c 5 -i 5d -e remount-ro -m 0 -L sdk1 /dev/sdk1
sudo mkdir /mnt/sdj1 /mnt/sdk1
sudo vim /etc/fstab
sudo mount -a

__envHEREDOC__
}

helpsfdisk(){
cat <<'__envHEREDOC__'
sfdisk -d $d > $dname.sfdisk - Backup.
sfdisk  $d < $dname.sfdisk   - Restore.

NOTE this only works for mbr/dos/msdos partition tables.
__envHEREDOC__
}
helptruecrypt(){
cat <<'__envHEREDOC__'
!!! NOTE !!! truecrypt is discontinued !!!

== In general ==
$ truecrypt --list -v

== Unmount and Mount ==
If the truecrypt device is already mounted and needs to be dis-mounted, determine the /dev/mapper/truecryptX device associated with the volume:
$ truecrypt --list  # e.g.
3: /dev/sde2 /dev/mapper/truecrypt4 /peanut/butter/truecrypt/time

$ sudo umount /peanut/butter/truecrypt/time
$ sudo mount /dev/mapper/truecrypt4 /peanut/butter/truecrypt/time

== Checking underlying file system ==
If the truecrypt device is mounted, dismount it.
$ sudo e2fsck -f -y -v /dev/mapper/truecrypt4

== See also ==
* helphdd4
* tcplay -- tool to manage TrueCrypt volumes  (DragonFlyBSD)
** http://leaf.dragonflybsd.org/cgi/web-man?command=tcplay
** The tcplay utility provides full support for creating and opening/mapping TrueCrypt-compatible volumes.
__envHEREDOC__
}
helpblkid(){
cat <<'__envHEREDOC__'
Upon inserting a failing hdd, syslog displayed:
  timeout '/sbin/blkid -o udev -p /dev/sdd2'
  timeout: killing '/sbin/blkid -o udev -p /dev/sdd2' [23144]
  '/sbin/blkid -o udev -p /dev/sdd2' [23144] terminated by signal 9 (Killed)
__envHEREDOC__
}



helpmodprobe(){
cat <<'__envHEREDOC__'
/calling helpdevices()/
__envHEREDOC__
	helpdevices
}
helpdevices(){
cat <<'__envHEREDOC__'
== Device and Driver Info and Hardware-related commands ==
dmidecode
udevadm trigger --verbose --dry-run
modprobe --list  # Shows all modules (but from where?  all built into kernel?  all available on system, but not in kernel(if that is even a thing)?  all that are known about to my OS (from like some master list or something lol?)? ??)
modprobe <TAB-TAB>  # Same as --list

# Find all mounted USB CD-ROM's
awk '$1 ~ /\/dev\/sr[0-9]+$/ { print $2 }' < /proc/mounts


== The ls's ==
lsattr (1)           - list file attributes on a Linux second extended file system
lsb_release (1)      - print distribution-specific information
lsblk (8)            - list block devices
lscpu (1)            - display information on CPU architecture
lsdev (8)            - display information about installed hardware
lshw (1)             - list hardware
lsinitramfs (8)      - list content of an initramfs image
lsmod (8)            - program to show the status of modules in the Linux Kernel
lsof (8)             - list open files
lspci (8)            - list all PCI devices
lspcmcia (8)         - display extended PCMCIA debugging information
lspgpot (1)          - extracts the ownertrust values from PGP keyrings and list them in GnuPG ownertrust format.
lss16toppm (1)       - Convert an LSS-16 image to PPM
lstopo (1)           - Show the topology of the system (note that hwloc-bind(1) provides a detailed explanation of the hwloc system; it should be read before reading this man page).
lsusb (8)            - list USB devices

# Example:
lsusb --verbose ; lspci, lscpu, etc.

== USB ==
usb-devices          - print USB device details.  Aggregates nfo from...
        /sys/bus/usb/devices/usb (The part of the sysfs tree the script walks through to assemble the printed information.)
        /proc/bus/usb/devices (for kernel 2.6.31-)
        /sys/kernel/debug/usb/devices (for kernel 2.6.31+)

== See also ==
helphardinfo[2] helplstopo helpprocfs helpsysfs
__envHEREDOC__
}




helpchkconfig(){
cat <<'__envHEREDOC__'
== RHEL-related ==
* RHEL7 / systemd uses:
systemctl
* instead of:
service
* e.g.:
sudo systemctl {start|stop|restart|enable} docker

== Debian-related ==
chkconfig /seems/ to be workable, but isn't exactly like rhel (also, I think its just a convenience program... and probably shouldnt really be used--USE the deb shtuff instead!)... when do --list, it generates the list of services directly from the files existing under /etc/init.d (with rhel, you explicitly --add  and  --del the list of registered OS services.

see also : insserve update-rc.d helpupdatercd
                      ^...use this guy e.g. sudo update-rc.d krb5-admin-server enable

see also2 :
* REFUSED(buggy or obsolete) rcconf(must also manually install 'dialog') - displays a menu of all the services which could be started at boot
* sysv-rc-conf(or ksysv for KDE)
* sysvconfig
* bootchart bootchart2
* bum
* menu-l10n ktsuss sux

other keywords : lsb upstart lsb-header

   OBSOLETE ==== upstart commands ====
   OBSOLETE * initctl - can use in place of "service" with the commands bellow. Run initctl help.
   OBSOLETE ** initctl list === `service --status-all' in RHEL
   OBSOLETE * start - start a service
   OBSOLETE ** sudo start <service>
   OBSOLETE * stop - stop a service
   OBSOLETE * reload - sends a SIGHUP signal to running process
   OBSOLETE * restart - restarts a service without reloading its job config file
   OBSOLETE * status - requests status of service


== See also ==
* https://help.ubuntu.com/community/UbuntuBootupHowto
* http://wiki.debian.org/LSBInitScripts
* helpsystemctl[23]
* helpupdatercd
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
__envHEREDOC__

#$ sudo su -c "source /home/bdavies/dotfiles/home-machines/.functions.sh ;
#i.e.
## sudo su -c "source /home/bdavies/dotfiles/home-machines/.functions.sh ; slowdown 808"
cat <<'__envHEREDOC__'
sudo su -c "source $ZOMG_DOTFILES/.functions.sh ; <insert name of function to call>
sudo su -c "source $ZOMG_DOTFILES/.functions.sh ; slowdown
i.e.
sudo su -c "source $ZOMG_DOTFILES/.functions.sh ; slowdown 808"
__envHEREDOC__

cat <<'__envHEREDOC__'

Nicenesses range from -20 (most favorable scheduling) to 19 (least favorable).

EXAMPLES
$ nice                # Print the current niceness.

$ nice --18 process   # (faaast) Run process in the real time class (one of the Most Favorable scheduling classes)

~~~$ renice -18 23871    # Change process priority (to be in one of the Most Favorable scheduling classes)~~~

$ nice --19 process   # (fastest)

$ nice [-10] process  # (default) Run process in one of the more Least Favorable scheduling classes.
$ nice [-+10] process # Same as prior.
$ nice -11 process    # (slower) Run process in one of the more Least Favorable scheduling classes.
$ nice -+11 process   # Same as prior.

$ nice -19 process    # (slowest) Run process in, basically, the Least Favorable scheduling class.
$ nice -+19 process   # Same as prior.

__envHEREDOC__

cat <<'__envHEREDOC__'
== See also ==
* getprocesspriority() slowdown() unslowdown()
* helpsudo() helpionice()
* cpulimit
* pidstat
__envHEREDOC__
}
helprenice2(){
cat <<'__envHEREDOC__'
== Set niceness of entire current shell/environment scope or context/shell script ==
In bash (at least), can use the $$ variable to refer to the current env scope.

# Schedule process very unfavorably (slowest).
renice +19 -p $$       >/dev/null 2>&1

# Schedule I/O in the next best favorable manner from Idle(which is the slowest).
# IOW, its just one notch above the slowest/worst.
ionice -c2 -n7 -p $$   >/dev/null 2>&1
__envHEREDOC__
}
helpnice(){
cat <<'__envHEREDOC__'
/calling helprenice()/
__envHEREDOC__
	helprenice
}
helppasswd(){
cat <<'__envHEREDOC__'
== In general ==
$ passwd -d USERNAME   # BAD (in general)!!! this allows *anyone* to become USERNAME (literally puts the empty string in /etc/shadow).  If used, ensure PermitEmptyPasswords is no/false in ssh server config, else anyone can log in.
$ passwd -l USERNAME   # BETTER. this "locks" the account (this is what you want if you use ssh keys for authentication--puts "!!" or "!" in /etc/shadow)
__envHEREDOC__
}
helpmail(){
cat <<'__envHEREDOC__'
== Works on Debian ==
# assuming which mailx actually resolves to something (on a 12.04 box, got
# readlink -e `which mailx` -> /usr/bin/heirloom-mailx), need to at least
# install sendmail:
sudo apt-get install sendmail

# then can successfully cmdln like:
echo "email body... oh, so fine" | mailx -v -s "PROBLEM: the website is down" -S from="borat@remote.tacowolf.comz" some-guy-Earl@gmail.com

== Works on RHEL ==
# Send an email message to Guru (using the mailx package):
$ echo 'message body... oh hai11111111 on:' `date --rfc-3339=ns` `who -m`  |  \
	mail -s "message subject from `who -m | cut -d"(" -f2 | cut -d")" -f1`"  guru@rip.com
#^^TODO STUB uhuhg this doesn't look right on the reciever's side... fixup the stdout string crap thats going on here

# Same as previous, but use custom SMTP server to send the email
$ echo 'message body... oh hai11111111 on:' `date --rfc-3339=ns` `who -m`  |  \
	mail  -S smtp=qa-in-f26.1e100.net  -s "message subject from `who -m | cut -d"(" -f2 | cut -d")" -f1`"  guru@rip.com

# Had been having problems sending mail on a client network that used a relay mail server...
# it turned out that I should have been setting the from property. Without that, mails
# weren't getting through (not sure if that was fault of local relay server or destination
# mail server.
echo 'msg body' |\
   mail -v -S  smtp="192.192.192.192" -S  from="noreply@domain.com"  -s "msg subject" guru@domain.com
# ^^and with this, I also had to modify /etc/postfix/main.cf with:
relayhost = 192.192.192.192
# because I noticed in /var/log/maillog a lot of "relay=<none>" entries.

== See also ==
http://superuser.com/a/219051
__envHEREDOC__
}
helpshred(){
cat <<'__envHEREDOC__'
# securely wipe/delete/zero out files
shred [--interations=N] --remove --verbose --zero  file
shred [-n N]            -u       -v        -z      f
time find . -type f -exec  echo shred -n1 -v -u -z '{}' \;
__envHEREDOC__
}
helpjava(){
cat <<'__envHEREDOC__'
bsh - Java scripting environment (BeanShell) Version 2

== See also ==
- NOTE the following $db paths containing snippets, etc.:
-- find $db/db.scripts-snippets/ -name *.java
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
helptypeset
helpkpathsea
__envHEREDOC__
}

helpnotify_send(){
	# helpnotify-send alert gnome popup pop up message
cat <<'__envHEREDOC__'
notify-send (1)      - a program to send desktop notifications
notify-send [OPTION...] <SUMMARY> [BODY] - create a notification
$ notify-send  "dry-run COMPLETE" "dry-run COMPLETE"

== EXAMPLE ==
Keep displaying message until loop is aborted:
$ while [[ 1 ]] ; do notify-send "TIMER TIMED OUT!! GO RUN HIDE!! RUN HIDE!! RUN HIDE!!"; sleep 10s; done

== TROUBLESHOOTING ==
Problem: Swear I had this working on my KDE4 desktop just the other day.  Now I go to do it, exactly as it is above and it doesn't work.
Solution: Turns out I need to be in a non-multiplexed terminal.  :/ Can't just do it in any ol' xterminal I guess.  I was trying within a tmux session but opened a brand new Konsole and it worked.
__envHEREDOC__
}
helppopup(){
cat <<'__envHEREDOC__'
/calling helpnotify_send()/
__envHEREDOC__
	helpnotify_send
}
helpalert(){
cat <<'__envHEREDOC__'
== See also ==
* helpnotify_send()
* growlnotify (OSX app only)
** http://superuser.com/questions/235417/whats-the-linux-equivalent-of-os-xs-growl
__envHEREDOC__
}
helpreadlink(){
cat <<'__envHEREDOC__'
$ readlink `which java`
/etc/alternatives/java

$ readlink -e `which java`
/usr/lib/jvm/java-6-openjdk-amd64/jre/bin/java
__envHEREDOC__
}
helplinks(){
cat <<'__envHEREDOC__'
/calling helpreadlink()/
__envHEREDOC__
	helpreadlink
}
helpXephyr(){
cat <<'__envHEREDOC__'
Xephyr -query vega2 :1
~~Xephyr -query remote-vega2 :1~~ # cannot do this due to... port issue.
__envHEREDOC__
}

helpwHOA_wtf_cmd__u_blow_my_mind(){
	# whoa
cat <<'__envHEREDOC__'
List of cmds I just happen to randomly come across and make me say "WHOA! WTF!! :) cmd, u blow my mind..."
fuser - identify processes using files or sockets (similar to lsof)
   fuser -v -m /
helphdd8_network_direct_blk_dev_access # geom-ggate
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
/calling helpzip()/
__envHEREDOC__
	helpzip
}
helptar(){
cat <<'__envHEREDOC__'
tar (single-threaded tar)
-------------------------
$ tar zcfW a.tar.gz  a/    # -W attempt to verify the archive after writing it

Exclude the file "snoop-lion" and/or anything within "snoop-lion" directory:
$ tar zcfv a.tar.gz  /home/calvin-broadus/  --exclude=/home/calvin-broadus/snoop-lion
Extract to pre-existing directory:
$ tar xf tarfile.tar -C /path/to/pre-existing/directory/to/extract/into/
Extract to stdout:
$ tar xf tarfile.tar -O
$ tar xfO tarfile.tar
Keep leading `/' in member names with `P' (prevent tar from removing the leading `/' from member names):
$ tar zcfvP tarfile.tar.gz

Limit to a single or small number of files (conversely, to limit a large number of files, theres also --exclude -like options):
-> list archive contents, only for the archvie paths specified within tmpfilelist.txt :
echo vm-image.img >tmpfilelist.txt
tar ztfv tarfile.tar.gz --files-from tmpfilelist.txt
-> similarly, extract the files listed in tmpfilelist.txt :
tar zxfv tarfile.tar.gz --files-from tmpfilelist.txt
-> basically, compute hash sum for files listed in tmpfilelist.txt :
tar zxfv tarfile.tar.gz --files-from tmpfilelist.txt -O | sha1sum -
-> create an archive containing the files listed in tmpfilelist.txt
tar zcfv tarfile.tar.gz --files-from tmpfilelist.txt

mtar (multi-threaded tar)
-------------------------
$ bsdtar zcfvY a.tar.gz /path/to/some/de/lah  # -Y indicates to run multi-threaded

$ time sudo /usr/local/bin/bsdtar zcfvY  vm-phd2-a1.kvm.tar.gz  --files-from /home/libvirt-images/vm-phd2-a1.files.txt.0
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
Convert stupid old zip files with their stupid 4GB limit with :
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
helplocate(){
cat <<'__envHEREDOC__'
== OPTIONS ==
--existing

== EXAMPLES ==
locate --limit 2 --database /var/lib/mlocate/mlocate-all.db  -r  the/blah/blah/dir/file.txt.[123]
for i in `locate --limit 2 --database /var/lib/mlocate/mlocate-all.db  -r  the/blah/blah/dir/file.txt.[123]` ; do   echo rm $i blah; done
for i in `locate -r /mnt/rsnapshot/.*/Downloads/NVIDIA-Linux-x86_64-295.33.run` ; do   echo rm $i blah; done
locate -r home.*aesop-rock.*bash_history

# multiple -d args are additive...
locate -d /var/lib/mlocate/mlocate.db   -d /var/lib/mlocate/downloads-dir.db
# for example:
[ teelah@newjack ~ ]$ sudo locate -i -d /var/lib/mlocate/custom.db  -d /var/lib/mlocate/mlocate.db the | wc -l
32662
[ teelah@newjack ~ ]$ sudo locate -i -d /var/lib/mlocate/custom.db  the | wc -l
16311
[ teelah@newjack ~ ]$ sudo locate -i -d /var/lib/mlocate/mlocate.db the | wc -l
16351
[ teelah@newjack ~ ]$ sudo locate -i -d /var/lib/mlocate/mlocate.db -d /var/lib/mlocate/custom.db the | wc -l
32662

updatedb --database-root /mnt/something -o /var/lib/mlocate/something.db
sudo updatedb --database-root /mnt/$dname -o /var/lib/mlocate/${dname}.db
sudo updatedb --database-root /mnt/$dname -o /var/lib/mlocate/${dname}.$( date +"%Y%m%d%H%M%S" ).db
__envHEREDOC__
}
helpapplekeyboard(){
cat <<'__envHEREDOC__'
== F1-F12 KEYS VIA F{1-12} (typical keyboard behaviour) ==
# bash alias: keyboardBeNormal
$ sudo su -c "echo '2' > /sys/module/hid_apple/parameters/fnmode"

# Can also add this snippet to /etc/rc.local :
echo '2' > /sys/module/hid_apple/parameters/fnmode

== F1-F12 KEYS VIA fn+F{1-12} (Apple keyboard default) ==
# bash alias: keyboardBeFruity
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
helpmount(){
cat <<'__envHEREDOC__'
= /etc/fstab Entry Examples =
-----------------------------
== swap /etc/fstab ==
# pri is priority E [0,32767]; higher num -> higher priority; devices with higher priority are used first before any device with a lower priority.
LABEL=linux-swap     none     swap     sw,pri=9    0 0

== sshfs /etc/fstab ==
sshfs#t@phi:/mnt/h/  /mnt/phi   fuse  user,allow_other,nonempty,follow_symlinks,noauto   0 0
sshfs#b@demoportal:/usr/local/tomcat/  /home/b/mnt/demoportal  fuse  user,allow_other,nonempty,follow_symlinks,noauto   0 0

== cifs /etc/fstab ==
<.. it's probably not complicated>

= Mount Via Cmdln Examples =
----------------------------
== NTFS-3g : Mount NTFS volume with full user write permission ==
mount -v /dev/sdg1 /media/mountpoint -t ntfs -o rw,allow_other,blocksize=4096,default_permissions

== fat : Mount FAT* volume with full user write permission ==
mount -v /dev/sdb1 /media/mountpoint -t vfat -o uid=1000,gid=1000,utf8,dmask=027,fmask=137
mount -v /dev/sdb1 /media/mountpoint -t vfat -o rw,nosuid,nodev,uid=$( id -u ),gid=$( id -g ),shortname=mixed,dmask=0077,utf8=1,showexec,flush

== tmpfs : Mount/Create ramdisk/tmpfs ==
#RAMDISK=/tmp/ramdisk
#mkdir $RAMDISK
#chmod 777 $RAMDISK
sudo mount -t tmpfs -o size=256m tmpfs $RAMDISK
#chown -R user:group $RAMDISK

== iso9660 : Mount ISO image file ==
mount -t iso9660 -o ro,loop /path/to/isofile /mnt/mountpoint
mount -t msdos -o loop,offset=$((2048 * 512 )) image.dd /mnt/tmp

== iso9660 : Mount CD-ROM (or some other optical media) ==
mkdir /media/cdrom
mount -t iso9660 -o ro /dev/sr0 /media/cdrom

== loop : Mount dd partition image ==
sudo mount -t ext4  -o ro,loop /path/to/fsimg.dd /mnt/tmp
# mount 2nd partition that exists within a full disk image:  2nd partition starts at (512-byte) sector number 540672 ::
sudo mount -t ext4 -o loop,offset=$(( 540672 * 512 )) image.dd /mnt/tmp

== cifs : Mount samba/smb/cifs share ==
sudo mount -v -t cifs //le-simba-server/$USER /mnt/tmp -o user=$USER

=== Notice this `mount' cmdln works for one samba server, but not the other :( ... ya but no. ===
Performed on id-9-ubu1204 to mount local samba share (ALL FAIL):
$ sudo mount -v -t cifs -o username=tellah,dmask=770,fmask=660,user_xattr //id-9-ubu1204/tellah /mnt/tmp
$ sudo mount -v -t cifs -o username=tellah,dmask=770,fmask=660,user_xattr //id-9-ubu1204/homes/tellah /mnt/tmp
$ sudo mount -v -t cifs -o username=tellah,dmask=770,fmask=660,user_xattr //id-9-ubu1204/homes/ /mnt/tmp
$ sudo mount -v -t cifs -o username=tellah,dmask=770,fmask=660,user_xattr //id-9-ubu1204/homes /mnt/tmp
$ sudo mount -v -t cifs -o username=tellah,dmask=770,fmask=660,user_xattr //id-9-ubu1204/ /mnt/tmp
$ sudo mount -v -t cifs -o username=tellah,dmask=770,fmask=660,user_xattr //id-9-ubu1204/tellah /mnt/tmp

Performed on id-9-ubu1204 to mount p-8-f13 samba share (SUCCESS):
$ sudo mount -v -t cifs -o username=tellah,dmask=770,fmask=660,user_xattr //p-8-f13/the-thing

= See also =
------------
helpmount*()
helpumount()
__envHEREDOC__
}
helpmount2mountoptions(){
cat <<'__envHEREDOC__'
== Various mount options ==
=== ext[43] (ext2?) Extended Attributes ===
user_xattr

=== ext4 Default mount opts ===
* If the `defaults' option specifies: rw, suid, dev, exec, auto, nouser, and async.
* If contradicting options are used (e.g.) like `defaults,noexec', the later will take precedence.
* If no options are specified, the default options in ubu are: rw, relatime.

=== NTFS-3g Other misc mount opts ===
remove_hiberfile, umask=, fmask=, dmask=, streams_interface=.

=== NTFS-3g Default mount opts (originally copied from syslog) ===
ntfs-3g: Version 2010.8.8 external FUSE 28 ; ntfs-3g: Mounted /dev/sdc1 (Read-Write, NTFS 3.1)
ntfs-3g: Cmdline options: rw,nosuid,nodev,uhelper=udisks,uid=1000,gid=1000,dmask=0077,fmask=0177
ntfs-3g: Mount options: rw,nosuid,nodev,uhelper=udisks,allow_other,nonempty,relatime,fsname=/dev/sdc1,blkdev,blksize=4096,default_permissions

=== Command line options ===
-r, --read-only
       Mount the filesystem read-only. A synonym is -o ro.

       Note that, depending on the filesystem type, state and kernel behavior, the system may  still  write
       to the device. For example, Ext3 or ext4 will replay its journal if the filesystem is dirty. To pre‐
       vent this kind of write access, you may want to mount ext3 or ext4 filesystem with "ro,noload" mount
       options or set the block device to read-only mode, see command blockdev(8).

=== Filesystem independent mount options ===
* noatime - do not update inode access times on this fs.
* nodiratime - do not update directory inode access times on this fs.
* nobootwait - useful for mountpoints that may prevent system fully booting.
** RHEL6-based OS's : bad option
* nofail - ?useful for mountpoints that may prevent system fully booting?
** ( RHEL6-based OS's : OK :: it actually gets converted to: _netdev )
* _netdev - The filesystem resides on a device that requires network access (used to prevent the system from attempting to mount these filesystems until the network has been enabled on the system).
** lol this be prob a (?early?) workaround for not having the ( actual nofail or ) nobootwait option???

__envHEREDOC__
}
helpmount3sshfsfromscratch(){
cat <<'__envHEREDOC__'
== sshfs : use pre-requirements ====
* need package
$ <package manager> install sshfs

* if want to mount without root priviledges, add user to fuse group
$ sudo usermod --groups fuse --append $USER

* set 'user_allow_other' in /etc/fuse.conf

* mount resource by specifying the absolute path. e.g.
$ sshfs phi:/mnt/h/ /home/t/ri/m/phi/ -o allow_other -o follow_symlinks

* unmount the resource using:
$ fusermount -u $absolute_path
__envHEREDOC__
}


helpeject(){
cat <<'__envHEREDOC__'
sync ; sudo umount /dev/sdj1 ; sudo eject /dev/sdj ; sync
__envHEREDOC__
}

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

== See also ==
* helpvisudo()
__envHEREDOC__
}
helpvisudo(){
cat <<'__envHEREDOC__'
Make visudo use vim NOT nano (see also: helpvim)
sudo update-alternatives --config editor


This entry, initially appears to be what you want...
bmore-sun-reporter ALL=NOPASSWD: ALL

...but there _IS_ a difference between ^^that and this:
bmore-sun-reporter ALL=(ALL) NOPASSWD: ALL

One difference is that the former is unable to run the specified command as a user other than root.
IOW, if need to exec things as different users (sans root)...
  e.g. sudo -u bmore-sun-reporter  echo "China Threatens Drama if Obama Meets the Dalai Lama"
  e.g. sudo -u hdfs hdfs dfsadmin -report
...it wont work.
__envHEREDOC__
}
helpusermod(){
cat <<'__envHEREDOC__'
If necessary, create group first:
$ groupadd ilike

Now add members:
$ usermod -a -G GROUPNAME USER
$ usermod -a -G ilike devborrat

Now, can just put entry into sudoers file that allows the 'ilike'
group to do shtuffs...  e.g.
## Allows people in group wheel to run all commands
# %wheel        ALL=(ALL)       ALL
## Same thing without a password
%ilike ALL=(ALL)      NOPASSWD: ALL


== usermod cmdln's and resulting output of `id` ==
Here's default...
[u-god@vm-hdp2-x1 ~]$ id
uid=500(u-god) gid=500(u-god) groups=500(u-god)

And maybe some modifications are made...
[u-god@vm-hdp2-x1 ~]$ sudo usermod -a -G hdfs u-god
[u-god@vm-hdp2-x1 ~]$ id
uid=500(u-god) gid=500(u-god) groups=500(u-god),497(hdfs)

[u-god@vm-hdp2-x1 ~]$ sudo usermod -g wu-tang -G hdfs u-god
[u-god@vm-hdp2-x1 ~]$ id
uid=500(u-god) gid=1007(wu-tang) groups=1007(wu-tang),497(hdfs)

== add yourself to various groups by doing some group appends ==
usermod -aG docker $USER
usermod -aG adm $USER
usermod -aG xpra $USER
usermod -aG lpadmin $USER
usermod -aG sambashare $USER
usermod -aG libvirt $USER
usermod -aG sudo $USER
usermod -aG audio $USER
usermod -aG fuse $USER
usermod -aG cdrom $USER

__envHEREDOC__
}
helptypeset(){
cat <<'__envHEREDOC__'
: src : https://unix.stackexchange.com/a/370169
: typeset is analogous to declare.
-F [function name] : display [specific] function(s)

$ typeset -p VARIABLE     # Displays definition.
$ typeset -p              # Displays all variables and their definition.
$ set      # Without options, the name and value of each shell variable are
           # displayed in a format that can  be reused as input for setting
           # or resetting the currently-set variables.
$ shopt    # Toggle the values of variables controlling optional shell behavior.
           # With no options or with -p, a list of all settable options is displayed
$ alias ALIAS             # Similarly, displays alias definition.
$ export -p               # If no names are given, or if the -p option is
                          # supplied, a list of all names that are
                          # exported in this shell is printed.

== display function definition ==
ANSWER: type
$ type FUNCTION_NAME
ALSO: typeset -f FUNCTION_NAME

== List all defined shell functions *names* ==
typeset -F

== List all defined shell variables *names* ==
: multiple approaches offered.

# all variables and their definitions:
(set -o posix; set)

# compgen was created to aid cmdln completion:
compgen -v

# noticing that set dumps variables first, then functions, just stop the output at the first line that doesnt contain an equals sign:
set | awk -F '=' '! /^[0-9A-Z_a-z]+=/ {exit} {print $1}'
# similarly:
set | grep "^\([[:alnum:]]\|[[:punct:]]\)\+="

compgen -v | while read var; do printf "%s=%q\n" "$var" "${!var}"; done  # showing variable names along with their definitions.
printenv      # shows exported (environment) variables and non-exported (shell) variables.
env           # shows exported (environment) variables and non-exported (shell) variables.
# diffing against a clean shell to ensure also variables from rc scripts get left out:
diff <(bash -cl 'set -o posix && set') \
   <(set -o posix && set && set +o posix) | \
   grep -E "^>|^\+" | \
   grep -Ev "^(>|\+|\+\+) ?(BASH|COLUMNS|LINES|HIST|PPID|SHLVL|PS(1|2)|SHELL|FUNC)" | \
   sed -r 's/^> ?|^\+ ?//'

== See also ==
helpcommand
helpbash

=== all these give varying outputs although are similar ==
set
typeset
typeset -x
typeset -p    # only prints variables but with some ugly attributes
comm -3 <(declare | sort) <(declare -f | sort)
declare -p | cut -d " " -f 3 | sort

comm -3 <(comm -3 <(declare | sort) <(declare -f | sort)) <(env | sort)  # i have no clue... but supposively is supposed to just show variable names (and not their definitions).
__envHEREDOC__
}
helpcommand(){
cat <<'__envHEREDOC__'

== See also ==
helpbash
helpenv helptypeset which

== Related ==
* http://www.cyberciti.biz/faq/unix-linux-shell-find-out-posixcommand-exists-or-not/
$ apropos cmd             # Search the manual page names and descriptions.
$ man -k cmd              # === to apropos
$ whatis cmd              # Display manual page descriptions.
$ help                    # Display information about builtin commands.
$ type [-afptP] name [name ...]   # Display information about command type.
#       -a display all locations
#       -f suppress function lookup
#       -P
#       -p
#       -t output a single word, E[`alias', `keyword',`function', `builtin', `file', `']
__envHEREDOC__
}
helpman(){
cat <<'__envHEREDOC__'
 /usr/bin/mandb -cq
catman                     # builds windex files which are used by keyword searches, i.e. apropos === man -k.
makewhatis
nroff -mdoc tmux.1 | less  # reading man pages without calling "man".

== Finding ==
apropos cmd                # Search the manual page names and descriptions.
man -k cmd                 # === to apropos
whatis cmd                 # Display manual page descriptions.
man -f cmd                 # === to whatis
whatis -r cmd              # Interpret each name as a regular expression.
                           # If a name matches any part of a page name, a match will be made.
man --manpath=/usr/share/bcc/man/ biosnoop  # specify custom man path.

== Printing and Viewing Escapades ==
man -t iptables > iptables.ps   # saves the manpage to postscruipt file.
man -t iptables | lpr -P HP690C # print manpage to printer.

man iptables | col -b | \       # uses col to strip out backspaces and reverse linefeeds,
   sed 's/[0-9]\{1,\}m//g' \    #    uses sed to strip out 'm' escape codes.
   > iptables.txt

man iptables > iptables.txt     # ... although I also had luck with just doing
                                # this, straight up: (gives a plaintext manpage version):
                                # (I suspect this could be due to MAN_KEEP_FORMATTING variable (see man man))

== Locations ==
/usr/share/man/      # main man docs location.
/usr/share/man/man1  # corresponds to manpage type: section number 1 (user executables and programs)
/usr/share/man/man2  # corresponds to manpage type: section number 2 (system calls)
...etc.

== Notable apt-packages ==
asr-manpages          - alt.sysadmin.recovery manual pages
freebsd-manpages      - Manual pages for a GNU/kFreeBSD system
funny-manpages        - more funny manpages
gmanedit              - GTK+ man pages editor
gman                  - small man(1) front-end for X
help2man              - Automatic manpage generator
man2html-base         - convert man pages into HTML format
man2html              - browse man pages in your web browser
man-db                - on-line manual pager
whichman              - Fault tolerant search utilities: whichman, ftff, ftwhich
xmltoman              - simple XML to man converter

== Notable manpage topics ==
man proc   # docs for processes information pseduo-file sys ( /proc ).

/calling helpcommand()...//////////
__envHEREDOC__
	helpcommand

cat <<'__envHEREDOC__'
/////////////////////////--> DONE!/

== See also ==
* helpless()
* helpprocfs()
* helplpr()
__envHEREDOC__
}

helpinotify(){
cat <<'__envHEREDOC__'
Monitor for filesystem changes beginning from some top-level path (inotify):
$ inotifywait --monitor --recursive .kde/
__envHEREDOC__
}
helppv(){
cat <<'__envHEREDOC__'
pv - Shell pipeline element to meter data passing though.

(2012-12-05 19:05:39) Tim C.
$ dd if=/dev/sdb bs=4M | pv -eprb -s 466g > /dev/null

Cmdln I generated from somewhere... (apparently I must've been using a special version because
none of the other "pv" binaries allow "-a" option lol:
$ pv -pterab

Parted Magic's pv does not support the -a option, nor does ubu1204/debian:
$ pv -pterb
__envHEREDOC__
}
helpvlc(){
cat <<'__envHEREDOC__'
== VLC cmdln --help, various invocations of ==
$ vlc-wrapper [--help]
...
  -h, --help, --no-help          print help for VLC (can be combined with --advanced and --help-verbose) (default disabled)
  -H, --full-help, --no-full-help
                                 Exhaustive help for VLC and its modules (default disabled)
      --longhelp, --no-longhelp  print help for VLC and all its modules (can be combined with --advanced and --help-verbose) (default disabled)
      --help-verbose, --no-help-verbose
                                 ask for extra verbosity when displaying help (default disabled)
x

== Playlist-related: repeating ==
  -Z, --random, --no-random      Play files randomly forever (default enabled)
  -L, --loop, --no-loop          Repeat all (default disabled)
  -R, --repeat, --no-repeat      Repeat current item

== Notable others ==
      --advanced, --no-advanced  Show advanced options (default disabled)

  -l, --list, --no-list          print a list of available modules (default disabled)
      --list-verbose, --no-list-verbose
                                 print a list of available modules with extra detail (default disabled)
      --config <string>          use alternate config file

__envHEREDOC__
}
helplame(){
cat <<'__envHEREDOC__'
== Notes ==
For ID3 tags, should always include the --add-id3v2 option (for encoding, at least). From `lame --help id3`:
    Note: A version 2 tag will NOT be added unless one of the input fields
    won't fit in a version 1 tag (e.g. the title string is longer than 30
    characters), or the '--add-id3v2' or '--id3v2-only' options are used,
    or output is redirected to stdout.

== Examples cmdlns ==
$ lame  -V 0          --add-id3v2 --verbose --tt "TITLE"  --tl "ALBUM"  --ty "2012"  --tc "-V 0"  in.wav  out.1-v0.mp3
$ lame  -V 2          --add-id3v2 --verbose --tt "TITLE"  --tl "ALBUM"  --ty "2014"  --tc "-V 2"  in.wav  out.2-v2.mp3
$ lame  --abr 192     --add-id3v2 --verbose --tt "TITLE"  --tl "ALBUM"  --ty "2012"  --tc "--abr 192"  in.wav  out.3-abr192.mp3
$ lame  --preset standard  --add-id3v2 --verbose --tt "TITLE"  --tl "ALBUM"  --ty "2012"  --tc "--preset standard (vbr)"  in.wav  out.4-preset-standard.vbr.mp3
$ lame  --preset 192  --add-id3v2 --verbose --tt "TITLE"  --tl "album"  --ty "2012"  --tc "--preset 192 (abr)"  in.wav  out.5-preset-192.abr.mp3

Actual cmdln used by K3b to  __ ENCODE __  audio (2nd line has hints):
$ lame -r --bitwidth 16 --little-endian -s 44.1 -h --tt %t --ta %a --tl %m --ty %y --tc %c --tn %n - out.mp3
$ lame -r --bitwidth 16 --little-endian -s 44.1 -h --tt "TITLE" --ta "ARTIST" --tl "ALBUM TITLE" --ty "RELEASE YR" --tc "COMMENT" --tn "TRACK #" - out.mp3

And to  __ DECODE __  is stupid simple:
$ lame --decode /path/to/input.mp3    # Creates decoded form at location: /path/to/input.wav

==== ...And some actual numbers (file sizes of things created using the various encoding options) : ====
NOTE the flac file was encoded using maximum compression options and is
included here just for comparison.
$ flac  --verify --padding --compression-level-8  in.wav -o 2012-11-28-BBC-1Xtra-DJ-Nihal.flac

$ ls -lh
762M 12-02 04:17 2012-11-28-BBC-1Xtra-DJ-Nihal.flac
201M 12-02 04:27 2012-11-28-BBC-1Xtra-DJ-Nihal.1-v0.mp3
153M 12-02 04:32 2012-11-28-BBC-1Xtra-DJ-Nihal.2-v2.mp3
160M 12-02 04:36 2012-11-28-BBC-1Xtra-DJ-Nihal.3-abr192.mp3
153M 12-02 04:41 2012-11-28-BBC-1Xtra-DJ-Nihal.4-preset-standard.vbr.mp3
160M 12-02 04:46 2012-11-28-BBC-1Xtra-DJ-Nihal.5-preset-192.abr.mp3
1.2G 12-02 03:16 2012-11-28-BBC-1Xtra-DJ-Nihal.wav

== Moar cmdlns ==
Get info
$ lame --help id3

== See also ==
helplame helpflac helpmuzik
__envHEREDOC__
}
helpflac(){
cat <<'__envHEREDOC__'
== Example cmdlns ==
$ flac  --verify --padding --compression-level-8 --picture=picturefile.jpg   input.wav -o output.flac
$ flac  --verify --padding --compression-level-8 --qlp-coeff-precision-search --picture=picturefile.jpg   input.wav -o output.flac

Actual cmdln used by K3b to ENCODE audio:
$ flac -V -o %f --force-raw-format --endian=little --channels=2 --sample-rate=44100 --sign=signed --bps=16 -T ARTIST=%a -T TITLE=%t -T TRACKNUMBER=%n -T DATE=%y -T ALBUM=%m -

Get info
$ metaflac --list infile.flac

Split 1 flac file into 2 wav files (_straight up!_ without cuefile crap!).
# First, must determine number of samples in track.  One way:
file infile.flac

# which outputs something like

#   2012-11-28-BBC-1Xtra-DJ-Nihal.flac: FLAC audio bitstream data, 16 bit, stereo, 44.1 kHz, 317667328 samples
# Second, do the split by dividing samples by 2:
samples=317667328
flac --decode --until=$( clac.py "${samples} / 2" ) infile.flac -o 1of2.wav
flac --decode --skip=$( clac.py "${samples} / 2" )  infile.flac -o 2of2.wav

Decode flac to wav:
$ flac --decode the.flac

== See also ==
helplame helpflac helpmuzik
__envHEREDOC__
}
helpmuzik(){
cat <<'__envHEREDOC__'
== Random muzik-related packages and programs ==
abcde: Command Line Music CD Ripping for Linux
icedax: stands for InCrEdible Digital Audio eXtractor
 * It can retrieve audio tracks (CDDA) from CDROM drives that are capable of reading audio data.
fapg: generates playlist of audio files (Wav, MP2, MP3, Ogg, etc) in various formats (M3U, PLS, XSPF, HTML, RSS, etc).
flac: Flac encoder/decoder
lame: mp3 encoder/decoder    LAME AINT AN MP3 ENCODER, duh
ffmpeg: M4A / AAc files
mpgtx: is a tool to manipulate MPEG files.
 * ( video ) mpgtx can currently split and join MPEG 1 video files and most MPEG audio files.
 * ( video ) mpgtx can fetch detailed information from MPEG 1 and MPEG 2.
 * ( video ) mpgtx can demultiplex MPEG 1 and MPEG 2 files (System layer, Program layer and Transport Layer).
 * mpgtx can add, remove and edit ID3 tags from mp3 files and rename mp3 files according to their ID3
   tags. It reads and writes ID3v1, but only reads ID3v2.
 * PROVIDES:
     mpgsplit
         is equivalent to mpgtx -s
     mpgjoin
         is equivalent to mpgtx -j
     mpgcat
         is equivalent to mpgtx -j -o -
     mpginfo
         is equivalent to mpgtx -i
     mpgdemux
         is equivalent to mpgtx -d
     tagmp3
         is equivalent to mpgtx -T
libmp3-tag-perl: Module for reading tags of MP3 audio files.
 * MP3::Tag is a wrapper module to read different tags of mp3 files. It provides an easy way to access the
   functions of separate modules which do the handling of reading/writing the tags itself.
 * At the moment MP3::Tag::ID3v1 and MP3::Tag::ID3v2 are supported.
 * PROVIDES: mp3info2

madplay: MPEG audio player in fixed point. MAD is an MPEG audio decoder. There is also full support for ID3 tags.
mpg123:  MPEG layer 1/2/3 audio player.
taggrepper - search and match tags of audio files against regular expressions
mpv - fork of mplayer2/MPlayer; shares features with the former and introduces more, supports wide variety video file formats, audio, video codecs, subtitle types. https://mpv.io


=== id3-related ==
$ aptitude search id3 --disable-columns | grep -v 386
id3 - An ID3 Tag Editor
id3ren - id3 tagger and renamer
id3tool - Command line editor for id3 tags
id3v2 - A command line id3v2 tag editor
kid3 - KDE MP3 ID3 tag editor
kid3-qt - Audio tag editor
libaudid3tag-dev -
libicegrid34 - Libraries implementing grid-like services for ZeroC Ice
libid3-3.8.3-dev - ID3 Tag Library: Development Libraries and Header Files
libid3-3.8.3c2a - library for manipulating ID3v1 and ID3v2 tags
libid3-dev -
libid3-doc - ID3 Tag Library: Documentation
libid3-tools - ID3 Tag Library: Utilities
libid3tag0 - ID3 tag reading library from the MAD project
libid3tag0-dev - ID3 tag reading library from the MAD project
libsmokesolid3 - Solid SMOKE libraries
php-getid3 - PHP script to extract informations from multimedia files
python-id3 - Python module for id3-tags manipulation
squid3 - Full featured Web Proxy cache (HTTP proxy)
squid3-cgi -
squid3-client -
squid3-common - Full featured Web Proxy cache (HTTP proxy) - common files
squid3-dbg - Full featured Web Proxy cache (HTTP proxy) - Debug symbols
xmms2-plugin-id3v2 - XMMS2 - ID3v2 plug-in

https://github.com/leafnode/m3ugen/raw/master/m3ugen.py - Create a m3u playlist with all files (ogg, mp3, mpc) in given directory. Uses eyeD3 and pyvorbis libs to read music length.
eyed3 - Display and manipulate id3-tags on the command-line
python-eyed3 - Python module for id3-tags manipulation


== See also ==
helplame helpflac helpmuzik helpsox
mediainfo
__envHEREDOC__
}
helpmuzik2snippets_flac_to_mp3_conversion(){
cat <<'__envHEREDOC__'
== generic loop defn ==
# e.g. files like : "07 Donald Byrd - Just My Imagination.wav"
for i in *.wav ; do
 j=$( echo $i | awk '{ for(i = 5; i <= NF; i++) { printf("%s ", $i) } printf("\n") }' )
 ttt=$( echo "${j%%.wav }" )
 lame  -V 0 --verbose   --tl "Places and Spaces"  --ty "1975"   --tc "-V 0" --ta "Donald Byrd"  --tt "$ttt"  "$i"
done

=== two loop states: ===
01 Donald Byrd - Change.wav
Change.wav
Change
lame -V 0 --verbose --tl "Places and Spaces" --ty "1975" --tc "-V 0" --ta "Donald Byrd" --tt "Change" 01 Donald Byrd - Change.wav

02 Donald Byrd - Wind Parade.wav
Wind Parade.wav
Wind Parade
lame -V 0 --verbose --tl "Places and Spaces" --ty "1975" --tc "-V 0" --ta "Donald Byrd" --tt "Wind Parade" 02 Donald Byrd - Wind Parade.wav
__envHEREDOC__
}
helpmuzik4(){
cat <<'__envHEREDOC__'
for iTunes and stupid Apple forced interfaces for getting audio files onto playing devices, easiest way to generate a playlist of files youre trying to add and then drag it over the iTunes.  And the so-called playlist in this case only really needs to be a simple file listing.

__envHEREDOC__
}
helpmuzik3detecterrors(){
cat <<'__envHEREDOC__'
= MP3 =
-------
Using mp3info
find path -name *.mp3  -print0 | xargs --verbose -n 1 -0 nice -19 ionice -c 3 mp3info -p "%b\n"

= FLAC =
--------
pretty sure FLAC has its very own checking criteria options from the cmdln...
 --test
 --verify

__envHEREDOC__
}
helpsox(){
cat <<'__envHEREDOC__'
       SoX - Sound eXchange, the Swiss Army knife of audio manipulation
== from sox manpage, slightly modified ==
capabilities, detailed explanations of use, all parameters,
file formats, and effects can be found in sox(1), soxformat(7), and soxi(1).

Here is a selection of examples of how SoX might be used.
The simple:
   sox recital.au recital.wav
^^translates an audio file in Sun AU format to a Microsoft WAV file, whilst
   sox recital.au -b 16 recital.wav channels 1 rate 16k fade 3 norm
^^performs  the  same format translation, but also applies four effects (down-mix to one channel, sample rate change,
fade-in, nomalize), and stores the result at a bit-depth of 16.
   sox -r 16k -e signed -b 8 -c 1 voice-memo.raw voice-memo.wav
^^converts `raw' (a.k.a. `headerless') audio to a self-describing file format,
   sox slow.aiff fixed.aiff speed 1.027
^^adjusts audio speed,
   sox short.wav long.wav longer.wav
^^CONCATENATES two audio files, and
   sox -m music.mp3 voice.wav mixed.flac
^^mixes together two audio files.
   play "The Moonbeams/Greatest/*.ogg" bass +3
^^plays a collection of audio files whilst applying a bass boosting effect,
   play -n -c1 synth sin %-12 sin %-9 sin %-5 sin %-2 fade h 0.1 1 0.1
^^plays a synthesised `A minor seventh' chord with a pipe-organ sound,
   rec -c 2 radio.aiff trim 0 30:00
^^records half an hour of stereo audio, and
   play -q take1.aiff & rec -M take1.aiff take1-dub.aiff
^^(with POSIX shell and where supported by hardware) records a new track in a multi-track recording.  Finally,
   rec -r 44100 -b 16 -s -p silence 1 0.50 0.1% 1 10:00 0.1% | \
     sox -p song.ogg silence 1 0.50 0.1% 1 2.0 0.1% : \
     newfile : restart
^^records a stream of audio such as LP/cassette and splits in to multiple audio files at points  with  2  seconds  of
silence.  Also, it does not start recording until it detects audio is playing and stops after it sees 10 minutes of
silence.
__envHEREDOC__
}
helpdig(){
cat <<'__envHEREDOC__'
# how to say to the dig command to determine an ip address of a hostname, and specify which dns server to use:
dig @server name
dig @dnsserver hostname

dig +short myip.opendns.com @resolver1.opendns.com # determine current ipaddr
__envHEREDOC__
}
helpidentify(){
cat <<'__envHEREDOC__'
identify - describes the format and characteristics of one or more image files. (ImageMagick's image info tool)

# get all information possible:
$ identify -verbose image
# get x-dimensions:
$ identify -format %G image | awk --field-separator x '{ print $1 }'
# get y-dimensions:
$ identify -format %G image | awk --field-separator x '{ print $2 }'

= See also =
helpimages
mediainfo
__envHEREDOC__
}
helpburn(){
cat <<'__envHEREDOC__'
Erase rewritable medium
-----------------------
* In general -> try these 2 cmdln's in this order:
$ cdrecord -v blank=fast dev=/dev/sr0
$ cdrecord -v blank=all -force dev=/dev/sr0
* cdrw -> see `helpwodim`
* dvdrw -> continue:
$ /usr/bin/dvd+rw-format -gui -force /dev/sr0
** ^this is what K3b executes (if, for instance, told it to burn an .iso file and it didn't like the state of the optical media...)
*** yeah, but the actual outcome was that prob didn't actually work.
$ dvd+rw-format -force /dev/sr0
** 1.  ^just ran this and it seems to never come back!! just chillin at 100% :( (got locked to infinity).
** 2.  ^So then i go to K3b and do: format and erase:: everything set to Auto, except-Settings( Force=Checked, Quick_Format=Unchecked ).
*** Then I look at the cmdln that resulted in success... THE SAME AS THE ONE I RAN!  And did NOT result in getting locked to infinity!... uhg
*** Actual cmdln: /usr/bin/dvd+rw-format -gui -force /dev/sr0
** 3.  ^mmk. Perhaps I just haz bad anomoly?  The above cmdln worked on the next dvd+rw I needed to quick-clear.
$ dvd+rw-format -force[=full] [-lead-out | -blank[=full]] /dev/sr0
* https://bugs.launchpad.net/ubuntu/+source/cdrkit/+bug/15424/comments/77

Generate ISO of non-audio, optical medium
-----------------------------------------
dd duh-duh-duh-duh-duh-DUMB arss
$ dd if=/dev/sr0 of=/path/to/output/file.iso
$ dcfldd if=/dev/sr0 of=knoppix.iso

Burn ISO
--------
* cdrw -> see `helpwodim`
* dvdrw -> continue:
** growisofs -dvd-compat -Z /dev/dvd=image.iso
** growisofs -dvd-compat -Z /dev/sr0=image.iso   # <- YES! finally! something works!
** growisofs -dvd-compat -Z /dev/dvd -l -r -V "volume-name" "directory-to-burn"

dd to ISO (e.g.) for Speed Reports (context=Debian Other mailing list "USB Port speeds")
----------------------------------------------------------------------------------------
$ dd if=/dev/zero bs=1M count=1000 | \
  xorriso -as cdrecord -v dev=/dev/sr0 -

$ dd if=/dev/zero bs=1M count=1000 | \
  xorriso -as cdrecord -v dev=/dev/sr0 stream_recording=on -

General Tips
------------
* wodim says: HINT: use dvd+rw-mediainfo from dvd+rw-tools for information extraction:
** $ dvd+rw-mediainfo /dev/sr0
* How to find out the device that your DVD/CD rom is attached to:
** $ cat /proc/sys/dev/cdrom/info
* If errors are received (esp when burning re-writables) try specifying different speeds
** speed=6

Terminology
-----------
: srcs : http://forums.afterdawn.com/threads/what-tao-sao-dao-raw-dao-means.264689/
: http://club.myce.com/f44/tao-dao-better-why-62255/

* TAO: Track-At-Once
* SAO and DAO
** Session-At-Once and Disk-At-Once
** SAO is similar to DAO, but DAO closes the disc, SAO closes only the last session

See Also
--------
* helpwodim*
* helpgrowisofs
* helpdd2 - use dcfldd to post-burn verif.
* devdump, isoinfo, isovfy, isodump - Utility programs for dumping and verifying iso9660 images.
* isomaster - gui program allows for modification of [bootable] ISO's.
* genisoimage
__envHEREDOC__
}
helpwodim(){
cat <<'__envHEREDOC__'
https://bugs.launchpad.net/ubuntu/+source/cdrtools/+bug/556595/comments/4
https://bugs.launchpad.net/ubuntu/+source/cdrkit/+bug/530141/comments/5
some ppl also claiming that wodim does not do dual layer dvd's.

* 8580b51ab99fecd7c5463b0895046904be31927e
$ wodim --devices

* If dev=device is omitted and only 1 optical device exists, by default wodim will use the device.

Erase rewritable medium using ( blank=help ) (for DVD's see helpburn):
----
$ wodim dev=/dev/sr0 -v blank=all  [-eject]   # Blank the entire disk. This may take a long time.
$ wodim dev=/dev/sr0 -v blank=fast [-eject]   # Minimally blank the disk. This results in erasing the PMA, the TOC and the pregap.
$ wodim dev=/dev/sr0 -v blank={type} [-force] # The -force option may be used to blank CD-RW disks that otherwise cannot be blanked.
$ wodim dev=/dev/sr0 -v -format [-eject] # RARE: Format  a  CD-RW/DVD-RW/DVD+RW disc.
  Formatting is currently only implemented for
  DVD+RW media.  A 'maiden' DVD+RW media needs to be formatted before you may  write
  to  it.   However,  as  wodim autodetects the need for formatting in this case and
  auto formats the medium before it starts  writing,  the  -format  option  is  only
  needed if you like to forcibly reformat a DVD+RW medium.

Burn ISO image
----
$ wodim dev=/dev/sr0 -v -tao -data /path/to/iso speed=0  [-eject]
* Re: "speed=0":: If you get an error mesage saying /wodim: trying to use a high speed medium on low writer/, try use higher burninng speed such us speed=1 or speed=2.
* If speed=N is omitted, by default wodim will try the max.

Burn file[s| tree] without making ISO
----
$ genisoimage -R /master/tree | wodim dev=2,0 -v fs=6m speed=2 -
If your system is loaded, you should run genisoimage in the real time class too:
$ sudo nice --18 genisoimage -R /master/tree | wodim dev=2,0 -v fs=6m speed=2 -

$ genisoimage [-V workstation] -R workstation/* | wodim dev=/dev/sr0 -v speed=2 -

~~Some snippets and scratch notes while zero'ing in on the right cmdln to use for optical backups:
~~cd disk01 ;
~~nice --18 genisoimage -V disk01 -R . | wodim dev=/dev/sr0 -v -eject
~~/Some snippets and scratch notes while zero'ing in on the right cmdln to use for optical backups:


See Also
----
* goog"wodim write iso image"
__envHEREDOC__
}
helpwodim2audio(){
cat <<'__envHEREDOC__'
Burn Audio CDR using input.wav
----
* -audio
** (defaults to -audio for  all filenames that end in .au or .wav and to -data for all other files.)

* -text Write CD-Text information based on information taken from a file that contains ascii information for  the  text  strings. Requires 1 of:
** -useinfo (req) tells wodim to read the *.inf (related to icedax)
** -cuefile=filename
***  If a CUE sheet file contains both (binary CDTEXTFILE and text based SONGWRITER) entries, then the information based on the CDTEXTFILE entry will win.

* -textfile=filename Write CD-Text based on information  found  in  the  binary  file filename.
** (To  get  data in a format suitable for this option use `wodim -vv -toc'  to  extract  the  information   from   disk.)

Examples:
$ wodim dev=/dev/sr0 -v -pad infile.wav
$ wodim dev=/dev/sr0 -v -pad -text -cuefile=infile.cue infile.wav

Actual cmdln used by K3b to burn audio CD:
$ wodim -v gracetime=2 dev=/dev/sr0 speed=24 -sao driveropts=burnfree -useinfo -audio /path/to/k3b_audio_0_01.inf
__envHEREDOC__
}
helpgenisoimage(){
cat <<'__envHEREDOC__'
src : https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Installation_Guide/s1-kickstart2-putkickstarthere.html
"Making the Kickstart File Available"

Explains how to modify a bootable linux iso rom for adding a Kickstart file to the install media:

Copy data off optical media to local:
mount image.iso /media/cdrom -t iso9660
rsync -av /media/cdrom/ iso/

Account for the Kickstart file:
touch iso/ks.cfg
mv somekickstartfile.cfg iso/ks.cfg
...

Edit the iso/isolinux/isolinux.cfg configuration file...
vim iso/isolinux/isolinux.cfg
... and the ks= boot option to the line beginning with "append", e.g.
append initrd=initrd.img ks=icdrom:/ks.cfg

Use genisoimage in the iso/ directory to create a new bootable ISO image with your changes included:
cd iso
genisoimage -U -r -v -T -J -joliet-long -V "RHEL-6.7" -volset "RHEL-6.7" -A "RHEL-6.7"
  -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4
  -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot
  -o ../NEWISO.iso .


Implant a md5 checksum into the new ISO image:
# implantisomd5 ../NEWISO.iso
__envHEREDOC__
}
helpscan0(){
cat <<'__envHEREDOC__'
Notes on my Scanning Devices
----
$ lsusb | grep -i epson
Bus 001 Device 008: ID 04b8:0103 Seiko Epson Corp. Perfection 610

__envHEREDOC__
}
helpscan(){
cat <<'__envHEREDOC__'
Notes on how to Scan artifacts in Linux
----

TODO STUB---ROOT OUT BADS, IDENTIFY GOODS.
* gscan2pdf : GNOME-based prog
** not bad!
** Edit > Preferences > Default filename for PDF's:
*** %Y-%M-%D_%t--%a_%y-%m-%d

* simple-scan : GNOME-based prog
* xsane.i686 : X Window System front-end for the SANE scanner interface
* xsane-gimp.i686 : GIMP plug-in providing the SANE scanner interface
* XSane can easily create a book scan from a series of individual scans
* libsane-hpaio.i686 : SANE driver for scanners in HP's multi-function devices
* sane-backends.i686 : Scanner access software
* sane-frontends.i686 : Graphical frontend to SANE
* python-imaging-sane.i686 : Python Module for using scanners
* gnome-scan.i686 : Gnome solution for scanning in the desktop on top of libsane
*
* papras - Manage of electronic documents.  Pap'rass is an application that will interface with your scanner to save documents and index, annotate, classify, and search them.
* scantailor - Interactive post-processing tool for scanned pages.  Scan Tailor is an interactive post-processing tool for scanned pages. It performs operations such as page splitting, deskewing, adding/removing borders, and others. You give it raw scans, and you get pages ready to be printed or assembled into a PDF or DJVU file. Scanning, optical character recognition, and assembling multi-page documents are out of scope of this project.

/TODO STUB


$ sane-find-scanner

$ simple-scan

$ xsane

Currently in my kubuntu newjack-2-ubu1404 install by default:
* Skanlite / AcquireImages
** basic scanning seemed to work ok except for the scan preview.  gave error: "Invalid argument"
** wasn't able to determine the actual supported resolutions.  i tried 75dpi and gave same error.  also, didn't offer 1200dpi which im sure this scanner can do.
** ...
** lol ooh wait, hold up... the default preview scan resolution was 100dpi.  changing that to 150, which is a supported resolution by the scanner, preview works!
** ok, not a bad program.
** it would be nice, however, along with the changable image properties(bright,contra,gamm) it offers you, if it would show a realtime updated potential image... instead you will have to do trial and error scans if youre trying to tinker with those properties.

__envHEREDOC__
}
helpscan2(){
cat <<'__envHEREDOC__'
Tips on how to Scan artifacts in Linux
----
* For optimum OCR results, its good to scan text with a resolution of no less than 300dpi
PROGRAMS:
* unpaper : Post-processing of scanned and photocopied book pages.
__envHEREDOC__
}
helppdf(){
cat <<'__envHEREDOC__'
pdfunite pdfseparate pdfimages tiff2pdf tiff2ps okular xournal pdfgrep pdftotext

== PDF files too large? Try this and adjust -quality value: ==
convert *tif -compress jpeg -quality 1 pdf.pdf
convert *png -compress jpeg -quality 1 pdf.pdf
convert *[pretty much most image formats, AWESOMELY!] -compress jpeg -quality 1 pdf.pdf

== PDF to plain text ==
pdftotext

pdftotext pdf -          # default
pdftotext -layout pdf -  # better than above.  -layout           : maintain original physical layout
pdftotext -layout pdf - -nopgbrk  # better than above.  -nopgbrk          : don't insert page breaks between pages

== remove PDF 'protections' ==
qpdf --decrypt i.pdf o.pdf

= See also =
catdoc - behaves much like cat(1) but it reads MS-Word file and produces human-readable text on standard output. microsoft docx office
__envHEREDOC__
}
helpwget(){
cat <<'__envHEREDOC__'
$ wget -i links.txt --wait=15 --random-wait
$ wget --limit-rate 768000 url  # Limit download bandwidth to 750kibibytes (768000 bytes).
$ wget --limit-rate 409600 url  # Similarly, 400KiB.
$ wget --limit-rate $(( desired-KiB-amount  *  1024 )) url
$ wget url -O filename          # Download url target to filename.
$ wget url -O -                 # Download url target to stdout.

-c,  --continue                resume getting a partially-downloaded file.
__envHEREDOC__
}
helplogrotate_of_files(){
cat <<'__envHEREDOC__'
== Just some Gulf Floundering (scribles and nonsense) ==
filename-and-file-extension.N.`date +"%Y-%m-%d"`
^^prefer
filename-and-file-extension.N.`date +"%Y-%m-%d-%H-%M"`
^^prefer (by extension)

filename-and-file-extension.`date +"%Y-%m-%d"`.N

filename-and-file-extension.`date +"%Y-%m-%d"`

filename.`date +"%Y-%m-%d"`.file-extension
filename.`date +"%Y-%m-%d"`.N.file-extension
filename.N.`date +"%Y-%m-%d"`.file-extension

filename-and-file-extension.`date +"%Y-%m-%d.%H-%M`

== cp's ==
f=
cp -p ${f} ${f}.`date +"%Y-%m-%d"`
cp -p ${f} ${f}.`date +"%Y-%m-%d-%H-%M"`

__envHEREDOC__
}


helpcp(){
cat <<'__envHEREDOC__'
/calling helplogrotate_of_files()/
__envHEREDOC__
helplogrotate_of_files
}

helpbackup(){
cat <<'__envHEREDOC__'
/calling helplogrotate_of_files()/
__envHEREDOC__
helplogrotate_of_files
}
helpbackupsinglefiles(){
cat <<'__envHEREDOC__'
/calling helplogrotate_of_files()/
__envHEREDOC__
helplogrotate_of_files
}

helpadaptec(){
cat <<'__envHEREDOC__'
== Run the java-based Storage Manager ==
sudo /usr/StorMan/StorMan.sh

=== NOTES ===
* For new/blank physical devices, the "Clear" option goes over the entire disk, is not _quick_.

== See also ==
mpt-status - get RAID status out of mpt (and other) HW RAID controllers
dpt-i2o-raidutils - Adaptec I2O hardware RAID management utilities
__envHEREDOC__
}
helpstormanager(){
cat <<'__envHEREDOC__'
/calling helpadaptec()/
__envHEREDOC__
       helpadaptec
}

helpupdatercd(){
cat <<'__envHEREDOC__'
update-rc.d - install and remove System-V style init script links

update-rc.d SERVICE disable|enable [ S|2|3|4|5 ]

update-rc.d[-insserv]

== See also ==
helpchkconfig
__envHEREDOC__
}
helplstopo(){
cat <<'__envHEREDOC__'
lstopo is apart of the Portable Hardware Locality (hwloc) project.

# These 2 options print locality of I/O devices (Breaks down
# which hardware controls which device),
# in a hierarchical manner. For example, this is especially useful if trying to
# find out which controller a particular hdd is connected to, etc.
$ lstopo --taskset
$ lstopo --cpuset
#/These 2 options

$ lstopo --logical
$ lstopo --physical
$ lstopo --whole-io
__envHEREDOC__
}
helpchromium(){
	case $1 in
		google-chrome) local whichbrowser="$1" ;;
		*) local whichbrowser="chromium" ;;
	esac

	heredocWithVariables=$(cat <<__envHEREDOC__
${whichbrowser} URL
${whichbrowser} --incognito URL
__envHEREDOC__
	)
	echo "$heredocWithVariables"
}
helpgooglechrome(){
   helpchromium "google-chrome"
}
helpgrowisofs(){
cat <<'__envHEREDOC__'
* This worked perfectly (or not???) on a known good, previously used dvd+rw medium:
growisofs -dvd-compat -Z /dev/sr0=kubuntu-13.04-desktop-amd64.iso

* Here's a snippet of output:
Executing 'builtin_dd if=kubuntu-13.04-desktop-amd64.iso of=/dev/sr0 obs=32k seek=0'
/dev/sr0: pre-formatting blank DVD+RW...
/dev/sr0: "Current Write Speed" is 2.5x1352KBps.
   14614528/973078528 ( 1.5%) @2.4x, remaining 5:27 RBU  99.9% UBU   1.9%
   25690112/973078528 ( 2.6%) @2.4x, remaining 4:55 RBU  99.9% UBU  94.4%
   36765696/973078528 ( 3.8%) @2.4x, remaining 4:40 RBU  99.9% UBU  94.4%
<SNIP!>
  941686784/973078528 (96.8%) @2.4x, remaining 0:09 RBU  93.6% UBU  94.4%
  952762368/973078528 (97.9%) @2.4x, remaining 0:06 RBU  60.5% UBU  94.4%
  963837952/973078528 (99.1%) @2.4x, remaining 0:02 RBU  27.5% UBU  94.4%
builtin_dd: 475136*2KB out @ average 2.4x1352KBps
/dev/sr0: flushing cache
/dev/sr0: writing lead-out
/dev/sr0: reloading tray

* Note that /var/log/syslog displayed this during the above exec:
Jun  7 23:42:50 intelduo kernel: [772304.792033] warning: `growisofs' uses 32-bit capabilities (legacy support in use)



Or Not??? (didn't work perfectly?)
----
* appears to have burned OK, however, the resulting medium would not boot!
** I tried multiple drives on multiple computers and also even tested that I could boot a different dvd+rw medium that was laying around, so it's not a drive issue.
** next:
*** FAILS tried: sudo !!
*** FAILS trying totally different dvdrw media
*** FAILS trying dvdr-9 (dual layer) (used that crappy white media tho...)
*** trying dvdr-5, but via k3b or whatever.. here is the cmdln that is running:
**** /usr/bin/wodim -v gracetime=2 dev=/dev/sr0 speed=8 -sao driveropts=burnfree -data -tsize=475136s -
**** ^^so prob calculated the size (tsize; which is easy) and then is piping over the .iso file, i assume.
__envHEREDOC__
}
helpguestaccount(){
cat <<'__envHEREDOC__'
Create a guest account login:
$ sudo useradd -m guest
$ sudo passwd -d guest

It's important to note a few things with the above config.
* ensure that PermitEmptyPasswords is no/false in ssh server config, else anyone can log in.
* if applicatble, remove read and execute permissions on any /home directories that shouldn't be readable, listable to the guest user account.
* this does NOT give ability to 'su - guest' via some random X Terminal or remote shell since this are not considered "secure" in this situation.
* this DOES give ability to login via any graphical login (GDM, KDM, LightDM), text log in, and via 'su - guest' if executed within a text login session.  All without a password.

There is an argument to pam_unix.so called nullok_secure.  Changing this to nullok may allow for login via 'su - guest' when using a random X Terminal or remote shell, however it's recommended to not do. http://unix.stackexchange.com/a/10872
__envHEREDOC__
}
helptmux(){
cat <<'__envHEREDOC__'
== CheatSheets ==
http://www.dayid.org/os/notes/tm.html
https://gist.github.com/MohamedAlaa/2961058

== cmdln's ==
tmux ls
tmux attach [-t session-number-index] - attach to tmux session.

== Attached session commands ==
c-a d   - unattach curr tmux session
c-a ?   - shows currently bound/bind'ed keys
c-a :   - tmux command mode e.g. can say like 'show-environment'; BONUS: has tab-completion
c-a ,   - rename curr tmux WINDOW/pane
c-a x   - kill curr tmux window/pane (it uses actual window name)
c-a &   - kill curr tmux WINDOW/pane (it just uses the word "pane" 0); "kill-window"
c-a ???   - kill entire curr tmux session

c-a w   - seems to give you a nifty selectable hierarchical breakdown of all sessions; "choose-tree"

c-a "   - splits current WINDOW/pane horizontally
c-a !   - "break-pane"
c-a ;   - "last-pane"
c-a q   - "display-panes"
c-a h   - "select-pane -L" (vim-mode Left)
c-a j   - "select-pane -D" (vim-mode Down)
c-a k   - "select-pane -U" (vim-mode Up)
c-a l   - "select-pane -R" (vim-mode Right)

== Commands ==
show-environment [-g] - lists environment variables [on a global basis (! this is neat though, its puts each entry ON A SINGLE LINE)]
list-clients  - list all clients attached to the server
detach-client - Detach the current client if bound to a key, the client specified with -t, or all clients currently attached to the session specified by -s.  If -P is given, send SIGHUP to the parent process of the client, typically causing it to exit.
 `--> detach-client -t /dev/pts/5 - when two clients attached to same session, detach other client.

tmux list-pane  - no clue.
tmux list-panes -a - lists all panes on the server
tmux list-panes -as - lists all panes of the current session (seems identical to "-a")
tmux list-panes -F FORMAT
tmux list-panes -F '#{session_name}' - get current session name
 `--> Later, can use this in a script like this: ( http://betabug.ch/blogs/bsdcow/48 )

tmux select-window -t$SESSION:window_name

tmux rename-session [-t] - renames current session [or session specified]

tmux kill-session [-t] - kill current session [or session specified] and all windows

== Misc ==
Specify own window selection session commands
* Do a c-a followed by ":" and enter:
** bind-key -n F10 select-window -t 10  # -n says that the initial tmux c-a is not to be used (just pressing F10 will do the thing)
** bind-key -n F11 select-window -t 11
** bind-key -n F12 select-window -t 12

tmux copy to OS system clipboard? (KDE)
* http://unix.stackexchange.com/questions/15715/getting-tmux-to-copy-a-buffer-to-the-clipboard
* SEE ALSO: helpxdotool()

=== Figure out's ===
* I seem to have a confusion as to what "panes" means...
** session - when you run tmux brand new for first time, you create a session.
** window - when a session is created, one window is created within the session (can think of this like a "tab").
** pane - this is something else???   is it the same as a window?????
          i think pane's are contained within windows.
          ... lol k. now im still confused tho. maybe if i play with splitting and things, it'll become clear?

= See also =
* tmate - Instant terminal sharing (fork of tmux; can coexist on same system)
__envHEREDOC__
}
helphadoop(){
cat <<'__envHEREDOC__'
# Print the full java classpath needed by Hadoop (at least v2):
hadoop classpath

# Print version nfo:
hadoop version         # see also : /etc/default/hadoop (at least for HDP2)

# Put file into HDFS from outside:
hadoop fs -copyFromLocal /sw/big /big1
hadoop fs -copyFromLocal /sw/big /big2

# To see the actual block placement of a specific file...
hadoop fsck filename -files -blocks -racks
# ...from the NameNode server and looked at the top of the report.

# Create a file with more than three replicas
hadoop fs -D dfs.replication=4 -copyFromLocal ~/big /big5

# Changing the replication factor of an existing file...
hadoop fs -setrep 6 /big7
# ...the NameNode wont immediately apply the new replica policy.
# If youre in a hurry, adding -w to the command should trigger immediate replication level change:
hadoop fs -setrep 5 -w /big7

# Similarly, changing the replication factor recursively
hadoop fs -setrep -R 5 -w /big7

# Recursive directory list
hadoop fs -lsr
hdfs dfs -ls -R

# Count the directories, files, and bytes in a path:  (run this if du returns unexpected information)::
hadoop fs -count hdfs://node/data

# Empty filesystem trash
hadoop fs -expunge


# Distributed copy from one or more node/dirs to a target:
hadoop distcp  hdfs://node1:8020/dir_a  hdfs://node2:8020/dir_b

# Distributed copy from one or more node/dirs to the same location on a target (works like cp):
hadoop distcp  hdfs://node1:8020/dir_a  hdfs://node2:8020/

# Job list, dispatching, status check, and kill:
hadoop|mapred job -list [all]
hadoop|mapred job -submit job_file
hadoop|mapred job -status id
hadoop|mapred job -kill id
 ^^------------->> deprecated; use mapred (at least on HDP2.2)
yarn application -list
yarn application -kill id

# List job queues
hadoop|mapred queue -list
 ^^------------->> deprecated; use mapred (at least on HDP2.2)
__envHEREDOC__
}
helphadoop2(){
cat <<'__envHEREDOC__'
== Initiate the Checkpointing process (fsimage, edits, etc.) ==
hadoop|hdfs dfsadmin -saveNamespace
 ^^------------->> deprecated; use hdfs (at least on HDP2.2)

== Snapshots ==
=== usage ===
Usage: hadoop fs [generic options]
        [-createSnapshot <snapshotDir> [<snapshotName>]]
        [-deleteSnapshot <snapshotDir> <snapshotName>]
        [-renameSnapshot <snapshotDir> <oldName> <newName>]

=== examples ===
# To make root directory snapshottable:
hdfs dfsadmin -allowSnapshot /

# Create snapshot of root directory:
hadoop fs -createSnapshot /

# List root directory snapshots:
hadoop fs -ls /.snapshot/

#  drwxr-xr-x   - hdfs hdfs          0 2017-01-05 22:31 /.snapshot/pre-play-around-and-maybe-ruin-hive-data

hdfs dfs -deleteSnapshot / pre-play-around-and-maybe-ruin-hive-data

== DataNode block scanner ==
* http://datanode:50075/blockScannerReport
* http://datanode:50075/blockScannerReport?listblocks
** list of all blocks on the datanode along with their latest verification status.

== Create HDFS home directory for curr $USER ==
NOTE: if hdfs permissions are disabled, you can omit the 'sudo -u hdfs':
sudo -u hdfs hadoop fs -mkdir /user/$USER
sudo -u hdfs hadoop fs -chown $USER:$USER /user/$USER

NOTE: if using MapR, you should use the mapr user instead of hdfs above:
sudo -u mapr hadoop fs -mkdir /user/$USER
sudo -u mapr hadoop fs -chown $USER:$USER /user/$USER

== Rebalance HDFS nodes ==
$ hdfs balancer # starts the rebalancer with the default settings
$ hdfs balancer -threshold 10 # default 10%.  The lower, the more impossible it is.  The higher, the more
rough an average it is or the direction in which the balancer gives up more easier.

== Manually create HDFS fsimage ==
Normally, this would be handled automatically.. but sometimes problems occur and fresh fsimages are not created... or maybe you want to create one manually.
If a new fsimage is not regenerated periodically, you will end up with many unsaved edits to the fsimage.  This will significantly increase the start up time of HDFS service.

hdfs dfsadmin -safemode enter
hdfs dfsadmin -saveNamespace
hdfs dfsadmin -safemode leave
__envHEREDOC__
}
helphadoop3fsck(){
cat <<'__envHEREDOC__'
== Find the blocks for a file ==
Find out which blocks are in any particular file, e.g.
$ hadoop fsck /user/tainted/rubbish -files -blocks -racks

== HDP v2.0.6.0 (or v2.0.8.0; it is not clear to me) (Hadoop2 with YARN) ==
[bdavies@vm-hdp2-b2 ~]$ hdfs fsck -help
Usage: {hadoop|hdfs} DFSck <path> [-list-corruptfileblocks | [-move | -delete | -openforwrite] [-files [-blocks [-locations | -racks]]]]
        <path>  start checking from this path
        -move   move corrupted files to /lost+found
        -delete delete corrupted files
        -files  print out files being checked
        -openforwrite   print out files opened for write
        -list-corruptfileblocks print out list of missing blocks and files they belong to
        -blocks print out block report
        -locations      print out locations for every block
        -racks  print out network topology for data-node locations
                By default fsck ignores files opened for write, use -openforwrite to report such files. They are usually  tagged CORRUPT or HEALTHY depending on their block allocation status
__envHEREDOC__
}
helphadoop4distros(){
cat <<'__envHEREDOC__'
== CDH4 (Hadoop 2) ==
- - - - - - - - - - - - - -
$ sudo -u hdfs hdfs dfs -rm -r -skipTrash /mnt/benchmark-test-data/

Default location of a users .Trash folder:
hadoop fs -ls .Trash
hadoop fs -ls /user/$USER/.Trash


$ sudo -u hdfs hadoop dfsadmin -safemode get
$ sudo -u hdfs hadoop dfsadmin -safemode enter
$ sudo -u hdfs hadoop dfsadmin -safemode leave
$ sudo -u hdfs hadoop dfsadmin -report         # DEPRECATED
$ sudo -u hdfs hdfs dfsadmin -report

== HDP v1.3.0 (Hadoop 1) ==
- - - - - - - - - - - - - -
$ sudo -u hdfs hadoop fs -rmr /mnt/benchark-test-data/   # -> /user/hdfs/.Trash/Current/mnt/benchmark-test-data/
$ sudo -u hdfs hadoop fs -rmr -skipTrash /mnt/benchark-test-data/

$ scp voyager:/mnt/sdd1/kmeans_100GB/* /dev/stdout  | pv -pterb  | hadoop fs -put - /mnt/benchmark-test-data/

$ hdfs getconf -confKey <confKey> # e.g.
$ hdfs getconf -confKey mapreduce.input.fileinputformat.split.minsize
0

== MapR v2.1.3 M3,M5 (Hadoop 1) ==
- - - - - - - - - - - - - -
# -skipTrash option valid?  where is .Trash/ by default?
$ sudo -u mapr hadoop fs -rmr /mnt/benchmark-test-data/

$ hadoop conf -dump  # Cool feature that dumps the curr conf information for this node.

Pretty cool feature if using Hadoop examples jar: you can set a lot of the job parameters from the cmdln that you may have had to set manually within the mapred-site.xml file. E.g.:
$ hadoop jar hadoop-examples.jar terasort -Dmapred.map.child.java.opts="-Xmx1000m"

__envHEREDOC__
}
helphadoop5archives(){
cat <<'__envHEREDOC__'
Hadoop Archives (HAR) reduces load, memory usage on NameNode in particulr when HDFS is storing
many small files (small defn.: a file that uses <1 HDFS block (default=128MB)).

= See also =
* https://developer.yahoo.com/blogs/hadoop/hadoop-archive-file-compaction-hdfs-461.html
* http://hadoop.apache.org/docs/r0.19.0/hadoop_archives.html
* https://www.inkling.com/read/hadoop-definitive-guide-tom-white-3rd/chapter-3/hadoop-archives
__envHEREDOC__
}
helphadoop6distcp(){
cat <<'__envHEREDOC__'
[yep-im-a-scientist@vm-centos6-hdp2-i1 ~]$ hadoop version
 Hadoop 2.2.0.2.0.6.0-101
 Subversion git@github.com:hortonworks/hadoop.git -r b07b2906c36defd389c8b5bd22bebc1bead8115b
 Compiled by jenkins on 2014-01-09T05:18Z
 Compiled with protoc 2.5.0
 From source with checksum 704f1e463ebc4fb89353011407e965
 This command was run using /usr/lib/hadoop/hadoop-common-2.2.0.2.0.6.0-101.jar

[yep-im-a-scientist@vm-centos6-hdp2-i1 ~]$ locate distcp
 /usr/lib/hadoop-mapreduce/hadoop-distcp-2.2.0.2.0.6.0-101.jar

[yep-im-a-scientist@vm-centos6-hdp2-i1 ~]$ hadoop distcp
usage: distcp OPTIONS [source_path...] <target_path>
              OPTIONS
 -async                 Should distcp execution be blocking.
 -atomic                Commit all changes or none.
 -bandwidth <arg>       Specify bandwidth per map in MB.
 -delete                Delete from target, files missing in source.
 -f <arg>               List of files that need to be copied.
 -filelimit <arg>       (Deprecated!) Limit number of files copied to <= n .
 -i                     Ignore failures during copy.
 -log <arg>             Folder on DFS where distcp execution logs are saved.
 -m <arg>               Max number of concurrent maps to use for copy.
 -mapredSslConf <arg>   Configuration for ssl config file, to use with hftps:// .
 -overwrite             Choose to overwrite target files unconditionally, even if they exist.
 -p <arg>               preserve status (rbugp)(replication, block-size, user, group, permission).
 -sizelimit <arg>       (Deprecated!) Limit number of files copied to <= n bytes.
 -skipcrccheck          Whether to skip CRC checks between source and target paths.
 -strategy <arg>        Copy strategy to use. Default is dividing work based on file sizes.
 -tmp <arg>             Intermediate work path to be used for atomic commit.
 -update                Update target, copying only missingfiles or directories.

"distcp -update" will update a file if src size is different from dst size.
 Keep in mind -update is not a delta-xfer algo like rsync and only does a size check,
 which isn't perfect when files are all the same size yet data is different.

"distcp -overwrite" will overwrite the file no matter whether the size matches or not. It's
 a destructive process, so make sure that you really want to do this.


== arguments seem to have luck with for most distros ==
hadoop distcp -delete -overwrite -prbugp

== arguments had to use instead with HDP2.1.7.0 and Isilon ==
hadoop distcp -delete  -skipcrccheck -update
__envHEREDOC__
}
helphive(){
cat <<'__envHEREDOC__'
= Import/Export database tables: syntax and example =
ssh host "hive -e "EXPORT TABLE ${hivetable} TO \"${hdfsdestination}/${hivetable}\";"
`-> ssh vm-hdp22-c1      'hive -e "EXPORT TABLE mts_scheduling_domain_2_0_orc.place_patterns_orc TO '\''/tmp/exports/mts_scheduling_domain_2_0_orc.place_patterns_orc'\'';"'
`-> ssh muzik-production 'hive -e "EXPORT TABLE mfdoom_quotes.buttery_biscuits TO '\''/tmp/exports/mfdoom_quotes.buttery_biscuits'\'';"'

ssh host "hive -e \"CREATE DATABASE $hivedatabase;\""
`-> ssh vm-hdp22-f1 'hive -e "CREATE DATABASE mts_scheduling_domain_2_0_orc;"'
`-> ssh muze        'hive -e "CREATE DATABASE mfdoom_quotes;"'

ssh host "hive -e \"USE $hivedatabase; DROP TABLE ${hivetable};\""
`-> ssh vm-hdp22-f1 'hive -e "USE mts_scheduling_domain_2_0_orc; DROP TABLE mts_scheduling_domain_2_0_orc.place_patterns_orc;"'
`-> ssh muze        'hive -e "USE mfdoom_quotes; DROP TABLE mfdoom_quotes.buttery_biscuits;"'

ssh host "hive -e \"USE $hivedatabase; IMPORT FROM '${hdfssource}/${hivetable}';\""
`-> ssh vm-hdp22-f1 'hive -e "USE mts_scheduling_domain_2_0_orc; IMPORT FROM '\''/tmp/exports/mts_scheduling_domain_2_0_orc.place_patterns_orc'\'';"'
`-> ssh muze        'hive -e "USE mfdoom_quotes; IMPORT FROM '\''/tmp/exports/mfdoom_quotes.buttery_biscuits'\'';"'


= Meta && discovery =
: Rule of thumb: pretty sure Hive runs on top of MySQL (or through it, idk, doesn't matter),
  basically, if unsure about syntax, can always try the MySQL equivalent.

hive> SHOW CONF $conf-name ; returns a description of the specified configuration property.
hive> set $conf-name ; shows the current value of $conf

hive> show databases
hive> describe database $db
hive> describe database extended $db

hive> show tables
hive> describe $table
hive> describe extended $table

special count
hive>
hive>
hive>

= Other =
hive> ANALYZE TABLE table_name COMPUTE STATISTICS FOR COLUMNS ;  will compute column statistics for all columns in the specified table (and for all partitions if the table is partitioned).

To view the gathered column statistics:
hive> DESCRIBE FORMATTED [db_name.]table_name column_name ;
hive> DESCRIBE FORMATTED [db_name.]table_name column_name PARTITION (partition_spec);

See https://cwiki.apache.org/confluence/display/Hive/StatsDev#StatsDev-ExistingTables for more information about the ANALYZE TABLE command.

beeline -u 'jdbc:hive2://hostname:10000/default;principal=hive/_HOST@DOMAIN.COM'
beeline -u 'jdbc:hive2://'

__envHEREDOC__
}
helpambari(){
cat <<'__envHEREDOC__'
: src : https://cwiki.apache.org/confluence/display/AMBARI/Using+APIs+to+delete+a+service+or+all+host+components+on+a+host

List cluster services:
curl -u admin:admin -H "X-Requested-By: ambari" -X GET  http://`hostname`:8080/api/v1/clusters/vmhdp23d/services/

List service components (for example, components of service=HDFS):
curl -u admin:admin -H "X-Requested-By: ambari" -X GET  http://`hostname`:8080/api/v1/clusters/vmhdp23d/services/HDFS

List info about service component (for example, component=SECONDARY_NAMENODE):
curl -u admin:admin -H "X-Requested-By: ambari" -X GET  http://`hostname`:8080/api/v1/clusters/vmhdp23d/services/HDFS/components/SECONDARY_NAMENODE

Delete a service component (for example, component=SECONDARY_NAMENODE):
curl -u admin:admin -H "X-Requested-By: ambari" -X DELETE http://`hostname`:8080/api/v1/clusters/vmhdp23d/services/HDFS/components/SECONDARY_NAMENODE
__envHEREDOC__
}
helpfind(){
cat <<'__envHEREDOC__'
== Syntax ==
-xdev  - do not cross filesystem boundaries.

== Examples ==
# Recursively list *file* modification times:
find $a -type f -exec stat --format '%Y :%y %n' {} \;

# Pretty sure this lists the 10 most recently modified files. Probably
# even lists ALL files in most recently modified first, order:
find $a -type f -exec stat --format '%Y :%y %n' {} \; | sort -nr | cut -d: -f2- | head

# Both of the next 2 cmdln's will find the same number of files, but in order
# to use '-exec' *MUST* wrap within parens or else the '-exec' will only
# operate on the file that match the last '-name':
find ark.*    -name \*.rar -o -name \*.par2
find ark.* \( -name \*.rar -o -name \*.par2 \) -exec ls '{}' \;


# Find files modified over a day ago
find . -name x -mtime +2

# Find files modified in the last 2 days:
$ find . -type f -mtime -2

# To search for files in /target_directory and all its sub-directories, that have been modified in the last 60 minutes:
$ find /target_directory -type f -mmin -60

# Find files that have been modified in the last 7 days, but not in the last 3 days:
$ find /target_directory -type f -mtime -7 ! -mtime -3

# Find most recently modified file:
find /target_directory -type f -exec stat --format '%Y :%y %n' {} \; | sort -nr | cut -d: -f4- | cut -d' ' -f3- | head -1

== See also ==
helpcomparingdirectories
__envHEREDOC__
}
helpstat(){
cat <<'__envHEREDOC__'
/calling helpfind()/
__envHEREDOC__
	helpfind
}
helpxclip(){
cat <<'__envHEREDOC__'
To copy contents of a file or output of some command to clipboard use:
   cat ./myfile.txt | xclip -i
the text can be then pasted somewhere using middle mouse button (this is called "primary selection buffer").

If you want to copy data to the "clipboard" selection, so it can be pasted into an application with Ctrl-V, you can do:
   cat ./myfile.txt | xclip -i -selection clipboard

xclip -selection clipboard < ~/.ssh/id_rsa.pub

Copy the contents of a remote text file:
   ssh remote  cat /etc/ansible/hosts | xclip -i -selection clipboard

== SEE ALSO ==
* Linux command xclip wiki page
__envHEREDOC__
}
helpcomparingdirectories(){
	# for DIR in a b c ; do  curr=$( eval echo "\$$( echo "$DIR" )" );
cat <<'__envHEREDOC__'
== Setup some variables ==
e.g.
a=/mnt/theon-grayjoy/files/
b=/path/to/dir/with/similar/shtuff/to/compare/
c=/mnt/khal-drogo/files/
<...>

== Get Comparison Statistics ==
# Disk Usages:
$ for DIR in a b c ; do  curr=$( eval echo "\$$( echo "$DIR" )" );  /usr/bin/du --exclude=lost+found -s $curr ; done
for DIR in a b c ; do  curr=$( eval echo "\$$( echo "$DIR" )" );  /usr/bin/du --exclude=lost+found -s --apparent-size $curr ; done

# File Counts:
for DIR in a b c ; do  curr=$( eval echo "\$$( echo "$DIR" )" );  find $curr -type f | wc -l ; done

# Pretty sure this lists the 10 most recently modified files. Probably even lists ALL files in most recently modified first, order:
for DIR in a b c ; do  curr=$( eval echo "\$$( echo "$DIR" )" );  echo "-> le $curr";   find $curr -type f -exec stat --format '%Y :%y %n' {} \; | sort -nr | cut -d: -f2- | head ;  echo "->/le $curr";  echo;  echo; done

# Perform a quick diff--basically just a file existance and file size comparison:
rsync -av --delete --stats --progress --human-readable --xattrs --hard-links --devices  --dry-run --no-owner --no-group --no-perms --no-times --exclude=lost+found/  $a  $b

# Perform a long diff--same as previous but just add the --checksum option.
__envHEREDOC__
}

helpgetfattr(){
   echo "/calling helpxattrs()/"
   helpxattrs
}

helpattr(){
   echo "/calling helpxattrs()/"
   helpxattrs
}

helpxattrs(){
cat <<'__envHEREDOC__'
= various tools that interact with Extended Attributes =
== youtube-dl option ==
   --xattrs  Write metadata to the video file's xattrs (using dublin core and xdg standards)

== attr: /usr/bin/getfattr ==
Package Description: Utilities for manipulating filesystem Extended Attributes
 A set of tools for manipulating Extended Attributes on filesystem objects, in particular getfattr(1) and setfattr(1). An attr(1) command is also provided which is largely compatible with the SGI IRIX tool of the same name.
   getfattr - get Extended Attributes of filesystem objects
   setfattr - set Extended Attributes of filesystem objects
   attr - Extended Attributes on XFS filesystem objects     (lol, k... XFS, huh?...)

== python-xattr: /usr/bin/xattr ==
Package Description: module for manipulating filesystem Extended Attributes
This module allows manipulation of the filesystem Extended Attributes present in some operating systems (GNU/Linux included). It is compatible to python-pyxattr but also provides a dictionary like interfaces for manipulating these Attributes.
   xattr - sets or lists Extended Attributes on a file or directory.


= filesystem confusion, etc =
   attr - is aimed specifically at users of the XFS filesystem!!!
   getfattr/setfattr - for filesystem __independent__ Extended Attribute manipulation.


== e2fsprogs: lsattr and chattr ==
  lsattr - list file attributes on a Linux second Extended file system; apart of e2fsprogs.
  chattr - list file attributes on a Linux second Extended file system; apart of e2fsprogs.
... !!! ... this has nothing to do with Extended Attributes; theyre simply _file attributes_.

== xfs and chattr ==  xfs(5)
  The XFS filesystem supports setting the following file attributes on Linux systems using the chattr(1) utility:
     a - append only
     A - no atime updates
     d - no dump
     i - immutable
     S - synchronous updates
  refer to chattr(1) for descriptions of these attribute flags.
... !!! ... this has nothing to do with Extended Attributes; theyre simply _file attributes_.


= examples =
getfattr -d file > file.getfattrdump # dump.
setfattr --restore=file.getfattrdump # restore.
setfattr -n user.ya -v 77            # do a thing.

= See also =
* [http://www.linux-mag.com/id/8741/ Extended File Attributes Rock! | Linux Magazine]
* [http://www.linux-mag.com/id/8794/ Checksumming Files to Find Bit-Rot | Linux Magazine]
* $ aptitude search xattr

* a metadata dumping tool : metastore - Store and restore metadata from a filesystem
?metamonger - Save, diff, and restore filesystem metadata
?extract - displays meta-data from files of arbitrary type

== other meta-related but not necessarily Extended Attribute-related ==
metacam - extract EXIF information from digital camera files
atomicparsley - read, parse and set metadata of MPEG-4 and 3gp files
exempi - command line tool to manipulate XMP metadata
exifprobe - read metadata from digital pictures
exiv2 - EXIF/IPTC/XMP metadata manipulation tool
oidua - audio file metadata lister
pngmeta - Display metadata information from PNG images
pypy-mutagen - audio metadata editing library (PyPy)
python-enzyme - video metadata parser (Python 2)
yamdi - a utility for adding metadata to flash video files

python3-enzyme - video metadata parser (Python 3)
python3-libxmp - Python3 library for XMP metadata
python3-mutagen - audio metadata editing library (Python 3)
python3-pafy - Download videos and retrieve metadata from YouTube
python-extractor - extracts meta-data from files of arbitrary type (Python bindings)
python-hachoir-metadata - Program to extract metadata using Hachoir library
python-kaa-metadata - Media Metadata for Python
python-libxmp - Python library for XMP metadata
python-mutagen - audio metadata editing library

tracker-extract - metadata database, indexer and search tool - metadata extractors
tracker-gui - metadata database, indexer and search tool - GNOME frontends
tracker - metadata database, indexer and search tool
tracker-miner-fs - metadata database, indexer and search tool - filesystem indexer
__envHEREDOC__
}
helpxpra(){
cat <<'__envHEREDOC__'
host1 HAS a window thats desired to be viewed.
host2 is WHERE its desired to view the window.

host1~ sleep 7s ; tail -F ~/.xpra/*.log
host1~ xpra {start|upgrade} :100 --start-child=konsole
host2~ xpra attach ssh:host1:100

= kubu1804 =
- two machines, both with xpra v2.1.3-r17247M, are unable to perform the above, out of the box.
__envHEREDOC__
}
helpkde(){
cat <<'__envHEREDOC__'
kde4-config  --kde-version
qdbus org.kde.klipper /
qdbus org.kde.klipper /klipper  # shows function prototypes.
qdbus org.kde.klipper /klipper getClipboardContents # calls one of the functions.
__envHEREDOC__
}





helpzfs(){
cat <<'__envHEREDOC__'
zfs list   [-v]  - Gives overview--pool name, disk usage, mountpoint.
zpool list [-v]  - Similar to zfs; doesn't delv into filesystem stats.
zpool iostat [-v] - Gives details of r/w operations.
zpool status     - Gives current status.


zpool export     - Exports the given pools from the system. All devices are marked as exported, but are still considered in use by other subsystems. The devices can be moved between systems (even those of different endianness) and imported as long as a sufficient number of devices are present.
zpool import     - Imports the given pool.  When no pool specified, display pools available for import.

zpool offline [-t] - Disables the disk in the array[, temporarily (will be restored upon reboot)].
zpool replace    - Swaps the existing medium.

zpool remove     - Removes specified device from the pool. Currently, only pertains to hot spares, cache, and log devices.
zpool detach     - Detaches device from a mirror. Operation is refused if there are no other valid replicas of the data.
zpool destroy    - Destroys the pool.

zpool clear      - When errors occur (should become a fault or degrade), once resolved, clears the error status of that zpool
zpool labelclear - Removes ZFS label information from the specified device.

zpool get all [zpool] - Gives properties [of specified zpool].
zfs get all [fs] - Gives properties [of specified filesystem].
zpool set        - Set a property pertaining to a pool. (lists properties if dataset provided)
zfs set          - Set a property pertaining to <filesystem|volume|snapshot>. (lists properties if dataset provided)

zfs get origin   - For cloned file systems or volumes, the snapshot from which the clone was created. See also the clones property.

zpool-features   - Supposidly, displays the available features included with the running ZFS version.

zpool events [-v]   - UNDOCUMENTED.
zpool history [-il] - Displays internally logged zfs events.

zdb              - display zpool debugging and consistency information

__envHEREDOC__
}
helpzfs2(){
cat <<'__envHEREDOC__'
== ZFS CREATION ==
# NOTE: assumes brand new blank drive.
# NOTE: OmniOS (at least 5.11 omnios-8d266aa 2013.05.04) does not support this 'ashift' option.
# NOTE: on Sun/Illumos/Omni, first call cfgadm.
d=c7t1d0               # e.g. on Solaris.
d=/dev/sdc             # e.g. on Linux.
dnamefull=a107-2787
dname=$( echo ${dnamefull} | cut --delimiter=- --fields=1 )

# Only if on Thumper:
cfgadm -la sata                    # if necessary, to find an empty slot / to determine which slot hdd was plugged into.
sudo cfgadm -c configure <Ap_Id>   # (e.g. sata5/1)

# Only if physical 512-byte size for physical sectors.
sudo zpool create                 -m /mnt/${dname} $dname ${d}
# Only if using AF/4096-byte size for physical sector disks: http://wiki.illumos.org/display/illumos/ZFS+and+Advanced+Format+disks
sudo zpool create -f -o ashift=12 -m /mnt/${dname} $dname ${d}


sudo zfs create ${dname}/fs1
#sudo zfs set mountpoint=none ${dname}
sudo zfs create  -o mountpoint=none  ${dname}/iam--${dnamefull}--$( basename ${d} )
#sudo zfs set mountpoint=none ${dname}/iam--${dnamefull}--$( basename ${d} )

sudo zpool set delegation=on $dname
sudo zfs allow everyone readonly ${dname}/fs1
sudo zfs allow everyone readonly ${dname}/iam--${dnamefull}--$( basename ${d} )

sudo chmod ugo+rwx /mnt/${dname}/fs1

# If this is to be a single disk-backed zpool?  Increase copies property which could possibly protect from bad blocks:
sudo zfs set copies=2  ${dname}/fs1

# SMB / SAMBA / CIFS sharing
sudo zfs set "sharesmb=name=${dname},description=${dname}" ${dname}/fs1

# NFS sharing
sudo zfs set sharenfs=on export/home
sudo zfs share export/home

# Set desired zfs-auto-snapshot behaviour:
sudo zfs set com.sun:auto-snapshot=false ${dname}
sudo zfs set com.sun:auto-snapshot=false ${dname}/fs1
sudo zfs set com.sun:auto-snapshot=false ${dname}/iam--${dnamefull}--$( basename ${d} )
sudo zfs set com.sun:auto-snapshot=true ${dname}
sudo zfs set com.sun:auto-snapshot=true ${dname}/fs1
sudo zfs set com.sun:auto-snapshot=true ${dname}/iam--${dnamefull}--$( basename ${d} )


== create a raidz1 device ==
sudo zpool create -n  -m /mnt/$poolname  $poolname  raidz  c7t1d0  c7t5d0  c4t6d0




== ADD DEVICE TO EXISTING ZPOOL TO CREATE MIRROR ==
# assuming a128 is the pooled device you want to add to another pool (and delete a128):
old_pool_full_name=a128-2786
old_pool=$( echo ${dnamefull} | cut --delimiter=- --fields=1 )
zpool status $old_pool            # Note the device of this pool.
sudo zpool destroy $old_pool

old_pool_device=c7t1d0            # From above.

pool=a122
device=c7t3d0
new_device=${old_pool_device}

sudo zpool attach $pool $device $new_device

sudo zfs create a122/iam--a128-2786--c11t5d0
sudo zfs create ${pool}/iam--${old_pool_full_name}--${old_pool_device}


== ZFS STATUS ==
zpool scrub $dname
zpool status $dname

== ZFS SNAPSHOTS ==
zfs snapshot ${dname}/fs1
zfs snapshot ${dname}/fs1@$( date +"%Y-%m-%d_%H.%M.%S" )

zfs snapshot ${dname}@$( date +"%Y-%m-%d_%H.%M.%S" )

zfs set snapdir=visible - Makes the .zfs directory visibe in the root of the filesystem.

= See also =
helphdd4
__envHEREDOC__
}
helpzfs3(){
cat <<'__envHEREDOC__'
NOTE: properties are inherited from the parent unless overriden by the child.
zfs set mountpoint=/mnt/testpool testpool

zfs set dedup=on   testpool # e.g. Would get inherited by testpool/fs{1,2,3}, if existing.
zfs set compression=on pool # e.g. Would get inherited by     pool/fs{1,2,3}, if existing.

zpool get dedup  - Lists system pools and associated deduplication ratio.
zfs   get dedup  - Lists system pools and child datasets, if exists, and associated dedup property value.

zpool get all    - Retrieves all properties for specified pool.
zfs   get all    - Displays all properties that apply to the given datasets (or all datasets on the system if none specified) type; filesystem, volume, or snapshot.

__envHEREDOC__
}
helpzfs4(){
cat <<'__envHEREDOC__'
df -hT ; echo ; sudo zfs list  ; free -m ; uptime ; echo
di ; echo ; sudo zpool list -v ; sudo zfs list -t all -r  ; free -m ; uptime ; echo

zpool status ; sudo zpool list -v ; sudo zfs list -t all -r
zpool status | grep -vP "^[\s]*$" ; sudo zpool list -v ; sudo zfs list -t all -r  ########
zpool status | grep -v "^$" | grep -v config: | grep -v errors:

iostat 1
sudo zpool iostat 1
 alternatively...
sudo zpool iostat -v 1

echo ; sudo zpool list -v ; sudo zfs list

di ; echo ; sudo zpool list -v ; sudo zfs list -t all -r  ; free -m ; uptime ; echo
__envHEREDOC__
}
helpzfs5(){
cat <<'__envHEREDOC__'
2013-12-11 steps to replace redundant zpool partition device with non-partitioned device.

Not sure if you can even do this gracefully using zfs cmdln's (it seems you can... prob
want to nail down the actual best steps to follow, along with an example), ~~~nor how
difficult the extra work may be if the graceful approach doesn't work~~~ (N/A).

# the base block device :
d=/dev/sda
# the partitioned block device, i.e. /dev/sda1 :
partitioneddev=${d}1

zpool remove rpool $partitioneddev  # should fail with: cannot remove /dev/sdc1: only inactive hot spares, cache, top-level, or log devices can be removed.
zpool detach rpool $partitioneddev  # should fail with: cannot detach /dev/sdc1: only applicable to mirror and replacing vdevs.

zpool export rpool
zpool labelclear -f $partitioneddev

# ~~~(if applicable, physically swap out hdd that should be removed and swap in new)~~~
# (if your current scenario calls for physical hdd swapping for some reason, NOW
#  is the time to do so.)

zpool import rpool  # should succeed with: pool being imported and brought online, albeit in a degraded state.

zpool replace rpool $partitioneddev $d  # should succeed with: pool beginning to resilver.


# to cancel that resilver operation (e.g. maybe takes too long), can do one of:
$ zpool detach your_pool_name new_device  # which detaches the new device and stops resilver.
$ zpool scrub -s your_pool_name           # which stops the scrub/resilver.
^^^TODO STUB: mv this content elsewhere.


2017-05-22
# steps to remove a single device-backed zpool whose device has been physically removed but is currently shown as FAULTED:
#  ( ran into this problem when a bad hdd locked up the os as far as storage cmds were concerened; physically removed device; bounced machine (possibly hard) ).
zpool destroy

2017-05-23
# steps to resolve:
## state: ONLINE
## status: One or more devices are faulted in response to IO failures.
## errors: 8194 data errors, use '-v' for a list
# By default, the _failmode_ property is set to _readonly_. so you can't do anything basically at this point.
# Will need to set it to _continue_.
zpool clear a134
zpool status -v a134               # to list errors
#zpool set failmode continue a134
zfs set copies 3 a134/fs1

lol bad disk still locked up system wrt disk tools concerning particular zpool :/
__envHEREDOC__
}
helpzfs6sending(){
cat <<'__envHEREDOC__'
# Backup an entire pool including all snapshots and properties and dedupeish:
# Create snapshot:
sudo zfs snapshot -r a46-467@2014-03-08_01-05-30--for-sending

# Do the dump:
time sudo zfs send -v -P  -R -D  a46-467@2014-03-08_01-05-30--for-sending  >a46-467-at-2014-03-08_01-05-30--for-sending.zfs-send-dump

# Another
destinname=a155
sourcename=a122
snapshotname="${sourcename}@$( date +'%Y-%m-%d_%H.%M.%S' )"
sudo zfs snapshot -r ${snapshotname}
sudo zfs unmount $destinname

# dont use this.... seemed to do weird stuff afterwards with automounting not working (try solution where destination isnt mounted):
#time sudo zfs send -vPR ${snapshotname} | sudo zfs receive -e $destinname
# same (dont use this):
time sudo zfs send -vP ${snapshotname} | sudo zfs receive -Fv $destinname/fs1

# COMPLETE; this works correctly!::
#  `-> methinks the big thing was... the export followed by the import *without* any kind of mounting.
# NOTE: this does not include any snapshots other than the one that is sent.
destinname=a134
sourcename=a114
snapshotname="${sourcename}/fs1@$( date +'%Y-%m-%d_%H.%M.%S' )"
sudo zpool export ${destinname}
sudo zpool import -N ${destinname}
time sudo zfs send -vP $snapshotname | sudo zfs receive -vF ${destinname}/fs1
# receiving full stream of a123/fs1@2017-06-10_22.49.35 into ${destinname}/fs1@2017-06-10_22.49.35
#   receive full stream of a114/fs1@2017-06-10_01.42.19 into          a134/fs1@2017-06-10_01.42.19
# to receive /ALL/ snapshots, use -R in the send


# Doesnt actually receive a stream but ALLOWS TO VERIFY THE NAME the receive operation WOULD use:
zfs receive -n -v
__envHEREDOC__
}




helpntp(){
cat <<'__envHEREDOC__'
# How off or drift'ed is this machines time? (add servers to increase accuracy and resilience)
ntpdate -q -v ntp.ubuntu.com  pool.ntp.org
ntpq -pn
ntpdc -c sysinfo
ntpstat         # Seems to only be on RHEL-based machines.  Says if machine is synchronized or not.

# Sync this machines time:
sudo ntpdate -v ntp.ubuntu.com  nist1-pa.ustiming.org  time-d.nist.gov

# Sync this machines time but stop the ntp service first since it uses the same socket:
sudo service ntpd stop || sudo service ntp stop; sudo ntpdate -v 2.north-america.pool.ntp.org; sudo service ntpd start || sudo service ntp start

== Install an NTP daemon ==
# For RHEL, see mwiki [[Linux command ntpdate]] as it requires >1 step.
# For Ubuntu (debian too?):
sudo apt-get install ntp
# Note that if the machine is WAY out of sync, prob must manually sync first using ntpdate (above).
# Note by default ntp uses UDP port 123.

== Public NTP servers (from the pool.ntp.org proj) ==
 -> Project asks that queries to pub servers do not occur >once/4s.
[0-3].fedora.pool.ntp.org
tick.apple.com
[0-3].north-america.pool.ntp.org

time.nist.gov

nist1-ny.ustiming.org         # DED? NYC, NY, USA
nist1-pa.ustiming.org         # DED? Northern Philly, PA, USA
time-[a-d].nist.gov           # MoCo, MD, USA
nist1.aol-va.symmetricom.com  # NoVa, VA, USA
nist1-la.ustiming.org         # LA, CA, USA

== sysfs thinggies ==
cat /sys/devices/system/clocksource/clocksource0/current_clocksource
cat /sys/devices/system/clocksource/clocksource0/available_clocksource

Apparently "hpet" is preferable to at least tsc.  hpet is apparently the future (of this technology).
sudo su -c 'echo "hpet" > /sys/devices/system/clocksource/clocksource0/current_clocksource'
__envHEREDOC__
}
helpbattery(){
cat <<'__envHEREDOC__'
on_ac_power (1)      - test whether computer is running on AC power

DESCRIPTION
       checks  whether  the  system is running on AC power (i.e., mains power) as
       opposed to battery power.

EXIT STATUS
       0 (true)  System is on mains power
       1 (false) System is not on mains power
       255 (false)    Power status could not be determined

FILES
       /proc/apm         APM status information file
       /proc/acpi        ACPI status information directory


== See also ==
upower
__envHEREDOC__
}
helppython(){
cat <<'__envHEREDOC__'
python -c 'print 2**100**100'   # Hog RAM and peg 1 CPU.

python -c 'import socket; print socket.gethostbyname(socket.getfqdn())'  # get hostname/ip or something

echo '{"numRows": "-1"}' | python -mjson.tool  # reformats JSON to human readable format.

python -m SimpleHTTPServer 9999   #  To "http" serve current working directory on the network, port 9999.

== dynamic interpretter ==
use ptpython - https://github.com/jonathanslenders/ptpython/ - pip install ptpython
use bpython  - https://github.com/bpython/bpython            - pip install bpython

=== functions ===
dir( [object] ) - shows current env objects[, shows objects properties].
help( [object] ) - API docs [for object].
type( object )  - shows object type.

== dumping variables ==
import pprint
pprint.pprint( var )

== Regex ==
: src : http://www.thegeekstuff.com/2014/07/advanced-python-regex/
>>> paragraph = \
... '''
... YOUR MULTI LINE STRING IN QUESTION TO DO REGEXING ON
... '''
>>> import re
>>> match = re.search( r' THE REGULAR EXPRESIONISMS ', paragraph, re.MULTILINE)
>>> match.string
<the matched string will display if it matched, otherwise it will not>

# alternatively...
>>> re.search( r' THE REGULAR EXPRESIONISMS ', paragraph, re.MULTILINE).string

== non-Pythonic loop ==
for i in range(0, len( filesArray )):
   print( filesArray[i] )

== See also ==
helpvirtualenv
configparser - a library for modifying ini-based files as a dictionary
__envHEREDOC__
}
helppythonic(){
cat <<'__envHEREDOC__'
print("\n".join(filesArray[1:4])) # K.I.M.: in slice notation, the stop value (4,
           # here) represents the first value that is /not/ in the selected slide.

3 in [1, 2, 3] # => True     https://stackoverflow.com/questions/9542738/python-find-in-list

a = [ {'name':'pippo', 'age':'5'} , {'name':'pluto', 'age':'7'} ]
[d for d in a if d['name']=='pluto'][0]      # =>  {'age': '7', 'name': 'pluto'}
[d for d in a if d['name'] == 'pluto']       # => [{'age': '7', 'name': 'pluto'}]
filter(lambda x: x.get('name') == 'pluto',a) # => [{'age': '7', 'name': 'pluto'}]
[d['age'] for d in a if d['name']=='pluto']  # => ['7']

existing_snaps = ec2.describe_snapshots(OwnerIds=account_ids)["Snapshots"]
found_snaps = [ d for d in existing_snaps if d['SnapshotId'] == snapshotid ]
__envHEREDOC__
}
helpalternatives(){
cat <<'__envHEREDOC__'
sudo alternatives --install /usr/bin/java java /usr/java/jdk1.5.0_22/bin/java 2
sudo alternatives --install /usr/bin/javac javac /usr/java/jdk1.5.0_22/bin/javac 2
sudo alternatives --config java
sudo alternatives --config javac
__envHEREDOC__
}
helpupdatealternatives(){
cat <<'__envHEREDOC__'
/calling helpalternatives()/
__envHEREDOC__
	helpalternatives
}
helpnc(){
cat <<'__envHEREDOC__'
/calling helpnetcat()/
__envHEREDOC__
	helpnetcat
}





# TODO STUB: Determine better function names... or remove these entirely.
# Solaris-like operating system help texts would be more precise, methinks.
# or better yet: Illumos.

#### add this somewhere too:
#### - https://wiki-bsse.ethz.ch/display/ITDOC/Solaris+tips+and+tricks

helpomnios1_ipmitool(){
cat <<'__envHEREDOC__'
ipmitool sdr     # Print Sensor Data Repository entries and readings. temperature, fan speed, power info, hdd slot state
ipmitool sdr type Temperature
ipmitool sdr type Temperature | awk '{ print $9 }' | xargs echo $( date --rfc-3339 sec )     # Just a single line of output.

ipmitool sensor  # Similar to sdr, but with more data.

ipmitool fru     # Prints nfo about the sensors.

ipmitool user set password 0x02 changeme     # Makes the ILOM login credentials root:changeme

# latest installed ipmitool doesn't work anymore for some absolutely unknown and mind boggling
# reason, something about doesn't know about "fan" option for "sunoem" lol bullocks.
ipmitool sunoem fan speed 0   # Sets fan speed to 0%  ; avg 3900RPM; <base wattage>w
ipmitool sunoem fan speed 100 # Sets fan speed to 100%; avg 7900RPM; <base wattage>w+150w
# luckily, have a copy of an older working ipmitool...
/opt/ipmitool-1.8.12/sbin/ipmitool sunoem fan speed 0   # Sets fan speed to 0%  ; avg 3900RPM; <base wattage>w
/opt/ipmitool-1.8.12/sbin/ipmitool sunoem fan speed 100 # Sets fan speed to 100%; avg 7900RPM; <base wattage>w+150w

ipmitool firewall info  # Sort of caused the system to lock up... PROB DONT RUN THIS!

ipmitool -V      # Print version
__envHEREDOC__
}
helpomnios2_equivalents(){
cat <<'__envHEREDOC__'
== system start and stop cmdln ==
shutdown -y -i5 -g0 # (USE THIS!! to turn machine OFF) like init 0; can take ~4-5mins, fyi.
shutdown -y -i6 -g0 # restart like init 6;

shutdown -y -i0 -g0 # does NOT turn machine off and power off (just stops OS apparently). ; POSSIBLY RESTART
                 # ^^tried this (along with reboot -lnd) and POSSIBLY WORKED when stalled storage-related cmds for zpool.

reboot -l
reboot -l -n     # avoids calling sync but still attempts to sync filesystems
                 # ^^tried this and DIDNT WORK when stalled storage-related cmds for zpool.
                 # - cannot ssh back in, however is pingable.

reboot -l -n -d  # avoids calling sync (and does not attempt to sync filesystems).
                 # ^^tried this and WORKED when stalled storage-related cmds for zpool.

reboot -l -q     # reboot ungracefully, without shutting down running processes first.


init 5         # like init 0 (well, at least on Solaris proper, I think this is true, but does NOT turn machine off and power off)
init 1         # like init 1
init 4         # like init 2-5*  ( *=normal states )
init 6         # like init 6


== misc cmdln ==
notes synopsis: omnios/solaris cmdln   # the equivalent cmdln in Linux.
prstat         # like top
svcs           # like service --status-all
svcadm         # use in conjunction with svcs.
pkg search     # like aptitude search
pkg install    # like aptitude install
pkg info       # like aptitude show
pkg update -nv # like aptitude upgrade
pkg contents -t file smartmontools  # list the full file paths of package files, e.g. show me what just got installed.
prtconf | grep Mem # like free; prints physical memory size
vmstat         # like free.... sort of?... am not pleased lol
vmstat 5 10    # like free.... ? let it run ~30s. free ram in KiB is last number in free col.

psrinfo -vp    # like less /proc/cpuinfo
isainfo -x     # like arch

# Steps to get ram usage:
sar -r 1 1     # get number under 'freemem' column. This measurement is wrt the pagesize.
freemem=253992 # e.g..
echo "$freemem * ( $( pagesize ) / 1024 ) | bc -l"   # Free RAM in KiB.
# ^^src : http://karellen.blogspot.com/2011/10/available-used-and-free-memory-in.html

#   ...Potential 1-liner?
sar -r 1 1 | tail -1 | awk '{ print $2 }' | \
 xargs echo  "$(( $( pagesize ) / 512 )) *" | bc | xargs echo RAM Free, KiB:
#   ...displays like:
#RAM Free, KiB: 1369504
#
#   ...again, but for MiB (COMPACT THIS):
sar -r 1 1 | tail -1 | awk '{ print $2 }' | \
 xargs echo  "$(( $( pagesize ) / 512 )) *" | bc | \
 xargs echo "scale = 10; (1/1024) *" | bc | xargs echo RAM Free, MiB:
#   ...displays like:
#RAM Free, MiB: 1852.5703125000
#
# ----
swap -l [-h]   # like swapon -s; list swap devices [in human-readable format].
swap -s [-h]   # like swapon -s; list amt of swap space available [in human-readable format].



== files ==
/var/adm/messages  # like /var/log/syslog or /var/log/messages

== See also ==
helpafs
https://wiki-bsse.ethz.ch/display/ITDOC/Major+difference+between+Linux+and+Solaris
Sysadmin's Unixersal Translator:
   http://bhami.com/rosetta.html
Comparison Map: ifconfig and ipadm Commands::
   https://docs.oracle.com/cd/E26502_01/html/E28987/gmait.html#scrolltoc
__envHEREDOC__
}
helpomnios3_basicSysnfo(){
cat <<'__envHEREDOC__'
prtconf        # Print various system config and peripheral nfo.  Displays system configuration information, including the total amount of memory and the device configuration, as described by the system's hierarchy. This useful tool verifies whether a device has been seen by the system.
prtconf -d     # Look at things like PCI devices. As of r151006, the new "-d" option uses a built-in copy of the PCI device database to provide vendor info.
prtdiag        # Print various system peripheral nfo.
sysdef         # Displays device configuration information, including system hardware, pseudo devices, loadable modules, and selected kernel parameters.
dmesg          # Displays system diagnostic messages (from /var/adm/messages) as well as a list of devices attached to the system since the most recent restart.
psrinfo -vp    # Like 'less /proc/cpuinfo'.  The bonus with psrinfo is that you can also see how the cores map to sockets.
lgrpinfo       # If really curious about how the system schedules work across the CPUs. Displays the NUMA topology of the system. The scheduler attempts to schedule threads "near" (in NUMA terms) their associated memory allocations and potential cache entries.
isainfo -x     # Like 'arch'. Identifies various attributes of the instruction set architectures of the system.
pgstat -pv 1   # Displays realtime CPU information.

kstat          # Display kernel statistics.
__envHEREDOC__
}
helpomnios4_hdd_and_storage_related(){
cat <<'__envHEREDOC__'
== defn's ==
Instance Name : e.g. sd0, sd1, sd2, ssd23, md301
Descriptive Name : e.g. in the cXtYdZsN format. The logical device
 name.  Are populated in /dev/dsk.


== observations ==
The nfo gathered from...
* executing prtconf, and
* listing /dev/dsk
...can be linked up according to the ancestry of prtconf's "disk" nodes the
sym link targets of /dev/dsk/*.

Alternatively, can just pass -v to prtconf and search to "disk" instances
within the output.

ls -l /dev/rdsk | grep 'c.t.d0 '

== cmdln ==
zpool status  # Displays pool members in the cXtYdZsN format.

format        # Displays both physical and logical device names for all available disks.
   SEE ALSO
        fmthard(1M), prtvtoc(1M), rmformat(1), format.dat(4), attri-
        butes(5),  sd(7D)

     x86 Only
        fdisk(1M)

format inq <disk name, e.g. c11t3d0>

prtvtoc /dev/rdsk/c11t3d0   # prints some hardware parameters like geometry, also partition nfo.

iostat -E     # Display storage device nfo. By  default,
              # disks  are  identified by instance names such as
              # ssd23 or md301.

iostat -Ei    # Same as -E but instead of S/N, prints Device Id.

iostat -E -Xn # Combining the X option with the -n option causes
              # disk names to display in the
              #         cXtYdZsN
              # format, more easily associated
              # with physical hardware characteristics.  Using the
              # cXtYdZsN format is particularly helpful in the
              # FibreChannel environments where the FC World
              # Wide Name appears in the t field.
              # Disks are identified by controller names.

iostat -xcnCXTdz interval  # Particularly useful for determining whether
                           # disk I/O problems exist and for identifying problems.

iostat -xnp   # Generates partition and device statistics for each disk.
              # Disks are identified by controller names (disk names also
              # display in the cXtYdZsN  format).

fsstat -F 1   # Filesystem statistics organized by whichever process is reading/writing.

fsstat $(awk '{ print $2 }' /etc/mnttab | xargs) 1   # FS statistics broken down by FS.

ipmitool sdr | grep hdd    # displays state of each hdd slot, humanly numbered by physical slot layout.


== sector size ==
echo ::sd_state | mdb -k | egrep '(^un|_blocksize)'
# ^^will return output like the following:
un 1: ffffff0d0c58cd40
    un_sys_blocksize = 0x200
    un_tgt_blocksize = 0x200
    un_phy_blocksize = 0x1000
    un_f_tgt_blocksize_is_valid = 0x1
# ^^This is for a disk with a physical sector size of 4K (0x1000) and a logical sector size of 512b (0x200).
#
# If you see 0x1000 for the tgt or sys blocksize, you have a disk with 4K logical sector size.

== See also ==
helpsmartctl
helpafs
hd      -x (Generate hd_map.html)
hdadm
__envHEREDOC__
}
helpomnios5_cfgadm(){
cat <<'__envHEREDOC__'
== Configuration Administration ==
cfgadm -alv - will show all three disks and a zillion sata ports lol (with some additional non-sata devices too) (and actually, the -a specifies that the -l option must also list dynamic attachment points)

cfgadm -la sata - will show all disks with less verbosity. ("lists all current configurable hardware information" of type sata).

"cfgadm -l sata | grep -v empty" - makes it seem like you have disks plugged into sata5/1 and sata6/2.

=== Post-Physically Inserting a HDD ===
(adding a hdd)

cfgadm -c configure sata5/1 - makes the sata device to be usable/seen and ready for normal operations, e.g. zpools, etc.


=== Pre-Physically Removing a HDD ===
(removing a hdd)

cfgadm -c unconfigure sata5/1 - makes the sata device to be logically removed from the system.

And if the device is still in the zpool list, can get rid of it with:

sudo zpool export a108

__envHEREDOC__
}
helpomnios6_fault_manager(){
cat <<'__envHEREDOC__'
== How to use these things, I don't know. ==
sudo fmadm config
sudo fmadm faulty
sudo fmadm faulty -a -r -v

sudo fmstat

fmdump
__envHEREDOC__
}
helpomnios7_adm_cmdlns(){
cat <<'__envHEREDOC__'
fmadm   # see also : helpomnios6_fault_manager
logadm
cfgadm  # see also : helpomnios5_cfgadm
svcadm
flowadm
dladm
ipadm
smbadm  # see also : helpomnios8_sambasmbcifs
hdadm   # pkgin search hdadm  # if dont have


== Network-related ==
# flowstat is in bytes for some reason-but maxbw is bits.
# Once a "flow" is defined, can do nifty things like:
flowstat -i 1    # Show current network i/o.  Like iostat -m 1 but for network.
flowadm set-flowprop -t -p maxbw=1200K  afs3-volser-udp    # Throttle network i/o.
                 # maxbw is in kilobits/s; 1200K = 1200 kilobits ~= 146.48 kibibytes

# Example of setting up a flow:
sudo flowadm add-flow -t -l e1000g0 -a transport=tcp,local_port=7005 afs3-volser-tcp
sudo flowadm add-flow -t -l e1000g0 -a transport=udp,local_port=7005 afs3-volser-udp


# network information on network devices:
dladm show-link
dladm show-linkprop e1000g0   # Show ethernet link speed.
ipadm show-ifprop
ipadm show-if e1000g0

# restart networking:  see also http://wiki.openindiana.org/oi/Static+IP
sudo svcadm restart svc:/network/physical:default   # Restart the network.

==== configuration ====
/kernel/drv/e1000g.conf       # To configure jumbo frames, edit and change MaxFramesize to 3 :: MaxFrameSize=3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3;

__envHEREDOC__
}
helpomnios8_sambasmbcifs(){
cat <<'__envHEREDOC__'
smb(4) - configuration properties for Solaris CIFS server
   |-- Behavior of the Solaris CIFS server is defined by property values that are stored in the Service Management Facility, smf(5).
   |   `- smf(5)
   |-- An authorized user can use the sharectl(1M) command to set global values for these properties in SMF.
   |   `- sharectl(1M)
   |-- smbadm(1M)
   |-- smbd(1M)
   `-- smbstat(1M)

zfs property : sharesmb



src : https://wiki.openindiana.org/oi/Using+OpenIndiana+as+a+storage+server

zfs set "sharesmb=name=myshare,description=My ZFS share" yourpool/shares/bob

# check status:
zfs get sharesmb pool/share/bob


-->> Am assuming this is just 1 time setup thing <<--
# enable "pam_smb_passwd" to make regular users have smb passwords: append to /etc/pam.conf the following:
other password required pam_smb_passwd.so.1 nowarn

# change user's password with passwd.  After this, their smb password will also be set so they can connect via smb with the same username and password.

.... hrm... not working..
__envHEREDOC__
}
helpomnioslogging(){
cat <<'__envHEREDOC__'
/var/log/          - nothing happens here or within descendants...
/etc/syslog.conf   - configuration file for syslogd system log daemon
/var/adm/messages  - kernel logging
/etc/logadm.conf   - configuration file for logadm command; see also : https://wiki-bsse.ethz.ch/display/ITDOC/Solaris+log+rotation

svcs -xv svc:/some/svc - display explanations for service state
svcs -L svc:/some/svc - display path of this services logfile
__envHEREDOC__
}

#/TODO STUB






helpnetcat(){
cat <<'__envHEREDOC__'
Netcat file transfer from host1 to host2:
host2$ nc -l 8080 > file
host1$ nc host2 8080 < file
tip: if firewall complains of invalid HTTP request upon port80 use, do with 443 instead.

Transfer a whole directory (including its content) from hostA.com to hostB.com:
hostb$ nc -l 5000 | tar xvf -
hosta$ tar cvf - /path/to/dir  | nc hostb 5000


Test if TCP port is open:
$ nc -vn 192.168.1.102 5000
nc: connect to 192.168.1.102 port 5000 (tcp) failed: Connection refused
$ nc -vn 192.168.1.102 22
Connection to 192.168.1.102 22 port [tcp/*] succeeded!
SSH-2.0-OpenSSH_6.1p1 Debian-4

Send test UDP packet to remote host:
$ echo -n "foo" | nc -u -w1 192.168.1.102 5000

Perform TCP port scan in the ranges of [1-1000] and [2000-3000] to check which port(s) are open:
$ nc -vnz -w 1 192.168.1.102 1-1000
$ nc -vnz -w 1 192.168.1.102 2000-3000

# Immediately exit upon success:
nc -vz HOST PORT

# Exit after trying for 1s:
nc -w1 HOST PORT

== See also ==
helpnmap
http://xmodulo.com/2014/01/useful-netcat-examples-linux.html
socat
__envHEREDOC__
}
helprdesktop(){
cat <<'__envHEREDOC__'
rdesktop -g 1400x1000 vm-w7-2
# Generally, pretty good:
rdesktop -u laluna -p "laluna's passwordie" -g 1200x900 las-vms-machines
# Slightly larger display:
rdesktop -u laluna -p "laluna's passwordie" -g 1250x1000 las-vms-machines
# Better fits on shazam's own display:
rdesktop -u laluna -p "laluna's passwordie" -g 1250x980 las-vms-machines

= Decrease network traffic =
rdesktop -u laluna -p "laluna's passwordie" -g 1250x900 las-vms-machines -C -D -a 8 -z -P

= Clipboard =
rdesktop -u laluna -p "laluna's passwordie" -g 1250x900 las-vms-machines -C -D -a 8 -z -P -r clipboard:PRIMARYCLIPBOARD

= See also =
xfreerdp
__envHEREDOC__
}
helpxfreerdp(){
cat <<'__envHEREDOC__'
xfreerdp --plugin cliprdr -u laluna -p "laluna's passwordie" las-vms-machines

= See also =
rdesktop
__envHEREDOC__
}
helpvncviewer(){
cat <<'__envHEREDOC__'
vncviewer phobos:5900
__envHEREDOC__
}
helpkvm(){
cat <<'__envHEREDOC__'
Snapshot functionality can only be used on certain disk image formats...
    ok: qcow2
	!ok: raw

qemu-img snapshot -l  # List snapshots for image file.

# Create a snapshot, "pre-partitiontable-modify".
qemu-img snapshot -c pre-partitiontable-modify vm-centos6.img

# Get vdisk image nfo.
qemu-img info vm-centos6.img

# Convert [, with -progress,] the image file from qcow2 format to raw format.
qemu-img convert -p -f qcow2 -O raw vm-centos6.qcow2.img vm-centos6.raw.img

# Create a 33GiB image file, using raw format.
qemu-img create -f raw vm-centos6.swap.img 33G

# Similarly, a qcow2-format image file, with a bit of preallocation.
qemu-img create -f qcow2 -o preallocation=metadata centos_test0_preallc.qcow2 33G

# Resize (e.g. a qcow2-format) image file to be 60GiB.
qemu-img resize vm-centos6.img 60G


# ??? Shrinks an expandable virtual disk by removing any unused sectors ???
# ^^this didn't work for a qcow2 volume that has once-allocated blocks which
# are now NOT allocated.
# ??? May need to zero out the fs on the vdisk image...
#
# -> man page only mentions qcow i.e. NOT qcow2... not sure what's supported.
qemu-img convert  -p -f qcow2 -O qcow2  original.img  new.img

# Mount qcow2 image file:
modprobe nbd max_part=8
qemu-nbd --connect=/dev/nbd0 qcow2-file
parted -l /dev/nbd0                        # to determine which partition want to mount.
mount /dev/nbd0p1 /mnt/tmp
mount /dev/nbd0p2 /mnt/tmp  # or like.
umount /mnt/tmp             # finished?
qemu-nbd --disconnect /dev/nbd0
modprobe -r nbd

== See also ==
helpkvm() helpvirsh() virt-install virt-top virt-df libvirt.conf libvirtd.conf qemu.conf
virt-cat virt-edit virt-filesystems virt-inspector virt-ls virt-make-fs virt-rescue virt-resize virt-tar virt-win-reg
__envHEREDOC__
}
helpvirsh(){
cat <<'__envHEREDOC__'
virsh snapshot-list vm-vcs
virsh snapshot-dumpxml vm-vcs 1395958755
virsh snapshot-current vm-vcs                       # display information about current snapshot.
virsh snapshot-create vm-vcs                        # snapshot name will be curr timestamp (name = $time)
virsh snapshot-create-as vm-vcs wuuut               # create a named snapshot (name = "wuuut")

virsh snapshot-revert vm-vcs 1395958755
virsh snapshot-delete --children vm-vcs 1395958755  # deletes this snapshot and all descendant nodes.

virsh console vm-vcs
virsh start vm-vcs --console

# If you made manual changes to the KVM xml definition/conf file, you must tell virsh
# about it.  To apply the changes, do:
virsh define /path/to/updated/xml/file
virsh define /etc/libvirt/qemu/vm-log.xml

# Lists block devices used by vm:
virsh domblklist <domain/id/vm>

# Attach a qcow2-formatted vdisk (domain xml file will be updated):
virsh attach-disk <domain> centos_test0_preallc.qcow2 vdX --subdriver qcow2 --persistent

# Attach a qcow2-formatted vdisk temporarily(i havent tried this yet but I guess upon reboot/shutdown or upon a virsh destroy, this vdisk will no longer be associated):
virsh attach-disk <domain> centos_test0_preallc.qcow2 vdX --subdriver qcow2

# get net facts regarding guests:
virsh net-info  # --> choose desired network... (will assume its just the first one, for simpley):
netName=$( virsh net-list --name | head -1 )
virsh net-info $netName
virsh net-dhcp-leases $netName

# get net addresses for domain
virsh domifaddr $domain

# get net addresses for all domains:
virsh list --name | while read n ; do
  [[ ! -z $n ]] && virsh domifaddr $n
done

== See also ==
helpkvm()
* https://raymii.org/s/tutorials/KVM_add_disk_image_or_swap_image_to_virtual_machine_with_virsh.html
* https://raymii.org/s/tutorials/KVM_with_bonding_and_VLAN_tagging_setup_on_Ubuntu_12.04.html - learn how to set up a proper KVM hypervisor host.
__envHEREDOC__
}
helpgpg(){
cat <<'__envHEREDOC__'
NOTE that in order to enter your passphrase, it seems like it wants to open an X window in order to enter.

gpg --gen-key      # Generate a new key pair.
gpg --list-keys    # List all keys from the public keyrings, or just the keys given on the command line.
gpg [-a|--armor] --export "User Name" [> public.key]             # Export public key.
gpg [-a|--armor] --export-secret-key "User Name" [> private.key] # Export private key.

gpg-connect-agent

gpg --list-keys
gpg --output foo.txt --decrypt foo.txt.gpg

if you're getting problems with not being prompted for a passphrase and you've ssh'd and su'd to the curruser, NOTE
that su does not change the ownership of your TTY, so you need to manually chown it or ssh connect directly as that user.

gpg --output file.txt --decrypt file.txt.pgp

== See also ==
http://www.gnupg.org/gph/en/manual.html       - GPG docs
http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/  - GPG Cheat Sheet *** (good)
http://www.cyberciti.biz/tips/linux-how-to-encrypt-and-decrypt-files-with-a-password.html - webpost
http://xmodulo.com/2013/09/how-to-create-encrypted-zip-file-on-linux.html How to create an encrypted zip file on Linux - Linux FAQ
http://xmodulo.com/2013/08/how-to-pgp-encrypt-decrypt-digitally-sign-files-via-gnupg-gui.html How to PGP encrypt, decrypt or digitally sign files via GnuPG GUI
__envHEREDOC__
}
helpgpg2(){
cat <<'__envHEREDOC__'
Encrypting archive data on the fly
: src : https://askubuntu.com/a/829835

== symmetric ==
==== encrypt ====
: -c     Encrypt with a symmetric cipher using a PASSPHRASE. The default symmetric cipher used is CAST5, but may be chosen with the --cipher-algo option.
tar -cz dir | gpg -c -o archive.tgz.gpg
==== decrypt ====
gpg -d archive.tgz.gpg | tar xz


== asymmetric ==
==== encrypt ====
: -e     Encrypt data (using a KEY). Optionally, this option may be combined with --symmetric (for a message that may be decrypted via a secret key or a passphrase).
: -r     Recipient or key to use.
tar -cvz . | gpg -e -r recipient234567 -o archive.tgz.gpg
==== decrypt ====
gpg -d archive.tgz.gpg | tar -xz        # to decrypt to cwd.
gpg -o archive.tgz -d archive.tgz.gpg   # to decrypt to a standard tgz file for later unpacking.
__envHEREDOC__
}
helptcpdump(){
cat <<'__envHEREDOC__'
Print all email packets to and from port 25, i.e. print only packets that
contain data, not, for example, SYN and FIN packets and ACK-only packets, on eth2:
$ tcpdump -i eth2 'tcp port 25 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
__envHEREDOC__
}
helpbc(){
cat <<'__envHEREDOC__'
== decimal math with bc ==
$ echo 39938 / 60 / 24 | bc
27
$ echo scale=2 \; 39938 / 60 / 24 | bc
27.73

== See also ==
clac.py
wcalc - a capable calculator
__envHEREDOC__
}
helpselinux(){
cat <<'__envHEREDOC__'
fattrs-related ( see also : helpxattrs )


Remove the security context associated with files:
$ find . -print0 |xargs -0 -n 1 setfattr -h -x security.selinux

Add security context to /home e.g. so that public key authentication freaking
works when SELinux is enabled:
$ sudo setfattr -n security.selinux -v system_u:object_r:home_root_t:s0 /home

See what the security context is for /home :
$ getfattr -n security.selinux /home
__envHEREDOC__
}
helpmunin(){
cat <<'__envHEREDOC__'
tail -F /var/log/munin/munin-*.log /var/log/munin-node/munin-node.log

Force the munin to do the update:
$ sudo -u munin /usr/share/munin/munin-update

The output from the following cmdln be helpful esp when manip.'ing /etc/munin/munin.conf
Can get field names and stuff, the plugin's capabilities, etc.
$ sudo -u munin munin-run diskstats config

__envHEREDOC__
}
helppaths(){
cat <<'__envHEREDOC__'
List of notable home-directory config paths
* .config/user-dirs.dirs
** some apps seem to use the values specified here for their start location for file open/save.

== See also ==
[[Linux_kde]]
__envHEREDOC__
}
helpbashloopsnippets(){
cat <<'__envHEREDOC__'
# Update a logstash config(s) on logstash clients:
for i in `grep -v hadoopcl ~/active-nodes-list.txt | grep -v $( hostname -s )` ; do rsync -av --progress /etc/logstash/conf.d/input.conf root@${i}:/etc/logstash/conf.d/input.conf ; done

# Execute commands on remote hosts:
for i in `grep -v hadoopcl ~/active-nodes-list.txt | grep -v $( hostname -s )` ; do echo -n "$i:" ; ssh $i  sudo service logstash status ; done

# Read a file.txt line by line:
while read line; do echo $line; done < file.txt
__envHEREDOC__
}
helpredis(){
cat <<'__envHEREDOC__'
== Connecting ==
$ redis-cli
$ redis-cli -h vm-log
redis vm-log:6379> help

== Help ==
redis-cli 2.4.10
Type: "help @<group>" to get a list of commands in <group>
      "help <command>" for help on <command>
      "help <tab>" to get a list of possible help topics
      "quit" to exit

> help @server
> help @transactions
> help @list
> help @generic
# ... etc.

== Monitor transactions in real-time ==
> MONITOR

== Remove data from database(s) ==
> FLUSHDB       - Removes data from your connection's CURRENT database.
> FLUSHALL      - Removes data from ALL databases.
__envHEREDOC__
}
helpphp(){
cat <<'__envHEREDOC__'
# View the default values of phpinfo
php -i

# To print the real and customized parameters of the phpinfo
php -r "phpinfo();"
# or
echo "<?php phpinfo(); ?>" | php
__envHEREDOC__
}
helpec2(){
cat <<'__envHEREDOC__'
ec2-describe-images -o self   # AMI's created/owned by me.
ec2-describe-images -o amazon # Amazon provided AMI's.

ec2-describe-spot-price-history -a us-east-1c  # other regions: us-east-1b us-east-1a
ec2-describe-spot-price-history -t m3.xlarge
ec2-describe-spot-price-history -a us-east-1c -t t1.micro


ec2-describe-instance
ec2-describe-instances
ec2-describe-instances --show-empty-fields  -H | grep -P '^INSTANCE'   # gives parsable / computable output

# What to do if instance immediately terminates:
ec2-describe-instances <instance id> -v
# then search for XML node <stateReason>.  There should be <code> and <message> nodes describing
# the reason that the instance terminated, for example, VolumeLimitExceeded.

== See also ==
helpec2snippets helpaws
__envHEREDOC__
}
helpec2snippets(){
cat <<'__envHEREDOC__'
Using the unique vpc id discovered beforehand, wanted to know the private ip (col $18) and 'Name' (col $35) tag for all instances
within this vpc id...
[v1] $ ec2-describe-instances --show-empty-fields  -H | grep -P '^INSTANCE|^TAG' | grep --after-context=1 vpc-6379d406 | sed 'N;s/\n/\t/'  | awk '{ print $18 " " $35 }'
... example output:
  10.0.0.159 vm-hdp2-k02
  10.0.0.167 vm-hdp2-k03
  10.0.0.165 vm-hdp2-k04
  10.0.0.166 vm-hdp2-k05
An attempt at an improved version of [v1] from above...
[v2] $ ec2-describe-instances --show-empty-fields  -H | grep -P '^INSTANCE|^TAG' | grep -vP '\teip\t' | grep --after-context=1 vpc-6379d406 | sed 'N;s/\n/\t/'  | awk '{ print $18 " " $35 }'
^^NOTE: since am only interested in the "Name" tag and not the "eip" tag, remove that line because it will mess up the snippet.
^^NOTE: both seemed to not get the last one... something with a leading "--" instead of "INSTANCE" was output by the ec2-describe-instances for some reason...

^^^^FOLLOW UP: lol k, the "--" is inserted by grep in between groups of matches, duh.  so cut that out too...
[v3] $ ec2-describe-instances --show-empty-fields  -H | grep -P '^INSTANCE|^TAG' | grep -vP '\teip\t' | grep --after-context=1 vpc-6379d406 | grep -v -- '--' | sed 'N;s/\n/\t/'  | awk '{ print $18 " " $35 }'
^^^^^^YES, this got everything, perfectly!
  10.0.0.159 vm-hdp2-k02
  10.0.0.167 vm-hdp2-k03
  10.0.0.165 vm-hdp2-k04
  10.0.0.163 vm-hdp2-k07
  10.0.0.164 vm-hdp2-k06
  10.0.0.161 vm-hdp2-k09
  10.0.0.162 vm-hdp2-k08
  10.0.0.160 vm-hdp2-k10
  10.0.0.197 vm-hdp2-k01
  10.0.0.191 vm-hdp2-k05

How about also getting the instance id?
[v4] $ ec2-describe-instances --show-empty-fields  -H | grep -P '^INSTANCE|^TAG' | grep -vP '\teip\t' | grep --after-context=1 vpc-6379d406 | grep -v -- '--' | sed 'N;s/\n/\t/'  | awk '{ print $18 " " $35 " " $33 }'

__envHEREDOC__
}
helpaws(){
cat <<'__envHEREDOC__'
# List of all running instance ids:
aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" --output json | grep -P InstanceId | awk '{ print $2 }' | sed 's/[",]//g'

# List of all running instance public and private ip addrs:
aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" --output json | grep -P IpAddress\" | awk '{ print $2 }' | sed 's/[",]//g' | uniq



# Shows all instanceids of instancetypes disallowed by AWS for network scanning:
aws ec2 describe-instances --filter "Name=instance-state-name,Values=running,Name=instance-type,Values=t2.nano,t1.micro,m1.small" --output json --query 'Reservations[*].Instances[*][InstanceId,InstanceType,Tags]'

aws ec2 describe-instances --filter "Name=instance-state-name,Values=running,Name=instance-type,Values=t2.nano,t1.micro,m1.small" --query 'Reservations[*].Instances[*][InstanceId]' --output text

aws ec2 describe-instances --filter "Name=instance-state-name,Values=running,Name=instance-type,Values=t2.nano,t1.micro,m1.small"  --query 'Reservations[*].Instances[*][InstanceId]' --output text


# BETTER list of all running EC2 instance ids: (which excludes instance types disallowed by AWS for network scanning)::
aws --output text ec2 describe-instances --filter "Name=instance-state-name,Values=running,Name=instance-type,Values=t2.nano,t1.micro,m1.small" --query 'Reservations[*].Instances[*][InstanceId,Tags[*].Key.Name]' | sort > excluded-running-instances.txt
aws --output text ec2 describe-instances --filter "Name=instance-state-name,Values=running"                                                     --query 'Reservations[*].Instances[*][InstanceId]'                  | sort > all-running-instances.txt
# comm -13 suppress 'column 3' which is lines that appear in both files:
comm -13 excluded-running-instances.txt all-running-instances.txt

# List of all running RDS instance ids:
aws rds describe-db-instances --query 'DBInstances[*].DbiResourceId' --output json | jq -r '.[]'

# BETTER list of all running RDS instance ids: (which excludes instance types disallowed by AWS for network scanning)::
# exclude any line containing  nano, small or micro :
aws --output text rds describe-db-instances --query 'DBInstances[*].[DBInstanceClass,DbiResourceId]' | grep -vP 'nano|micro|small' | awk '{ print $2 }'

# RDS nfo
aws rds describe-db-instances --output json --query \
  'DBInstances[*].Engine,DBName,DBInstanceIdentifier,AllocatedStorage,BackupRetentionPeriod,DBInstanceClass,AvailabilityZone]'

# List all linked accounts within Organizations:
aws organizations list-accounts   --output text   --query 'Accounts[?Status==`ACTIVE`][Status,JoinedTimestamp,Id,Email,Name]' |   sort |   cut -f2-


# MISC GUARDDUTY:
detector="--detector-id $( aws --profile $p  guardduty list-detectors | awk '{ print $2 }' )"

# guardduty finding id's:
aws --profile $p guardduty list-findings  --sort-criteria '{ "AttributeName": "updatedAt", "OrderBy": "ASC" }' \
   $detector

# enabling/disabling ip lists:
threatIntelSets=$( aws --profile $p guardduty list-threat-intel-sets $detector --output json --query "ThreatIntelSetIds[*]" | jq -r '.[]' )
for i in $threatIntelSets ; do echo $i ; aws --profile $p guardduty get-threat-intel-set $detector --threat-intel-set $i ; done

aws --profile $p guardduty update-threat-intel-set --threat-intel-set <threat intel set id> --activate|--no-activate \
   $detector

# Cleanup instances in Standby mode (cant do it via web interface for some reason)
aws autoscaling terminate-instance-in-auto-scaling-group  --no-should-decrement-desired-capacity  --instance-id

== See also ==
helppythonaws
__envHEREDOC__
}
helpawsbillparsing(){
cat <<'__envHEREDOC__'
=== only top-level sections ===
for i in *.pdf ; do
   pdftotext -layout $i -nopgbrk - \
      | sed '/about:blank/d' \
      | sed '/^\s\{6,\}/d' \
      | sed '/^$/d' \
      | sed 's/[ \t]*$//;s/^[ \t]*//' \
      | sed 's/\s\{7,\}/\t/'   >  $i.csv
done

=== only EC2 top-level and subsections ===
# TODO: make more generic by not assuming next top-level will be Elastic File System:
for i in *.pdf ; do
   pdftotext -layout $i -nopgbrk - \
      | sed '/about:blank/d' \
      | sed -n '/Elastic Compute Cloud/,/Elastic File System/p' \
      | sed '/Elastic File System/d' \
      | sed '/^$/d' \
      | sed 's/[ \t]*$//;s/^[ \t]*//' \
      | sed 's/\s\{6,\}/\t/g' \
      | sed -n '/\t/p'      >  $i-ec2-only.csv
done
__envHEREDOC__
}





helpfalcon(){
cat <<'__envHEREDOC__'
[sudo -u ambari-qa] falcon entity -type cluster  -list
sudo -u ambari-qa falcon entity -type cluster  -list
sudo -u ambari-qa falcon entity -type feed -list
sudo -u ambari-qa falcon entity -type process  -list
__envHEREDOC__
}
helpoozie(){
cat <<'__envHEREDOC__'
oozie version
echo 'export oozieurl="-oozie http://localhost:11000/oozie/"' >> ~/.bash_profile

oozie jobs $oozieurl
oozie jobs $oozieurl  -jobtype bundle

oozie job $oozieurl  -info jobid

oozie job $oozieurl  -kill jobid   # except... for bundle jobs, depending on conf, the job will respawn!!!!!! ARG!!!!
# perhaps -suspend'ing a bundle job that keeps respawning is the way to go????
oozie job $oozieurl  -suspend jobid

oozie job $oozieurl
oozie job $oozieurl

oozie admin $oozieurl  -queuedump
oozie admin $oozieurl  -status

__envHEREDOC__
}
helphue(){
cat <<'__envHEREDOC__'
To list all available configuration options:
$ /usr/lib/hue/build/env/bin/hue config_help | less

__envHEREDOC__
}





helpcron(){
cat <<'__envHEREDOC__'
== Crontab entry examples ==
NOTE: certain characters must be escaped in a crontab, e.g. '%'.

# Execute a custom logrotate every day at 1300 and log all of its output to a dated logfile:
00 13 * * * /root/bin/logrotate.custom.sh  >  /root/bin/logrotate.custom.sh.log-$( /bin/date +\%Y-\%m-\%d_\%H-\%M-\%S )  2>&1
__envHEREDOC__
}
helpdu(){
cat <<'__envHEREDOC__'
Some tips for analyzing a filesystem(s) containg lots of shtuff.

# Occasionally run this and feed the output into sort -n:
nice -n 19 ionice -c 3 du -a

# The output of du can diverted to a file, running overnight, and then
# afterward, xdu can take it as input and display it nicely.

# ncdu takes some time to finish calculating, but the output is easier to
# handle and you can drill down to lower directories without losing the other data.

# To capture disk usage nfo, run:
ionice -c3 ncdu -o ~/ncdu-output
# then to examine the file that was produced, run:
ncdu -f ~/ncdu-output
__envHEREDOC__
}
helpprocfs(){
cat <<'__envHEREDOC__'
cat /proc/net/bonding/bond0
cat /proc/net/vlan/config
cat /proc/sys/fs/file-max  - global file limit (check local limits with ulimit -Hn and ulimit -Sn)

echo 1 > /proc/sys/vm/drop_caches - drop disk cache that's stored in RAM right now.

== Thinkpad-specific ==
cat /proc/acpi/ibm/fan               - stats and help.
echo level 0 > /proc/acpi/ibm/fan    - fan off (WARNING); 0rpm.
echo level 2 > /proc/acpi/ibm/fan    - low speed;      2500rpm.
echo level 4 > /proc/acpi/ibm/fan    - medium speed;   3000rpm.
echo level 7 > /proc/acpi/ibm/fan    - maximum speed;  3800rpm.
echo level full-speed > /proc/acpi/ibm/fan - 100% duty-cycle (WARNING) ?
echo level disengaged > /proc/acpi/ibm/fan - 100% duty-cycle (WARNING) ? possible undefined behaviour.
echo level auto > /proc/acpi/ibm/fan - automatic (default).


= See also =
man proc   # docs for processes information pseduo-file sys ( /proc ).
helpsysfs helpdevices
__envHEREDOC__
}
helpsysfs(){
cat <<'__envHEREDOC__'
# Shows all key value pairs for a network bonding device:
for i in /sys/class/net/bond0/bonding/* ; do echo $i;  echo "  $( cat $i )" ; done

# md/mdadm arrays can be scrubbed by writing: check or repair to this sysfs file for the device:
# assuming the md device is md0:
If "check" was used, no action is taken to handle the mismatch, it is simply recorded.
If "repair" was used, then a mismatch will be repaired in the same way that resync repairs arrays.
sudo su -c 'echo check > /sys/block/md0/md/sync_action'

# Holds curr count of mismatches (SEE md(4) if nonzero):
/sys/block/md0/md/mismatch_cnt
# If set, overrides the system-wide setting in /proc/sys/dev/raid/speed_limit_min for this array only.
/sys/block/md0/md/sync_speed_min

# This is the partner of md/sync_speed_min and overrides /proc/sys/dev/raid/speed_limit
/sys/block/md0/md/sync_speed_max

# This  can  be  used  to monitor and control the resync/recovery process of MD.
#   "check" will cause the array to read all data block and check they are consistent; discrepancies
#   found are NOT corrected.  A count of problems found will be stored in md/mismatch_count.
#   "repair" will cause the same check to be performed, but any errors will be corrected.
#   "idle" will stop the check/repair process.
/sys/block/md0/md/sync_action

# This is only available on RAID5 and RAID6.
# Records the size (in pages per device) of the stripe cache which is used for
# synchronising all write operations to the array and all read operations if
# the array is degraded.  The default is 256.  Valid values are 17 to 32768.
# Increasing this  number can increase performance in some situations, at some
# cost in system memory.  Note, setting this value too high can result in an
# "out of memory" condition for the system.
#
# memory_consumed = system_page_size * nr_disks * stripe_cache_size
/sys/block/md0/md/stripe_cache_size

# This is only available on RAID5 and RAID6.
# This variable sets the number of times MD will service a full-stripe-write
# before servicing a stripe that requires some "prereading".  For fairness
# this defaults to 1.  Valid values are 0 to stripe_cache_size.  Setting
# this to 0 maximizes sequential-write throughput at the cost of fairness to
# threads doing small or random writes.
/sys/block/md0/md/preread_bypass_threshold

# This  tells  md  to  start  all  arrays in read-only mode.
/sys/module/md_mod/parameters/start_ro

# This module parameter allows special arrays (SEE md(4)) to be started at boot time:
/sys/module/md_mod/parameters/start_dirty_degraded

# Thermal information, (in C * 1000) (at least on Thinkpad w520 on 3.2.0-126-generic)
/sys/class/thermal/thermal_zone0/temp


= See also =
helpprocfs helpdevices
__envHEREDOC__
}
helpsleep_suspend_and_hibernate(){
cat <<'__envHEREDOC__'
uswsusp

Description: tools to use userspace software suspend provided by Linux

This package (also known as µswsusp, suspend-utils or simply suspend) contains the programs
to use the userspace software suspend facility available in Linux kernels 2.6.17-rc1 and
higher. It allows the system to have its state saved to disk and be powered off. On
restarting, it will be put back in the state it was left in (this is sometimes called hibernation).

It also includes a program to suspend the system to RAM after the state is saved to disk. In
that state, the system still uses power, but resuming is faster. If the battery depletes, the state
is resumed from disk without data loss.

s2ram --test
s2ram


# i think for this to work, you need a swap space that is at least
# equal to the size of physical RAM:
sudo pm-hibernate
__envHEREDOC__
}
helpbashseq(){
cat <<'__envHEREDOC__'
echo {1..9}
1 2 3 4 5 6 7 8 9
echo {9..3}
9 8 7 6 5 4 3

echo {a..r}}
a} b} c} d} e} f} g} h} i} j} k} l} m} n} o} p} q} r}
echo {a..r}
a b c d e f g h i j k l m n o p q r

ascii ' '
<gives info about the SPACE ascii character>

i 0xffff
<prints in decimal, hexadecimal, octal and as ASCII characters (if printable)>
__envHEREDOC__
}
helpansiblehosts(){
cat <<'__envHEREDOC__'
== Specifying / Limiting ==
# All hosts using wildcard, except for one:
restarthosts1='vm-dss:vm-rsnapshot:vm-hdp23-a*:!vm-hdp23-a1'
restarthosts2='vm-hdp23-a1'

* regex usage
~(web|db).*\.example\.com

== /etc/ansible/hosts -less ==
host=
ansible $host -i $host, --become  -m apt -a "upgrade=dist"  -vvvv
__envHEREDOC__
}
helpansible(){
cat <<'__envHEREDOC__'
= Modules with the "ansible" binary =
ansible ${h}:proxy-vm-centos6-hdp13-a-template -l sparks_deb_shared:sparks_rhel_shared  -m ping
ansible $h -l sparks_rhel_shared  -m ping --list-hosts
ansible hadoopcl\* -m ping
ansible \* -i hadoopcl08-hadoopcl12.txt -m ping

# Executes the hostname command on remote box:
ansible $h -l sparks_rhel_shared  -m command --args "hostname"
proxy-vm-centos6-hdp13-a-template | success | rc=0 >>
vm-centos6-hdp13-a-template

# Gather and print Facts for a remote box:
ansible $h -l sparks_rhel_shared  -m setup

# Inspecting the gathered Facts for a remote box:
ansible $h -l sparks_rhel_shared  -m setup --args "filter=ansible_fqdn"

# runs apt-get dist-upgrade on hosts contained in sparks_deb_shared:
ansible $h -l sparks_deb_shared  -m apt -a "upgrade=dist"  -vvvv --sudo

# Bounces hosts:
ansible $h -l sparks_deb_shared  -m command -a "/sbin/reboot"   --sudo
ansible $h -m command -a "init 6" --sudo

# Sets machines hostname
ansible $h  -m hostname -a "name=the.new.hostname"

ansible $h -m win_ping
# Gets dumb mswin updates
ansible $h -m win_updates -a "category_names='SecurityUpdates'"
ansible $h -m win_updates -a "category_names='CriticalUpdates'"
ansible $h -m win_updates -a "category_names='UpdateRollups'"
ansible $h -m win_updates -a "category_names='DefinitionUpdates'"

= ansible-doc =
ansible-doc --list
ansible-doc [--snippet] <module>
ansible-doc shell

= See also =
* [https://gist.github.com/marktheunissen/2979474 Insanely complete Ansible playbook, showing off all the options]
* [http://www.stavros.io/posts/example-provisioning-and-deployment-ansible/ An example of provisioning and deployment with Ansible - Stavros' Stuff]
* [https://github.com/lorin/ansible-quickref lorin/ansible-quickref] - ** GREAT list of all those extra task options that are possible **
* [http://stackoverflow.com/questions/27805976/resolve-dictionary-key-or-parameter-variable-in-ansible resolve dictionary key or parameter variable in Ansible] - successfully determines value of variable that uses / depends on a just previously defined variable, all within the same "vars" section.

__envHEREDOC__
}
helpansibleplaybook(){
#= Playbook content-related =
cat <<'__envHEREDOC__'
== cmdln parameters ==
ansible-playbook ...
-C, --check  - don't make any changes; instead, try to predict some of the changes that may occur
--check - dont actually do the tasks(unless task has "always_run: true"), try to predict some of the changes that may occur
--inventory-file - can specify an *executable file* now! (default /etc/ansible/hosts)
--list-hosts  - be hosts listing...
--list-tasks  - be tasks listing...
--sudo  - executes remote operations with sudo
--start-at-task='Check if a reboot is required'  - would start at task with "name: Check if a reboot is required"
--step
--syntax-check
-v - normal verbosity mode, -vvv for more, -vvvv to enable connection debugging

== Execute something locally/on the Ansible host ==
: src : http://docs.ansible.com/playbooks_delegation.html#local-playbooks
# To run an entire playbook locally, on the Ansible host, specify --connection=local when calling a playbook resembling:
- name: a play that runs entirely on the ansible host
  hosts: 127.0.0.1
  connection: local
  tasks:
  - name: check out a git repository
    git: repo=git://foosball.example.org/path/to/repo.git dest=/local/path
# (It's also possible to run a specific play localally within a larger playbook that includes plays that should be executed as normally)

: src : http://docs.ansible.com/playbooks_delegation.html#delegation-rolling-updates-and-local-actions
# If you just want to run a single task on your Ansible host, you can use local_action to specify that a task should be run locally:
  - local_action: git repo=git://foosball.example.org/path/to/repo.git dest=/local/path

# (the synopsys of local_action is like)
  - local_action: module_to_use [module params [...]]

# Alternatively, to run a task locally:
sudo: yes
tasks:
  - git: repo=git://foosball.example.org/path/to/repo.git dest=/local/path
    sudo: no  # would probably not want sudo (because SSH keys) if private git repository configured like this.
    delegate_to: 127.0.0.1

== Condition execution of a task (based on your own VARIABLE defn) ==
vars:
- timezone: 'America/New_York'
tasks:
  - name: Set value of the variable- current_zone (whichll be interrogated at next task)
    shell: awk -F\" '{ print $2}' /etc/sysconfig/clock
    register: current_zone
    # controls what defines an Ansible "change" as far as playbook execution status's are concerned:
    changed_when: False

  - name: (current system timezone != the above defined $timezone) -> (Make it be the above defined $timezone)
    file: src=/usr/share/zoneinfo/{{ timezone }}  dest=/etc/localtime state=link force=yes
    when: current_zone.stdout != '{{ timezone }}'

== Condition execution of a task (based on gathered Facts) ==
tasks:
  - debug: msg="this might be CentOS 6"
    when: "{{ ansible_distribution_major_version | int }} == 6"
  - debug: msg="this might be CentOS 7"
    when: "{{ ansible_distribution_major_version | int }} > 6"

  - set_fact: snmp_group="wheel"
    when: ansible_os_family == 'RedHat'
  - set_fact: snmp_group="snmp"
    when: ansible_os_family == 'Debian'

  # Setting this fact allows you to them use 'service' module in a generic way, e.g. service: name={{ntpservice}} state=stopped
  - set_fact: ntpservice="ntpd"
    when: ansible_os_family == 'RedHat'
  - set_fact: ntpservice="ntp"
    when: ansible_os_family == 'Debian'

== Condition continued execution of a playbook upon task failure threshold ==
: src : http://docs.ansible.com/playbooks_delegation.html#maximum-failure-percentage
- hosts: webservers
  # If more than 3 of the 10 servers inthe group fail, the rest of the play is aborted:
  max_fail_percentage: 30
  serial: 10

== Tagging a task ==
# To run a tagged task, specify the tag to the --tags= param.
# Alternatively, to skip a tagged task use --skip-tags= param.
  - command: echo example
    tags: [configuration,timezone]

== User-defined granularity over when (and where, if desired) a task executes ==
: src : http://docs.ansible.com/playbooks_delegation.html#run-once
# To run a task one time on the first host, as defined by inventory:
hosts: webservers
tasks:
  - script: update_app_on_host_frozen-windex.sh
    run_once: true
# or on a specific host:
    delegate_to: frozen-windex.example.org

# The above is a more concise and cleaner approach compared to something like:
  - script: update_app_on_host_frozen-windex.sh
    when: inventory_hostname == webservers[0]

# Says to run task even when --check was specified
  - script: test.sh
    always_run: True


== Other/misc. ==

__envHEREDOC__
}
helpansibleplaybookvariable(){
cat <<'__envHEREDOC__'
inventory_hostname - this will be the value of the current machine as specified by your inventory (/etc/ansible/hosts)
  In other words, it is not determined by a value from the remote machine in any way (/etc/hosts, cname, etc.).

: src : http://docs.ansible.com/playbooks_variables.html
  - set_fact: hiveuserpassword="{{ lookup('password', hiveuserpasswordfilepath + ' length=15') }}"
    when: generate_passwords=='yes'
  - debug: msg="hiveuserpassword is {{ hiveuserpassword }}"

  - user: name=hiveuserpasswordtest password={{ hiveuserpassword }}
    fail: msg="the command failed"
    when: "'FAILED' in command_result.stderr"

  - shell: /usr/bin/foo
    register: foo_result
    ignore_errors: True

  - shell: /usr/bin/bar
    when: foo_result.rc == 5
    failed_when: bar_result.rc not in [0,22]
    #failed_when: bar_result.rc == 0 or bar_result.rc >= 2
    register: bar_result

  - name: fail the play if the previous command did not succeed
    fail: msg="the command failed"
    when: "'FAILED' in bar_result.stderr"

  - name: add home dirs to the backup spooler
    file: path=/mnt/bkspool/{{ item }} src=/home/{{ item }} state=link
    with_items: home_dirs.stdout_lines
    # same as with_items: home_dirs.stdout.split()
    # or even with_items:
    #           - netcat
    #           - curl
    #           - tmux

=== Skip fact gathering ===
hosts: all
gather_facts: no

=== Lookups ===
: src : http://docs.ansible.com/playbooks_lookups.html

# Password-management-related: Creates the account phifedawg with password atribecalledquest::
# First, use this python cmdln snippet to obtain a string used thereafter:
python -c 'import crypt; print crypt.crypt("atribecalledquest", "$1$SomeSalt$")'
# ^^generated:
$1$SomeSalt$iF1zSVy0JhijVfk9yubdN.
# Now, can use the user module to create the account and set the password to this:
  - user: shell=/bin/bash password=$1$SomeSalt$iF1zSVy0JhijVfk9yubdN. name=phifedawg

# lookup('csvfile', 'key arg1=val1 arg2=val2 ...')
  - debug: msg="The atomic mass of Lithium is {{ lookup('csvfile', 'Li file=elements.csv delimiter=, col=2') }}"

  - debug: msg="{{ lookup('pipe', 'uuidgen') }}"
  - debug: msg="{{ lookup('pipe', 'date +"%Y%m%d_%H%M%S"') }}"
  - debug: msg="{{ lookup('env','HOME') }} is an environment variable"
  - debug: msg="{{ lookup('pipe','date') }} is the raw result of running this command"

# redis_kv lookup requires the Python redis package
  - debug: msg="{{ lookup('redis_kv', 'redis://localhost:6379,somekey') }} is value in Redis for somekey"

# dnstxt lookup requires the Python dnspython package
  - debug: msg="{{ lookup('dnstxt', 'example.com') }} is a DNS TXT record for example.com"

  - debug: msg="{{ lookup('template', './some_template.j2') }} is a value from evaluation of this template"
  - debug: msg="{{ lookup('etcd', 'foo') }} is a value from a locally running etcd"

# Concatenates the file /etc/motd to the variable motd_value:
vars:
  motd_value: "{{ lookup('file', '/etc/motd') }}"

# {{ var | quote}} is useful esp when parameters are being passed to like a shell script and, if you were calling it directly on cmdln, would need to be quoted.
# Synopsis for parse-block.sed.sh: parse-block.sed.sh beginning-marker ending-marker [path]
  - shell: ./files/parse-block.sed.sh {{ some_string_containing_spaces | quote }} {{ end_with_more_spaces | quote }} {{ hosts_file_path | quote }}  >  {{ generated_hosts_file_database_output_path | quote }}

# Debug/Dump a variable ( e.g.   register: reboot_hint ):
- name: What's in reboot_hint?
  debug: var=reboot_hint

# Dump all variables (assumes dumpall has been installed, a non-standard thing)
$ cat dumpall.yml
# ansible-playbook $this -l $hosts
---
- hosts: aneyays
  roles:
       - { role: f500.dumpall, dumpall_host_destination: /tmp/examine-the-aneyays-host }

# Defining and using ansible host/inventory variables in plays
: (considered a _role_ variable when setting custom kv pairs, but can use access it regardless of implementation of role-based plays) conditionals in plays.
: this approach can be used to define both simple flags and kv-pairs.
Inventory file contains:
wmavm-hdp23-a1-dred   im_a_flag
wmavm-hdp23-a2-dred   im_a_key=thevalue

Playbook can contain:
- whatevermodule: msg="oh hai im wmavm-hdp23-a1-dred"
  when: im_a_flag is defined
- whatevermodule: msg="oh hai im wmavm-hdp23-a2-dred"
  when: im_a_key is defined and im_a_key == "thevalue"

- include: tasks/sometasks.yml
  when: im_a_key is defined and im_a_key == "thevalue"


=== See also ===
* http://docs.ansible.com/playbooks_loops.html#looping-over-parallel-sets-of-data
* http://docs.ansible.com/playbooks_loops.html#looping-over-integer-sequences
* http://docs.ansible.com/playbooks_loops.html#random-choices
__envHEREDOC__
}
helpansibleyaml(){
cat <<'__envHEREDOC__'
/calling helpansibleplaybook2()/
__envHEREDOC__
   helpansibleplaybook2
}
helpansibleplaybook2(){
cat <<'__envHEREDOC__'
---
- name: Basic playbook, also shows how YAML syntax can express the same Ansible thing in 2 very different ways.
  hosts: all
  tags: [tag,your,it]
  vars:
   - thekey: "and the value"
  tasks:
   - git: repo=git@git.example.com:repos/scripts.git dest=/tmp/scripts
     sudo: False  # other valid values: false, true, yes, no

   - debug: msg="the above can also be written like..."
   - git:
     repo: git@git.example.com:repos/scripts.git
     dest: /tmp/scripts
     sudo: False
__envHEREDOC__
}
helpansibleplaybook3(){
cat <<'__envHEREDOC__'
== superuser access to a machine but as a different user (authenticated with password and with a sudo password) but user has your key and you want to create your own account ==
# update as applicable: /etc/ansible/hosts or /etc/ansible/hosts.2
# update as applicable: /etc/hosts
# update as applicable: ~/.ssh/config
# update as applicable: ~/active-nodes-list.txt

me=somebody
remoteuser=somebodyelse

host="ansible_hosts_set"
host_limits="-l $host"
# or
host_limits="-l $host  -i /etc/ansible/hosts.2"
host_and_user_and_key_args="$host_limits  -u $remoteuser -k --ask-sudo-pass"

# TIP: useful to get password in paste buffer since will be prompted multiple times.

sudo sed -i 's/^pipelining = True/pipelining = False/g' /etc/ansible/ansible.cfg
ansible-playbook user-account-management-tasks.yml --tags $me $host_and_user_and_key_args
ansible-playbook sudoers.yml $host_and_user_and_key_args  -e accounts='["'$me'"]'
sudo sed -i 's/^pipelining = False/pipelining = True/g' /etc/ansible/ansible.cfg

# now can exec as myself:
host_and_user_and_key_args="$host_limits"

ansible-playbook sshd_config-update.yml $host_and_user_and_key_args
ansible-playbook ssh_config-update.yml $host_limits
__envHEREDOC__
}
helpansiblemodule(){
cat <<'__envHEREDOC__'

== Module: lineinfile ==
# Add a line to a file if it does not exist, without passing regexp:
- command: touch /tmp/testfile
- lineinfile: dest=/tmp/testfile line="192.168.1.99 foo.lab.net foo"

- lineinfile: dest=/etc/profile line="export JAVA_HOME=/usr/java/default"
- lineinfile: dest=/etc/profile line="export PATH=$JAVA_HOME/bin:$PATH"
- lineinfile: dest=/etc/environment line="JAVA_HOME=/usr/java/default"


__envHEREDOC__
}
helpansiblemodule_blockinfile(){
cat <<'__envHEREDOC__'
The "blockinfile" module is not a standard module.

The "blockinfile" module works like the (standard) "lineinfile" module but
allows to operate on multi-line blocks of text instead of just one.

 TODO STUB: THIS DOESN'T SEEM LIKE THE CORRECT WAY OR I DON'T KNOW HOW TO PROPERLY USE THE MODULE AFTER INSTALLATION
 but i def know, in order to see the documentation (ansible-doc blockinfile), when I do the following, it works. but
 I'd like to know the proper intended way to install/use galaxy modules...

To install:
ansible-galaxy install yaegashi.blockinfile

which will create:
/etc/ansible/roles/yaegashi.blockinfile/

and will contain:
/etc/ansible/roles/yaegashi.blockinfile/library/blockinfile

so to obtain this module:
cp -p /etc/ansible/roles/yaegashi.blockinfile/library/blockinfile library/

where the destination library is the desired library.

To use in a playbook, it should be picked up automatically if the library/
dir is a sibling to the playbook being executed.  Otherwise, it should always
work when the library/ path is specified. For example, to read the ansible-doc
for blockinfile module:
ansible-doc -M library/ blockinfile
__envHEREDOC__
}




helpafs(){
cat <<'__envHEREDOC__'
== Login using kerberos ==
kinit username && aklog

== information ==
"vos listpart bhse.tc.example.com" you can see that we've got just the one
"vos listpart dozer.tc.example.com" has 3 partitions on a few zpools

"vos partinfo dozer.tc.example.com" shows the sizes


== regarding AFS space ==
you can always put something in a volume backed only by bump if you want

some stuff is already like that

from anywhere in the world on any AFS client you can query stuff like this though
"vos listvol bhse.domain.com" will list all of the volumes on bump
and how much space they represent.  this includes readonly clones and backups though

to see actual space used/available you can
"vos partinfo $server"
e.g., vos partinfo bhse.domain.com


or if you just know a path and want AFS to figure out which volume/host/partition it's on you can ask with "fs"

fs diskfree -human /afs/.domain.com/shared/path
Volume Name                   total      used     avail %used
path                         748.7G    592.1G    156.6G   79%

fs version  # shows version


# To restart the fs server from any machine that you're authenticated on:
bos restart bhouse.domain.com fs
# although it didn't seem to actually update the IP in the volume database.
# that shoudl normally do it but on bump i force it to use your public
# address in a file: /usr/afs/local/NetInfo
# since otherwise it only knows the private NATted address. so i need to update that first.


# Primary Volume Database Server election
It will take AFS a while to be convinced that dzr is down and vote for a new primary volume database server.
I guess we shoudl just wait a bit.
Kind of fun to watch the two remaining servers slowly figure out 1) dzr is gone, and 2) who shoudl be the new boss?
Can piece it together by watching "udebug tutti.domain.com vlserver ; udebug tuba.domain.com vlserver".
So far theyr'e both voting for my server here in the apartment.
But haven't actually switched to it.
Wonder if they're waiting for a 3rd vote from dzr and will eventually give up.


== TODO STUB backing up AFS data ==
TODO : get im's from tim that were from like... within last few days to within last few weeks.
its about what is the best way to backup afs content.


== Create a Volume on a New Partition ==
# Assuming you are doing this on a ZFS-enabled system, create and mount the new vice partition:
sudo zfs create -o mountpoint=/vicebX zpool/vicebX  # where X is the next alpha in use for this system.

# Now youve got to tell afs about it.  maybe this requires restarting fs service...
"bos status bhse.tc.example.com" will tell you that the fs server is running
(hooray)
if you run "bos restart bhse.tc.example.com fs" then it will restart the fs server
can do that from anything, like a laptop or something
then "vos partinfo bhse.tc.example.com" should know about the "b" partition


# Now create the volume:
vos create -server bhse.tc.example.com -partition /vicepb -name shared.tv.$i;
# ^^this will create the Volume as you expect, but it's not mounted anywhere.

# Now, to corrolate this Volume with an actual path on a usable filesystem
# e.g. how to associate /afs/tc.example.com/shared/tv/Adam Ruins Everything/ with shared.tv.$i[.*] used in the vos cmd?

# You actually store mount points to Volumes /IN/ other Volumes, like in the Filesystem.
# To create a mountpoint, you could do something like
fs mkmount -dir /afs/.tc.example.com/shared/tv/simpsons -vol shared.tv.jeopardy

# Then you have to Release shared.tv in order for the mountpoint to show up in the RO version of shared.tv, at /afs/tc.example.com/shared/tv/
it's a bit tricky cuz there can be multiple mountpoints of the same volume
and the mountpoints are treated exactly the same way as regular files in terms of their RO/RW parent volumes

i'll warn that $i needs to be relatively short see "man vos_create", under the "-name" option
it says the max length is 22 characters
i forget if that includes the .readonly/.backup suffixes)

since there is a relatively small limit for the total volume name length
the command to add a RO copy (which you can do at the beginning before fs mkmount) would be like
vos addsite -server bhse.tc.example.com -partition b -id shared.tv.jeopardy
that would wind up creating a shared.tv.jeopardy.readonly
which is sort of a copy on write snapshot of shared.tv.jeopardy


forgot to mention
you might learn the "fs setacl" and "fs listacl" commands
to ensure that when you create new directories the permissions are kosher

in a nutshell, the ACLs do what you'd expect, except they're ONLY on directories
files just get the ACL of whatever directory they're in

that's why you end up sometimes with stilly stuff in AFS like /afs/athena.mit.edu/contrib/bitbucket/README.bitbucket/README.bitbucket
the README.bitbucket directory only exists to make it so that people can't delete the README.bitbucket file



== if getting connection timed out errors ==
me:
any ideas why the AFS resources on bump dont show up when you try to get at them from the front end? (horribley worded question)

like, when i ls /afs/tc.example.com/shared/tv/ get errors for all the stuff that's on bump :(  also tried from a machine that is on an external network/not at my house with same results


TC:
ah
yeah I'm pretty sure it's that your IP address changed
so for example if you do "vos listvldb shared.tv.viks"
it will show the volume as sitting on your old IP address, which of course doesn't work
since bump is just a fileserver I think you can fix this by just restarting the fileserver and it will fix the volume entries
since you're an administrator on bump, you can restart its fileserver from any AFS client machine once authenticated
so from a laptop, you could do like "bos restart bhse.tc.example.com fs"
I've just done that
ah nope
first need to update the address in file /usr/afs/local/NetInfo
now when I restart the "fs" server it fixes the vldb
the clients should eventually figure out the update, but you can force it by doing an "fs flush /afs/tc.example.com/shared/xyz/"
that wipes your client cache


== bump: root crontab entries found: ==
10 3 * * * /usr/sbin/logadm
15 3 * * 0 [ -x /usr/lib/fs/nfs/nfsfind ] && /usr/lib/fs/nfs/nfsfind
30 3 * * * [ -x /usr/lib/gss/gsscred_clean ] && /usr/lib/gss/gsscred_clean
30 0,4,8,12,14,18 * * * PATH=$PATH:/usr/afsws/etc /afs/tc.com/usr/tcreech/pub/bin/autorankservers | /usr/afsws/bin/fs sp -stdin ; /usr/afsws/bin/fs sp bhouse.tc.com 20000
* * * * * /usr/afsws/bin/fs setcrypt -crypt on


= See also =
helpomnios*
man: bos
man: fs
man: vos - Introduction to the vos command suite
__envHEREDOC__
}
helpsystemd(){
cat <<'__envHEREDOC__'
= Init Services =
# Init scripts (now called "units" or "unit-files" or "unit" or something) are now represented by
# .conf files within these directories (may be symbolic links, these two...):
/lib/systemd/system/
/etc/init/

= Logging =
: see helpjournalctl

= See also =
helpsystemctl
helpjournalctl
__envHEREDOC__
}
helpxdotool(){
cat <<'__envHEREDOC__'
Simulate/automate keyboard presses:

# used to enter password on a w7 login screen displayed within vncviewer:
xdotool getactivewindow type 'jijijijij password ayyy lmao'

# other misc
xdotool key alt+Tab
xdotool key "Return"

# used to exhaust autopaging when you scroll to the bottom of a list:
while true; do sleep 5s ; xdotool key "End"; done

== See also ==
helpxnee
__envHEREDOC__
}
helpxnee(){
cat <<'__envHEREDOC__'
xnee - http://www.sandklef.com/xnee/ - a suite of programs that can record, replay and distribute user actions under the X11 environment. Think of it as a robot that can imitate the job you just did.

== See also ==
helpxdotool
__envHEREDOC__
}
helpchmod(){
cat <<'__envHEREDOC__'
== set user or group ID on execution (s) bit ==
chmoduser=nobody
chmodgroup=devops
pathtochange="/opt/coolcode/"

sudo groupadd ${chmodgroup}
sudo usermod -a -G ${chmodgroup} user, etc.

sudo find ${pathtochange} -type d               -exec chmod 2775  '{}' \;  # ug+rwx, o=rx, g+s
sudo find ${pathtochange} -type f   -executable -exec chmod  775  '{}' \;  # ug+rwx, o=rx
sudo find ${pathtochange} -type f ! -executable -exec chmod  664  '{}' \;  # ug+rw,  o=r

sudo chown -R ${chmoduser}:${chmodgroup} "${pathtochange}"

# the above will result in files looking something like:
drwxrwsr-x 3 nobody devops  20 Jan 23 23:23 somedirectory
-rwxrwxr-x 1 nobody devops 356 Jan 23 23:23 script.sh
-rw-rw-r-- 1 nobody devops 356 Jan 23 23:23 somefile.txt
__envHEREDOC__
}
helpiftop(){
cat <<'__envHEREDOC__'
= AFS processes =
sudo iftop -f 'port afs3-callback'
__envHEREDOC__
}
helppulseaudio(){
cat <<'__envHEREDOC__'
pacmd list-sinks

__envHEREDOC__
}
helphdparm(){
cat <<'__envHEREDOC__'
The man page is pretty straight forward but, here are some things Ive ran...
# show the APM level, basically how loud the hdd can be:
sudo hdparm -B /dev/sdb

# set the APM level to the lowest/quietest/lowest power use:
sudo hdparm -B 1 /dev/sdb

# set the activity timeout before the hdd spins down, to 5s:
sudo hdparm -S 1 /dev/sdb

# disable the activity timeout:
sudo hdparm -S 0 /dev/sdb

# Check the current IDE power mode status, which will always be one of unknown (drive does not support this command), active/idle (normal operation), standby (low power mode, drive has spun down), or sleeping (lowest power mode, drive is completely shut down).
sudo hdparm -C /dev/sdb
__envHEREDOC__
}
helppostgres(){
cat <<'__envHEREDOC__'
\l+  - shows list of databases along with Owner,Encoding,Collate,Ctype,Access privileges,Size,Tablespace,Description
\t   - switches tuples on and off.
\d   - shows tables?
\dl  - ?

# Remove a user
REVOKE ALL ON DATABASE "database" FROM "user OR role";
DROP USER "user OR role";

# Define custom privileges for a user within a database:
SET ROLE dba;
GRANT CONNECT ON DATABASE database TO me!!;
\connect database;
SET ROLE dba;
CREATE USER "user" WITH PASSWORD 'password';
GRANT CONNECT ON DATABASE database TO "user";
GRANT INSERT ON TABLE some_table TO "user";
GRANT SELECT ON TABLE some_other_table TO "user";

= See also =
helppostgresgettingstarted
__envHEREDOC__
}
helppostgresgettingstarted(){
cat <<'__envHEREDOC__'
# After fresh installation, become this user in order to initialize a dba role:
sudo su - postgres

# with the following pg_hba.conf...
   ## "local" is for Unix domain socket connections only
   local   all   postgres                               ident
   ## IPv4 local connections:
   host    all   postgres         127.0.0.1/32          ident
   ## IPv6 local connections:
   host    all   postgres         ::1/128               ident

   #local  all  ambari,mapred md5
   host  all   all           0.0.0.0/0  md5

# can login as postgres user with:
psql

# otherwise, login as a dba user with:
psql  --password dba -h `hostname`

# newdb and user commands:
#execute:
SET ROLE "dba";
#execute:
CREATE ROLE "database" NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN;
CREATE ROLE "user" NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN ENCRYPTED PASSWORD 'password';
GRANT "database" TO "user";
CREATE DATABASE "database" WITH OWNER="user";
#REVOKE ALL ON DATABASE "database" FROM "public";
REVOKE CONNECT ON DATABASE "database" FROM "public";
GRANT ALL ON SCHEMA "public" TO "user" WITH GRANT OPTION;
GRANT CONNECT ON DATABASE "database" TO "user";
#ALTER ROLE "user" ON DATABASE "database" WITH SUPERUSER;
#ALTER DEFAULT PRIVILEGES FOR USER "user" IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON tables TO "user";

#CREATE USER readonly  WITH ENCRYPTED PASSWORD 'readonly';
#GRANT USAGE ON SCHEMA public to readonly;
#ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readonly;
#
#GRANT CONNECT ON DATABASE "database" to readonly;
#\c database
#GRANT USAGE ON SCHEMA public to readonly;
#GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO readonly;
#GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;
__envHEREDOC__
}
helppsql(){
cat <<'__envHEREDOC__'
/calling helppostgres()/
__envHEREDOC__
helppostgres
}
helpjavascript(){
cat <<'__envHEREDOC__'
echo '{"numRows": "-1"}' | python -mjson.tool  # reformats JSON to human readable format.

== See also ==
cmdln program: jq (ive cloned its git repo and is in cdb)
helpjq
__envHEREDOC__
}
helpjson(){
cat <<'__envHEREDOC__'
/calling helpjavascript()/
__envHEREDOC__
	helpjavascript
}
helpsystemctl(){
cat <<'__envHEREDOC__'
systemctl (or) systemctl list-unit-files --type=service (or)
ls /lib/systemd/system/*.service /etc/systemd/system/*.service
# Like ls /etc/init.d/
Used to list the services that can be started or stopped
Used to list all the services and other units

systemctl                  # By itself, stuff about services.
systemctl --all            # Other stuff about services.
systemctl list-units       # Like service --status-all ?

systemctl list-unit-files  # Like chkconfig --list !
systemctl list-unit-files --type=service (or) ls /etc/systemd/system/*.wants/
Print a table of services that lists which runlevels each is configured on or off

ls /etc/systemd/system/*.wants/frobozz.service   # Like chkconfig <svc> --list

systemctl disable <svc>    # Like chkconfig <svc> off
systemctl ...DNE.......    # Like chkconfig <svc> --delete
systemctl enable <svc>     # Like chkconfig <svc> on
systemctl daemon-reload    # Like chkconfig <svc> --add



systemctl cat <svc>        # Like cat /etc/init.d/<svc> ?
systemctl is-enabled <svc> # Like chkconfig <svc> # See if its enabled to run at boot.

systemctl stop <svc>       # Like service <svc> stop
systemctl start <svc>      # Like service <svc> start
systemctl restart <svc>    # Like service <svc> restart
systemctl condrestart <svc># Like service <svc> condrestart
systemctl reload <svc>     # Like service <svc> reload
systemctl status <svc>     # Like service <svc> status

systemctl list-dependencies <svc>           # What does this svc depend on?
systemctl list-dependencies <svc> --reverse # What depends on this svc?


= After stopping, service comes back =
If youve
systemctl stop <svc>
and then
systemctl status <svc>
a bit later and the service is back to running
TODO STUB: what to do?

systemctl disable <svc>
systemctl stop <svc>
anope. ITS STILL RUNNING!  ¿why cannot I find *anything* about this on google?
Ive had this issue multiple times on multiple machines for a varying degree of different applicatuions/services....

the only brute force/hammer (instead of scalpel) way i know how to solve this is:
* uninstall the responsible package, or
* move the .conf file associated with the service/unit somewhere else.
* oh and also shred the executable.




= See also =
helpsystemctl2 helpsystemctl3
helpsystemd
helpchkconfig helpupdatercd
journalctl
__envHEREDOC__
}
helpsystemctl2(){
cat <<'__envHEREDOC__'
# On a CentOS Linux release 7.2.1511 (Core) system...
sudo systemctl --version
systemd 219
+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD +IDN

cancel                               -- Cancel all, one, or more jobs
cat                                  -- Show the source unit files and drop-ins
daemon-reexec                        -- Reexecute systemd manager
daemon-reload                        -- Reload systemd manager configuration
default                              -- Enter system default mode
delete                               -- Remove one or more snapshots
disable                              -- Disable one or more unit files
edit                                 -- Edit one or more unit files
emergency                            -- Enter system emergency mode
enable                               -- Enable one or more unit files
exit                                 -- Ask for user instance termination
get-default                          -- Query the default target
halt                                 -- Shut down and halt the system
help                                 -- Show documentation for specified units
hibernate                            -- Hibernate the system
hybrid-sleep                         -- Hibernate and suspend the system
is-active                            -- Check whether units are active
is-enabled                           -- Check whether unit files are enabled
is-failed                            -- Check whether units are failed
isolate                              -- Start one unit and stop all others
is-system-running                    -- Query overall status of the system
kexec                                -- Shut down and reboot the system with kexec
kill                                 -- Send signal to processes of a unit
link                                 -- Link one or more units files into the search path
list-dependencies                    -- Show unit dependency tree
list-jobs                            -- List jobs
list-sockets                         -- List sockets
list-timers                          -- List timers
list-unit-files                      -- List installed unit files
list-units                           -- List units
mask                                 -- Mask one or more units
poweroff                             -- Shut down and power-off the system
preset                               -- Enable/disable one or more unit files based on preset configuration
reboot                               -- Shut down and reboot the system
reenable                             -- Reenable one or more unit files
reload                               -- Reload one or more units
reload-or-restart                    -- Reload one or more units if possible, otherwise start or restart
reload-or-try-restart  force-reload  -- Reload one or more units if possible, otherwise restart if active
rescue                               -- Enter system rescue mode
reset-failed                         -- Reset failed state for all, one, or more units
restart                              -- Start or restart one or more units
set-default                          -- Set the default target
set-environment                      -- Set one or more environment variables
show                                 -- Show properties of one or more units/jobs or the manager
show-environment                     -- Dump environment
snapshot                             -- Create a snapshot
start                                -- Start (activate) one or more units
status                               -- Show runtime status of one or more units
stop                                 -- Stop (deactivate) one or more units
suspend                              -- Suspend the system
switch-root                          -- Change root directory
try-restart            condrestart   -- Restart one or more units if active
unmask                               -- Unmask one or more units
unset-environment                    -- Unset one or more environment variables
__envHEREDOC__
}
helpsystemctl3(){
cat <<'__envHEREDOC__'
# On a CentOS Linux release 7.2.1511 (Core) system...
sudo systemctl --version
systemd 219
+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD +IDN

--after                    -- Show units ordered after
--all                  -a  -- Show all units/properties, including dead/empty ones
--before                   -- Show units ordered before
--fail                     -- When queueing a new job, fail if conflicting jobs are pending
--failed                   -- Show only failed units
--force                -f  -- When enabling unit files, override existing symlinks. When shutting down, execute action immediately
--full                 -l  -- Dont ellipsize unit names on output
--global                   -- Enable/disable unit files globally
--help                 -h  -- Show help
--host                 -H  -- Operate on remote host
--ignore-dependencies      -- When queueing a new job, ignore all its dependencies
--ignore-inhibitors    -i  -- When executing a job, ignore jobs dependencies
--irreversible             -- Mark transactions as irreversible
--kill-who                 -- Who to send signal to
--lines                -n  -- Journal entries to show
--no-ask-password          -- Do not ask for system passwords
--no-block                 -- Do not wait until operation finished
--no-legend                -- Do not print a legend, i.e. the column headers and the footer with hints
--no-pager                 -- Do not pipe output into a pager
--no-reload                -- When enabling/disabling unit files, dont reload daemon configuration
--no-wall                  -- Dont send wall message before halt/power-off/reboot
--output               -o  -- Change journal output mode
--plain                    -- When used with list-dependencies, print output as a list
--privileged           -P  -- Acquire privileges before execution
--property             -p  -- Show only properties by specific name
--quiet                -q  -- Suppress output
--reverse                  -- Show reverse dependencies
--root                     -- Enable unit files in the specified root directory
--runtime                  -- Enable unit files only temporarily until next reboot
--show-types               -- When showing sockets, show socket type
--signal               -s  -- Which signal to send
--state                    -- Display units in the specifyied state
--system                   -- Connect to system manager
--type                 -t  -- List only units of a particular type
--user                     -- Connect to user service manager
--version                  -- Show package version
__envHEREDOC__
}
helpsystemctlsuspendAndHibernation(){
cat <<'__envHEREDOC__'
# : src : https://wiki.debian.org/Suspend
# Disable:
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Reenable:
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Prevent suspending when the lid is closed : edit /etc/systemd/logind.conf :: ( logind.conf(5) )
[Login]
HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
# and exec :
systemctl restart systemd-logind.service
__envHEREDOC__
}
helpopenssl(){
cat <<'__envHEREDOC__'
openssl ciphers # shows supported ciphers

various cipher formats/names for the same actual cipher:
https://www.openssl.org/docs/manmaster/apps/ciphers.html


= s_server : useful for debugging =
= s_client : useful for debugging =
openssl s_client --help
openssl s_client -connect hostname:port

Im not positive, but I think this might be the way to connect using a specific cipher... should double check though:
openssl s_client -state -host host -port 443 -cipher TLS_RSA_WITH_3DES_EDE_CBC_SHA
openssl s_client -state -host host -port 443 -cipher DES-CBC3-SHA
openssl s_client -state -host host -port 443 -cipher DES-CBC3-SHA
openssl s_client -state -host host -port 443 -cipher DHE-RSA-DES-CBC3-SHA
openssl s_client -state -host host -port 443 -cipher AES128-SHA256

== See also ==
helpnmap
helpkeytool
__envHEREDOC__
}
helpssl(){
cat <<'__envHEREDOC__'
/calling helpopenssl()/
__envHEREDOC__
   helpopenssl
}
helpapg(){
cat <<'__envHEREDOC__'
apg - generates several random passwords  # (search string matching; ignore: passwd)

apg -m 8 -x 8                # 8 characters long, _exactly_.
apg -m 32                    # 32 characters long, at least.
apg                     -s   # Prompt user for some entropy.
apg           -a 1           # random character password generation (i.e. not pronounceable, the default)
apg             -M SNCL      # include Special, Number, Capital, and Lowercase characters.
apg -m 32  -a 1 -M SNCL -s   # best. all the things.

apg -m 32  -a 1 -M NCL  -s   # include Numbers, Capital characters, and Lowercase characters.
__envHEREDOC__
}

helpgeneratepasswords(){
cat <<'__envHEREDOC__'
/calling helpapg()/
__envHEREDOC__
	helpapg
}

helppasswordgeneration(){
cat <<'__envHEREDOC__'
/calling helpapg()/
__envHEREDOC__
	helpapg
}

helpvideo(){
cat <<'__envHEREDOC__'
/calling helpffmpeg()/
__envHEREDOC__
	helpffmpeg
}

helpffmpeg(){
cat <<'__envHEREDOC__'
# Important/Helpful packages that can easily manually compile:
libav  git://git.libav.org/libav.git     https://libav.org/download/ (major releases are cut every 4-6 months)
ffmpeg https://git.ffmpeg.org/ffmpeg.git https://trac.ffmpeg.org/
   ( to hide header version nfo being printed out each execution, include : -hide_banner )

# Get a video files run length/duration time:
ffprobe  -show_format  inputfile  2>&1  | grep -i duration | sed 's/.*=//'
# Looped:
# first, have to change the shells IFS variable (see helpIFS), then can execute:
for i in $( find . -type f -size +100M ) ; do
   echo $i
   ffprobe -show_format $i 2>&1 | grep -i duration | sed 's/.*=//'
done > video-runtime-lengths.txt

# Get a files nfo + streams:
ffprobe -show_streams  -of json  inputfile | jq


# To EXTRACT only a small segment in the middle of a movie... (https://trac.ffmpeg.org/wiki/Seeking#Cuttingsmallsections)
#   cut from 00:01:00 to 00:03:00 (in the original), using the faster seek:
ffmpeg -ss 00:01:00 -i video.mp4 -to 00:02:00 -c copy cut.mp4

#   cut from 00:01:00 to 00:02:00, as intended, using the slower seek:
ffmpeg -i video.mp4 -ss 00:01:00 -to 00:02:00 -c copy cut.mp4

#   cut from 00:01:00 to 00:02:00, as intended, using the faster seek:
ffmpeg -ss 00:01:00 -i video.mp4 -to 00:02:00 -c copy -copyts cut.mp4

# If you cut with stream copy (-c copy) you need to use the -avoid_negative_ts 1 (https://ffmpeg.org/ffmpeg-all.html#Format-Options)
# option if you want to use that segment with the concat demuxer (https://trac.ffmpeg.org/wiki/How%20to%20concatenate%20(join,%20merge)%20media%20files#demuxer):
#   for example:
ffmpeg -ss 00:03:00 -i video.mp4 -t 60 -c copy -avoid_negative_ts 1 cut.mp4

# To CONCATenate...
#    If you have media files with exactly the same codec and codec parameters you can concatenate: https://trac.ffmpeg.org/wiki/Concatenate#samecodec
#    If you have media with different codecs you can concatenate: https://trac.ffmpeg.org/wiki/Concatenate#differentcodec
# ...files of SAME type (lossless):
# : src : https://amiaopensource.github.io/ffmprovisr/#join_files
ffmpeg -f concat -safe 0 -i mylist.txt -c copy out.mov   #  mylist.txt : file './first_file.ext'\n...
 ^^?? any way to do the same BUT ALSO say to drop the audio???
     .
     |-- # tried and failed :
     |-- ffmpeg -i f1 -i f2 -filter_complex "[0:v:0][1:v:0]concat=n=2:v=1:a=0[video_out]" -map "[video_out]" -c copy out.mov
     |-- # with : >>> Streamcopy requested for output stream 0:0, which is fed from a complex filtergraph. Filtering and streamcopy cannot be used together.
     |
     `-- #ok, so I'm pretty sure (from "Stream copy" (ffmpeg(1))) the answer is _NO_ because : "Applying
         #   filters is obviously also impossible, since filters work on uncompressed data."

# ...files of DIFF type (transcode):
# : src : https://amiaopensource.github.io/ffmprovisr/#join_different_files
ffmpeg -i f1 -i f2 -filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0]concat=n=2:v=1:a=1[video_out][audio_out]" \
   -map "[video_out]" -map "[audio_out]"  out.mov

# Video stabilization0
  for big time, serious, manual stabilization where you center on something in the video, ffmpeg isn't going to help with that; check out a program like Natron.

# Video stabilization1
  i've not actually had good results with the following; havent exactly put in any time to investigate either.
  https://video.stackexchange.com/questions/19089/youtube-like-video-stabilization-on-linux
ffmpeg -i shaky-input.mp4 -vf deshake stabilized-output.mp4   # one pass approach.
ffmpeg -i shaky-input.mp4 -vf vidstabdetect=shakiness=5:show=1 dummy.mp4  # 1/2 two pass approach.
ffmpeg -i shaky-input.mp4 -vf vidstabtransform,unsharp=5:5:0.8:3:3:0.4 stabilized-output.mp4 # 2/2

# Video stabilization2
http://bernaerts.dyndns.org/linux/74-ubuntu/350-ubuntu-xenial-rotate-stabilize-video-melt-vidstab

# Demux out just the _V_ideo portion from a media file:
ffmpeg -i f1 -c:v copy -map 0:0 video.mov

# Strip any potentially insane metadata from media files:
ffmpeg -i in.mov -map_metadata -1 -c:v copy -c:a copy out.mov
for i in * ; do echo $i;  ffmpeg -i "$i" -map_metadata -1 -c:v copy -c:a copy "stripped.$i"; done

== See also ==
helpmkvmerge
helphandbrake
blender / https://wiki.blender.org/index.php/Dev:Doc/Building_Blender/Linux/Ubuntu/CMake
mediainfo

=== ffmpeg ===
https://amiaopensource.github.io/ffmprovisr/
__envHEREDOC__
}
helpmkvmerge(){
cat <<'__envHEREDOC__'
# Merge a bunch of auto-split videos (like what you would get if you were forced to
# record onto the most cat rapey filesystem still in use today that we should have
# f*#$%^& abandoned in like 2000):
mkvmerge -o joined-peanuckle-video.mp4.mkv  peanuckle-video1.mp4 + peanuckle-video2.mp4 + ...

__envHEREDOC__
}
helphandbrake(){
cat <<'__envHEREDOC__'
Transcode a video (e.g. from high quality to much lower for use on less powerful machine/device):

Transcode a whole bunch of videos:

__envHEREDOC__
}
helpglances(){
cat <<'__envHEREDOC__'
freaking python/pip/glances-installation problems

pip install -U pip setuptools
or might be
sudo /usr/local/bin/pip install -U pip setuptools

__envHEREDOC__
}
helpxlsclients(){
cat <<'__envHEREDOC__'
xlsclients - list client applications running on a display (x11 related)
__envHEREDOC__
}
helppowertop(){
cat <<'__envHEREDOC__'
: http://xmodulo.com/how-to-monitor-power-usage-in-linux.html
powertop is an ncurses-based command-line tool developed by Intel to monitor process-level power consumption, and to provide suggestions to optimize power management.
__envHEREDOC__
}
helpvirtualenv(){
cat <<'__envHEREDOC__'
install package: python-virtualenv
python -m virtualenv the-what-now
cd the-what-now ; source bin/activate

# at this point, can run pip (at bin/pip) and whatever and it will install pips within this virtualenv.
__envHEREDOC__
}
helpzsh(){
cat <<'__envHEREDOC__'
bindkeys - shows current keyboard shortcuts.
history - shows last 16 cmdlns (wtf? why 16?).
history N - where N is number of lines you want to see, e.g. history 100 would show the last 100 cmdlns.
__envHEREDOC__
}
helpconfigure(){
cat <<'__envHEREDOC__'
# generally:
./configure --prefix=/usr/local/ --option-flag1 ...

# to pass any special compiler flags, before executing ./configure , modify it so that the
# cmake cmdln in it looks sort of like:
cmake -D CMAKE_CXX_FLAGS="<whatever flags you want... e.g. -std=c++03>"
# ^^hrm... that didnt seem to actually work.  ended up manually editing a generated makefile
# to actually get the effect :(

__envHEREDOC__
}
helpcomm(){
cat <<'__envHEREDOC__'
# For union'ing and intersecting datasets, comm -13 suppress 'column 3' which is lines that appear in both files::
comm -13 a.sorted.txt b.sorted.txt

# For intersecting:
comm -12 a.sorted.txt b.sorted.txt

# For variables, instead of files:
x="a b c"
comm -13  <(echo a) <(echo $x | tr " " "\n")
# ^^result is: b c  ( removed "a" from "a b c" )
__envHEREDOC__
}
helpjq(){
cat <<'__envHEREDOC__'
https://jqplay.org/jq?q=.foo&j=%7B%22notfoo%22%3A%20true%2C%20%22alsonotfoo%22%3A%20false%7D#

<any json> | jq  # to produce pretty print equivalent.

echo '{
  "Tags": [ { "Value": "TRASH", "Key": "Name" } ],
  "Encrypted": false,
  "VolumeType": "standard",
  "VolumeId": "vol-01103d27fb2fd09a8"
}' | jq '.VolumeId'
# -> "vol-01103d27fb2fd09a8"
{<SAME>}' | jq -r '.VolumeId'
# -> vol-01103d27fb2fd09a8  (no quotes)
{<SAME>}' | jq -r '.VolumeId, .VolumeType'
# -> "vol-01103d27fb2fd09a8"
# -> "standard"
echo '{
    "AccessKeyMetadata": [
        {
            "UserName": "SVC",
            "Status": "Active",
            "CreateDate": "2017-04-19T14:53:49Z",
            "AccessKeyId": "AKIAJ5ZDNO7BR4FIKPOQ"
        }
    ]
}' | jq '.AccessKeyMetadata[].AccessKeyId'
# -> "AKIAJ5ZDNO7BR4FIKPOQ"

# on windows, JSON parsing seems to be a big problem; always like "
# this helps though:  call a custom defined function:: pretty*.jq :::
#  ( the pretty1.jq and pretty2.jq text files be in dotfiles, currently)
jq -Rr 'include "pretty2"; pretty' some.js >some.js.pretty2
__envHEREDOC__
}

helpkpathsea(){
cat <<'__envHEREDOC__'
Kpathsea - a library for path searching!?
__envHEREDOC__
}

helpsnap(){
cat <<'__envHEREDOC__'
= PACKAGE MANAGEMENT =
# Sort of works like all the other package managers... aptitude, apt, yum, etc...
snap search vlc
snap info vlc
snap install vlc
snap install vlc --channel=beta
snap install vlc --channel=edge

== See also ==
flatpak
__envHEREDOC__
}
helpsnap2(){
cat <<'__envHEREDOC__'
= APPARMOR-RELATED =
/var/lib/snapd/apparmor/profiles/

__envHEREDOC__
}

helpimages(){
cat <<'__envHEREDOC__'
exif - shows EXIF information in JPEG files
exiftool - Read and write meta information in files
perceptualdiff - perceptual image comparison tool
posterazor - splits an image across multiple pages for assembly into a poster

# Losslessly transform jpeg, i, 90 degrees clockwise using jpegtran (of libjpeg-turbo-progs):
jpegtran -copy all -rotate 90  -outfile tranned${i}  $i

== See also ==
helpidentify
__envHEREDOC__
}
helpgps(){
cat <<'__envHEREDOC__'
qmapshack - GPS mapping (GeoTiff and vector) and GPSr management
__envHEREDOC__
}
helppaste(){
cat <<'__envHEREDOC__'
= paste - merges lines of files :: Write lines consisting of the sequentially corresponding lines from each FILE, separated by TABs, to standard output. =
file1
-----
1
2
3

file2
-----
a
b
c

$ paste file1 file2
1       a
2       b
3       c

= some interesting behaviour =
$ paste -   < file1
1
2
3

$ paste - - < file1
1       2
3

$ paste - - - < file1
1       2       3

$ paste - - - - < file1 file2
1       2       3               a
                                b
                                c
__envHEREDOC__
}
helpsqlite(){
cat <<'__envHEREDOC__'
sqlite3 dbname .dump > dbname.dump.txt
__envHEREDOC__
}



helppythonaws(){
cat <<'__envHEREDOC__'
http://boto3.readthedocs.io/en/latest/reference/services/
__envHEREDOC__
}



helphdd8_network_direct_blk_dev_access(){
cat <<'__envHEREDOC__'
Network Block Device
== FreeBSD ==
: src : https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/geom-ggate.html
ggatec ggated -
   GEOM provides a simple mechanism for providing unencrypted remote access to devices such
   as disks, CDs, and file systems through the use of the GEOM Gate network daemon, _ggated_.
   The system with the device runs the server daemon which handles requests made by clients
   using _ggatec_

== Linux ==
: src : https://nbd.sourceforge.io/
nbd nbd-client nbd-server
when compiled into your kernel, Linux can use a remote server as one of its block devices.

=== see also ===
http://www.linux-mag.com/id/7118/ - Network Block Devices: Using Hardware Over a Network
https://web.archive.org/web/20071026061326/http://w3.linux-magazine.com/issue/70/Network_Block_Devices.pdf - discusses not just NBD, but other implementations as well
http://www.microhowto.info/howto/export_a_block_device_using_nbd.html
[[wikipedia: Network block device]]
__envHEREDOC__
}
helpkeytool(){
cat <<'__envHEREDOC__'
# import PEM formatted certificate (generally used with openssl) into a Java KeyStore file:
keytool -import -v -alias 1 -file certificate.cer -keystore KeyStore.jks

= See also =
helpopenssl
__envHEREDOC__
}
helplpr(){
cat <<'__envHEREDOC__'
-# <copies>          # oddly, this doesnt get interpretted as a Bash comment.

# for some reason, this is the only error-free way I can print to brother from newjack
# (meaning, the page doesnt get stretched out and/or stupidly deformed and cutting off the
# headers and/or footers, for some reason) :
lpr -o media=letter -o sides=two-sided-long-edge -o fit-to-page  "$FILE"
   -o sides=one-sided
   -o number-up={2|4|6|9|16}
      -o number-up=2
   -o page-ranges=
   -o BRPrintQuality=Black -o "Color/mono=Mono"     # greyscale printing.

# other options whose behaviour have not been hammered down:
   -o BRColorMode=False     ... actual valid values appear to be : BRColorMode=Normal  BRColorMode=Vivid
   -o Color/mono=Auto       ... can also try : Color/mono=Color  Color/mono=Mono  Color/mono=Black
   -o BRPrintQuality=Mono   ... BRPrintQuality=Color
   -o BRPrintQuality=Black
         BRProcessColor=1
         BRColorAdapt=false
         BRRenderMode=true

# print cups status information...
# -l Shows a long listing of printers, classes, or jobs.
# -t Shows all status information; === to using -r, -d, -c, -v, -a, -p, and -o options.
lpstat -lt


lpoptions - display or set printer options and defaults

   /etc/cups/lpoptions - system-wide defaults and instances created by the root user.
   ~/.cups/lpoptions - user defaults and instances created by non-root users.

~/.cups/lpoptions  content pulled from newjack.local :

Dest Brother_HL-4150CDN_series_br-script33 Resolution=2400x1200dpi TonerSaveMode=On
Default Brother_HL-4150CDN_series_br-script33

# for printing of media with IMAGES:
lpr -o media=letter -o sides=two-sided-long-edge -o fit-to-page -o TonerSaveMode=Off -o BRImprovedGray=On -o UCRGCRForImage=On -o BRReducedImage=On  "$FILE"

# filename of MOST RECENTLY MODIFIED file:
FILE=$( find . -maxdepth 1 -type f -exec stat --format '%Y :%y %n' {} \; | sort -nr | cut -d: -f4- | cut -d' ' -f3- | head -1 ) ; echo "$FILE"


== troubleshooting ==
# sometimes, seemingly randomly, get that SO frustrating printed out GENERAL FAILURE error, instead
# of the actual document getting printed.  Message is like:
#    ERROR NAME;
#       typecheck
#    COMMAND;
#       image
#    OPERAND STACK;
# Something I finally noticed about this is that the source PDF file that caused the failure says it's a:
#    PDF document, version 1.7
# This PDF version thing must be the reason for some if not all of these failure print-outs.
# Can determine PDF version with the 'file' cmdln:
file some-pdf-file.pdf
__envHEREDOC__
}
helpmanjaro(){
cat <<'__envHEREDOC__'
= See also =
helppacman
__envHEREDOC__
}
helppacman(){
cat <<'__envHEREDOC__'
Arch Linux Package Management
-----------------------------
# query package database for pm:
pacman -Ss pm

# query package database for locally installed packages like "pm":
pacman -Qs pm

# upgrade system and packages:
pacman -Syyu

# [re]installs bind package [if it's already installed]:
pacman -S bind

# installs bind package if not already installed: yaourt::
pacman -S --needed bind
pacman -S --needed yaourt

# removes package:
pacman --remove package

# search AUR repository for chrome: google-chrome::
package-query --aur --search chrome
package-query --aur --search google-chrome

# Which package provides a file that is already on system:
pacman -Qo $( which dig )
/usr/bin/dig is owned by bind-tools 9.13.5-4


makepkg - package build utility
package-query - Query alpm database and/or AUR
namcap - package analysis utility
__envHEREDOC__
}
helpkdeconnect(){
cat <<'__envHEREDOC__'
# idk what the deal is but kde connect seems almost so perfect but constantly crashes...
rm -rf ~/.config/kdeconnect
killall kdeconnectd
killall -s KILL kdeconnectd
ps -fp $(pgrep kdeconnectd)
kdeconnectd
__envHEREDOC__
}
helposxHELPPPPPP(){
cat <<'__envHEREDOC__'
having the most bizzaire and confusing situation ever within the so called
   GNU bash v3.2.57(1)-RELEASE-(X86_64-APPLE-DARWIN15)
whereby upon (attempting) to load my usual shell environment preferences,
the osx bash just flat out regurgitates... and refuses with:
   argument list too long

UPDATE: hrm... loading these 4 files manually appeared to succeed fine... did
like (NOTE: not sure if tried this in the past or not... something else in this
machine state /could/ have changed):
   source .aliases.sh
   source .functions.sh
   source .git-prompt.sh
   source .variables.sh

but... hrm... lol this is going to require some re-jiggering... a lot of the linux/gnu-
based cmdlns am used to, specifically like the alias'ing of cmdlns like _du_, youve
aliased this with options that are not valid in osx bash....... so... ya, have fun
Bob Barkering that out.
__envHEREDOC__
}
helposx(){
cat <<'__envHEREDOC__'
= random notes =
launchctl interfaces with launchd to load, unload daemons/agents and generally control launchd.
 launchctl list

from hostname(1):
To keep the hostname between reboots, run `scutil --set HostName name-of-host'.
     scutil -- Manage system configuration parameters
scutil provides a command line interface to the "dynamic store" data maintained by configd(8).

__envHEREDOC__
}
helppkgin(){
cat <<'__envHEREDOC__'
: src : http://pkgsrc.se/ :
The NetBSD Packages Collection (pkgsrc) is a framework for building third-party software on NetBSD and other UNIX-like systems.

pkgsrc-wip (work in progress) is a project to get more people actively involved with creating packages for pkgsrc,
a portable packaging system coming from NetBSD, but ported to many other operating systems, including
Solaris, Linux, Darwin, FreeBSD, OpenBSD, and others.

: src : https://www.pkgsrc.org/ :
The binary packages that are produced by pkgsrc can be used without having to compile everything from source. NetBSD already contains the necessary tools for managing binary packages; on other platforms you need to bootstrap pkgsrc to get the package management tools installed.


// this is all at least for illumos / omnios / bump //
pkgin - A tool to manage pkgsrc binary packages.

https://pkgsrc.joyent.com/install-on-illumos/


== on bump ==
pkgin help
pkgin search fio
pkgin install fio-2.19nb1          # Flexible IO Tester


= See also =
pkg_add(1), pkg_info(1), pkg_summary(5), pkgsrc(7)

== linux-related ==
* https://www.reddit.com/r/linux/comments/7b13x7/pkgsrc_on_linux_worth_it/
** http://www.codeghar.com/blog/essential-pkgsrc-the-missing-mini-handbook.html
__envHEREDOC__
}
helpkill(){
cat <<'__envHEREDOC__'
SIGTERM ( 15) tells an application to terminate.
SIGKILL ( 9 ) tells the kernel to remove an application.
__envHEREDOC__
}
helpgrub2(){
cat <<'__envHEREDOC__'
# Steps to reinstall / rebuild the grub2 so the system can boot on its own, once again:
# within a live session...

mount ${root-filesystem-to-perform-the-reinstall-of-grub2-for}  /mnt/
# ^^for example:  $ mount /dev/sda1  /mnt/
# or perhaps   :  $ mount LABEL=id-9-ubu1204  /mnt/

mount --bind /dev/  /mnt/dev/
mount --bind /proc/  /mnt/proc/
mount --bind /sys/  /mnt/sys/
chroot /mnt/
update-grub
# ^^but sometimes, running update-grub is not enough.  When this is the case, must also do:

# Install the boot loader files to the boot sector (+some additional contiguous
# area from the boot sector, methinks) of the base device:
grub-install --recheck --no-floppy  ${BASE-DEVICE-OF-root-filesystem-to-perform-the-reinstall-of-grub2-for}
# ^^for example:  $ grub-install --recheck --no-floppy  /dev/sda

# If youre running btrfs, instead run grub-install something like:
grub-install --root-directory=/mnt/@/ /dev/sda1
__envHEREDOC__
}
helphdd9_btrfs(){
cat <<'__envHEREDOC__'
d=/dev/sdd
dname=a58-458
sudo mkdir /mnt/$dname/

sudo mkfs.btrfs -L $dname  $d    # NOTICE : using entire device / no partition table in this example.

sudo btrfs device scan [--all]

sudo mount -t btrfs LABEL=$dname /mnt/$dname   # this is just some sort of meta container for management and creation of subvolumes (thatll be created next).

# the fs mounted at /mnt/$dname is the freshly created filesystem and is also a subvolume, called top-level.
#    A Btrfs filesystem has a default subvolume, which is initially set to be the top-level subvolume and which is mounted if no subvol or subvolid option is specified.
#    Changing the default subvolume with btrfs subvolume default will make the top level of the filesystem inaccessible, except by use of the subvol=/ or subvolid=5 mount options.


sudo btrfs device usage /mnt/$dname
sudo btrfs device stats /mnt/$dname

sudo btrfs filesystem show -d
sudo btrfs filesystem usage /mnt/$dname   ====   sudo btrfs filesystem df /mnt/$dname

sudo btrfs subvolume create /mnt/$dname/svol
sudo btrfs subvolume list /mnt/$dname

sudo umount /mnt/$dname
sudo mount -t btrfs -o subvol=svol LABEL=$dname /mnt/$dname
#^^creates a mount like:
#   $d on /mnt/$dname type btrfs (rw,relatime,ssd,space_cache,subvolid=257,subvol=/svol) [$dname]
sudo chmod ugo+rwx /mnt/$dname

# optionally, update fstab:
sudo su -c "echo \"LABEL=${dname}             /mnt/${dname}              btrfs     defaults        0 0\" >> /etc/fstab"
__envHEREDOC__
}
helpmediainfo(){
cat <<'__envHEREDOC__'
# Video codec of file
mediainfo "$i" --Inform="Video;%CodecID%"

# Video codec of all files in cwd :
for i in * ; do echo "$( mediainfo "$i" --Inform="Video;%CodecID%" ) : $i"; done


__envHEREDOC__
}

helptail(){
cat <<'__envHEREDOC__'
# Concatenate multiple files but include filename as section headers ( https://stackoverflow.com/q/5917413 )
tail  -n +1  file1.txt file2.txt...
__envHEREDOC__
}
helpparallel(){
cat <<'__envHEREDOC__'
seq 10 | parallel echo {} + 1 is {= '$_++' =}

# if have a bunch of system files that its unclear if a known package is claiming them or not, this speeds things up significantly compared to linear:
cat is-any-package-own-these-files.txt | parallel  apt-file search
__envHEREDOC__
}


helpsparse(){
cat <<'__envHEREDOC__'
ls -lsh   # prints occupied size in the new first column.  if occupied size is < apparent size(the normal size column), the file is sparse.

cp --sparse=always  # copies the file smartly (the way youd want / expect it to behave if its truely a small file thats "huge")
__envHEREDOC__
}
helpls(){
cat <<'__envHEREDOC__'
Meaning of "+" under the access permissions column, e.g.:
   drwxr-x---+  2 root   root       6 06-16 23:43 tabi/

Meaning of "." under the access permissions column, e.g.:
   drwxr-x---.  2 root   root       6 06-16 23:43 tabi/

^^^These have to do with SELinux and ACL's:

   ' ' (blank) no SELinux coverage
   '.' (dot) ordinary SELinux (ACL) context only
   '+' (plus) general ACL

= See also =
ls -Z tabi/    # For SELinux context; modify with one of: chcon semanage fcontext restorecon
getfacl tabi/  # To see what access control the file has.
__envHEREDOC__
}
helpjournalctl(){
cat <<'__envHEREDOC__'
# Get logs for the docker daemon can be viewed using:
journalctl -u docker                     # -u, --unit=UNIT|PATTERN
journalctl -u ntpd                       # -u, --unit=UNIT|PATTERN


journalctl --identifier=zfs-auto-snap    # -t, --identifier=SYSLOG_IDENTIFIER
__envHEREDOC__
}

helpflatpak(){
cat <<'__envHEREDOC__'

# Run Flatpak app over an x11 forwarding situation:
flatpak run --branch=stable --arch=x86_64 --command=sh com.makemkv.MakeMKV  -c "DISPLAY=:10.0  makemkv"

__envHEREDOC__
}
helppythonfilesandDirectories(){
cat <<'__envHEREDOC__'
# WARNING on glob.glob(path) : if theres any chance a path will contain pattern matching characters (e.g. * [] etc.), youll get some unpredictable / undesirable behaviour.

# nice selection of common case snippets:
#   https://stackoverflow.com/questions/33090642/pythons-os-listdir-with-os-path-isdir-does-not-return-all-directories
#   https://stackabuse.com/python-list-files-in-a-directory/
#   https://stackoverflow.com/questions/3964681/find-all-files-in-a-directory-with-extension-txt-in-python
__envHEREDOC__
}
helpcowsay(){
cat <<'__envHEREDOC__'
# demonstrate all installed cows:
for i in /usr/share/cowsay/cows/* ; do echo $i; cowsay -f $i 'demonstrate all installed cows!!'; done |less
__envHEREDOC__
}








copyFromWindowsHomeIntoDotfilesRepoBecauseStupidness(){
   cp -vp ~/.tmux.conf $ZOMG_DOTFILES
   cp -vp ~/.mainly.sh $ZOMG_DOTFILES
   cp -vp ~/.bash_profile $ZOMG_DOTFILES
   cp -vp ~/.mainly.sh $ZOMG_DOTFILES
   cp -vp ~/.gitconfig $ZOMG_DOTFILES
   cp -vp ~/.minttyrc $ZOMG_DOTFILES


   cp -vp ~/.vimrc $ZOMG_DOTFILES
   rm -vr $ZOMG_DOTFILES/.vim/
   cp -vrfp ~/.vim/ $ZOMG_DOTFILES/
}


helpumount(){
cat <<'__envHEREDOC__'
# Troubleshooting umounting (at least) network things but (get that frustrating suuper shlowdown because)
# local connection to said thing has been severed.  IF /etc/mtab of troubley mount is like :
#
#  //192.168.1.154/c/ /media/smb-elon-musks-pc-c cifs rw,no<...SNIP!...>
#
# and    sudo umount -f /media/smb-elon-musks-pc-c   gives like  "target is busy.", TRY THE OTHER SIDE
# of that mount definition, the   //192.168.1.154/c/   :
sudo umount -f //192.168.1.154/c/

== See also ==
helpmount*()
__envHEREDOC__
}
helpbittorrent(){
cat <<'__envHEREDOC__'
/calling helpdd()/
__envHEREDOC__
	helpdd
}
helphex(){
cat <<'__envHEREDOC__'
== tools and snippets pertaining to hexadecimal data / file manipulation ==

# reverse a binary file (but not text files?)
< infile  xxd -p -c1 | tac | xxd -p -r  >  outfile

==== See also ====
hexdump
xxd
__envHEREDOC__
}




_help5(){
cat <<'__envHEREDOC__'

__envHEREDOC__
}

_help6calling(){
cat <<'__envHEREDOC__'
/calling helpgetconf()/
__envHEREDOC__
	helpgetconf
}

_help7_vars_interpretted(){
	heredocWithVariables=$(cat <<__envHEREDOC__

__envHEREDOC__
)
	echo "$heredocWithVariables"
}

_help8paginATE(){
   (
cat <<'__envHEREDOC__'

__envHEREDOC__
) | less --no-init
#) |& less -F;
}

unset -f _help6 _help7_vars_interpretted
## ### #### ###################################################################
##
## /help text functions
##
## ### #### ###################################################################


# CLEAN UP THIS FILE.  AREAS OF INTEREST::
# grep --line-number '`' .functions.sh

#41 up
