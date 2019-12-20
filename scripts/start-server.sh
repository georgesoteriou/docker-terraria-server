#!/bin/bash
LAT_V="${GAME_VERSION//.}"
MOD_VER="${MODLOADER_VER}"
CUR_V="$(find $DATA_DIR -name terraria-* | cut -d '-' -f 2,3)"
CUR_MOD_V="$(find $DATA_DIR -name TModLoader-* | cut -d '-' -f 2,3)"
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Version Check---"
if [ ! -d "${SERVER_DIR}/lib" ]; then
    echo "---Terraria not found, downloading!---"
    cd ${SERVER_DIR}
    wget -q - http://terraria.org/server/terraria-server-$LAT_V.zip
    unzip -q ${SERVER_DIR}/terraria-server-$LAT_V.zip -d ${SERVER_DIR}/$LAT_V
    mv ${SERVER_DIR}/$LAT_V/Linux/* ${SERVER_DIR}
    rm -R ${SERVER_DIR}/$LAT_V
    rm -R ${SERVER_DIR}/terraria-server-$LAT_V.zip
    touch ${DATA_DIR}/terraria-$LAT_V
elif [ "$LAT_V" != "$CUR_V" ]; then
    echo "---Newer version found, installing!---"
    rm ${DATA_DIR}/terraria-$CUR_V
    cd ${SERVER_DIR}
    wget -q - http://terraria.org/server/terraria-server-$LAT_V.zip
    unzip -q ${SERVER_DIR}/terraria-server-$LAT_V.zip -d ${SERVER_DIR}/$LAT_V
    mv ${SERVER_DIR}/$LAT_V/Linux/* ${SERVER_DIR}
    rm -R ${SERVER_DIR}/$LAT_V
    rm -R ${SERVER_DIR}/terraria-server-$LAT_V.zip
    touch ${DATA_DIR}/terraria-$LAT_V
elif [ "$LAT_V" == "$CUR_V" ]; then
    echo "---Terraria Version up-to-date---"
else
  echo "---Something went wrong, putting server in sleep mode---"
  sleep infinity
fi

echo "---Version Check TModLoader---"
if [ ! -d "${SERVER_DIR}/tModLoaderServer" ]; then
    echo "---TModLoader not found, downloading!---"
    cd ${SERVER_DIR}
    wget -q - https://github.com/tModLoader/tModLoader/releases/download/v$MOD_VER/tModLoader.Linux.v$MOD_VER.tar.gz
    tar -xzf ${SERVER_DIR}/tModLoader.Linux.v$MOD_VER.tar.gz
    rm -R ${SERVER_DIR}/tModLoader.Linux.v$MOD_VER.tar.gz
    chmod u+x  ${SERVER_DIR}/tModLoaderServer*
    touch ${DATA_DIR}/TModLoader-$MOD_VER
elif [ "$MOD_VER" != "$CUR_MOD_V" ]; then
    echo "---Newer version found, installing!---"
    rm ${DATA_DIR}/terraria-$CUR_MOD_V
    cd ${SERVER_DIR}
    wget -q - https://github.com/tModLoader/tModLoader/releases/download/v$MOD_VER/tModLoader.Linux.v$MOD_VER.tar.gz
    tar -xzf ${SERVER_DIR}/tModLoader.Linux.v$MOD_VER.tar.gz
    rm -R ${SERVER_DIR}/tModLoader.Linux.v$MOD_VER.tar.gz
    chmod u+x  ${SERVER_DIR}/tModLoaderServer*
    touch ${DATA_DIR}/TModLoader-$MOD_VER
elif [ "$MOD_VER" == "$CUR_MOD_V" ]; then
    echo "---Terraria Version up-to-date---"
else
  echo "---Something went wrong, putting server in sleep mode---"
  sleep infinity
fi

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
screen -S Terraria -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m ${SERVER_DIR}/tModLoaderServer ${GAME_PARAMS}
sleep 2
tail -f ${SERVER_DIR}/masterLog.0