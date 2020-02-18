### 프로세스간 통신

#### Inter Process Communication

두 개의 프로세스 상호간에 데이터를 주고받는 방법



### 멀티플렉싱



https://www.youtube.com/watch?v=Sio5Qc-zp-w

## Socket을 이용한 실시간 서비스

실시간 노래 배틀 서비스 구현 중에 게임룸의 모든 데이터를 socket.io로 연결하기로 했다.

- 실시간 서비스

   예) 실시간 공연 예약 서비스

   	- 사용자가 선택한 공연 정보 전달
   	- 예약 가능한 공연 날짜와 좌석정보
   	- 실시간으로 예약 가능한 시간과 좌석 정보 반영
   	- 다른 사용자가 예약 -> 예약 좌석 상황 반영
   	- 실시가능로 가능한 자리 선택 후 예약

-> 이러한것은 HTTP로 구현이 힘들다

- HTTP 통신은 요청과 응답 기반
- 다시 요청할때까지 변경사항 반영안됨



-> 그래서 TCP/UDP이용

*TCP* 통신

- 네트워크 레이어: Transport Layer
- stream을 이용한 실시간 통신
- 소켓을 이용한 네트워크 프로그래밍



-> 

소켓(socket)

​	은 통신 접점이 된다.

통신 접점(Entry point)

소켓 프로그래밍

	- 데이터 그램 소켓 : UDP
	- 스트림 소켓 : TCP

<img src="README.assets/image-20200214213057760.png" alt="image-20200214213057760" style="zoom:50%;" />



- TCP
  - 연결 지향이므로 연결 과정 필요
  - 연결 과정
    - 1. **서버 소켓 생성**, 준비, 대기
      2. **클라이언트 소켓** 연결, 소켓간 **연결**
      3. 데이터 교환
      4. 접속 끊기

소켓을 이용한 통신 과정

![image-20200214213443743](README.assets/image-20200214213443743.png)



데이터를 주고 받는 것은 스트림 기반

보내기 write

받기 read





- UDP

-> 넘어감, 지금 안씀

- net 모듈

  ```js
  var net = require('net')
  
  net.Server  // 서버-클라이언트는 socket을 통해 연결된다.
  net.Socket
  
  // 서버 생성
  var server = net.createServer([option][,connectionListener])
  
  // 서버 함수
  server.listen(port[,host][,backlog][,callback])
  // -> 클라이언트 접속 대기
  server.close([callback])
  // -> 추가 접속을 받지 않는다.
  server.getConnections(callback)
  // -> 연결 개수
  server.address()
  // -> 서버 주소
  ```

**net.server 이벤트**

net.server - listening -> fork binding, 접속가능상태(accessible status event)

net.server - connection -> client connection event

net.server - close -> close server when theres no socket connected

net.server - error



서버를 생성하고 connect해보는 코드

서버코드

```js
var server = net.createServer(function(socket){
  console.log('ConnectEvent', socket.remoteAddress)
  // connectEvent 
  // 
});

// 이벤트 핸들 등록
server.on('listening', function(){
  console.log('Server is listening @', server.address()) // console에는 접속가능한 server.address()의 주소가 찍힌다.
});
server.on('close', function(){
  console.log('ServerClose')
});

```



클라이언트코드

```js
var socket = new net.Socket()
var option = {
  host = 'localhost',
  port = 3000
};

socket.connect(option, function(){
  // connect한다
});
```



**net.Socket 이벤트**

- connect :  원격 소켓 연결 이벤트
- **data : 읽을 수 있는 데이터 도착**
- end : 원격 호스트의 소켓 종료 FIN
- timeout
- error



**net.Socket 함수, 프로퍼티**

- connect(options[,connectListener]) 연결
- write(data[,encoding] [,callback]) 데이터쓰기

