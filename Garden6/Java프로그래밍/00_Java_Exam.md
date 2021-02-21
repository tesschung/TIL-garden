[toc]







### 접근제한자

**`public`** - **모든 접근**을 허용

**`protected`** - **같은 패키지(폴더)**에 있는 **객체**와 **상속관계의 객체**들만 허용

**`default`** - **같은 패키지(폴더)**에 있는 **객체**들만 허용, 접근제어자를 지정하지 않았다면 자동으로 default로 지정된다.

**`private`** - **현재 객체 내에서만 허용**



| 접근 제한 | 적용 대상                    | 접근할 수 없는 클래스                          |
| --------- | ---------------------------- | ---------------------------------------------- |
| public    | 클래스, 필드, 생성자, 메소드 | 없음                                           |
| protected | 필드, 생성자, 메소드         | 자식 클래스가 아닌 다른 패키지에 소속된 클래스 |
| default   | 클래스, 필드, 생성자, 메소드 | 다른 패키지에 소속된 클래스                    |
| private   | 필드, 생성자, 메소드         | 모든 외부 클래스                               |



![img](images/img.png)

![img](images/img-1589103622849.png)



### 객체 형변환

`정의`

**'=' 연산자**를 기준으로 **좌변과 우변의 데이터 타입이 다른 경우**에 발생

다형성을 위해서 형변환을 한다. 여기서 다형성이란 **같은 타입이지만 실행 결과가 다양한 객체를 이용할 수 있는 성질**을 말한다.

서로 **상속관계**일때 형변환이 가능하다.



`조건`
좌변과 우변의 데이터타입은 상속관계여야한다.



`종류`

**묵시적 형변환**

상위(부모) 클래스 타입 = 하위(자식) 클래스 타입



:star::star:

부모 타입으로 자동 타입 변환된 이후에는 **`부모 클래스에 선언된 필드와 메소드만 접근`이 가능하다.**

**형변환된 상위 클래스 변수가 사용 할 수 있는 범위는 자신 클래스에 정의된 변수와 메소드만 사용 가능**

단, 상위 클래스의 메소드를 하위클래스에서 **오버라이딩(재정의) 했을 경우 하위클래스에 선언된 메소드가 호출**

![image-20200423164217957](images/image-20200423164217957.png)





**명시적 형변환** 

하위클래스 타입 = (하위클래스타입) 상위 클래스 타입

실제 메모리는 자식이 더 크기때문에 상위 클래스 타입 자리에 올 수 있는 객체는 실제 가리키는 메모리가 하위 클래스 타입 이어야 가능

**자식타입이 부모타입으로 묵시적형변환(자동 변환)한 후,**

**다시 자식타입으로 변환할때만 강제 타입 변환을 사용할 수 있다.**

```java
Parent p = new Child01(); // 이렇게 공간을 만들어주고
Child01 c = (Child01) p; // 명시적 형변환을 해야 한다.
// Child01 c = (Child01) new Parent(); 
// 명시적 형변환, 오류 발생
c.print();
```





### 생성자

1. **클래스 명과 이름이 동일**하다.
2. **반환 타입이 없다.**
3. **디폴트생성자가 존재**한다.
4. **오버로딩**을 지원한다.
   1. 클래스명과 이름이 동일해야하고,
   2. 매개변수 타입 혹은 개수가 달라야 한다.
5. 객체 생성시 **속성의 초기화를 담당**한다.
6. `this`를 활용하여 효율적으로 생성자를 만들 수 있다. 하지만 **static영역에서는 this 사용이 불가능**.
   1. 오버로딩한 생성자를 호출할 경우 this를 이용해서 호출할 수 있다. 그래서 super과 this는 동시에 사용할 수 없다. 그래서 super 사용자가 생략되어있다.



### 오버로딩

**메서드 이름**이 같아야 한다 
**매개변수의 개수 또는 타입**이 달라야 한다 
매개변수는 같고 리턴타입이 다른 경우는 오버로딩이 성립되지 않는다 

> 리턴타입이 다르고, 매개변수가 다르면 괜찮다.

리턴타입은 오버로딩을 구현하는데 아무런 영향을 주지 못한다 



### 추상





### 상속









### static 

static 멤버변수, 메소드에 붙일 수 있다.

static과 non-static 차이점



**`로딩 시점`**

static : 프로그램을 실행하는 순간/ 클래스 인식할때 로딩한다.

