#!/usr/bin/env sh

# Set Environment Variables
export HUBOT_IRC_NICK=kpt-chan
export HUBOT_IRC_SERVER=irc.aiming-inc.biz
export HUBOT_IRC_ROOMS="#hdemon"

# Using SSL?
export HUBOT_IRC_PORT=6697
export HUBOT_IRC_USESSL=true
#export HUBOT_IRC_SERVER_FAKE_SSL=true

# Server password?
export HUBOT_IRC_PASSWORD=aim1600023

# Don't let hubot flood the room.
export HUBOT_IRC_UNFLOOD=true

# enable notice command.
export HUBOT_IRC_SEND_NOTICE_MODE=true

# Output environment variables
echo HUBOT_IRC_NICK=$HUBOT_IRC_NICK
echo HUBOT_IRC_SERVER=$HUBOT_IRC_SERVER
echo HUBOT_IRC_ROOMS=$HUBOT_IRC_ROOMS
echo HUBOT_IRC_SEND_NOTICE_MODE=$HUBOT_IRC_SEND_NOTICE_MODE

echo HUBOT_IRC_PORT=$HUBOT_IRC_PORT
echo HUBOT_IRC_USESSL=$HUBOT_IRC_USESSL
echo HUBOT_IRC_SERVER_FAKE_SSL=$HUBOT_IRC_SERVER_FAKE_SSL
echo HUBOT_IRC_PASSWORD=$HUBOT_IRC_PASSWORD

# Start the redis brain
echo ""
echo "Starting Redis Server"
/usr/local/bin/redis-server > /dev/null &

echo ""
echo "Starting bot"
./bin/hubot -a irc
