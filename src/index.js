'use strict';

const Elm = require('./Elm/App');
const app = Elm.App.fullscreen();

app.ports.scrollToBottom.subscribe(function (id) {
  setTimeout(function () {
    const el = document.getElementById(id);
    el.scrollTop = el.scrollHeight;
  }, 5)
});