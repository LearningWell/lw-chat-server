'use strict';

const fs = require('fs');
const express = require('express');
const WebSocketServer = require('ws').Server;
const https = require('https');

const privateKey  = fs.readFileSync('./cert/key.pem', 'utf8');
const certificate = fs.readFileSync('./cert/cert.pem', 'utf8');

const credentials = { key: privateKey, cert: certificate };
const app = express();
//const httpsServer = http.createServer(app);

app.enable('trust proxy');
app.get('/', function(req,res) {
  res.send('Yes, this is chat server?');
});

console.log(process.env.PORT);

const server = app.listen(process.env.PORT, () => { console.log(`Listening on port ${process.env.PORT}`); });

//httpsServer.listen(process.env.PORT || 8443);

const wss = new WebSocketServer({
  server: server
});
 
wss.on('connection', function connection(ws) {
  ws.on('message', function incoming(message) {
    console.log('received: %s', message);
  });

  console.log('Client connected!');
  
  ws.send('something');
});
