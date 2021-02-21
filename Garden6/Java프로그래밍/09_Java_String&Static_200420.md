

## 09_200420

> 공지

**ict 신청**



**한이음 홈페이지에 한글파일을 올려야함**



**과제**

// nextLine() 으로 항상 버퍼 없애기!



~~1번 문자를 찾는 문제, static이 붙어있음 주의~~



~~2번 remove하는 문제~~



~~3번 계속 구매할때마다 다른사람이 사는 문제~~

![image-20200420163543840](09_Java_String&Static_200420.assets/image-20200420163543840.png)

![image-20200420163626276](09_Java_String&Static_200420.assets/image-20200420163626276.png)

![image-20200420163641506](09_Java_String&Static_200420.assets/image-20200420163641506.png)

![image-20200420163650154](09_Java_String&Static_200420.assets/image-20200420163650154.png)







## 참고

![image-20200420105327653](09_Java__200420.assets/image-20200420105327653.png)

이런식으로 break 코드를 사용하지 않을 수 있다.



멤버 변수를 갖지 않고 메소드만 가진 클래스를 기능 클래스라고 한다.







## 자바 문자열과 API



![image-20200417164445103](09_Java__200420.assets/image-20200417164445103.png)

![image-20200420112424054](09_Java__200420.assets/image-20200420112424054.png)

*String 문자열의 특징: 한 번 만들어지면 상수 영역이 사라지지 않는다.



![image-20200417164657906](09_Java__200420.assets/image-20200417164657906.png)



![image-20200420113336190](09_Java__200420.assets/image-20200420113336190.png)



![image-20200417165109532](09_Java__200420.assets/image-20200417165109532.png)



![image-20200417165222343](09_Java__200420.assets/image-20200417165222343.png)

string을 배열처럼 사용할 수 있다.



![image-20200417170251023](09_Java__200420.assets/image-20200417170251023.png)





## 문자열 비교

![image-20200420113411009](09_Java__200420.assets/image-20200420113411009.png)



```java
String str = new String("Hello"); 
String str2 = new String("Hello");
// new 하면 각각의 instance 객체를 만드는 것

// 서로의 주소가 다르다
System.out.println(str == str2); // false

String str3 = "Hello";
String str4 = "Hello";

// 서로의 주소가 다르다
System.out.println(str == str3); // false

// 주소가 같다
System.out.println(str3 == str4); // true

// 주소가 다르므로, 
// 주소비교하는 동등 아닌 equals() 를 사용해서 비교하는 것이 바람직하다. 
System.out.println(str.equals(str2)); // true

String str5 = "hello";

System.out.println(str4.equalsIgnoreCase(str5)); // true

System.out.println(str5.startsWith("h")); // true

System.out.println(str5.compareTo(str4)); // 32 
// 가장 먼저 발견한 차이를 바로 리턴한다.
// Hello와 hello는 달라서 사전수에 해당하는 그 차를 리턴한다.
// H와 h의 아스키 코드의 차이는 32이므로 이를 준다.

System.out.println(str4.compareTo(str5)); // -32
```



String1.`CompareTo`(String2)

| 값              | 조건                                                         |
| :-------------- | :----------------------------------------------------------- |
| 0보다 작습니다. | 이 인스턴스가 `value` 앞에 오는 경우                         |
| 0               | 이 인스턴스의 위치가 정렬 순서에서 `value`와 같은 경우       |
| 0보다 큽니다.   | 이 인스턴스가 `value` 다음에 오는 경우또는`value`은 `null`입니다. |



![image-20200420120155086](09_Java__200420.assets/image-20200420120155086.png)

```java
for(String name: names) {

    if (name.contains("홍")) {
     	// "홍"이 포함된 사람 검색 
    }
    
}
```



![image-20200420140727895](09_Java__200420.assets/image-20200420140727895.png)

**문자열 탐색**은 처음에 나온 것만 검색한다. 때문에 **두번째 인자에 시작 위치를 넣는게 가능하다.**



**indexOf()**

```java
String str = "hello world";
String searchStr = "l";

System.out.println(str+"에서"+searchStr+" 위치");
int searchIdx = str.indexOf(searchStr);

while(searchIdx != -1) {
    System.out.println("검색된 위치:" + searchIdx); // 2
    searchIdx = str.indexOf(searchStr,searchIdx+1);
}


System.out.println(str+"에서"+searchStr+"위치");
searchIdx = -1;
// 이 값이 -1이 아닌 경우 loop를 돌라는 뜻이다.
while ((searchIdx = str.indexOf(searchStr, searchIdx+1)) != -1) {
    System.out.println("검색된 위치:" + searchIdx); // 2
}
/*
hello world에서 l위치
검색된 위치:2
검색된 위치:3
검색된 위치:9
*/
```



