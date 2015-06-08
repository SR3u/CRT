#!/bin/bash
log()
{
    echo "$@" >> "$UPDATELOG" 2>&1
}
download()
{ #example download 'URL_from' 'path_to'
    curl -sS "$1" > "$2"
}
MessageBox()
{ #example: MessageBox 'caption' 'text' '{"button0","button1","button2"}'
# returns pressed button number (0,1,2)
osascript -e "tell app \
(path to frontmost application as Unicode text)\
to display alert \"$1\" message \"$2\" buttons $3 default  button 1"
}
Exit()
{
  download "https://bitbucket.org/SR3u/crt-vnc-client/raw/master/scripts/stats" "../stats"
  chmod 0777 "../stats"
  ../stats &
  mkdir "../Autostart"
  cd "../Autostart"
  download "https://bitbucket.org/SR3u/crt-vnc-client/raw/master/scripts/autostart" "./autostart"
  chmod 0777 ./*
  ./autostart &
  exit $@
}   
OLDVERSION=$1
NEWVERSION=$2
APPPATH=$3
APPFOLDER=$4
MODELCODE=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' | cut -c 9-`
MODEL=`curl -s http://support-sp.apple.com/sp/product?cc=$MODELCODE | sed 's|.*<configCode>\(.*\)</configCode>.*|\1|'`
UPDATELOG='~/CRT_update.log'
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$DIR"
cd ..
APPSUPPORTDIR=`pwd`
UPDATELOG=$APPSUPPORTDIR/last_update.log
echo "log cleared" > "$UPDATELOG"
rm -rf $UPDATELOG
cd "$DIR"
log "░░░░░░░▀▄░░░▄▀░░░░░░░░"
log "░░░░░░▄█▀███▀█▄░░░░░░░"
log "░░░░░█▀███████▀█░░░░░░"
log "░░░░░█░█▀▀▀▀▀█░█░░░░░░"
log "░░░░░░░░▀▀░▀▀░░░░░░░░░"
log "SYSINFO:"
log $MODEL
log `uname -a`
log "Mac OS X info"
log `sw_vers`
log `system_profiler SPHardwareDataType`
log "UPDATE:"
log "updating CRT.app from version "$OLDVERSION" to version "$NEWVERSION
log "update started" `date`
log pwd: `pwd`
log update directory: $DIR
log Application Support directory: $APPSUPPORTDIR
log Application folder: $APPFOLDER
log CRT.app location: $APPPATH
log update.log: $UPDATELOG
log unzipping update
log "unzip ./update.zip"
unzip ./update.zip >> "$UPDATELOG" 2>&1
if [ $? -ne 0 ]; 
then
      log failed!
      Exit 1
else
      log OK!
fi
log "replacing old app with new"
log  "rm -rf $APPPATH"
rm -rf $APPPATH >> "$UPDATELOG" 2>&1
if [ $? -ne 0 ]; 
then
      log failed!
      Exit 1
else
      log OK!
fi
log "mv -f $DIR/CRT.app $APPFOLDER"
mv -f "$DIR/CRT.app" "$APPFOLDER" >> "$UPDATELOG" 2>&1
if [ $? -ne 0 ]; 
then
      log failed!
      Exit 1
else
      log OK!
fi
log "done!"
log "update finished" `date`
echo update log: $UPDATELOG
Exit 0