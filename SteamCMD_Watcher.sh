#!/bin/bash
PATH="/usr/local/bin:/usr/bin:/bin" # Needed for MCRCON
#Script Name : SteamCMD_Watcher.sh
#Description : Script for monitoring and updating game servers for Linux SteamCMD
#Author : bnema
#Github : https://github.com/bnema/SteamCMD_Watcher
#--------------------------------------------#
# Call functions in prompt if needed. Example: ./SteamCMD_Watcher.sh check_update
#--------------------------------------------#
#check_server
#update_server
#shutdown_server
#start_server
#restart_server
#monitor_server
#daily_restart (for cronjob)
#RCONListPlayers
#--------------------------------------------#

# /!\ CHANGE THIS /!\
USER_PATH="/home/steam"
LOG_PATH="/home/steam/server/Logs"
RCON=true # or false (mcrcon is required https://github.com/Tiiffi/mcrcon)
RCON_PASSWORD="PASSWORD"
RCON_BROADCAST_ARG="broadcast" # or say (view mcrcon help for more info)
APP_ID="000000" # Find your game server ID here : https://developer.valvesoftware.com/wiki/SteamCMD#Game_Servers

# /!\ CHANGE THIS /!\ Create a variable of the full path where the steamcmd.sh file is located 
STEAMCMD=$USER_PATH/.steam/steam/steamcmd/steamcmd.sh

# /!\ CHANGE THIS /!\ Create a variable of the full path of the server
SERVER=$USER_PATH/path/of/your/Server.exe

# /!\ CHANGE THIS /!\ Create a variable for the name of the server executable
SERVER_EXE_NAME="Server.exe"

# Define a timesamp with DAY / MONTH / YEAR (Change the format if you want)
TIMESTAMP=$(date +"%d-%m-%Y %H:%M:%S")

# RCON messages

# /!\ CHANGE THIS /!\ Create 3 reasons for the server to restart
STRING_REASON_1="An update is available,"
STRING_REASON_2="Daily restart,"
STRING_REASON_3="Restart by an administrator,"

# /!\ CHANGE THIS /!\ Create 5 timers before the server is restarted
STRING_TIMER_1="The server will restart automatically in 15 minutes."
STRING_TIMER_2="The server will restart automatically in 10 minutes."
STRING_TIMER_3="The server will restart automatically in 5 minutes."
STRING_TIMER_4="The server will restart automatically in 1 minutes."

# ((((((((((((((((((((((((((((((((((((()))))))))))))))))))))))))))))))))))
# ((((((((((((((((((((((((CHANGE AT YOUR OWN RISK)))))))))))))))))))))))))
# ((((((((((((((((((((((((((((((((((((()))))))))))))))))))))))))))))))))))

# Wait for 60 seconds 
WATCHDOG_TIME=60

# Some colors for the prompt
Green=$'\033[0;32m'
Red=$'\033[0;31m'
Yellow=$'\033[0;33m'
Purple=$'\033[0;35m'
Nc=$'\e[0m'

# Get the pid of the server process with awk
PID=$(ps -ef | grep $SERVER_EXE_NAME | grep -v 'grep' | grep -v '/bin/sh' | awk '{ printf $2 }')

