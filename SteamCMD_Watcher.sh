#!/bin/bash
#Script Name : SteamCMD_Watcher.sh
#Description : Script for monitoring and updating game servers for Linux SteamCMD
#Author : bnema
#Github : https://github.com/bnema/SteamCMD_Watcher


# /!\ CHANGE THIS /!\
USER_PATH="/home/steam"
LOG_PATH="/home/steam/server/Logs"
RCON = "true"
RCON_PASSWORD="PASSWORD"
APP_ID="000000" # Find your game server ID here : https://developer.valvesoftware.com/wiki/SteamCMD#Game_Servers

# /!\ CHANGE THIS /!\ Create a variable of the full path where the steamcmd.sh file is located 
STEAMCMD=$USER_PATH/.steam/steam/steamcmd/steamcmd.sh

# /!\ CHANGE THIS /!\ Create a variable of the full path of the server
SERVER=$USER_PATH/path/of/your/Server.exe

# /!\ CHANGE THIS /!\ Create a variable for the name of the server executable
SERVER_EXE_NAME="Server.exe"



# ((((((((((((((((((((((((((((((((((((()))))))))))))))))))))))))))))))))))
# ((((((((((((((((((((((((CHANGE AT YOUR OWN RISK)))))))))))))))))))))))))
# ((((((((((((((((((((((((((((((((((((()))))))))))))))))))))))))))))))))))

# Get the pid of the server with awk
PID=$(ps -ef | grep $SERVER_EXE_NAME | grep -v 'grep' | grep -v '/bin/sh' | awk '{ printf $2 }')


# Function to check if the server is running

function check_server() {
    # Check if the server is running with grep and write the result in a log file
    if ps -p $PID > /dev/null
    then
        echo "Server $PID is running" >> $LOG_PATH/SteamCMD_Watcher.log | ts '[%Y-%m-%d %H:%M:%S]'
    else
        echo "Server is not running starting the server..." >> $LOG_PATH/SteamCMD_Watcher.log | ts '[%Y-%m-%d %H:%M:%S]'
        # If the server is not running, start the server
        xvfb-run --auto-servernum wine64 $SERVER -log -server 
    fi
}

# Function to check if an update is available and download it with SteamCMD
# If an update is available, the server will be restarted

# Ask steamcmd to check for updates
function update_server() {
$STEAMCMD +force_install_dir $USER_PATH/server +login anonymous +app_update $APP_ID +app_update +quit | tee $LOG_PATH/steam_update.log
    # Search in the log file if the update was successful
    if grep -q "Success! App '443030' fully installed." $LOG_PATH/steam_update.log; 
    then
        echo "Update successful, restarting server..."
        if RCON = "true"
        then  
        mcrcon -p $RCON_PASSWORD "broadcast Une mise à jour est disponible pour Conan redémarrage automatique dans 15 minutes, mettez- vous à l'abris !"
        sleep 5m
        mcrcon -p $RCON_PASSWORD "broadcast Une mise à jour est disponible pour Conan redémarrage automatique dans 10 minutes."
        sleep 5m
        mcrcon -p $RCON_PASSWORD "broadcast Une mise à jour est disponible pour Conan redémarrage automatique dans 5 minutes,"
        sleep 4m
        mcrcon -p $RCON_PASSWORD "broadcast Une mise à jour est disponible pour Conan redémarrage automatique dans 1 minute."
        else
        echo "RCON is not activated, restarting the server right now..."
        fi
        # Stop the server and wait for the process to end
        SIGINT $PID
        trap SIGINT $PID
        # Wait for the server to close
        wait $PID
        sleep $WATCHDOG_TIME
        # Start the server
        xvfb-run --auto-servernum wine64 $SERVER -log -server 
        # clear the log file
        > $LOG_PATH/steam_update.log
    else
        echo "No update available"
    fi
}
#Call functions
check_server
update_server


# Cron job to check if the server is running every 5 minutes and log the output silently
# 5 * * * * /home/steam/SteamCMD_Watcher.sh check_server >> /CHANGE_THE_DIRECTORY_HERE/Logs/SteamCMD_Watcher.log 2>&1

# Cron job to check if an update is available every 30 minutes and log the output silently
# 30 * * * * /home/steam/SteamCMD_Watcher.sh update_server >> /CHANGE_THE_DIRECTORY_HERE/SteamCMD_Watcher.log 2>&1
exit 0