- end([data] [,encoding]) 연결 종료 신호 FIN 보내기
- setKeepAlive([enable] [,initialDelay]) 연결 유지
- remoteAddress, remotePort 원격 호스트 주소와 포트



연결되어있다는 가정 하에 데이터쓰기write를 통해 데이터 전달

클라이언트 코드

```js
socket.write('Hello Node.js')
```

서버코드

```js
socket.on('data', function(chunk){
  // 데이터 도착
});
socket.on('end', function(){
  // 원격 호스트의 종료
})
```

![image-20200214230739957](README.assets/image-20200214230739957.png)

:star: 15:00

createServer해서 서버를 만든다

소켓 객체를 만든다.

만들어진 소켓객체를 받아 write함수를 통해 프로퍼티를 보낸다.

해당 welcome... 이라는 **데이터**를 클라이언트는 소켓.on에서 data(이벤트로서의 데이터)라는 이벤트로 **데이터**(값으로서의 데이터)를 받는다



서버에서 write함수를 통해 전달하는 경우 클라이언트쪽에서 data이벤트가 발생한다.

end를 하면 서버에서 end이벤트가 발생한다.



**이를 통해 채팅서비스 가능**

- 서버소켓준비
- 클라이언트 소켓 연결
- 소켓을 이용한 데이터 교환

**더 고려해야 할 사항**

이제 1:N으로 데이터를 전달해야 한다.

채팅 관련 명령어: 닉네임 변경, 1:1대화, 채팅방 나가기

소켓을 이용한 서비스: **데이터 전달 + 제어 명령어 전달**

![image-20200214231939038](README.assets/image-20200214231939038.png)

클라이언트가 접속하면, 닉네임과 소켓정보를 clientList에 담는다.

데이터가 쓰여지면 해당 데이터를 모든 소켓을 돌면서 전달한다.



message -> 제어코드



전체코드

서버

```js
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
```



클라이언트

```js
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
```



![image-20200214233645163](README.assets/image-20200214233645163.png)

-> 신기하다.. 채팅 만들러가야징





### 실시간 웹서비스 원리

다양한 웹 브라우저가 있어서 실시간 웹서비스를 하는게 좀 어려웠음

크롬, 익스 등 다르니까.

```cmd
npm install socket.io
```



**서버**

- http 서버
- **Socket.io 서버**

**클라이언트(웹 브라우저)**

- http 클라이언트
- **Socket.io 클라이언트**



**서비스 시작**

http 서버 준비

Socket.io 서버 준비

socket.io **클라이언트** 요청 -> html로 응답

socket.io 클라이언트 초기화 및 서버 접속



두 서버 준비

웹 서버 -> http, express

Socket.io 서버







socket.io 클라이언트 이벤트

connect

error

disconnect

Reconnect reconnecting reconnect_error...

서버와 연결 끊어지면 자동 재접속 시도



**메세지 전송**

이벤트 발생 Socket.emit()

Socket.emit('event', **data**)

-> 이벤트를 발생시킨다.



**메세지 수신**

이벤트 리스너 등록 Socket.on()

socket.on('event', function(**data**){}) -> 'event'에 반응하도록한다

-> 이벤트를 받는다.



![image-20200215191907372](README.assets/image-20200215191907372.png)

-> 서버와 클라이언트를 나누지 않은이유는

둘 다 가능하기 때문

서버에서도 보낼 수 있고, 클라이언트에서도 보낼 수 있다.



**이벤트로 메세지 주고받기**

- 서버에 이벤트 등록 - 클라이언트에서 이벤트 발생
- 클라이언트 이벤트 등록  - 서버에서 이벤트 발생



**서버에서의 이벤트 발생** **두 가지**

소켓 하나에 이벤트 발생 1:1

Socket.emit('Direct Event', [data])

연결된 모든 소켓에 이벤트 발생 1:N

socket.io.emit('broadcast Event', [data]) // io.emit으로도 가능



네임스페이스

