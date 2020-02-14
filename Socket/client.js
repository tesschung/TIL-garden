var net = require('net')
var socket = new net.Socket()

var ip = '192.168.0.7'
var port = 3000

socket.connect({host:ip, port:port}, function () {
    console.log('서버 연결 성공')
    // connect한다
    socket.write('Hello I am client.js')
    socket.end();

    socket.on('data', function (chunk) {
        // 데이터 도착
        console.log('서버가 보냄',
        chunk.toString())
    });
    socket.on('end', function () {
        // 원격 호스트의 종료
        console.log('서버 연결 종료')
    })

});
