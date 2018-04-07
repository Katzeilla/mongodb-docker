#!/bin/bash
set -m
 
cmd="mongod --bind_ip 0.0.0.0 --storageEngine $STORAGE_ENGINE"


if [ "$AUTH" == "yes" ]; then
	    cmd="$cmd --auth"
fi
     
if [ "$JOURNALING" == "no" ]; then
            cmd="$cmd --nojournal"
fi
	 
if [ "$OPLOG_SIZE" != "" ]; then
	    cmd="$cmd --oplogSize $OPLOG_SIZE"
fi
	     
$cmd &
	     
if [ ! -f /data/db/.mongodb_password_already_set ]; then
        /set_password.sh
fi
		 
fg
