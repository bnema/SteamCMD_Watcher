# SteamCMD_Watcher

SteamCMD_Watcher is a simple bash monitoring script for Linux allowing you automatically start your server if stopped or watch if an update is available and then restart the server.

## How to setup

Open the script and edit those lines with your own configuration

(Here is an example for Conan Exiles)

```bash
# /!\ CHANGE THIS /!\
USER_PATH="/home/steam"
LOG_PATH="/home/steam/server/Logs"
RCON = "true"
RCON_PASSWORD="RcOnPaSsWorD_69"
APP_ID="443030" # Find your game server ID here : https://developer.valvesoftware.com/wiki/SteamCMD#Game_Servers

# /!\ CHANGE THIS /!\ Create a variable of the full path where the steamcmd.sh file is located 
STEAMCMD=$USER_PATH/.steam/steam/steamcmd/steamcmd.sh

# /!\ CHANGE THIS /!\ Create a variable of the full path of the server
SERVER=$USER_PATH/server/conan/ConanSandbox/Binaries/Win64/ConanSandboxServer-Win64-Test.exe

# /!\ CHANGE THIS /!\ Create a variable for the name of the server executable
SERVER_EXE_NAME="ConanSandboxServer-Win64-Test.exe"
```

Make the script executable

```bash
chmod +x SteamCMD_Watcher.sh
```

Run the script

```bash
./SteamCMD_Watcher.sh 
```

Additionnaly, you can run the script and only call one function

```bash
./SeamCMD_Watcher.sh check_server
```

or

```bash
./SeamCMD_Watcher.sh update_server
```

### Some cron jobs

Cron job to check if the server is running every 5 minutes and log the output silently

```bash
5 * * * * /home/steam/SteamCMD_Watcher.sh check_server >> /home/steam/server/Logs/SteamCMD_Watcher.log 2>&1
```

Cron job to check if an update is available every 30 minutes and log the output silently

```bash
30 * * * * /home/steam/SteamCMD_Watcher.sh update_server >> /home/steam/server/SteamCMD_Watcher.log 2>&1
```