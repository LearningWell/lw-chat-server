'use strict';

const fs = require('fs');
const express = require('express');
const WebSocketServer = require('ws').Server;

const app = express();

app.enable('trust proxy');
app.get('/', function(req,res) {
  res.send('Yes, this is chat server?');
});

const server = app.listen(process.env.PORT, () => { console.log(`Listening on port ${process.env.PORT}`); });
const wss = new WebSocketServer({
  server: server
});
 
wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    console.log('received: %s', message);

    const jsonMsg = JSON.parse(message);

    if (!jsonMsg.hasOwnProperty('username') || !jsonMsg.hasOwnProperty('message')) {
      return;
    }

    const messageToSend = JSON.stringify({
      username: jsonMsg.username,
      message: jsonMsg.message,
      time: new Date().getTime()
    });

    wss.clients.forEach((client) => {
      client.send(messageToSend);
    });
  });

  console.log('Client connected!');
});
