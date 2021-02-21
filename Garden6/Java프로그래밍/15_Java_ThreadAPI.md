

## 15_200628

> 공지









## Thread API

**1) Thread**

**`메모리를 할당받아 실행 중인 프로그램`을 프로세스라고 합니다.**

**프로세스 내의 명령어 블록으로 시작점과 종료점을 가진다.**

**실행중에 멈출 수 있으며 동시에 수행 가능하다.** -> :star:동시성

**어떠한 프로그램내에서 특히 프로세스 내에서 실행되는 흐름의 단위.**

`스레드(thread)`는 `어떠한 프로그램 내에서, 특히 프로세스 내에서 실행되는 흐름의 단위`를 말한다. 일반적으로 한 프로그램은 하나의 스레드를 가지고 있지만, 프로그램 환경에 따라 둘 이상의 스레드를 동시에 실행할 수 있다. 이러한 실행 방식을 **멀티스레드(multithread)**라고 한다.

`작업단위`



###  멀티스레드

`동시성`

하나의 프로그램에서 **여러개의 작업(thread)**을 실행하기 위해서 

동시에 공유 자원들을 이용할때 생기는 문제가 있다.

그래서 이러한 문제를 해결하기 위한 기술인 **동기화**를 이용한다.



**2) Process**

**프로세스(process)**는 **컴퓨터에서 연속적으로 실행되고 있는 컴퓨터 프로그램**을 말한다. 종종 스케줄링의 대상이 되는 작업(task)이라는 용어와 거의 같은 의미로 쓰인다. 여러 개의 프로세서를 사용하는 것을 멀티프로세싱이라고 하며 같은 시간에 여러 개의 프로그램을 띄우는 시분할 방식을 멀티태스킹이라고 한다. 프로세스 관리는 운영 체제의 중요한 부분이 되었다.



**3) Process Vs Thread** 

**멀티프로세스**와 **멀티스레드**는 양쪽 모두 여러 흐름이 동시에 진행된다는 공통점을 가지고 있다. 하지만 멀티프로세스에서 각 프로세스는 독립적으로 실행되며 각각 별개의 메모리를 차지하고 있는 것과 달리 멀티스레드는 프로세스 내의 메모리를 공유해 사용할 수 있다. 또한 프로세스 간의 전환 속도보다 스레드 간의 전환 속도가 빠르다.

멀티스레드의 다른 장점은 CPU가 여러 개일 경우에 각각의 CPU가 스레드 하나씩을 담당하는 방법으로 속도를 높일 수 있다는 것이다. 이러한 시스템에서는 여러 스레드가 실제 시간상으로 동시에 수행될 수 있기 때문이다.

멀티스레드의 단점에는 각각의 스레드 중 어떤 것이 먼저 실행될지 그 순서를 알 수 없다는 것이 있다.



**4) Multi Tasking**

전산학 분야에서 멀티태스킹(multitasking) 또는 다중작업(이하 멀티태스킹)은 다수의 작업(혹은 프로세스, 이하 태스크)이 중앙 처리 장치(이하 CPU)와 같은 공용자원을 나누어 사용하는 것을 말한다. 엄밀히 말해 한 개의 CPU를 가진 개인용 컴퓨터가 특정 순간에 수행할 수 있는 태스크의 개수는 하나뿐이다. 따라서 멀티태스킹은 스케줄링이라는 방식을 사용하여 컴퓨터 사용자에게 병렬 연산이 이루어지는 것과 같은 환경을 제공한다. 스케줄링 방식은 CPU 사용시간을 일정한 기준에 따라 나누어 각 태스크가 사용할 수 있도록 분배한다. 분배받은 시간동안 태스크가 CPU를 사용할 때 다른 태스크들은 자신의 차례가 오기를 기다린다. 분배받은 시간이 종료되어 태스크가 사용하던 CPU를 다른 태스크가 사용할 수 있도록 재배정하는 것을 문맥교환이라 하는데 스케줄링에서 이 문맥교환이 충분히 자주 발생하게 되면 컴퓨터 사용자는 병렬 연산이 이루어진 것처럼 느끼게 된다.