- 같은 네임스페이스에서만 메세지 주고 받음
- /name-space 이런식으로 정의해서 등록

io.of 이런식으로



룸

- 네임스페이스 내 채널
- 같은 룸에서만 데이터 교환
- 룸에 입장, 여러 움에 입장가능
- 룸에서 떠나기




```js
var app = require('express')();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

let rooms = {};

//connection event handler
io.sockets.on('connection' , function(socket) {

    console.log('Connect from Client: '+ socket.id)


    let room_id = socket.handshake.query.room_id;
    let user_id = socket.handshake.query.user_id;
    let user_identification = socket.handshake.query.user_identification;

    let room = rooms.room_id;
    let watcher_cnt = 0;

    let watchers = [null,null,null,null,null];

    if(room){
        //방이 존재 할때
        if (user_identification=="singer"){

            //노래 부르는 사람일때
            if (room.singer1){
                room.singer2=user_id;
            }else{
                room.singer1=user_id;
            }
        }else{//시청자일 때,
            
            if (room.watcher_cnt>=6){
              return;
            }
            //watcher_cnt++;
            room.watchers.push(user_id);
            console.log(watcher_cnt);
            room.watcher_cnt += 1;
        }
        
        room.sockets.push(socket);

    } else{
        //방이 존재하지 않을 때,
        if (user_identification=="singer"){
            room = {
                singer1: user_id,
                singer2: null,
                watcher_cnt: 0,
                watchers: {},
                sockets:[socket]
            }   


        }else{
            //시청자일 때,
            room = {
                singer1: null,
                singer2: null,
                watcher_cnt: 1,
                watchers: [user_id],
                sockets:[socket]
            }   
        }
            rooms.room_id = room;
    }
    socket.join(room_id);

    socket.to(room_id).broadcast.emit('join',{
        user: user_id,
        user_identification: user_identification,
        watcher_cnt: watcher_cnt,
        watchers: watchers

    });
    //webRTC
    // socket.on('message', data =>{
    //     socket.broadcast.emit('message', data);
    // });




    // 0217 승원 추가
    // chat 완료
    // 
    socket.on('chat', function(data){
        console.log('message from Client: '+data.message)
        var rtnMessage = {
            message: data.message
        };
        // 클라이언트에게 메시지를 전송한다
        socket.broadcast.emit('chat', rtnMessage);
    });

    // 0217 승원 추가
    socket.on('SEND_VOTE_SELECTED', function (data) {
        socket.broadcast.emit('GET_VOTE_SELECTED', data)
        io.emit('GET_VOTE_SELECTED', data)
        console.log('server', data)
    });

    // 0217 승원 추가
    socket.on('SEND_MUSIC_SELECTED', function(data) {
        socket.broadcast.emit('GET_MUSIC_SELECTED', data)
        io.emit('GET_MUSIC_SELECTED', data)
        console.log('server', data)
    });
    // 0217 승원 추가

})

server.listen(8082, function() {
    console.log('socket io server listening on port 3001')
})
```



