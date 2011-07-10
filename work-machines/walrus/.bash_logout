# ~/.bash_logout
 
# invalidate the gpm selection buffer iff logging out from a
# virtual terminal
if test -x /sbin/consoletype && /sbin/consoletype fg
then if test -r /var/run/gpm.pid && test -d "/proc/$(/bin/cat /var/run/gpm.pid)"
     then kill -USR2 "$(/bin/cat /var/run/gpm.pid)"
     fi
fi
 
clear