# If RCON=true then check if mcrcon is installed
if [ "$RCON" = true ]; then
    if [ ! -f /usr/local/bin/mcrcon ]; then
        echo -e "${Red}mcrcon is not installed. Please install it.${Nc}"
        exit 1
    fi
    function reasonUpdate() {
        mcrcon -p $RCON_PASSWORD "$RCON_BROADCAST_ARG $STRING_REASON_1 $STRING_TIMER_1"
        echo "${Purple}$TIMESTAMP - ${Red}$STRING_REASON_1 $STRING_TIMER_1" >> $LOG_PATH/SteamCMD_Watcher.log
        sleep 5m
        mcrcon -p $RCON_PASSWORD "$RCON_BROADCAST_ARG $STRING_REASON_1 $STRING_TIMER_2"
        echo "${Purple}$TIMESTAMP - ${Red}$STRING_REASON_1 $STRING_TIMER_2" >> $LOG_PATH/SteamCMD_Watcher.log
        sleep 5m
        mcrcon -p $RCON_PASSWORD "$RCON_BROADCAST_ARG $STRING_REASON_1 $STRING_TIMER_3"
        echo "${Purple}$TIMESTAMP - ${Red}$STRING_REASON_1 $STRING_TIMER_3" >> $LOG_PATH/SteamCMD_Watcher.log
        sleep 5m
        mcrcon -p $RCON_PASSWORD "$RCON_BROADCAST_ARG $STRING_REASON_1 $STRING_TIMER_4"
        echo "${Purple}$TIMESTAMP - ${Red}$STRING_REASON_1 $STRING_TIMER_4" >> $LOG_PATH/SteamCMD_Watcher.log
        sleep 1m
    }
    function reasonDaily() {
        mcrcon -p $RCON_PASSWORD "$RCON_BROADCAST_ARG $STRING_REASON_2 $STRING_TIMER_1"
        echo "${Purple}$TIMESTAMP - ${Red}$STRING_REASON_2 $STRING_TIMER_1" >> $LOG_PATH/SteamCMD_Watcher.log
        sleep 5m
        mcrcon -p $RCON_PASSWORD "$RCON_BROADCAST_ARG $STRING_REASON_2 $STRING_TIMER_2"
        echo "${Purple}$TIMESTAMP - ${Red}$STRING_REASON_2 $STRING_TIMER_2" >> $LOG_PATH/SteamCMD_Watcher.log
        sleep 5m
        mcrcon -p $RCON_PASSWORD "$RCON_BROADCAST_ARG $STRING_REASON_2 $STRING_TIMER_3"
        echo "${Purple}$TIMESTAMP - ${Red}$STRING_REASON_2 $STRING_TIMER_3" >> $LOG_PATH/SteamCMD_Watcher.log
        sleep 5m
        mcrcon -p $RCON_PASSWORD "$RCON_BROADCAST_ARG $STRING_REASON_2 $STRING_TIMER_4"
        echo "${Purple}$TIMESTAMP - ${Red}$STRING_REASON_2 $STRING_TIMER_4" >> $LOG_PATH/SteamCMD_Watcher.log
        sleep 1m
    }
    function reasonAdmin() {
        mcrcon -p $RCON_PASSWORD "$RCON_BROADCAST_ARG $STRING_REASON_3 $STRING_TIMER_1"
        echo "${Purple}$TIMESTAMP - ${Red}$STRING_REASON_3 $STRING_TIMER_1" >> $LOG_PATH/SteamCMD_Watcher.log
        sleep 5m
        mcrcon -p $RCON_PASSWORD "$RCON_BROADCAST_ARG $STRING_REASON_3 $STRING_TIMER_2"
        echo "${Purple}$TIMESTAMP - ${Red}$STRING_REASON_3 $STRING_TIMER_2" >> $LOG_PATH/SteamCMD_Watcher.log
        sleep 5m
        mcrcon -p $RCON_PASSWORD "$RCON_BROADCAST_ARG $STRING_REASON_3 $STRING_TIMER_3"
        echo "${Purple}$TIMESTAMP - ${Red}$STRING_REASON_3 $STRING_TIMER_3" >> $LOG_PATH/SteamCMD_Watcher.log
        sleep 5m
        mcrcon -p $RCON_PASSWORD "$RCON_BROADCAST_ARG $STRING_REASON_3 $STRING_TIMER_4"
        echo "${Purple}$TIMESTAMP - ${Red}$STRING_REASON_3 $STRING_TIMER_4" >> $LOG_PATH/SteamCMD_Watcher.log
        sleep 1m
    }
    function RCONListPlayers() {
            # Write with the list of the players in the log file SteamCMD_Watcher.log 
            echo -e "${Purple}$TIMESTAMP > ${Yellow}Liste des joueurs connect??s${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log
            mcrcon -p $RCON_PASSWORD "listplayers" >> $LOG_PATH/SteamCMD_Watcher.log
            echo -e "${Purple}$TIMESTAMP > ${Yellow}Fin de la liste des joueurs connect??s${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log
    }
elif [ "$RCON" = false ]; then
    echo -e "${Yellow}RCON is disabled.${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log
