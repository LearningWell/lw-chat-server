'use strict';

const Elm = require('./Elm/App');
const app = Elm.App.fullscreen();

app.ports.scrollToBottom.subscribe(function (id) {
  setTimeout(function () {
    let textarea = document.getElementById(id);
    textarea.scrollTop = textarea.scrollHeight;
  }, 1)
});