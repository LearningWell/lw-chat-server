'use strict';

const path = require('path');
const fs = require('fs');
const express = require('express');
const WebSocketServer = require('ws').Server;

const app = express();

app.enable('trust proxy');
app.use(express.static(path.join(__dirname, '../dist')));
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

const server = app.listen(process.env.PORT, () => { console.log(`Listening on port ${process.env.PORT}`); });
const wss = new WebSocketServer({ server: server });
 
wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    console.log('received: %s', message);

    const jsonMsg = JSON.parse(message);

    if (!jsonMsg.hasOwnProperty('username') || !jsonMsg.hasOwnProperty('message')) {
      return;
    }

    const messageToSend = JSON.stringify({
      username: jsonMsg.username.trim(),
      message: jsonMsg.message.trim(),
      time: new Date().getTime()
    });

    wss.clients.forEach((client) => {
      client.send(messageToSend);
    });
  });

  console.log('Client connected!');
});