**substring()**

```java
String str1 = "hello world";
System.out.println("substring(2) :" + str.substring(2));
System.out.println("substring(2, 6) :" + str.substring(2, 6));
System.out.println("substring(2, 6) :" + str.substring(2, 7));

/*
substring(2) :llo world
substring(2, 6) :llo 
substring(2, 6) :llo w
*/
```



**concat()**

```java
String A = "AAA";
String B = "BBB";
String AB = A+B;
System.out.println(AB); // AAABBB

String ABConcat = A.concat(B);
System.out.println(ABConcat); // AAABBB
```



**trim()** 

양쪽의 공백만 없애준다.

```java
str = "홍길동전:허균:조선시대";
String[] strA = str.split(":");
System.out.println(Arrays.toString(strA));
// [홍길동전, 허균, 조선시대]
```





![image-20200420144406287](09_Java__200420.assets/image-20200420144406287.png)



**String.valueOf()** 

정수를 문자열로

```java
int num = 12345;
System.out.println(12345+""+100); // 12345100
System.out.println(String.valueOf(num)+100); // 12345100
```



**Integer.valueOf("12") / Integer.parseInt("12")**

문자열을 정수로

```java
String num = "12345";
System.out.println(Integer.valueOf(num)+100); // 12445
```



**StringBuffer** 

*string을 출력하는데 가장 빠른 방법

```java
StringBuffer sb = new StringBuffer();

for (int i = 0;  i < 100000; i ++) {
    sb.append(i);
}
```



## 패키지와 접근제한자

![image-20200420152758015](09_Java__200420.assets/image-20200420152758015.png)

*private이 가장 보안성이 좋다.



:star:

`method`는 `public`

`field`는 `private`



## static

static void aaa() {}

void aaa() {}

static int num = 0;

int num = 0;

![image-20200420153147373](09_Java__200420.assets/image-20200420153147373.png)

*nonStatic `static`이 붙지않은 것



**같은 클래스의 instance 객체가 `static`이 붙은 값은 공유한다.**

static은 **하나의 공간**만 만들어진다.



![image-20200420154320390](09_Java__200420.assets/image-20200420154320390.png)



![image-20200420154343317](09_Java__200420.assets/image-20200420154343317.png)

static의 생성 시점이 더 빠르다.

왜냐하면 **인스턴스 객체 생성 전에 이미 생성되어있기 때문이다.**



![image-20200420154550419](09_Java__200420.assets/image-20200420154550419.png)

```java
Employee.empCount // 이렇게 접근 가능
```

```java
public class Employee {

    static int empCount;
    private String name;
    private int salary;

    public Employee() {
		empCount++;
    }

    public Employee(String name, int salary) {
        this.name = name;
        this.salary = salary;
        empCount++;
    }

    public void info() {
        System.out.println("사원명:" + name+", 연봉:"+ salary+"만원");

    }
    
}
```

```java
public class EmployeeMain {

    public static void main(String[] args) {
        Employee employee1 = new Employee("a", 2300); // ++
        Employee employee2 = new Employee("b", 2400); // ++
        employee1.info();
        employee2.info();
        int numOfEmployee = Employee.empCount;
        System.out.println("총 "+numOfEmployee+"명이 존재합니다."); // 2 명
    }
}
```

*만약 `static int empCount;` 에 `static`이 붙지않았으면, 인스턴스 필드로 생성되므로 1을 반환하게 된다.



![image-20200420161258402](09_Java_String&Static_200420.assets/image-20200420161258402.png)

***정보은닉성**

```java
public class Employee {

    private static int empCount; // 정적필드 
    private String name;
    private int salary;

    public Employee() {
        Employee.empCount++;
    }

    public Employee(String name, int salary) {
        this.name = name;
        this.salary = salary;
        Employee.empCount++;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setSalary(int salary) {
        this.salary = salary;
    }

    public String getName() {
        return name;
    }

    public int getSalary() {
        return salary;
    }

    public void info() {
        System.out.println("사원명:" + name+", 연봉:"+ salary+"만원");
    }

    public static void getEmpCount() { // 정적메소드  
        System.out.println("총 "+Employee.empCount+"명이 존재합니다.");
    }

}
```

```java
public class EmployeeMain {

    public static void main(String[] args) {
        Employee employee1 = new Employee("a", 2300);
        Employee employee2 = new Employee("b", 2400);
        employee1.info();
        employee2.info();
        Employee.getEmpCount();
    }
}
```