```vue
<template>
  <div>
    <br />
    <br />
    <br />

    <v-dialog v-model="dialog" id="dialog" max-width="500">
      <template v-slot:activator="{ on }">
        <v-btn dark v-on="on">노래고르는버튼</v-btn>
      </template>

      <v-card>
        <div>
          <v-radio-group v-model="musicSelectedOne" :mandatory="false">
            <ul v-for="(music, i) in musicTitle" :key="i">
              <li v-if="music.title != '창모- meteor.mp3'&music.title[music.title.length-1]==='3'">
                <!-- music.url이라는 value가 musicSelectedOne이라는 이름으로 들어간다. -->
                <v-radio color="orange" :value="music" :label="music.title"></v-radio>

                <hr />
              </li>
            </ul>
          </v-radio-group>

          <div class="wrapper">
            <div class="cols" v-for="(music, i) in musicTitle" :key="i">

              <div v-for="(image, ii) in imageUrl" :key="ii">
                <!-- v-if="image.title.substring(0,image.title.length-4)===music.title.substring(0,music.title.length-4)" -->

                <div
                  class="col"
                  v-if="music.title != '창모- meteor.mp3'&music.title[music.title.length-1]==='3'&image.title.substring(0,image.title.length-4)===music.title.substring(0,music.title.length-4)"
                  ontouchstart="this.classList.toggle('hover');"
                >
                  <div class="container">
                    <div class="front" :style="{ 'background-image': 'url(' + image.url + ')' }">
                      <div class="inner">
                        <p>{{ music.title }}</p>
                      </div>
                    </div>

                    <div class="back">
                      <div class="inner">
                        <p>{{ music.title }}</p>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- -->
              </div>
            </div>
          </div>
          <!-- 선택하면 선택한 것만 music.url을 보내기 -->
          <!-- <v-btn type="submit" @click="trigger(musicSelectedOne)">선택완료1</v-btn> -->
          <v-btn type="submit" @click="dialog = false & trigger(musicSelectedOne.url)">선택완료</v-btn>
        </div>
      </v-card>
    </v-dialog>
    <div>
      <br />
      <!-- this.로 접근하든 그냥 접근하든 같은 값이 나온다. -->
      <!-- {{ musicSelectedOne.title }} -->
      <!-- {{ musicSelectedOne.url }} -->
      <!-- musicSelectedOne이 있는 경우에만 -->
      <div v-if="musicSelectedOne">
        <video controls name="media">
          <source :src="musicSelectedOne.url" type="audio/mp3" />
        </video>
      </div>
    </div>
  </div>
</template>

<script>
import { app } from "../../services/FirebaseServices";
import * as firebase from "firebase/app";
//import firebase from "firebase/app";
import "firebase/firestore";
import "firebase/storage";
import axios from "axios";

// socket
import io from "socket.io-client";
import net from "net";

export default {
  data() {
    return {
      musicUrl: [],
      musicTitle: [],
      musicSelected: [],
      imageUrl: [], //앨범 커버 담는 배열
      dialog: false,
      // 선택되면 null에서 다른 값으로 바뀐다.
      musicSelectedOne: null,
      socket: null
    };
  },
  mounted() {
    //서버의 변경사항을 수신
    this.socket.on("GET_MUSIC_SELECTED", data => {
      this.musicSelectedOne = data["data"];
      console.log(data);
    });
  },
  created() {
    this.socket = io.connect("http://localhost:8080", {
      transports: ["websocket"]
    });
    // list에 있는 항목들을 불러옴

    var storageRef = firebase.storage().ref();

    storageRef
      .listAll()
      .then(result => {
        result.items.forEach(musicRef => {
          let music = {};
          let image = {};
          music.title = musicRef.name;
          image.title = musicRef.name;
          console.log(musicRef);
          musicRef.getDownloadURL().then(url => {
            //앨범 커버 정보를 담음
            image.url = url;

            if (image.title[image.title.length - 1] == "g") {
              this.imageUrl.push(image);
            }

            //음악 정보를 담음
            music.url = url;
            this.musicTitle.push(music);
          });
        });
      })
      .catch(function(error) {});
  },
  methods: {
    trigger: function(data) {
      console.log("trigger 시작했습니다.");
      this.socket.emit("SEND_MUSIC_SELECTED", { data });
      console.log("데이터 선택========", data);

      // musicSelectedOne.title 로 검색해서 lyrics
      // axios 로 받아서 lyrics 보여주기
    }
  }
};
</script>
<style lang="scss"></style>
<style scoped>
* {
  margin: 0;
  padding: 0;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
}

h1 {
  font-size: 1.5rem;
  font-family: "Montserrat";
  font-weight: normal;
  color: #444;
  text-align: center;
  margin: 2rem 0;
}

.wrapper {
  width: 90%;
  margin: 0 auto;
  max-width: 100rem;
}

.cols {
  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
  -ms-flex-wrap: wrap;
  flex-wrap: wrap;
  -webkit-box-pack: center;
  -ms-flex-pack: center;
  justify-content: center;
}

.col {
  width: calc(25% - 2rem);
  margin: 1rem;
  cursor: pointer;
}

.container {
  -webkit-transform-style: preserve-3d;
  transform-style: preserve-3d;
  -webkit-perspective: 1000px;
  perspective: 1000px;
}

.front,
.back {
  background-size: cover;
  background-position: center;
  -webkit-transition: -webkit-transform 0.7s cubic-bezier(0.4, 0.2, 0.2, 1);
  transition: -webkit-transform 0.7s cubic-bezier(0.4, 0.2, 0.2, 1);
  -o-transition: transform 0.7s cubic-bezier(0.4, 0.2, 0.2, 1);
  transition: transform 0.7s cubic-bezier(0.4, 0.2, 0.2, 1);
  transition: transform 0.7s cubic-bezier(0.4, 0.2, 0.2, 1),
    -webkit-transform 0.7s cubic-bezier(0.4, 0.2, 0.2, 1);
  -webkit-backface-visibility: hidden;
  backface-visibility: hidden;
  text-align: center;
  min-height: 150px;
  height: auto;
  border-radius: 10px;
  color: #fff;
  font-size: 1.5rem;
}

.back {
  background: #cedce7;
  background: -webkit-linear-gradient(45deg, #cedce7 0%, #596a72 100%);
  background: -o-linear-gradient(45deg, #cedce7 0%, #596a72 100%);
  background: linear-gradient(45deg, #cedce7 0%, #596a72 100%);
}

.front:after {
  position: absolute;
  top: 0;
  left: 0;
  z-index: 1;
  width: 100%;
  height: 100%;
  content: "";
  display: block;
  opacity: 0.6;
  background-color: #000;
  -webkit-backface-visibility: hidden;
  backface-visibility: hidden;
  border-radius: 10px;
}
.container:hover .front,
.container:hover .back {
  -webkit-transition: -webkit-transform 0.7s cubic-bezier(0.4, 0.2, 0.2, 1);
  transition: -webkit-transform 0.7s cubic-bezier(0.4, 0.2, 0.2, 1);
  -o-transition: transform 0.7s cubic-bezier(0.4, 0.2, 0.2, 1);
  transition: transform 0.7s cubic-bezier(0.4, 0.2, 0.2, 1);
  transition: transform 0.7s cubic-bezier(0.4, 0.2, 0.2, 1),
    -webkit-transform 0.7s cubic-bezier(0.4, 0.2, 0.2, 1);
}

.back {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
}

.inner {
  -webkit-transform: translateY(-50%) translateZ(60px) scale(0.94);
  transform: translateY(-50%) translateZ(60px) scale(0.94);
  top: 50%;
  position: absolute;
  left: 0;
  width: 100%;
  padding: 2rem;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
  outline: 1px solid transparent;
  -webkit-perspective: inherit;
  perspective: inherit;
  z-index: 2;
}

.container .back {
  -webkit-transform: rotateY(180deg);
  transform: rotateY(180deg);
  -webkit-transform-style: preserve-3d;
  transform-style: preserve-3d;
}

.container .front {
  -webkit-transform: rotateY(0deg);
  transform: rotateY(0deg);
  -webkit-transform-style: preserve-3d;
  transform-style: preserve-3d;
}

.container:hover .back {
  -webkit-transform: rotateY(0deg);
  transform: rotateY(0deg);
  -webkit-transform-style: preserve-3d;
  transform-style: preserve-3d;
}

.container:hover .front {
  -webkit-transform: rotateY(-180deg);
  transform: rotateY(-180deg);
  -webkit-transform-style: preserve-3d;
  transform-style: preserve-3d;
}

.front .inner p {
  font-size: 1rem;
  margin-bottom: 2rem;
  position: relative;
}

.front .inner p:after {
  content: "";
  width: 4rem;
  height: 2px;
  position: absolute;
  background: #c6d4df;
  display: block;
  left: 0;
  right: 0;
  margin: 0 auto;
  bottom: -0.75rem;
}

.front .inner span {
  color: rgba(255, 255, 255, 0.7);
  font-family: "Montserrat";
  font-weight: 300;
}

@media screen and (max-width: 64rem) {
  .col {
    width: calc(33.333333% - 2rem);
  }
}

@media screen and (max-width: 48rem) {
  .col {
    width: calc(50% - 2rem);
  }
}

@media screen and (max-width: 32rem) {
  .col {
    width: 100%;
    margin: 0 0 2rem 0;
  }
}
</style>
```



