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

const port = process.env.PORT;
const server = app.listen(port, () => { console.log(`Listening on port ${port}`); });
const wss = new WebSocketServer({ server: server });
 
wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    console.log('Received: %s', message);

    const jsonMsg = JSON.parse(message);

    if (!jsonMsg.hasOwnProperty('username') || !jsonMsg.hasOwnProperty('message') ||
        jsonMsg.username.trim() === '' || jsonMsg.message.trim() === '') {
      return;
    }

    const userColor = jsonMsg.hasOwnProperty('userColor') && jsonMsg.color.trim() !== '' 
      ? jsonMsg.userColor 
      : '#000000';

    const messageToSend = JSON.stringify({
      username: jsonMsg.username.trim(),
      message: jsonMsg.message.trim(),
      userColor: userColor,
      time: new Date().getTime()
    });

    wss.clients.forEach((client) => {
      client.send(messageToSend);
    });
  });

  console.log('Client connected!');
});
