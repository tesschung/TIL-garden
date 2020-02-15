var express = require("express");
var http = require("http");
var app = express();

var server = http.createServer(app);
server.listen(5500);

app.get("/", function(req, res) {
  res.sendFile("./client.html");
});

var io = require("socket.io")(server);

io.on("connect", function(socket) {
  console.log("클라이언트 접속");

  socket.on("disconnect", function() {
    console.log("클라이언트 접속 종료");
  });
  setInterval(function() {
    socket.emit("message", "메세지");
  }, 3000);
});
