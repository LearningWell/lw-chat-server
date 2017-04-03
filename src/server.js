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
    sendMessageToClients(JSON.parse(message), false);
  });

  console.log('Client connected!');
  sendMessageAsServer('A client has connected. How exciting!');
});

const sendMessageAsServer = (message) => {
  sendMessageToClients({
    username: 'Server',
    message: message,
    userColor: '#5e5e5e'
  }, true);
}

const sendMessageToClients = (message, asServer) => {
  if (!message.hasOwnProperty('username') || !message.hasOwnProperty('message') ||
       message.username.trim() === '' || message.message.trim() === '' || (!asServer && message.username.trim().toLowerCase() === 'server')) {
    sendMessageAsServer(`An invalid message was received: ${JSON.stringify(message)}`);

    return;
  }

  const userColor = message.hasOwnProperty('userColor') && message.userColor.trim() !== '' 
    ? message.userColor 
    : '#000000';

  const messageToSend = JSON.stringify({
    username: message.username.trim(),
    message: message.message.trim(),
    userColor: userColor,
    time: new Date().getTime()
  });

  wss.clients.forEach((client) => {
    client.send(messageToSend);
  });
}
