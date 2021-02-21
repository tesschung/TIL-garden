

## 16_200609

> 공지



## 과제













## Network API

컴퓨터와 컴퓨터끼리 어떠한 정보들을 주고받는 행위

서버와 클라이언트가 어떠한 정보를 주고받는 행위



### 소켓

컴퓨터가 연결된 통신의 끝점

소켓이 `쓴다`라는 것은 상대에게 데이터를 `전달`한다는 것

소켓이 `읽는다`라는 것은 상대가 전송한 데이터를 `수신`하는 것

자바에서 사용하는 소켓은 TCP와 UDP

웹은 TCP방식의 소켓 통신을 사용한다.



### 호스트(Host)

**호스트 주소(host name)**란 **하나의 컴퓨터에 할당된 고유 이름**으로 

인터넷 상에서 IP주소(컴퓨터고유번호)나 도메인명(dns: domain name service)을 말한다.



### 포트(Port)

**포트번호(port number)**란 한 컴퓨터에서 여러 서비스의 제공을 가능하게 함. 한 호스트에 있는 **여러개 서비스를 구분**하기 위해서 사용.

서버쪽에 지정하고, 클라이언트가 해당 포트를 지정해서 요청을 보낸다.

ex 8000, 3000, 8080, 1521 ...

**하나의 호스트**는 **여러 개의 포트**를 가질 수 있다. 서버 어플리케이션은 클라이언트의 요청을 위해 대기할 때 **미리 정해진 포트를 감시**한다. 호스트는 전화번호에 포트는 내선번호에 비교할 수 있다. 







![image-20200609094145509](images/image-20200609094145509.png)



월드 와이드 웹(**www**)은 인터넷에 연결된 컴퓨터를 통해 사람들이 정보를 공유할 수 있는 전 세계적인 정보 공간을 말한다. 간단히 웹이라 부르는 경우가 많다. 

파일 전송 프로토콜(File Transfer Protocol, **FTP**)은 TCP/IP 프로토콜을 가지고 서버와 클라이언트 사이의 파일 전송을 하기 위한 프로토콜이다.

텔넷(**Telnet**)은 인터넷이나 로컬 영역 네트워크 연결에 쓰이는 네트워크 프로토콜이다. 

![image-20200609095714705](images/image-20200609095714705.png)

이처럼 클라이언트와 서버의 socket안에 input stream/output stream이 있어서 데이터를 주고 받을 수 있다.





![image-20200609100149933](images/image-20200609100149933.png)













## InetAddress

https://docs.oracle.com/javase/8/docs/api/



new하지 않는다.

static 메소드를 이용해서 가져온다.



| `static InetAddress` | `getLocalHost()`                       |
| -------------------- | -------------------------------------- |
|                      | Returns the address of the local host. |

```java
import java.net.InetAddress;

public class InetAddreaaMain {

	public static void main(String[] args) {
		try {
			InetAddress localhost = InetAddress.getLocalHost();
			System.out.println("내 컴퓨터 IP 정보: "+ localhost);
			System.out.println(localhost.getHostName());
			System.out.println(localhost.getHostAddress());
			
			InetAddress addr = InetAddress.getByName("www.kopo.ac.kr");
			System.out.println("폴리텍 IP 정보: "+addr);
			
			InetAddress[] addrs = InetAddress.getAllByName("www.naver.com");
			
			for (InetAddress a : addrs) {
				System.out.println(a);
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
```





## URL

https://docs.oracle.com/javase/8/docs/api/

```
http://www.example.com/docs/resource1.html
http://www.example.com:1080/docs/resource1.html
```

프로토콜://호스트주소:포트/경로?쿼리

| `String` | `getHost()`Gets the host name of this `URL`, if applicable. |
| -------- | ----------------------------------------------------------- |
| `String` | `getPath()`Gets the path part of this `URL`.                |
| `int`    | `getPort()`Gets the port number of this `URL`.              |

| `int`    | `getPort()`Gets the port number of this `URL`.       |
| -------- | ---------------------------------------------------- |
| `String` | `getProtocol()`Gets the protocol name of this `URL`. |

```java
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;

public class URLMain {
	public static void main(String[] args) {
		
		
		try {
			URL urlObj = new URL("https://search.naver.com/search.naver?sm=top_hty&fbm=0&ie=utf8&query=%EA%B3%A0%EC%96%91%EC%9D%B4");
			System.out.println(urlObj.getProtocol());
			System.out.println(urlObj.getHost());
			System.out.println(urlObj.getFile());			
			System.out.println(urlObj.getPort()); // 없는 경우 -1 반환
			
			InputStream is = urlObj.openStream();
//			InputStreamReader isr = new InputStreamReader(is);
			InputStreamReader isr = new InputStreamReader(is, "utf-8");
				
		    while(true) {
		    	int c = isr.read();
		    	if(c == -1) break;
		    	System.out.print((char)c);
		    }
		    
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
	}
}
```