else
    echo -e "${Red}RCON is not set to true or false. Please check your configuration.${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log
    exit 1
fi

# Function to check if the server is running
function check_server() {
    # Check if the server is running with grep and write the result in a log file
    if ps -p $PID > /dev/null
    then
        echo "${Purple}$TIMESTAMP > ${Green}$SERVER_EXE_NAME with PID $PID is running...${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log 
        RCONListPlayers
    else
        echo "${Red}$TIMESTAMP > $SERVER_EXE_NAME is not running starting the server...${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log 
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
        echo "${Purple}$TIMESTAMP > ${Green}Update successful, restarting server...${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log 
        # If the update was successful, restart the server
        reasonUpdate
        # Send signal CTRL+C to the server to stop it
        kill -SIGINT $PID
        # Wait for the server to close
        sleep $WATCHDOG_TIME
        # Start the server
        xvfb-run --auto-servernum wine64 $SERVER -log -server 
        # clear the log file
        echo "" > $LOG_PATH/steam_update.log

    else
        echo "${Purple}TIMESTAMP > ${Red}No update available for $SERVER_EXE_NAME${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log 
    fi
}
function shutdown_server() {
    reasonAdmin
    # Send signal CTRL+C to the server to stop it
    kill -SIGINT $PID
    echo "${Purple}$TIMESTAMP > ${Red}Server is stopping${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log 
    # Wait for the server to close
    sleep $WATCHDOG_TIME
    echo "${Purple}$TIMESTAMP > ${Red}Server is stopped${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log 
    # clear the log file
    echo "" > $LOG_PATH/steam_update.log
}
function start_server() {
    # Start the server
    echo "${Purple}$TIMESTAMP > ${Red}Server is starting${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log 
    xvfb-run --auto-servernum wine64 $SERVER -log -server 
}
function restart_server() {
    reasonAdmin
    # Send signal CTRL+C to the server to stop it
    kill -SIGINT $PID
    echo "${Purple}TIMESTAMP > ${Red}Server is restarting${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log 
    # Wait for the server to close
    sleep $WATCHDOG_TIME
    # Start the server
    xvfb-run --auto-servernum wine64 $SERVER -log -server 
}
function daily_restart() {
    # Send signal CTRL+C to the server to stop it
    reasonDaily
    kill -SIGINT $PID
    echo "${Purple}$TIMESTAMP > ${Red}Server is restarting${Nc}" >> $LOG_PATH/SteamCMD_Watcher.log 
    # Wait for the server to close
    sleep $WATCHDOG_TIME
    # Start the server
    xvfb-run --auto-servernum wine64 $SERVER -log -server 
    # clear the log file
    echo "" > $LOG_PATH/steam_update.log
}
function monitor_server() {
    tail -f $LOG_PATH/SteamCMD_Watcher.log
}
#--------------------------------------------#
#Start the script in command prompt silently. Example : ./SteamCMD_Watcher.sh > /dev/null 2>&1 &
#--------------------------------------------#
# Some crontab examples :
#--------------------------------------------#

#Cron job start the server after reboot and log the output in a log file silently
#@reboot /home/steam/SteamCMD_Watcher.sh start_server >> /CHANGE_THE_DIRECTORY_HERE/Logs/Server_verbose.log > /dev/null 2>&1 &

# Cron job to check if the server is running every 5 minutes and log the output silently
# 5 * * * * /home/steam/SteamCMD_Watcher.sh check_server >> /CHANGE_THE_DIRECTORY_HERE/Logs/Server_verbose.log > /dev/null 2>&1 &

# Cron job to check if an update is available every 30 minutes and log the output silently
# 30 * * * * /home/steam/SteamCMD_Watcher.sh update_server >> /CHANGE_THE_DIRECTORY_HERE/Server_verbose.log > /dev/null 2>&1 &

# Cron job daily restart at 4:00 AM
# 0 4 * * * /home/steam/SteamCMD_Watcher.sh daily_restart >> /CHANGE_THE_DIRECTORY_HERE/Server_verbose.log > /dev/null 2>&1 &

#Very important, "$@" allow you to call the functions in the command prompt
"$@"
exit 0