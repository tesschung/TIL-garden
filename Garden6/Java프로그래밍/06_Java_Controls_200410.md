

## 06_200410

> 공지

과제



## 참고



## 제어

![image-20200410101716775](images/image-20200410101716775.png)



## 제어 break

break를 사용할 수 있는 경우 (반복문, 스위치)

`for`, `do ~ while,` `while`, `switch`



*가장 가까운 반복문 종료*

```java
while(true) { // 반복문 1
  for (;;) { // 반복문 2
    break; // 반복문 2만 종료
  }
}
```



*중첩된 반복문을 한 번에 빠져나갈때*

```java
loop01: while(true) { // 반복문 1
  for (;;) { // 반복문 2
    break loop01; // 반복문 1, 반복문 2 종료
  }
}
```



## 제어 continue

```java
while (true) {
  
  s01;
  if (a == true) {
  		s02;
  		continue; // 아래는 수행하지 않고 다시 while로 진행, s03, s04는 실행되지 않는다.  
  }
  s03;
  s04;
}
```



## 중첩된 반복문 For



*변수와 블록스코프의 개념이해*

```java
for (int cnt = 1; cnt <=5; cnt++) { // cnt 생성
  s01;
} // 반복이 다 돌면, cnt 소멸
for (int cnt = 1; cnt <=5; cnt++) { // cnt 생성
  s01;
} // 반복이 다 돌면, cnt 소멸
```



파이썬과 달리 자바는 문자열에 `*`가 불가능하다.

그래서 *별찍기* 는 아래와 같이 이뤄진다.

```java
for (int i = 1; i <= 5; i++) { // 5줄을 찍을 것
  for (int j = 1; j <= i; j++) { // j부터 i까지
    System.out.print("*");
  }
  System.out.print("\n"); // 한줄 끝나면 개행
}
/*

*
**
***
****
*****

*/
```





역순으로 출력하기 *방법1*

```java
for (int i = 1; i <= 5; i++) {

  for (int j = 1; j <= i-1; j++) { //i-1개만큼 찍는다.
    System.out.print(" "); // " "을 하나씩 늘려간다. 

  }
  for (int j = 1; j <= 6-i; j++) {
    System.out.print("*");
  }

  System.out.print("\n");
}

/*
*****
 ****
  ***
   **
    *
*/
```



역순으로 출력하기 *방법2*

```java
for (int i = 1; i <= 5; i++) {
  for (int j = 1; j <= 5; j++) {
    if (j < i) { // j가 1이고, i도 1이면 else
      System.out.print(" ");
    } else { // j가 5가 될때까지 *이 찍힌다.
      System.out.print("*");
    }
  }
  System.out.println("\n");
}

/*
*****
 ****
  ***
   **
    *
*/
```





```java
/*

*
**
***
****
*****
****
***
**
*

*/
```

<img src="images/image-20200410113730757.png" alt="image-20200410113730757" style="zoom:25%;" />

![image-20200410114136759](images/image-20200410114136759.png)