## URLConnection

https://docs.oracle.com/javase/8/docs/api/



![image-20200609132658095](images/image-20200609132658095.png)

연결한 URL 클래스의 자원의 속성을 알아내기 위해서 사용 ( Header 정보 )

| `int`    | `getContentLength()`Returns the value of the `content-length` header field. |
| -------- | ------------------------------------------------------------ |
| `long`   | `getContentLengthLong()`Returns the value of the `content-length` header field as a long. |
| `String` | `getContentType()`Returns the value of the `content-type` header field. |
| `long`   | `getDate()`Returns the value of the `date` header field.     |



![image-20200609141322322](images/image-20200609141322322.png)





```java
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;

public class URLConnectionMain {

	public static void main(String[] args) {
		
//		FileOutputStream fos = null;
//		OutputStreamWriter osw = null;
//		BufferedWriter bw = null;
//		try( ********여기********** ){ ********로직******}
		try (
				// JDK 7버전부터 가능
				FileOutputStream fos = new FileOutputStream("C:\\Users\\seung\\OneDrive\\바탕 화면\\tesschung.github\\HanaFinanceProgramming\\Lecture\\java-workspace\\java\\iotest\\naver.html");
				OutputStreamWriter osw = new OutputStreamWriter(fos, "utf-8");
				BufferedWriter bw = new BufferedWriter(osw);
				AAA a = new AAA();
			)
		
		{
			
//			fos = new FileOutputStream("C:\\Users\\seung\\OneDrive\\바탕 화면\\tesschung.github\\HanaFinanceProgramming\\Lecture\\java-workspace\\java\\iotest\\naver.html");
//			osw = new OutputStreamWriter(fos, "utf-8");
//			bw = new BufferedWriter(osw);
			
			URL urlObj = new URL("https://www.naver.com");
			
			
			URLConnection uc = urlObj.openConnection();
			
			// file인 경우 가져온다.
			System.out.println(uc.getContentLength());
			System.out.println(uc.getContentType());
			System.out.println(uc.getDate());
			System.out.println(uc.getLastModified());
			System.out.println(uc.getInputStream());
			
			// URLConnection 자체에서도 정보를 받아올 수 있다.
			// URL 객체의 전송정보를 iotest/naver.html에 저장
			
			
			// 1) InputStream을 가져온다.
			InputStream is = uc.getInputStream();
			
			// 2) utf-8 방식으로 가져온다.
			InputStreamReader isr = new InputStreamReader(is, "utf-8");
			
			// 3) BufferedReader으로 정보를 가져온다. (빠르게 읽도록 한다.)
			BufferedReader br = new BufferedReader(isr);
			
			// 4) 화면에 출력
			while(true) {
				
				String data = br.readLine();
				if(data == null) break;
				bw.write(data);
				bw.newLine();
				System.out.println(data);
				
			}
			
			System.out.println("naver.html을 저장하였습니다.");
			
//			FileClose.close(br);
//			FileClose.close(isr);
//			FileClose.close(is);
			bw.flush();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
//			FileClose.close(bw);
//			FileClose.close(osw);
//			FileClose.close(fos);
			
		}
	}
}

```



## ServerSocket

연결지향, 신뢰성보장, 1:1매칭 `TCP`

- packet이 손실되면 다시 요청해서 신뢰성을 보장한다. => 그럼 latency가 발생하겠지.
- stream을 사용해서 단방향 통신이다.

비연결지향, 신뢰성을 보장하지 않음, 멀티매칭가능 `UDP`

- 속도가 빠르다.
- packet들 마다 목적지가 정해져 있어서 해당 목적지에 도착하기만 해도 된다.
- 손실이 생겨도 상관없음



```
java.lang.Object
	java.net.ServerSocket
All Implemented Interfaces:
	Closeable, AutoCloseable
```



:star:`tcp socket programming`

![image-20200609141340425](images/image-20200609141340425.png)



`accept` method를 만들어두고 client가 접속하기를 계속해서 기다린다.

client가 접속하면 accept method는 return으로 Socket을 반환한다.



![image-20200609141352092](images/image-20200609141352092.png)



![image-20200609152141173](images/image-20200609152141173.png)



1. server: accept method를 가진 socket이 필요
   1. server: port를 열어서 client를 listening한다. => 여기서 port는 임의로 정해진다.

2. client: socket을 만들어둔 채로 server의 port에 맞게 요청을 보낸다.

4. server: client가 port에 요청을 하면 socket을 생성한다.

5. client - server: 그리고 접속하는 순간 client와 server간에 stream이 생성된다.

6. 그러고 나서 input/output 가능





## Socket

![image-20200609160907173](images/image-20200609160907173.png)







![image-20200609145729276](images/image-20200609145729276.png)





![image-20200609145741365](images/image-20200609145741365.png)



















## 동작방식



![image-20200609145826503](images/image-20200609145826503.png)