non-static: 객체 생성시



**`메모리 할당`**

static:

클래스당 하나씩 만들어진다.

`클래스명.메소드명`, `클래스명.필드명` 이렇게 접근한다.

non-static:

인스턴스 객체당 하나



**`문법적차이`**

static:

클래스 이름으로 접근

non-static: 

객체 생성 후 접근



**`사용상의 차이`**

static 메소드 안에서는 static method나 non-static method를 사용할 수 없다. 왜냐하면 가장 빠르게 실행되기 때문이다.

non-static 메소드에서는 static 영역에 대한 접근이 가능하다.





### 메인메소드

```java
public static void main(String[] args) {}
```



### 출력문

print

printIn

printf



### 클래스의 구조

클래스 선언부: 주석문, 패키지, 임포트, 클래스 선언

클래스 내용부: 멤버변수, 메소드, 내부클래스



Iterator hasNext



---

자바시험 5월 22일

이론시험 + 코딩시험 나올 수 있음
범위 : I / O까지 -> 메소드는 외우지 말것



**25문제 이상**

코딩시험

:star: exception 중요 : 문법적인 에러 찾는 문제, 바로 에러 나오는거

객관식 10개

단답식 12개

[과제한거 내에서 나옴!!!!!] 코드 끄적거리는거 -손코딩(몇십줄쓰는건아님) 4개

- 짧게 쓰는거
- 빈칸채우기

서술형 간단 정리 1개

:star: list/map 기본 메소드 외우기

오류 찾는 문제 문법 중요 -> 오류고치는 코드

-> :star: 오류 왜 났는지 이유를 쓸 것

낚시 조심(큰 흐름을 봤을때)



다큐먼트 api 관련 문제

컬랙션 제외하고 - > 이건 외워야 한다.







이거에 대한 실행결과는?

이러이런 프로그램을 작성하려는데 여기에 들어갈 코드를 쓰시오?







**인터페이스/추상클래스 생성**

**인터페이스/추상클래스 상속**

**명시적 형변환**

교재안보고 직접 손으로 쓰면서 코딩



예외처리



![image-20200516223426165](images/image-20200516223426165.png)

















### 이전 과제













day02.project.project01.java

```java
package kr.ac.kopo.day02.project;

/**
 * 
 * @author tess
 *  영문자 모음의 아스키 코드 값을 아래의 출력형식에 맞추어 화면에 출력하는 클래스 
  	A = 65
	E = 69
	I = 73
	O = 79
	U = 85
	
 */
public class Project01 {
	public static void main(String[] args) {
		char[] charArray = {'A', 'E', 'I', 'O', 'U'}; // 아스키 코드 값으로 변환할 char타입을 가진 char배열 선언 
		for(char alphabet : charArray) { // 하나씩 순환 
			System.out.printf("%c = %d\n", alphabet, (int) alphabet); // char타입을 int타입으로 명시적 형변환하여 출력 
		}
	}
```





day02.project.project02.java

```java
package kr.ac.kopo.day02.project;

import java.util.Scanner;
/**
 * 
 * @author tess
 * 3661초가 몇 시간 몇 분 몇 초인지 환산해서 출력하는 클래스 
 */
public class Project02 {
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in); // 입력을 받는다. 
		System.out.print("초를 입력하세요 : ");
		int input = sc.nextInt();
		
		String hours = String.valueOf((input/60)/60)+"시간";
		String minutes = String.valueOf((input/60)%60)+"분";
		String seconds = String.valueOf(input%60)+"초";
		
		String[] times = {hours, minutes, seconds}; // 변환한 수를 담고있는 배열 
		for (String time : times) { // 순환하면서, 0이 아닌 경우만 출력한다. 
			if (time.charAt(0) != '0') {
				System.out.print(time+" ");
			}
		}
		sc.close();
	}
}
```





:star:day02.project.project03.java

```java
package kr.ac.kopo.day02.project;

import java.util.Scanner;

/**
 * 
 * @author tess
 * 반지름이 10인 원의 면적을 구해서 출력하는 클래스 
 */
public class Project03 {
	public static void main(String[] args) {
		final double PI = 3.141592; // 상수 
		Scanner sc = new Scanner(System.in);
		double radius = Double.parseDouble(sc.nextLine()); // double 타입으로 받는다. 
		System.out.printf("원의 면적은 %.4f 입니다.",(PI*radius*radius));	
		
	}
}
```



 