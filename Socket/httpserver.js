// http 서버
var http = require('http')

var server = http.createServer(function(req, res) {
    res.end('socket.io Sample')
});
server.listen(3000);