## EchoServer 1:N



여러개의 client -> server







```java
package kr.ac.kopo.day19.echoServer;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;

import kr.ac.kopo.day18.project.echoServer.EchoServer;

/**
 * 1:N
 * 서버가 종료될 일은 없다. 
 * @author seung
 *
 */

class EchoThread extends Thread {

	private Socket socket;
	
	public EchoThread(Socket socket) {
		this.socket = socket;
	}
	
	@Override
	public void run() {
		// 어떤 소켓이 어떤 소켓과 관계되어있는지 알아야 한다.
		InetAddress client = socket.getInetAddress();
		System.out.println("클라이언트 [ "+client+" ]님이 접속하셨습니다.");
		
		try (
				InputStream is = socket.getInputStream();
				InputStreamReader isr = new InputStreamReader(is);
				BufferedReader br = new BufferedReader(isr);
				
				OutputStream os = socket.getOutputStream();
				OutputStreamWriter osw = new OutputStreamWriter(os);
				PrintWriter pw = new PrintWriter(osw); // socket에 전달
		)
		{
			while(true) {
				String msg = br.readLine();
				if (msg == null) {
					System.out.println("["+client+"] 접속을 종료합니다.");
					socket.close();
					break;
				}
				System.out.println(client + " 클라이언트에서 보낸 메세지: [ " + msg+ " ]");
				
				pw.println(msg);
				pw.flush();
			}
		
		} catch (IOException e) {
			
			e.printStackTrace();
		}
		
	}
	
}


public class EchoThreadServerMain {

	public static void main(String[] args) {
		
		System.out.println("EchoServer 구동");
		try {
			ServerSocket server = new ServerSocket(10001);
			while(true) {
				// 클라이언트의 접속을  기다린다.
				Socket socketClient = server.accept();
				// 소켓통신을 각각의 thread형식으로 진행
				System.out.println(socketClient);
				
				EchoThread echoServer = new EchoThread(socketClient);
				echoServer.start();
				
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
}

```



```java
package kr.ac.kopo.day19.echoServer;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.Scanner;

/*
 	java EchoClientMain 172.16.88.129 10001
 */

public class EchoClientMain {

	public static void main(String[] args) {
		
		if(args.length != 2) {
			System.out.println("------------------------");
			System.out.println("사용법 : java EchoServerMain 서버ip 접속port번호");
			System.out.println("------------------------");
			System.exit(0);
		}
		
		String serverIp = args[0];
		int portNo = Integer.parseInt(args[1]);
		
		try {
			System.out.println("2) 서버에 접속합니다.");
			
			Socket socket = new Socket(serverIp, portNo);
			System.out.println("4) 서버에 접속 완료했습니다.");
			
			// 서버에 전송할 메세지를 키보드로 입력하는 객체 필요
			BufferedReader keyboard 
								= new BufferedReader(new InputStreamReader(System.in));

			// 키보드로 입력받은 메세지를 서버에 전송할 객체
			OutputStream os = socket.getOutputStream();
			OutputStreamWriter osw = new OutputStreamWriter(os); // filter
			PrintWriter pw = new PrintWriter(osw);
			
			// 서버에서 보내준 메세지를 수신할 객체
			InputStream is = socket.getInputStream(); // is를 가져온다.
			InputStreamReader isr = new InputStreamReader(is, "UTF-8");	 // utf-8로 변환해준다.
			BufferedReader br = new BufferedReader(isr); // 빠르게 받아오도록 filter 한다.
			
			
			while (true) {
				System.out.println("전송할 메세지를 입력하세요. (q) 입력시 종료 : ");
				String msg = keyboard.readLine();
				
				if(msg.equalsIgnoreCase("q")) { // 대소문자상관x
					System.out.println("서버와의 접속 종료");
					socket.close(); // 종료
					break;
				}
				
				pw.println(msg);
				pw.flush();
				
				String echoMsg = br.readLine();
				System.out.println("서버에서 재전송한 메세지 : [ " +echoMsg+" ]");
				
			}
			
			
		} catch (UnknownHostException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
}

```





## UDP

- [DatagramChannel](https://docs.oracle.com/javase/8/docs/api/java/nio/channels/DatagramChannel.html)
- [DatagramPacket](https://docs.oracle.com/javase/8/docs/api/java/net/DatagramPacket.html)
- [DatagramSocket](https://docs.oracle.com/javase/8/docs/api/java/net/DatagramSocket.html)
- [DatagramSocketImpl](https://docs.oracle.com/javase/8/docs/api/java/net/DatagramSocketImpl.html)
- [*DatagramSocketImplFactory*](https://docs.oracle.com/javase/8/docs/api/java/net/DatagramSocketImplFactory.html)



비연결 지향 통신 방식

서버와 클라이언트라는 개념이 모호하다.

데이터를 받을수도, 보낼수도 있다.

실제 통로가 구성되어있지 않고 packet단위로 전송되는 것