### 컨텍스트스위칭(Context Switching)

`문맥교환`

멀티프로세스 환경에서 CPU가 어떤 하나의 프로세스를 실행하고 있는 상태에서 인터럽트 요청에 의해 다음 우선 순위의 프로세스가 실행되어야 할 때 기존의 프로세스의 상태 또는 레지스터 값(Context)을 저장하고 CPU가 다음 프로세스를 수행하도록 새로운 프로세스의 상태 또는 레지스터 값(Context)를 **교체하는 작업**

ready -> run -> runnable (동시에 작업하려는 runnable들이 들어있음)

여기서 JVM이 runnable에 queue상태에 들어있는 것들을 실행시켜준다.



### 컨텍스트

OS에서 **Context는 CPU가 해당 프로세스를 실행하기 위한 해당 프로세스의 정보들이다.**

이 **Context는 프로세스의 PCB(Process Control Block)에 저장**된다.



![image-20200608094422407](images/image-20200608094422407.png)





sleep()

join()

wait()

synchronized()

notify()

yield()





![image-20200608095845989](images/image-20200608095845989.png)

runnable instance를 받는 thread 존재.

```java
Thread t1 = new Thread();
Thread t2 = new Thread("threadName");
Thread t3 = new Thread(r);
```



![image-20200608100429274](images/image-20200608100429274.png)





```java
// Thread를 상속 받는다.
class AAA extends Thread {

	// source 에서 override 선택
	@Override
	public void run() {
		while(true) {
			System.out.println("go!!!");
		}
	}

}

class BBB extends Thread {

	@Override
	public void run() {
		while(true) {
			System.out.println("stop!!!");
		}
	}
	
}

public class ThreadMain01 {
	public static void main(String[] args) {
		System.out.println("hi");
//		Thread t = new Thread();
		
		// ready 상태
		AAA aaa = new AAA();
		BBB bbb = new BBB();
		
		aaa.start();
		bbb.start(); // stop이 보인다.
		
		aaa.run();
		bbb.run(); // stop이 보이지 않는다. // 실행 될 수 없다. 동시성의 개념을 갖지 않는다.
		
	}
}
```



runnable은 쓰레드의 상태

쓰레드는 실행하는 순서



runnable에 있는게 run이 되어야 쓰레드가 시작



![image-20200608104203843](images/image-20200608104203843.png)



```java
/*
 * Thread 생성하는 2가지 방식
 * 1. Thread 클래스 상속
 * 2. Runnable 인터페이스 상속
 */

class ExtendThread extends Thread {

	@Override
	public void run() {
		
		for(int i = 1; i <= 100; i++) {
			System.out.println(i + "번째 인형 눈 붙이기");
		}
	}
	
}

// Runnable을 상속받으면 반드시 run()을 오버라이드 해야한다.
class ImplementThread implements Runnable {

	@Override
	public void run() {
		for(int i = 1; i <= 100; i++) {
			System.out.println(i + "번째 인형 입 만들기");
		}
	}
	
}

public class ThreadMain02 {

	public static void main(String[] args) {
		System.out.println("현재 실행중인 스레드 개수: " + Thread.activeCount());
		// thread를 생성하지 않았음에도 1개가 나온다.
		// JVM은 main이 실행되는 것 자체가 thread이기 때문이다.
		
		ExtendThread et = new ExtendThread();
		ImplementThread it = new ImplementThread();
		Thread t = new Thread(it);
		
		// start를 하는 순간 thread queue에 들어가는데 누가 먼저 시작할 지 모르는 상태가 된다.
		et.start(); // thread 클래스를 상속받은 et를 runnable 상태로 만들기 위해서는 start가 필요
		t.start();
		
		System.out.println("현재 실행중인 스레드 개수: " + Thread.activeCount());
		// 3개가 나온다. -> main thread도 et, t와 경쟁을 하는 것
		
		// 모든 작업이 끝났을때 작업 종료를 print하려고 하는 경우
		try {
			et.join();
			t.join();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		System.out.println("인형 작업 종료..");
			

		for(int i = 1; i <= 100; i++) {
			System.out.println(i + "번째 감독중");
		}
		
		// main안에 있다고 해서 thread가 서로 종속적인 형태는 아니다!
	}
}
```