```vue
<template>
  <div>
    <br />
    <br />
    <br />
    <div>{{vote}}</div>
    <v-btn type="submit" @click="plus(vote)">plus</v-btn>
    <v-btn type="submit" @click="minus(vote)">minus</v-btn>

    <br />
    <br />
    <div>chat</div>
  </div>
</template>

<script>
// socket
import io from "socket.io-client";
import net from "net";

export default {
  data() {
    return { vote: 0 };
  },
  computed: {},
  created() {
    this.socket = io.connect("http://localhost:8082", {
      transports: ["websocket"]
    });
  },
  methods: {
    plus: function(data) {
      data += 1;
      console.log("plus", data);
      this.socket.emit("SEND_VOTE_SELECTED", { data });
      console.log("데이터 선택========", data);
    },
    minus: function(data) {
      data -= 1;
      console.log("minus", data);
      this.socket.emit("SEND_VOTE_SELECTED", { data });
      console.log("데이터 선택========", data);
    }
  },
  mounted() {
    //서버의 변경사항을 수신
    this.socket.on("GET_VOTE_SELECTED", data => {
      console.log('GET_VOTE_SELECTED')
      console.log(this.vote)
      this.vote = data["data"];
    });
  }
};
</script>
```



```vue
<template>
  <div class="page-container">
    <br />
    <br />
    <br />
    <br />
    <app>
      <app-toolbar class="md-primary">
        <div class="md-toolbar-row">
          <span class="md-title">My Chat App</span>
        </div>
      </app-toolbar>
      <app-content>
        <field>
          <label>Message</label>
          <br />
          <textarea
            v-model="textarea"
            disabled
            v-auto-scroll-bottom
            style="height:300px; width:300px; border: 4px dashed #bcbcbc;"
          ></textarea>
        </field>
        <field>
          <br />
          <label>Your Message</label>

          <input v-model="message" />
          <button type="submit" class="md-primary md-raised" @click="sendMessage()">Submit</button>
        </field>
      </app-content>
    </app>
  </div>
</template> 
<script>
import io from "socket.io-client";
import net from "net";

export default {
  name: "Chat",
  data() {
    return {
      textarea: "",
      message: ""
    };
  },
  created() {
    const userId = this.$session.get("userId");
    const userNickname = this.$session.get("userNickname");
    this.socket = io.connect("http://localhost:8082", {
      transports: ["websocket"]
    });
  },
  mounted() {
    this.socket.on("chat", data => {
      this.textarea += this.userNickname + ":" + data.message + "\n";
    });
  },
  // 그냥 다 왼쪽으로,
  // 아이디로 구분되므로
  methods: {
    sendMessage() {
      this.socket.emit("chat", {
        message: this.message
      });
      console.log(this.message);
      this.textarea += this.message + "\n";
      this.message = "";
    }
  }
};
</script> 
<style>
.md-app {
  height: 800px;
  border: 1px solid rgba(#000, 0.12);
}
.md-textarea {
  height: 300px;
}
</style>
```
