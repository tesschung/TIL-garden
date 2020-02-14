var net = require('net')

var server = net.createServer(function(socket){
  console.log('ConnectEvent', socket.remoteAddress)
  socket.write('Hello I am server.js')

  socket.on('data', function (chunk) {
    // 데이터 도착
    console.log('클리이언트가 보냄',
    chunk.toString())
  });
  socket.on('end', function () {
    // 원격 호스트의 종료
  })
});

server.on('listening', function(){
  console.log('Server is listening @', server.address()) // console에는 접속가능한 server.address()의 주소가 찍힌다.
});

server.on('close', function(){
  console.log('ServerClose')
});

server.listen(3000);

