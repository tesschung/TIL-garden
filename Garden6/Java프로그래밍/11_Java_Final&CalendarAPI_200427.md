

## 11_200427

> 공지



항상 control 클래스를 사용할 것

![image-20200427165514611]($images/image-20200427165514611.png)



달력만들기

![image-20200427165708250]($images/image-20200427165708250.png)

![image-20200427165721117]($images/image-20200427165721117.png)

![image-20200427165738504]($images/image-20200427165738620.png)



---





중복되지 않는 수가 나오도록 알고리즘 4개

![image-20200428165911743]($images/image-20200428165911743.png)

![image-20200428170231716]($images/image-20200428170231716.png)

![image-20200428170302257]($images/image-20200428170302257.png)

혹은

![image-20200428170429077]($images/image-20200428170429077.png)

![image-20200428170525370]($images/image-20200428170525370.png)

![image-20200428170631318]($images/image-20200428170631318.png)

![image-20200428170659510]($images/image-20200428170659510.png)

![image-20200428170854922]($images/image-20200428170854922.png)







## 참고





## :star:final

상수를 만들때 사용



![image-20200427101627884]($images/image-20200427101627884.png)

![image-20200427101817282]($images/image-20200427101817282.png)

final이 붙으면 override를 할 수 없다.



## 예외처리

![image-20200427111539829]($images/image-20200427111539829.png)

`checked exception` 일반 예외

컴파일 시점



`runtime exception` 실행 예외

실행 시점

![image-20200427112200558]($images/image-20200427112200558.png)



![image-20200427112452701]($images/image-20200427112452701.png)

예외 발생시 직접처리하는 키워드: `try` `catch` `finally`

간접처리: `throws`

사용자 정의 예외처리: `throw`

![image-20200427113226611]($images/image-20200427113226611.png)

*순서가 바뀌면 안된다.

![image-20200427113431837]($images/image-20200427113431837.png)

![image-20200427113712647]($images/image-20200427113712647.png)

![image-20200427115055056]($images/image-20200427115055056.png)



```java
try {
    FileReader fr = new FileReader("aaa.txt");
    // 컴파일 시점의 예외(checked exception)
    // 해당 파일에 있는 내용을 읽겠다.
} catch (FileNotFoundException e) {
    e.printStackTrace();
} finally {
    System.out.println("예외발생 유무에 상관없이 무조건 실행");
}
```



```java
System.out.println("main start");

for (int i = -2; i < 3; i ++) { // -2 -1 0 1 2 

    System.out.println("for문 진입 "+i);
    try {
        System.out.println(10/i);
    } catch(ArithmeticException e) {
        System.out.println("오류가 발생했습니다.");
        e.printStackTrace();
        break; // 아래 for문 내의 코드는 실행되지 않는다. (finally를 제외)
    } finally {
        // break가 있어도 finally내의 코드는 실행된다.
        // -> return이여도 실행된다.
        System.out.println("main end1");
    }
    System.out.println("for문 종료");
}
System.out.println("main end2");

/*
main start
for문 진입 -2
-5
main end1
for문 종료
for문 진입 -1
-10
main end1
for문 종료
for문 진입 0
오류가 발생했습니다.
java.lang.ArithmeticException: / by zero
main end1
main end2
	at kr.ac.kopo.day11.lesson.ExceptionMain02.main(ExceptionMain02.java:13)
*/
```





## 간접 예외처리 throws



![image-20200427140036525]($images/image-20200427140036525.png)

## 사용자 정의 예외처리 throw



![image-20200427144327443]($images/image-20200427144327443.png)

![image-20200427145440875]($images/image-20200427145440875.png)



## 생성자 정리

![image-20200427151233590]($images/image-20200427151233590.png)





**`디폴트 생성자`**  

body 내용을 갖고있지 않은 형태



**`this 생성자의 특징`**

오직 생성자 안에서 오버로딩 생성자를 호출할때 사용

생성자의 맨 첫줄에 작성





## static 정리

static 멤버변수, 메소드에 붙일 수 있다.

static과 non-static 차이점



**`로딩 시점`**

static : 프로그램을 실행하는 순간/ 클래스 인식할때 로딩한다.

non-static: 객체가 만들어지는 순간



**`메모리 할당`**

static:

클래스당 하나씩 만들어진다.