**#### run()과 start()의 차이**

\- `run()메소드`는 단순히 클래스에 오버라이딩 된 메소드를 호출해서 사용하는 것으로 생각하면 쉽다. 

\- `start()메소드`는 새로운 쓰레드가 작업을 실행하는데 필요한 호출스택(공간)을 생성한 다음 run()을 호출해서 그 안(스택)에 run()이 저장되는 것이다. 즉, 쓰레드를 사용하기 위해 start()를 실행시키는 순간 쓰레드만의 독립적인 작업 공간인 호출스택이 만들어지는 것이다. 그 후에 호출 스택안에 각 실행하고자 하는 예를 들면 run()과 같은 메소드들이 저장되는 것이다. 호출 스택에 있는 내용들이 모두 수행하고 나면 쓰레드는 호출스택 공간과 함께 메모리 상에서 소멸된다.



**#### Thread 의 우선순위(Proiority)**

\- Thread가 가질 수 있는 우선순위의 범위는 1 ~ 10 이며, 숫자가 높을수록 우선순위가 높다.

\- 우선순위라는 속성(멤버변수)을 가지고 있는데, 이 우선순위의 값에 따라 Thread가 얻는 실행시간이 달라진다.

\- 수행하는 작업의 중요도에 따라 Thread의 우선순위를 서로 다르게 지정하여 특정 Thread가 더 많은 작업시간을 갖도록 할 수 있다.

\- Thread의 우선순위는 Thread를 생성한 Thread로부터 상속받는다.



출처: https://postitforhooney.tistory.com/entry/JavaThread-Java-Thread-Pool을-이용한-Thread를-이해하기Thread-Runnable [PostIT]



## Thread 우선순위

![image-20200608112533964](images/image-20200608112533964.png)





```java

package kr.ac.kopo.day17.thread;


class PriorityThread extends Thread {
	
	public PriorityThread() {
		super();
	}

	public PriorityThread(String name) {
		super(name);
	}
	
	@Override
	public void run() {
		System.out.println(getName()+" 우선순위 : "+ getPriority());
		for (int i = 1; i <= 100; i++) {
			System.out.println(getName()+" 우선순위: "+getPriority()+"인 스레드: "+ i+"번째 작업중");
		}
	}
	
}

public class PriorityMain {
	public static void main(String[] args) {
		PriorityThread pt = new PriorityThread("우선순위 5인 스레드");
		PriorityThread pt2 = new PriorityThread("우선순위 10인 스레드");
		PriorityThread pt3 = new PriorityThread("우선순위 5인 스레드");
		
		// 기본적으로 thread를 만들면 thread는 5를 가지고 있다.
		// 우선순위가 1인 thread로 만들고 싶다면?

//		pt.setPriority(1);
		pt.setPriority(Thread.MIN_PRIORITY);
		pt2.setPriority(Thread.MAX_PRIORITY);
		pt3.setPriority(Thread.NORM_PRIORITY);
		
		pt.start();
		pt2.start();
		pt3.start();
		
		// 확률적으로 우선순위 높은 애가 실행 될 수 있다는 것이지 보장한다는 의미는 아니다.
		
	}
}

```





## Thread 상태

![image-20200608102116287](images/image-20200608102116287.png)



block 형태에 빠지는 경우에는 `os에 실행권한을 넘겨주고` 잠시 `대기상태`가 되는 것

`sleep()` - 작업권한을 **주고** 멈춤 -> 그래서 이걸 더 많이 씀

