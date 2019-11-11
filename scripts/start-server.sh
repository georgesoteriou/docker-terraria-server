#!/bin/bash
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Sleep zZz---"
sleep infinity


echo "---Checking if Terraria Mobile is installed---"
if [ ! -f "${SERVER_DIR}/TerrariaServer.exe" ]; then
	echo "---Terraria Mobile not found, downloading---"
	wget -qi https://terraria.org/server/MobileTerrariaServer.zip



echo "---Prepare Server---"
if [ ! -f "${SERVER_DIR}/serverconfig.txt" ]; then
  echo "---No serverconfig.txt found, downloading...---"
  cd ${SERVER_DIR}
  wget -qi serverconfig.txt "https://raw.githubusercontent.com/ich777/docker-terraria-server/master/config/serverconfig.txt"
fi
echo "---Server ready---"
chmod -R 777 ${DATA_DIR}
echo "---Checking for old logs---"
find ${SERVER_DIR} -name "masterLog.*" -exec rm -f {} \;


echo "---Start Server---"
cd ${SERVER_DIR}
screen -S Terraria -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m \
    mono-sgen TerrariaServer.exe \
    ${GAME_PARAMS}
sleep 2
tail -f ${SERVER_DIR}/masterLog.0