`클래스명.메소드명`, `클래스명.필드명` 이렇게 접근한다.

non-static:

인스턴스 객체당 하나



**`사용상의 차이`**

static 메소드 안에서는 satic method나 non-static method를 사용할 수 없다. 왜냐하면 가장 빠르게 실행되기 때문이다.

non-static 메소드에서는 가능하다.





## 상속 정리

**`다형성`**



**`재사용성과 확장성`**







**`extends 키워드`**



**`super 키워드`**



**`오버라이딩`**

다형성을 확보할 수 있다.

내용부를 재정의 할 수 있다.



**`오버로딩`**

같은 메소드명인데 매개변수가 다른 경우

여러 생성자를 생각





## 접근제한자 정리

**`public`** - **모든 접근**을 허용

**`protected`** - **같은 패키지(폴더)**에 있는 **객체**와 **상속관계의 객체**들만 허용

**`default`** - **같은 패키지(폴더)**에 있는 **객체**들만 허용, 접근제어자를 지정하지 않았다면 자동으로 default로 지정된다.

**`private`** - **현재 객체 내에서만 허용**



![img](images/img.png)

![img](images/img-1589103622849.png)



## 추상클래스 정리

추상메소드를 가지고 있는 클래스

표준을 만드는 클래스



**`abstract 키워드`**

**`추상메소드`**

선언부는 가지고 있으나 내용부는 가지고 있지 않은 형태



**`인스턴스 생성여부`**

인스턴스 객체를 만들 수 없다. 만들려면 추상클래스를 상속받은 자식클래스를 통해 만들 수 있다.



**`일반메소드와 추상메소드 모두 가능`**



**`하위클래스에서 해야 할 일`**

반드시 추상클래스의 추상메소드를 오버라이딩해야한다.



**`추상클래스 객체 변수 얻기`**



## 객체의 형변환 정리

`정의`

'=' 연산자를 기준으로 좌변과 우변의 데이터 타입이 다른 경우에 발생



`조건`
좌변과 우변의 데이터타입은 상속관계여야한다.



`종류`

묵시적 형변환 

명시적 형변환 



*기본자료형은 크기 기준

*객체형변환은 상속 기준



## 인터페이스 정리

다중상속 지원

기능추가

-able 형태로 이름을 일반적으로 작성한다.



`선언되는 메소드`

추상메소드



`선언되는 변수`

상수 변수



`인스턴스 생성여부`

상속받은 자식 클래스에서 인스턴스 객체를 생성가능



`하위클래스에서 해야 할 일`

implements

추상메소드들을 꼭 오버라이딩해야한다.



`인터페이스 객체 변수 얻기`



## final 정리

`변수에 적용`

static final 필드는 상수를 말한다.

`메소드에 적용`

오버라이딩 금지

`클래스에 적용`

상속 금지- 부모클래스로 사용할 수 없다.



## 예외처리 정리

프로그램을 실행하면서 발생하는 예기치않은 문제점에 의해 소프트웨어가 종료되는 것을 방지하여 문제가 발생하더라도 그다음 일을 진행하도록 도와주는 프로그래밍 방법

컴파일시점



런타임시점



직접처리 : try-catch-finally



간접처리 : throws



사용자정의예외발생 : throw



**`try`** - 예외 발생 가능 코드가 위치한다. try 블록의 코드가 예외 없이 정상 작동되면, catch 코드는 실행되지 않고 finally 블록의 코드를 실행한다.

**`catch`** - 만약 try 블록의 코드에서 예외가 발생하면 즉시 실행을 멈추고 catch 블록으로 이동하여 예외 처리 코드를 실행한다. 그리고 finally 코드를 실행한다.

**`finally`** - 예외 발생 여부와 상관없이 항상 실행할 내용이 있을 경우에만 finally 블록을 작성해주면 된다. try 블록과 catch 블록에서 return문을 사용하더라도 finally블록은 항상 실행된다.

**`throws`** - 간접처리 

`throw` - 사용자정의예외발생 



![image-20200427152725824]($images/image-20200427152725824.png)

2번, 클래스 생성자는 원래 반환형이 없다.

![image-20200427152816529]($images/image-20200427152816529.png)

2번, 클래스당 하나가 만들어진다.

![image-20200427152846577]($images/image-20200427152846577.png)

4번, 접근제한자에 따라 다르다.

