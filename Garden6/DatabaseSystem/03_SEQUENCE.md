## 07_200511





## 과제



:star:식별자(모델링 관점)가 무엇인가?

정의와 특징(1~2줄)

식별자란?

**엔티티는 인스턴스들의 집합이다.  그러한 엔티티 내에서 인스턴스들을 구분할 수 있는 구분자를 말한다.**

- 구분자 = 이름, 속성

![그림1](images/SQL_048.jpg)

여러 개의 집합체를 담고 있는 하나의 통에서 각각을 구분할 수 있는 논리적인 이름이 있어야 한다. 이 구분자를 식별자(Identifier)라고 한다. 식별자란 하나의 엔터티에 구성되어 있는 여러 개의 속성 중에 엔터티를 대표할 수 있는 속성을 의미하며 하나의 엔터티는 반드시 하나의 유일한 식별자가 존재해야 한다. 보통 식별자와 키(Key)를 동일하게 생각하는 경우가 있는데 식별자라는 용어는 업무적으로 구분이 되는 정보로 생각할 수 있으므로 논리 데이터 모델링 단계에서 사용하고 키는 데이터베이스 테이블에 접근을 위한 매개체로서 물리 데이터 모델링 단계에서 사용한다.

**엔티티: 사원정보**

**식별자: 사번**

**인스턴스(엔티티의 구현화)의 속성: 사번, 이름, 주민등록번호**

인스턴스: 1, 정승원, 950115

**인스턴스 내에서 유최불존의 특징을 가진 것이 식별자로서 작동한다.**

![img](images/image.png)

특징은?

![image-20200511151846623](images/image-20200511151846623.png)





:star:모델그리는 게 시험이 될 것





## 참고



## SEQUENCE

일련번호 자동생성 방식:    

① MAX(SEQ) + 1 방식 - 더이상 사용하지 않는다. 두명이 동시에 접속하면 똑같은 번호가 나타날 수 있다.

② 채번 TABLE 방식  - 더이상 사용하지 않는다.

③ SEQUENCE  - 이 방식으로 사용



① *CREATE는 DDL명령어 이다.

```sql
 CREATE SEQUENCE  SCOTT.ORDER_SEQ8 -- SCOTT.오브젝트명  [SCOTT.] 은 schema이다.
         INCREMENT BY   1 -- 1씩 증가
         START WITH    	1 -- 1부터 시작
         MAXVALUE    	999999999999 -- 최대값 여기까지
         MINVALUE    	1 -- 최소값
         NOCYCLE   		-- 최대값까지 도달하면 멈출 것, cycle이면 다시 minvalue로
         CACHE     		30; -- 미리 dbms 메모리 안에 1번부터 30번까지 만들어둔다. 30개를 다 쓰면 31번 부터 60번까지 만들어둔다.
-- sequence를 생성하는 명령어
-- schema : ~ 소유의, schema는 생략가능하다.
-- scott 소유의 order_seq를 생성
-- optional = '[]'
```

*cache란?  



SEQUENCE는 SELECT랑 같이 쓰이지 않는다.

```SQL
②
SELECT  ORDER_SEQ8.CURRVAL FROM DUAL; -- ERROR

③
SELECT  ORDER_SEQ8.NEXTVAL FROM DUAL; -- 다음값을 하고나서는 ERROR가 나지않는다.
SELECT  ORDER_SEQ8.CURRVAL FROM DUAL; -- 1
SELECT  ORDER_SEQ8.CURRVAL FROM DUAL; -- 1
ROLLBACK; -- 취소

④ 
SELECT  ORDER_SEQ8.NEXTVAL FROM  DUAL; 
SELECT  ORDER_SEQ8.NEXTVAL FROM  DUAL; 

```

*:star:SEQUENCE명.NEXTVAL을 호출하고 나서야 SESSION내에 변수가 할당 된다.

<img src="images/image-20200511151328030.png" alt="image-20200511151328030" style="zoom:33%;" />



![image-20200511144110609](images/image-20200511144110609.png)

왼쪽과 오른쪽은 서로 다른 `SESSION`으로 만들어져 있다.  (=고유한 CONNECTION이 존재한다)

SESSION은 다르지만 `ORDER_SEQ`라는 오브젝트를 **공유한다**.

`.CURRVAL`은 서로의 SESSION에 아무런 영향을 주지 않지만, `.NEXTVAL`은 서로 영향을 준다.



해당 시퀀스의 **값을 증가**시키고 싶다면

>  **ORDER_SEQ8`.NEXTVAL`**

**현재 시퀀스**를 알고 싶다면

>  **ORDER_SEQ8`.CURRVAL`**







DML 문장만 rollback이 된다.

sequence로 증가한건 rollback이 안된다.

![image-20200526131418339](images/image-20200526131418339.png)

그래서 중간에 숫자가 빌수가 있다.

![image-20200526131455514](images/image-20200526131455514.png)

*sequence에 `hole`이 생긴다고 볼 수 있다.

그래서 sequence는 `연속되지 않는` 고유한 번호라는 특징이 있다.





⑧ //  MAX+1 방식 , 문제점은 ? 
 INSERT INTO scott.ORDERS(ORDER_ID,ORDER_MODE,CUSTOMER_ID,ORDER_STATUS,SALES_ID)  VALUES((SELECT MAX(ORDER_ID)+1 FROM scott.ORDERS),'direct',335,1,7654); 

`에러발생`



