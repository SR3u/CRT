#!/bin/bash
log()
{
    echo $@ >> "$UPDATELOG" 2>&1
}
OLDVERSION=$1
NEWVERSION=$2
UPDATELOG='~/CRT_update.log'
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$DIR"
cd ..
APPSUPPORTDIR=`pwd`
UPDATELOG=$APPSUPPORTDIR/last_update.log
echo "log cleared" > "$UPDATELOG"
rm -rf $UPDATELOG
cd "$DIR"
log "updating from version "$OLDVERSION" to version "$NEWVERSION
log "update started" `date` 
log update directory: $DIR
log Application Support directory: $APPSUPPORTDIR
log update.log: $UPDATELOG
log unzipping update
log "unzip ./update.zip"
unzip ./update.zip >> "$UPDATELOG" 2>&1
log "replacing old app with new" 
log  "rm -rf /Applications/CRT.app"
rm -rf /Applications/CRT.app >> "$UPDATELOG" 2>&1
mv -f ./CRT.app /Applications >> "$UPDATELOG" 2>&1
log "mv -f ./CRT.app /Applications"
log "done!"
log "update finished" `date`
echo update log: $UPDATELOG