

## 04_200408



## 참고

0408 수업

블로그 https://keep-cool.tistory.com/15

자바공식문서 https://docs.oracle.com/javase/8/docs/api/

![image-20200408160031047](04_Java_200408.assets/image-20200408160031047.png)



/** 이렇게 작성하면 도큐먼트 주석이 생성된다

/**

*

*/ 이런식으로 생성됨

`project` -> `Generate Javadoc`로 도큐멘트 주석 단 부분이 정리되어 html으로 나타난다.



## 수업 진행 계획

자바

데이터베이스 sql jdbc

웹 html css javascript jquery

프론트앤드 ecmascript, typescript, react, angualr

백앤드 servlet, jsp, ajax

스프링 sprint, mybatis, hibernate 



앞으로 이런식으로 코드관리가 이뤄질 것

![image-20200408101525589](04_Java_200408.assets/image-20200408101525589.png)



## 자바언어

메모리관리(Garbage Collection)

객체지향적(Object-Oriented)

컴파일+인터프리터: OS 독립적

---

명령어 해석기인 컴파일러와 인터프리터 모두 컴퓨터는 2진수로 이뤄져 있다. 우리 혹은 컴퓨터가 서로를 이해할 수 있도록 통역한다는 점에서 같다.

> 컴파일러란?

특정 프로그래밍 언어로 쓰여 있는 문서를 다른 프로그래밍 언어로 옮기는 프로그램을 말한다. 

**전체소스코드를 보고 명령어를 수집하고 재구성**

> 인터프리터란?

프로그래밍 언어의 소스 코드를 바로 실행하는 컴퓨터 프로그램 또는 환경을 말한다. 

**소스코드의 각 행을 연속적으로 분석하며 실행**

---

![image-20200408102808134](04_Java_200408.assets/image-20200408102808134.png)



*컴파일하기 => Hello.class (bytecode) 형식으로 변환*

```cmd
javac Hello.java
```

*그러고 나면 이렇게 명령어로 Hello.class 실행 가능*

```cmd
java Hello
```





`JVM` Java Virtual Machine == interprete

public static void main(String[] args) { } // method 

![image-20200408104348830](04_Java_200408.assets/image-20200408104348830.png)

위 처럼 쓸 수 있지만, 권장되지는 않는다.





## 출력문

![image-20200408104444668](04_Java_200408.assets/image-20200408104444668.png)



## *println 

- **line feed**(\n, 개행문자) && **carriage return**를 가지고있다.

```java
System.out.println("abc");
System.out.println("123");
/*
abc
123
*/

System.out.print("abc");
System.out.println("123");
/*
abc123
*/

// 그래서 아래의 출력은 같다.
System.out.print("abc\n");
System.out.println("abc");
/*
abc
abc
*/
```



**''** 따움표: 문자(Character)

**""** 쌍따움표: 문자열(String)



## *printf (formating 하기)

*printf를 사용하면 입출력이 더 빠르다.



> 기본타입은? (논리값까지 포함하면 5가지이다.)

1. **문자**(**char**) 'ㅁ', '!'
2. **문자열**(**string**) "hello"
3. **정수**(byte short **int** long) 3, 12
4. **실수**(float, **double**) 0.1, 12.3
5. **논리값**(**boolean**) true false



자바의 기본형: char, string, int, double, boolean



%d

%f

%c

%s



```java
System.out.printf("%d %s", 10, "ABC");
/*
10  ABC
*/
```



## 실습

`control` + `n` 새로운 파일 생성

`control` + `m` 전체화면 전환

`control` + `f11` 실행



package를 생성해서 클래스명이 같아도 다른것으로 인식 할 수 있도록 한다.

`kr`.`co`.`hana`



**Hello**.java

class **Hello** {

// 클래스명은 코드 내에서 동일해야하고, 반드시 대문자+카멜표기법 이여야한다.

}



**HelloMain**.java

class **HelloMain** {

// Main을 포함한다면, 명시해줘야 한다.

// 45자 이내로 표현할 수 있다면 절대 축약하지 않는다.

}





## **\t** 과 중간 숫자 삽입

tab을 해준다. 일정한 간격으로 띄워져서 출력된다.

```java
System.out.printf("%d\t%s\n", 10 ,"Hello");
System.out.printf("%d\t%s\n", 10 ,"ABC");
System.out.printf("%d\t%s\n", 10 ,"NEW");

/*
10	Hello
10	ABC
10	NEW
*/
```

만약 tab(8자)를 넘어선다면?

```java
10	Hello
10	ABC
10	NEW
10029232	NEW
```

이런식으로 넘어가게되는 것을 볼 수 있다.



*그래서 해당 데이터가 들어갈 자리에 칸을 지정해주는 방식을 사용할 수 있다. 

> 숫자 오른쪽 정렬

```java
System.out.printf("%10d %s\n", 10 ,"Hello");
System.out.printf("%10d %s\n", 10 ,"ABC");
System.out.printf("%10d %s\n", 10 ,"NEW");
System.out.printf("%10d %s\n", 10029232 ,"NEW");

/*
        10 Hello
        10 ABC
        10 NEW
  10029232 NEW
*/
```



>  마이너스(-)숫자 왼쪽 정렬