![image-20200427152925707]($images/image-20200427152925707.png)

4번

![image-20200427152936898]($images/image-20200427152936898.png)

1번, 클래스와 메소드에만 사용할 수 있다.





## 날짜 API



![image-20200427153603594]($images/image-20200427153603594.png)

*Calendar

## Date

![image-20200427153801739]($images/image-20200427153801739.png)

![image-20200427154414748]($images/image-20200427154414748.png)

```java
	Date a = new Date();
	System.out.println(a.toString());
	// Mon Apr 27 15:51:30 KST 2020
```


![image-20200427161438974]($images/image-20200427161438974.png)

```java
	Calendar now = Calendar.getInstance();
	int year = now.get(Calendar.YEAR);
	System.out.println(year); // 2020
```
![image-20200427163811522]($images/image-20200427163811522.png)

그 달에 해당하는 가장 큰 날을 반환

![image-20200427164237396]($images/image-20200427164237396.png)





## SimpleDateFormat

![image-20200428105719869]($images/image-20200428105719869.png)

```java
String pattern = "오늘은 yyyy년 M월 dd일(E)입니다.";
SimpleDateFormat sdf = new SimpleDateFormat(pattern);
System.out.println(sdf.format(new Date()));
// 오늘은 2020년 4월 28일(화)입니다.
```




*Generic은 시험문제에 안나옴

## Collection API



![image-20200428142318015]($images/image-20200428142318015.png)

![image-20200428142854412]($images/image-20200428142854412.png)



## Generic

![image-20200428143344667]($images/image-20200428143344667.png)









## List

![image-20200428154636034]($images/image-20200428154636034.png)

## ArrayList

![image-20200428154721819]($images/image-20200428154721819.png)

![image-20200428154730984]($images/image-20200428154730984.png)

![image-20200428154741470]($images/image-20200428154741470.png)

![image-20200428154752452]($images/image-20200428154752452.png)

![image-20200428155014522]($images/image-20200428155014522.png)

![image-20200428155021772]($images/image-20200428155021772.png)

![image-20200428155037376]($images/image-20200428155037376.png)

![image-20200428155054908]($images/image-20200428155054908.png)



## Map

![image-20200518142258130](images/image-20200518142258130.png)



![image-20200518142423165](images/image-20200518142423165.png)

*키는 중복된 값이 생길 수 없지만, 값을 중복될 수 있다.

*만약 키에 중복된 값이 들어오면, 기존 값이 새로운 값으로 업데이트 된다.

```java
map.put("name", "승원");
```

![image-20200518142821659](images/image-20200518142821659.png)

```java
map.get("name");
```

![image-20200518143048290](images/image-20200518143048290.png)

```java
map.remove("addr");
// 반환 후 해당 키는 삭제된다.
```

![image-20200518143134072](images/image-20200518143134072.png)

```java
map.containsKey("addr");
// 해당 키가 존재할 경우 true를 반환하고 존재하지 않으면 false를 반환한다.
```

![image-20200518143316418](images/image-20200518143316418.png)

*{"age":16}이 추가되어 {"name":길동, "addr":인천, "age":16}이 된다.





V  `put`(K key, V value)   : 데이터입력

V  `get`(Object key)       : 데이터추출

V  `remove`(K key)         : 입력된데이터의크기반환

boolean `containsKey`(Object key)    : 특정한key 포함여부

void `putAll`(Map<K key, V value> m)  :  기존콜렉션데이터추가

Set<Map.Entry<K, V>> entrySet()      :  (key 와 value) 쌍을 표현하는 Map.Entry집합을 반환, map에 있는 데이터를 set으로 변환해준다.



## Set

![image-20200428161953320]($images/image-20200428161953320.png)

![image-20200428162101725]($images/image-20200428162101725.png)

![image-20200428162211345]($images/image-20200428162211345.png)

![image-20200428162232188]($images/image-20200428162232188.png)



![image-20200428162305717]($images/image-20200428162305717.png)

![image-20200428162312411]($images/image-20200428162312411.png)

*add(E e)는 데이터 입력 성공여부를 boolean 값으로 보여준다.

![image-20200428163055454]($images/image-20200428163055454.png)

![image-20200428163453332]($images/image-20200428163453332.png)





![image-20200428164838125]($images/image-20200428164838125.png)