`pause()` - 작업권한을 갖고 멈춤



`join()` - 스레드와 스레드의 관계 설정, join한 것이 먼저 끝나야 다음 스레드를 runnable 상태로 차례에 맞게 선점할 수 있게 해준다.





## Thread 동기화

\- **NEW** : 쓰레드가 생성되고 아직 START()가 호출되지 않은 상태 -> **READY**

\- **RUNNABLE** : 실행 중 또는 실행 가능 상태

\- **BLOCKED** : 동기화 블럭에 의해 일시정지 상태

\- WAITING : 작업이 종료되지는 않았지만 실행 불가(unrunnalbe) 일시정지 상태

\- TIMED_WAITING : 일시정지 시간이 지정된 경우

\- TERMINATED : 쓰레드의 작업이 종료된 상태



![image-20200608141021057](images/image-20200608141021057.png)



공유 자원을 건드릴때 동기화가 필요해진다.



## synchronized

1. **synchronized 함수를 만들어 사용한다.**

2. **synchronized block을 사용한다.**

`synchronized`

- 메소드 정의시 활용 제한자에 붙일 수 있다.



```java
// **synchronized 함수를 만들어 사용한다.**
public synchronized void sum() {
    for (int i = 0 ; i < 10000; i ++) {
        count++;
    }
}

// **synchronized block을 사용한다.**
public  void a() {
    System.out.println("hello");
    // 공유 객체가 Sync 이므로 this로 가르킨다.
    synchronized (this) {
        for(int i = 0; i < 10; i ++) {
            System.out.print('a');
        }
    }
    System.out.println("goodbye");
}
```

```java

class Data {
	
	// 동기화를 반드시 걸어줘야 한다.
	// 공유 영역 접근 제한
	public synchronized void a() {
		
		try {
			notify();
			System.out.println("a() 메소드 호출");	
			wait(); // a를 찍으면 block으로 가서 thread queue에 있는 b가 찍힌다.
			// 그래서 번갈아가면서 찍히게 된다.
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	
	public synchronized void b() {
		try {
			notify();
			System.out.println("b() 메소드 호출");	
			wait();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
}


class NotifyThread01 extends Thread {

	private Data data;
	
	public NotifyThread01(Data data) {
		this.data = data;
	}
	
	@Override
	public void run() {
		for ( int i = 0; i < 10; i++) {
			data.a();
		}
	}
}

class NotifyThread02 extends Thread {

	private Data data;
	
	public NotifyThread02(Data data) {
		this.data = data;
	}
	
	@Override
	public void run() {
		for ( int i = 0; i < 10; i++) {
			data.b();
		}
	}
}


public class NotifyMain {
	public static void main(String[] args) {
		Data data = new Data();
		
		NotifyThread01 nt01 = new NotifyThread01(data);
		NotifyThread02 nt02 = new NotifyThread02(data);
		
		nt01.start();
		nt02.start();
		
	}
}

```



| wait      | 갖고 있던 고유 락을 해제하고, 스레드를 잠들게 한다. -> block 상태로 변경 | 호출하는 스레드가 반드시 고유 락을 갖고 있어야 한다. 다시 말해, `synchronized` 블록 내에서 호출되어야 한다. |
| --------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| notify    | 잠들어 있던 스레드 중 임의로 하나를 골라 깨운다. -> runnable 상태로 변경 | 상동                                                         |
| notifyAll | 호출로 잠들어 있던 스레드 **모두 깨운다**. -> runnable 상태로 변경 | 상동                                                         |



BLOCK으로 보내는 제약조건: 

`sleep()` 

`pause()` 

`wait() - 아무조건 없이 스레드에서 빠져나오는 것` 

`synchronized()`

`join() - 해당 thread를 제외하고 다른 thread를 block으로` 

그러면 `lock`을 얻은 `thread`만 실행된다.



BLOCK에서 빠져나오는 방법:

`start()` 

`run()` 

`notify()` 

`notifyAll()`









