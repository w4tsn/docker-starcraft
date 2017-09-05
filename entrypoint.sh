#!/bin/bash
shopt -s expand_aliases

# Setting the config values provided per ENV
sed -i -r "s#(ai *= *).*#\1${BOT_PATH}#" $STARCRAFT/bwapi-data/bwapi.ini
sed -i -r "s#(ai_dbg *= *).*#\1${BOT_DEBUG_PATH}#" $STARCRAFT/bwapi-data/bwapi.ini
cat $STARCRAFT/bwapi-data/bwapi.ini

# Setup vnc server settings and password
printf "Starting X and VNC servers...\n"
Xvfb :0 -auth ~/.Xauthority -screen 0 1024x768x24 >> /var/log/xvfb.log 2>&1 &
x11vnc -forever -passwd melon -display :0 >> /var/log/xvnc.log 2>&1 &
printf "Initializing wine environment in $WINEPREFIX...\n"
su -c "wine wineboot --update" starcraft
if [ -e "$STARCRAFT/StarCraft.exe" ]; then
   printf "Starting StarCraft...\n"
   su -c "wine explorer /desktop=DockerDesktop,1024x768 $STARCRAFT/StarCraft.exe" starcraft >> /var/log/starcraft.log 2>&1 &
   printf "See logs in /var/log/starcraft.log!\n"
else
   printf "No StarCraft found. Consider building the image with a copy of StarCraft.\nAlternativly mount your copy to $STARCRAFT.\n"
fi

exec "$@"