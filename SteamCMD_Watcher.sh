#!/bin/bash
#Script Name : SteamCMD_Watcher.sh
#Description : Script for monitoring and updating game servers for Linux SteamCMD
#Author : bnema
#Github : https://github.com/bnema/SteamCMD_Watcher


# /!\ CHANGE THIS /!\
USER_PATH="/home/steam"
LOG_PATH="/home/steam/server/Logs"
RCON=true # or false (mcrcon is required https://github.com/Tiiffi/mcrcon)
RCON_PASSWORD="PASSWORD"
APP_ID="000000" # Find your game server ID here : https://developer.valvesoftware.com/wiki/SteamCMD#Game_Servers

# /!\ CHANGE THIS /!\ Create a variable of the full path where the steamcmd.sh file is located 
STEAMCMD=$USER_PATH/.steam/steam/steamcmd/steamcmd.sh

# /!\ CHANGE THIS /!\ Create a variable of the full path of the server
SERVER=$USER_PATH/path/of/your/Server.exe

# /!\ CHANGE THIS /!\ Create a variable for the name of the server executable
SERVER_EXE_NAME="Server.exe"

# Define a timesamp with DAY / MONTH / YEAR (Change the format if you want)
TIMESTAMP=$(date +"%d-%m-%Y %H:%M:%S")

# ((((((((((((((((((((((((((((((((((((()))))))))))))))))))))))))))))))))))
# ((((((((((((((((((((((((CHANGE AT YOUR OWN RISK)))))))))))))))))))))))))
# ((((((((((((((((((((((((((((((((((((()))))))))))))))))))))))))))))))))))
# Wait for 60 seconds 
WATCHDOG_TIME=60

# Get the pid of the server process with awk
PID=$(ps -ef | grep $SERVER_EXE_NAME | grep -v 'grep' | grep -v '/bin/sh' | awk '{ printf $2 }')

# Function to alert the players that the server is restarting (15 mins timer)
function RCONRebootUpdateMsg() {
    if [ "$RCON" = true ];
        then  
        mcrcon -p $RCON_PASSWORD "broadcast Une mise à jour est disponible pour Conan redémarrage automatique dans 15 minutes, mettez- vous à l'abris !"
        echo "$TIMESTAMP > RCON(Update/Restart) - First message sent" >> $LOG_PATH/SteamCMD_Watcher.log 
        sleep 5m
        mcrcon -p $RCON_PASSWORD "broadcast Une mise à jour est disponible pour Conan redémarrage automatique dans 10 minutes."
        echo "$TIMESTAMP > RCON(Update/Restart) - Second message sent" >> $LOG_PATH/SteamCMD_Watcher.log 
        sleep 5m
        mcrcon -p $RCON_PASSWORD "broadcast Une mise à jour est disponible pour Conan redémarrage automatique dans 5 minutes,"
        echo "$TIMESTAMP > RCON(Update/Restart) - Third message sent" >> $LOG_PATH/SteamCMD_Watcher.log 
        sleep 4m
        mcrcon -p $RCON_PASSWORD "broadcast Une mise à jour est disponible pour Conan redémarrage automatique dans 1 minute."
        echo "$TIMESTAMP > RCON(Update/Restart) - Fourth message sent" >> $LOG_PATH/SteamCMD_Watcher.log 
        else
        echo "$TIMESTAMP > RCON is not activated" >> $LOG_PATH/SteamCMD_Watcher.log 
        fi
}

function RCONListPlayers() {
    if [ "$RCON" = true ];
        then
        # Write the list of the players in the log file
        mcrcon -p $RCON_PASSWORD "listplayers" >> $LOG_PATH/SteamCMD_Watcher.log
        else
        echo "$TIMESTAMP > RCON is not activated" >> $LOG_PATH/SteamCMD_Watcher.log 
        fi
}

# Function to check if the server is running
function check_server() {
    # Check if the server is running with grep and write the result in a log file
    if ps -p $PID > /dev/null
    then
        echo "$TIMESTAMP > $SERVER_EXE_NAME with PID $PID is running..." >> $LOG_PATH/SteamCMD_Watcher.log 
        RCONListPlayers
    else
        echo "$TIMESTAMP > $SERVER_EXE_NAME is not running starting the server..." >> $LOG_PATH/SteamCMD_Watcher.log 
        # If the server is not running, start the server
        xvfb-run --auto-servernum wine64 $SERVER -log -server 
    fi
}
# Function to check if an update is available and download it with SteamCMD
# If an update is available, the server will be restarted

# Ask steamcmd to check for updates
function check_update() {
$STEAMCMD +force_install_dir $USER_PATH/server +login anonymous +app_update $APP_ID +app_update +quit | tee $LOG_PATH/steam_update.log
    # Search in the log file if the update was successful
    if grep -q "Success! App '443030' fully installed." $LOG_PATH/steam_update.log;
    then
        echo "$TIMESTAMP > Update successful, restarting server..." >> $LOG_PATH/SteamCMD_Watcher.log 
        # If the update was successful, restart the server
        RCONRebootUpdateMsg
        # Send signal CTRL+C to the server to stop it
        kill -SIGINT $PID
        # Wait for the server to close
        sleep $WATCHDOG_TIME
        # Start the server
        xvfb-run --auto-servernum wine64 $SERVER -log -server 
        # clear the log file
        > $LOG_PATH/steam_update.log
    else
        echo "$TIMESTAMP > No update available for $SERVER_EXE_NAME" >> $LOG_PATH/SteamCMD_Watcher.log 
    fi
}

function shutdown_server() {
    # Send signal CTRL+C to the server to stop it
    kill -SIGINT $PID
    echo "$TIMESTAMP > Server is stopping" >> $LOG_PATH/SteamCMD_Watcher.log 
    # Wait for the server to close
    sleep $WATCHDOG_TIME
    echo "$TIMESTAMP > Server is stopped" >> $LOG_PATH/SteamCMD_Watcher.log 
    # clear the log file
    > $LOG_PATH/SteamCMD_Watcher.log
}
function start_server() {
    # Start the server
    echo "$TIMESTAMP > Server is starting" >> $LOG_PATH/SteamCMD_Watcher.log 
    xvfb-run --auto-servernum wine64 $SERVER -log -server 

}
function restart_server() {
    # Send signal CTRL+C to the server to stop it
    kill -SIGINT $PID
    echo "$TIMESTAMP > Server is restarting" >> $LOG_PATH/SteamCMD_Watcher.log 
    # Wait for the server to close
    sleep $WATCHDOG_TIME
    # Start the server
    xvfb-run --auto-servernum wine64 $SERVER -log -server 
}
#Call functions if needed. Example: ./SteamCMD_Watcher.sh check_update
#check_server
#update_server
#shutdown_server
#start_server
#restart_server
#RCONRebootUpdateMsg
#RCONListPlayers

#Very important, "$@" allow you to call the functions in the command prompt
"$@"

# Cron job to check if the server is running every 5 minutes and log the output silently
# 5 * * * * /home/steam/SteamCMD_Watcher.sh check_server >> /CHANGE_THE_DIRECTORY_HERE/Logs/SteamCMD_Watcher.log 2>&1

# Cron job to check if an update is available every 30 minutes and log the output silently
# 30 * * * * /home/steam/SteamCMD_Watcher.sh check_update >> /CHANGE_THE_DIRECTORY_HERE/SteamCMD_Watcher.log 2>&1

exit 0