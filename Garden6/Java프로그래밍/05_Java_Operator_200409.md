

## 05_200409



> 공지

- 과제

자바파일로

주석달기

파일 8개여야함









## 참고





## 연산자

![image-20200408154550440](05_Java_200409.assets/image-20200408154550440.png)

![image-20200409112602775](05_Java_200409.assets/image-20200409112602775.png)



컴퓨터는 왼쪽에서 오른쪽으로 계산한다.

```java
int num = 10;

System.out.println(++num); // 11
System.out.println(num); // 11
System.out.println(num++); // 11
System.out.println(num); // 12

--num;
num--;
```

`전위증가연산자`

`후위증가연산자`



![image-20200409112656629](05_Java_200409.assets/image-20200409112656629.png)

![image-20200409112814221](05_Java_200409.assets/image-20200409112814221.png)

조건(논리)연산자는 교환법칙이 성립하지 않는다. 때문에 순서가 중요하다는 것을 알 수 있다.



![image-20200409115252535](05_Java_200409.assets/image-20200409115252535.png)



> 조건문보다 3항 연산자 사용이 더 빠르다.

![image-20200409115314336](05_Java_200409.assets/image-20200409115314336.png)



## 조건문 If

```java
// 다중 if문
if () {
  
} else if () {
  
} else {
  
}
```



![image-20200409151127690](05_Java_200409.assets/image-20200409151127690.png)







## 조건문 Switch

![image-20200409154519853](05_Java_200409.assets/image-20200409154519853.png)

default가 위에 있더라도, case를 먼저 보고 실행된다.



![image-20200409155617595](05_Java_200409.assets/image-20200409155617595.png)



## 반복문 For

![image-20200409161816774](05_Java_200409.assets/image-20200409161816774.png)



![image-20200409162954936](05_Java_200409.assets/image-20200409162954936.png)



```java
if() 
  xxx;
for(); { // for();이 하나의 블럭으로 인식되어 for만 돌고 아무것도 출력되지 않는다.
  xxx; // 무조건 한 번 출력된다.
}
```



## 반복문 do ~ while



![image-20200410101500750](images/image-20200410101500750.png)





