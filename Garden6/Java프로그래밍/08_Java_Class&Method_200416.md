

## 08_200416

> 공지

과제 2번

교수님 코드 참고하면서 작성

생성자에 this.사용하면서 멤버필드 갱신하기

StringUtil stringUtil = new StringUtill;



아이스크림 클래스를 메소드들이 필요할 것

그걸  알아서 만들기.. 메소드를 만들기..







Integer.paseInt(sc.nextLine()); // 꼭 이런식으로 써야한다.

아래와 같이 맞춰써야한다.

[001] [11100000000000] [000111]

![image-20200417101453693](08_Java_Class&Method_200416.assets/image-20200417101453693.png)

버퍼를 비워줘야 하기 때문이다.



디자인패턴책



## 참고



![image-20200416102947234](08_Java_200416.assets/image-20200416102947234.png)



```java
int[] intArray = new int[99]; // 편의상 101까지 늘린다.

System.out.println("< 2 ~ 100사이의 소수 출력 >");

for (int i = 0; i < intArray.length; i++) {
    intArray[i] = i+2;
}

for (int i = 0; i < intArray.length; i++) {
    // 돌면서 0이 아니라면, 소수라는 의미
    // 저장된 2부터 차례대로 돌면서 구한다.
    if (intArray[i] != 0) {
        for (int j = i+1; j < intArray.length; j ++) {
            if(intArray[j] % intArray[i] == 0) {
                intArray[j] = 0;
            }
        }
    }
}

for (int ans : intArray) {
    if (ans != 0) {
        System.out.print(ans+" ");
    }
}
```





## 2차원 배열



```java
int[][] arr = new int[1][2];
System.out.println(Arrays.deepToString(arr));

// [[0, 0]]
```



![image-20200416113655328](08_Java_200416.assets/image-20200416113655328.png)



![image-20200416114344492](08_Java_200416.assets/image-20200416114344492.png)



```java
int[][] arr = new int[3][];

arr[0] = new int[4];
arr[1] = new int[4];
arr[2] = new int[4];
```



```java
int[][] arr = new int[3][];

for (int i =0; i <arr.length; i++) {
    arr[i] = new int[i+2];
}

System.out.println(Arrays.deepToString(arr));
```



![image-20200416115538793](08_Java_200416.assets/image-20200416115538793.png)



![image-20200416120254640](08_Java_200416.assets/image-20200416120254640.png)





## 클래스

눈에보이는 사물들을 컴퓨터상에 추상화 시켜놓은 집합

![image-20200416144426090](08_Java_200416.assets/image-20200416144426090.png)



![image-20200416145119489](08_Java_200416.assets/image-20200416145119489.png)



![image-20200416145540097](08_Java_200416.assets/image-20200416145540097.png)



![image-20200416150455931](08_Java_200416.assets/image-20200416150455931.png)



`객체`란 인스턴스 변수를 모아둔 애들을 통칭

`인스턴스 변수`란 멤버변수, 메소드

![image-20200416160026358](08_Java_200416.assets/image-20200416160026358.png)

```java
public class HandPhone {

    String phone;
    String name;
    String company;

}
```

```java
public class HandPhoneMain {

    public static void main(String[] args) {

        HandPhone hp = new HandPhone();
        hp.name = "홍길동";
        hp.phone = "010-1111-2222";
        hp.company = "Samsung";

        System.out.println(hp.name);

        // 데이터형[] 배열명 = {객체1, 객체2, 객체3}
        HandPhone[] HandPhoneArray = {hp};

        for (int i = 0; i < HandPhoneArray.length; i++) {
            System.out.println(HandPhoneArray[i].name);
        }
    }
}
```



## 메소드



![image-20200417104711980](08_Java_Class&Method_200416.assets/image-20200417104711980.png)



![image-20200417104931103](08_Java_Class&Method_200416.assets/image-20200417104931103.png)





![image-20200417105912808](08_Java_Class&Method_200416.assets/image-20200417105912808.png)



여러개  값을 넘기고 싶으면 배열을 사용한다.

타입이 다른 것들을 넘기려면 객체를 이용해서 반환해야한다.



![image-20200417110534596](08_Java_Class&Method_200416.assets/image-20200417110534596.png)





## 생성자

1. 클래스 명과 이름이 동일하다

2. 반환 타입이 없다

![image-20200417151402461](08_Java_Class&Method_200416.assets/image-20200417151402461.png)



```java
Dog d = new Dog();
```



![image-20200417151957352](08_Java_Class&Method_200416.assets/image-20200417151957352.png)



생성자가 없는 경우 JVM이 자동으로 제공해준다.

```java
Dog(){} // 이런식으로
```



![image-20200417152206556](08_Java_Class&Method_200416.assets/image-20200417152206556.png)





![image-20200417154023228](08_Java_Class&Method_200416.assets/image-20200417154023228.png)



생성자를 정의하고나면

```java
Dog d = new Dog(); // 이 부분이 에러난다.
```





![image-20200417164033656](08_Java_Class&Method_200416.assets/image-20200417164033656.png)


