# SteamCMD_Watcher

SteamCMD_Watcher is a simple bash monitoring script for Linux allowing you to automate tasks such as checking if the server is online, or if an update is available on SteamCMD, restarting the server properly (With option to notify players via RCON) and more to come.

## How to setup

Open the script and edit the first lines with your own configuration

(Here is an example for Conan Exiles)

```bash
USER_PATH="/home/steam"
LOG_PATH="/home/steam/server/Logs"
RCON=true # (mcrcon is required https://github.com/Tiiffi/mcrcon)
RCON_PASSWORD="RcOnPaSsWorD_69"
APP_ID="443030" # Find your game server ID here : https://developer.valvesoftware.com/wiki/SteamCMD#Game_Servers

STEAMCMD=$USER_PATH/.steam/steam/steamcmd/steamcmd.sh
SERVER=$USER_PATH/server/conan/ConanSandbox/Binaries/Win64/ConanSandboxServer-Win64-Test.exe
SERVER_EXE_NAME="ConanSandboxServer-Win64-Test.exe"
```

Make the script executable

```bash
chmod +x SteamCMD_Watcher.sh
```

Run the script with a function in prompt. Example :

```bash
./SteamCMD_Watcher.sh start_server
```

Here is a list of all the available functions :

```bash
check_server    # Check if the server is running, if not, start it.
update_server   # Check in an update is available, if success, restart the server (if you use RCON it will alert the players every 5 minutes for 15 minutes).
shutdown_server # Stop the server properly (if you use RCON it will alert the players every 5 minutes for 15 minutes).
start_server #  Start the server.
restart_server # Restart the server (if you use RCON it will alert the players every 5 minutes for 15 minutes).
monitor_server # tail -f in the SteamCMD_Watcher.log to monitor the server.
daily_restart (for cronjob) # Its a restart but with a different RCON message.
RCONListPlayers # Simply print the RCON command to list all players connected.
```

## Additional content

### Some cron jobs

```bash
# Cron job start the server after reboot and log the output in a log file silently
@reboot /home/steam/SteamCMD_Watcher.sh start_server >> /CHANGE_THE_DIRECTORY_HERE/Logs/Server_verbose.log > /dev/null 2>&1 &

# Cron job to check if the server is running every 5 minutes and log the output silently
5 * * * * /home/steam/SteamCMD_Watcher.sh check_server >> /CHANGE_THE_DIRECTORY_HERE/Logs/Server_verbose.log > /dev/null 2>&1 &

# Cron job to check if an update is available every 30 minutes and log the output silently
30 * * * * /home/steam/SteamCMD_Watcher.sh update_server >> /CHANGE_THE_DIRECTORY_HERE/Server_verbose.log > /dev/null 2>&1 &

# Cron job daily restart at 4:00 AM
0 4 * * * /home/steam/SteamCMD_Watcher.sh daily_restart >> /CHANGE_THE_DIRECTORY_HERE/Server_verbose.log > /dev/null 2>&1 &

```
