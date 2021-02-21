

## 07_200413

> 공지

과제

1. 짝수, 홀수 따로 출력 후, 짝수sum, 홀수sum을 구하고 나중에 출력한다.

2. while을 사용해서 5번 받으면서 진행, 큰수를 계속 갱신하면서 비교
3. 2부터 100까지 숫자 저장

2를 제외하고 2의 배수를 찾아 0으로 만든다. (소수일 수 없는 애)

0으로 안바뀐애는 이 자체가 소수

3을 제외하고 3의 배수를 0으로 만든다.

숫자와 0이 아닌 숫자로 구성되는데, 그게 소수가 된다.



## 참고





## 1차원 배열

> 배열이란 연속적인 공간에 **같은 타입의 변수**를 **고정된 개수**만큼 모아둔 집합



**같은 종류(타입)의 데이터**를 저장한다.

**크기가 고정**되어있다. 한 번 생성된 배열은 크기를 바꿀 수 없다.

객체로 취급하기때문에 **new**라는 생성자를 항상 사용한다. (참조자료형이다.)

배열의 요소를 참조하려면 배열이름과 색인(**index**)이라고 하는 int 유형의 정수값을 조합하여 사용한다.

![image-20200413140823523](07_Java_200413.assets/image-20200413140823523.png)

```java
// 0x -> 16진수
```



![image-20200413141425225](07_Java_200413.assets/image-20200413141425225.png)



![image-20200413141512182](07_Java_200413.assets/image-20200413141512182.png)



```java
// 배열이름 = new 배열유형 [배열크기];
int[] prime = null; // 1) null로 초기화한 상태로 선언하고,
prime = new int[10]; // 2) 새로운 배열객체를 저장한다.

// 만약 prime에 char[10]을 하면, 타입이 상이하므로 에러가 발생한다.
```



![image-20200413142204074](07_Java_200413.assets/image-20200413142204074.png)



![image-20200413143716857](07_Java_200413.assets/image-20200413143716857.png)



배열의 인덱스는 0부터 배열길이-1까지의 인덱스를 가지고 있다.

![image-20200413144424157](07_Java_200413.assets/image-20200413144424157.png)

![image-20200413145523245](07_Java_200413.assets/image-20200413145523245.png)



```java
// 5개짜리 배열 생성
int[] arr = new int[5]; // [0] ~ [4]

// 힙 영역의 주소값이 찍힌다.
System.out.println("arr : " + arr);

System.out.println("arr : " + arr[0]); // 0
System.out.println("arr : " + arr[1]); // 0
System.out.println("arr : " + arr[2]); // 0
System.out.println("arr : " + arr[3]); // 0
System.out.println("arr : " + arr[4]); // 0


// String[] strArr = {"politech", "java", "education"};

String[] strArr = new String[5];
int loc = 0;
strArr[loc++] = "politech";
strArr[loc++] = "java";
strArr[loc++] = new String("education");

for (int i = 0; i < strArr.length; i++) {
    System.out.println(strArr[i]); 
}

// politech
// java
// education
```

![image-20200413160245955](07_Java_200413.assets/image-20200413160245955.png)

```java
for (int i = 0; i < strArr.length; i++) {
    System.out.println(strArr[i]); 
}


for (int num : strArr) {
    System.out.println(num);
}
					// Arrays라는 클래스의 toString 메소드
System.out.println(Arrays.toString(strArr));
```

![image-20200413161925638](07_Java_200413.assets/image-20200413161925638.png)



## 깊은복사 얕은복사

```java
int[] arr = {10, 20};
int[] copyArr;
copyArr = new int[arr.length];

// 방식1
// for문 돌면서 저장한다.

// 방식2
System.arraycopy(arr, 0, copyArr, 0, arr.length);
```

![image-20200413164411449](07_Java_200413.assets/image-20200413164411449.png)





```java
int[] ar = /*new int[]*/{10, 20}; // new 생성자 생략하고 선언되는 경우,
// ar = {10}; // 에러발생
ar = new int[]{10}; // 반드시 명시해야 한다.
```



## 2차원 배열

```java
int[][] arr = new int[3][2];
/*
[
[0,0],
[0,0],
[0,0]
]
*/


int[][] arr1 = new int[3][]; // 이렇게 되면,
/*
[
[null],
[null],
[null],
]
*/
```

