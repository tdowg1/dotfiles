#!/bin/sh

_CRBASE=/view/bdavies_BOC_Merge_u/vobs/gnms_cvob/
_CRBASE=/view/bdavies_GNMS_Main_TEST_u/vobs/gnms_cvob/
_CRBASE=''
_CRBASE=/view/bdavies_CR9245_u/vobs/gnms_cvob

[ $# = 0 ] && echo "042"


case "$1" in
	crbase)
		echo "$_CRBASE"
	;;
	exportcrbase|exportCrbase)
		export CRBASE="$_CRBASE"
	;;
	trapdirs)
		out=$(cat <<__HERE__
Document_Component/design
MIB_Component
NMSConfig_Component/cutover_support
NMSConfig_Component/netcool
NMSConfig_Component/netview/trapd
NMSConfig_Component/sendtrap
__HERE__)
		echo "$out"
	;;

	*)
	;;
esac