```java
System.out.printf("%-10d %s\n", 10 ,"Hello");
System.out.printf("%-10d %s\n", 10 ,"ABC");
System.out.printf("%-10d %s\n", 10 ,"NEW");
System.out.printf("%-10d %s\n", 10029232 ,"NEW");

/*
10         Hello
10         ABC
10         NEW
10029232   NEW
*/
```



## %f 

*기본으로 소수점 `8자리`까지 찍는데,

- `%.3f`로 하면 `3자리`까지만 찍는다.

```java
System.out.printf("%-10.0f %s\n", 10.929232 ,"NEW");

/*
11         NEW
*/
```

*무조건 `절사`가 되게 하고싶으면,

- `-0.05`를 뺀다.

```java
System.out.printf("%-10.1f %s\n", 12.43 - 0.05 ,"NEW");
System.out.printf("%-10.1f %s\n", 12.46 - 0.05 ,"NEW");
/*
12.4       NEW
12.4       NEW
*/
```



## 입출력 주의사항

문자와 문자를 더하면 **숫자**가 나온다. 왜냐하면 컴퓨터는 문자를 숫자라고 인식하기 때문이다.

```java
System.out.println('A'+'B');

/*
131
*/

System.out.println(65 +'B');

/*
131
*/
```

---

유니코드 '\u0041'

```java
System.out.println('\u0041');
// A
```

아스키코드 65

문자 'A'







## 클래스의 구조

![image-20200408141309507](04_Java_200408.assets/image-20200408141309507.png)



![image-20200408141755340](04_Java_200408.assets/image-20200408141755340.png)





## 식별자

![image-20200408141913934](04_Java_200408.assets/image-20200408141913934.png)



![image-20200408143218652](04_Java_200408.assets/image-20200408143218652.png)





## 변수

![image-20200408143836083](04_Java_200408.assets/image-20200408143836083.png)

![image-20200408144925416](04_Java_200408.assets/image-20200408144925416.png)

## 자료형

![image-20200408144311104](04_Java_200408.assets/image-20200408144311104.png)



`기본 자료형` 소문자로 시작

`참조 자료형` 대문자로 시작



![image-20200408145009328](04_Java_200408.assets/image-20200408145009328.png)

![image-20200408145720714](04_Java_200408.assets/image-20200408145720714.png)



## :star:형변환:star:

기본 자료형에서의 형변환

![image-20200408150103220](04_Java_200408.assets/image-20200408150103220.png)



> byte(1) < short(2)/char(2) < int(4) < long(8) < float(4) < double(8)



> 묵시적 형변환

```java
char charValue = 'A';
int intValue = charValue; // 65 묵시적변환되어 저장
```



> 명시적 형변환

![image-20200408152824422](04_Java_200408.assets/image-20200408152824422.png)

`77` 출력

(char) 77 => 'M'



> 에러 발생하는 경우

```java
char a = 'A';
short shortValue = a; 
System.out.println(shortValue); // error
```

같은 byte의 경우에도 명시적 형변환을 해야한다. 즉, 묵시적 형변환은 byte가 **큰** 경우에만 가능하다.

```java
short shortValue = (short) a; 
System.out.println(shortValue); // 65
```





![image-20200408153054844](04_Java_200408.assets/image-20200408153054844.png)

## 변수, 상수, 자료형

![image-20200408153029256](04_Java_200408.assets/image-20200408153029256.png)



![image-20200408154403219](04_Java_200408.assets/image-20200408154403219.png)



## Scanner


```java
java.util.Scanner sc = new java.util.Scanner(System.in);
```

`short-cut`
```java
import java.util.Scanner;
.
.
.
Scanner sc = new Scanner(System.in);

int num = sc.nextInt(); // 정수
```

`문자열 입력받아 출력하기`

```java
String st = sc.nextLine();
System.out.println(st);

/*
입력: 안녕하세요 선생님
출력: 안녕하세요 선생님
*/

String stn = sc.next();
System.out.println(stn);

/*
입력: 안녕하세요 선생님
출력: 안녕하세요
*/
```



## Buffer 이해

Scanner은 Buffer를 사용하기 때문에,

```java
Scanner sc = new Scanner(System.in);
int num = sc.nextInt(); // 여기서 1 2를 입력하면
int num1 = sc.nextInt();
System.out.println(num+ " "+num1); // 1 2가 출력된다. Buffer때문이다.
```

 

이러한 문제를 해결하기 위해서

> 방식1:

```java
Scanner sc = new Scanner(System.in);
int num = sc.nextInt(); // 1 2 입력
sc.nextLine();
int num1 = sc.nextInt(); // 3 4 입력
sc.nextLine();
System.out.println(num+ " "+num1); // 1 3가 출력된다.
```



> 방식2: 더 많이 쓰이는 방법

```java
int num2 = Integer.parseInt(sc.nextLine());
// 이런식으로 쓰면 위 처럼 긴 코드를 할 필요 없어진다.
```



## Random

```java
Random r = new Random();

int num = r.nextInt(); // 임의의 정수(음수&양수) 추출
System.out.println(num);

int num1 = r.nextInt(10); // 0~9사이의 난수(양수) 추출
System.out.println(num1);

int num2 = r.nextInt(10)+1; // 1(0+1)~10(9+1)사이의 난수(양수) 추출
System.out.println(num2);
```

