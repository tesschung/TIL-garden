```SQL
SELECT * FROM TAB;

SELECT * FROM EMP;

SELECT * FROM DA08.EMP;

ALTER USER DA08 IDENTIFIED BY DA08; -- 패스워드 수정 가능

SHOW USER;
```



## 과제

:star: log data란?

기록을 남기다.

로그는 공통된 파일에 통합적으로 남기는 것이 필요하다.

기록을 남겨서 사고나 장애 발생시, 원인을 파악하고 대처할 수 있는 근거를 제공하는 데이터이다.

LOG4J (박진우님)



:star: ROLLBACK 원리

![image-20200514101106348](images/image-20200514101106348.png)





![image-20200514110658924](images/image-20200514110658924.png)



data buffer cache - 메모리에 올라온 데이터를 재사용할 수 있게 해준다.

logical read - memory에 올라온 데이터를 읽는 것

![image-20200514112910722](images/image-20200514112910722.png)

:star:

블럭은 레코드의 길이가 다 다른데, variable length record(=row) 방식을 지원한다.

레코드 길이는 가변적이다. 

dbms가 가변길이 레코드를 지원할 수 있는 이유는? 

데이터 타입이 여러가지 있는데, 모든 데이터 타입을 담기위해서 가변길이 레코드를 지원한다.









:star: `발표` [요구]MERGE SQL 작성

머지를 응용한 SQL작성 

`merge` - 두 연산( insert, update )의 합 

1. ON에 맞는 데이터가 있으면 `insert` 하고
2. 없으면 `update`한다.

 `MERGE INTO` 문 으로 해결 할 수 있다. 

![image-20200514093303705](images/image-20200514093303705.png)

```SQL
CREATE TABLE TESTA(
NUM NUMBER(4),
NAME VARCHAR2(18)
);
SELECT * FROM TESTA;

CREATE TABLE TESTB(
NUM NUMBER(4),
NAME VARCHAR2(18)
);
SELECT * FROM TESTB;

INSERT INTO TESTB VALUES(1, 'SEUNGWON');
INSERT INTO TESTB VALUES(2, 'MINHO');
INSERT INTO TESTA VALUES(1, NULL);
SELECT * FROM TESTA;
SELECT * FROM TESTB;

-- MERGE INTO 시작
MERGE INTO TESTA A 
USING (
    SELECT NUM, NAME FROM TESTB
) B
ON (A.NUM = B.NUM) -- 조인조건 일치여부

-- 이미 존재하는 경우 찾아서 업데이트 해줄 것
WHEN MATCHED THEN
UPDATE 
SET A.NAME = B.NAME


-- 존재하지 않을 경우 새로 추가 해줄 것
WHEN NOT MATCHED THEN
INSERT(NUM,NAME)
VALUES(B.NUM,B.NAME);

SELECT * FROM TESTA;
SELECT * FROM TESTB;


DROP TABLE TESTA;
DROP TABLE TESTB;
```



```SQL
-- MERGE INTO
MERGE INTO CUSTOMER C
-- MERGE INTO CUSTOMER C : INSERT 또는 UPDATE 할 테이블과 테이블의 ALIAS 를 지정해줍니다.
USING 
-- USING : 원하는 결과를 추출하기 위한 SELECT 문입니다.  이 SELECT 문에서 나온 결과를 INSERT 또는 UPDATE 할 예정입니다.
(
      SELECT USERNO
           , USERNAME
           , ADDRESS
           , PHONE
       FROM NEW_JOIN
      WHERE INPUT_DATE = '20170724'
) N
ON ( C.USERNO = N.USERNO) -- SELECT한 결과와 입력하고 싶은 테이블의 UNIQUE한 값을 매칭하는 연결고리.

-- WHEN MATCHED THEN
WHEN MATCHED THEN
-- WHEN MATCHED THEN : SELECT 의 결과가 INSERT 할 테이블에 값이 이미 존재하는 경우 UPDATE 를 실행합니다.
UPDATE
SET C.USERNAME = N.USERNAME
  , C.ADDRESS  = N.ADDRESS
  , C.PHONE    = N.PHONE
  
-- WHEN NOT MATCHED THEN
WHEN NOT MATCHED THEN
-- WHEN NOT MATCHED THEN : SELECT 의 결과가 INSERT 할 테이블에 값이 없는 경우 INSERT 를 실행합니다.
INSERT ( USERNO
       , USERNAME
       , ADDRESS
       , PHONE
       )
 VALUES (
         N.USERNO
       , N.USERNAME
       , N.ADDRESS
       , N.PHONE
 )
```





:star: SELECT ~ FOR UPDATE 의 기능 및 트랜잭션 시작/종료를 설명 하십시요.

`FOR UPDATE`

업데이트하는 중이니까 SELECT에 작성된 컬럼은 하지말것



기능:

1. **FOR UPDATE**

   SELECT 절에 FOR UPDATE를 사용하면 해당 행에 LOCK이 걸려서 다른 사용자가 제어할 수 없다.

   SESSION1

   ```SQL
   SELECT EMPNO FROM EMP WHERE EMPNO=7369 FOR UPDATE;
   ```

   SESSION2

   ```SQL
   SELECT EMPNO FROM EMP WHERE EMPNO=7369;
   UPDATE EMP SET EMPNO=7368 WHERE EMPNO=7369;
   ```

   <img src="images/image-20200513195921388.png" alt="image-20200513195921388" style="zoom:33%;" />

   FOR UPDATE에 붙을 수 있는 두 가지 옵션

   **FOR UPDATE NOWAIT**

   SELECT할때 LOCK을 제어할 수 없으면 에러처리함
   
   ```SQL
SELECT EMPNO FROM EMP WHERE EMPNO=7369 FOR UPDATE NOWAIT;
   ```
   
   
   
   **FOR UPDATE WAIT SECOND**
   
   지정한 시간 만큼 LOCK을 제어하려고 재시도 후 에러처리
   
   ```SQL
   SELECT EMPNO FROM EMP WHERE EMPNO=7369 FOR UPDATE WAIT 10;
   ```
   
   

트랜잭션 시작/종료:

`ROLLBACK`, `COMMIT`으로 `FOR UPDATE`를 종료할 수 있다.



---

MMDBMS 컴퓨터의 리소스

-CPU : 연산, CPU가 연산을 하려면 반드시 MEMORY에 해당 정보가 있어야 한다.

-MEMORY : 중간 저장 장치

-DISK -> 디스크가 가장 성능 문제가 많다. : 장기 기억 장치

-NETWORK



## 시험문제

![image-20200513155820817](images/image-20200513155820817.png)

트랜잭션의 정의 : 하나의 논리적인 일의 단위

여러 SQL(DML의 덩어리)를 가지고 트랜잭션은 구성된다.



트랜잭션의 특징 : 일원고지



일관성(x시험문제 안나옴)

원자성 - `all or nothing`, 더이상 쪼개질 수 없는 최소 일의 단위, 논리적인 일의 단위 내의 모든 연산이 성공해야 된다. 그렇지 않으면 모든 연산은 취소된다.

고립성 - 변경이 진행중인 나 외의 세션의 쿼리는 다른 세션에서 볼 수 없다.

지속성 - `commit과 rollback`, 변경한 데이터가 영구히 저장되는 것



`계좌이체` 라는 트랜잭션, 하나의 논리적인 일의 단위

A -> B 한테 500만원을 `계좌이체`한다고 했을때

1. A의 계좌에서 500만원 인출			`UPDATE`
2. B의 계좌에 500만원 입급                `UPDATE`
3. A가 B한테 송금한 사실을 기록        `INSERT`





## 참고

비효율

![image-20200513140756424](images/image-20200513140756424.png)



효율

![image-20200513141008958](images/image-20200513141008958.png)











## DML

![image-20200513100211923](images/image-20200513100211923.png)



## INSERT

![image-20200513110517588](images/image-20200513110517588.png)

② 컬럼명을 명확하게 명시해주어야 한다.

④ 에러발생, 값이 컬럼 개수만큼오고 타입도 같아야한다.

⑤ `DESC를 확인했을때 NOT NULL인 경우` 컬럼의 개수가 부족하므로 ERROR가 발생

​	NOT NULL이 아니면 지정하지 않은 컬럼에 묵시적으로 NULL이 추가된다.



`명시적`

⑥ INSERT INTO DEPT(DEPTNO,DNAME,LOC) VALUES(52, '북부영업점',NULL);

⑦ INSERT INTO DEPT(DEPTNO,DNAME,LOC) VALUES(53, '남부영업점','');

문자 데이터 NULL



`묵시적`

⑧INSERT INTO DEPT(DEPTNO,DNAME)  VALUES(54,'서부영업점');

컬럼을 생략해서 묵시적으로 NULL추가



## UPDATE

![image-20200513111236212](images/image-20200513111236212.png)

특정 데이터를 `찾아서` `수정`한다.

![image-20200513111245476](images/image-20200513111245476.png)



COMMIT; 

DBMS에 `영구히 반영`

 ROLLBACK; 

`취소`

:star:

③

```sql
UPDATE DEPT SET LOC='미개척지역';  -- 주의사항: WHERE절 생략시 전체 ROW가 처리됩니다. 
```



## DELETE

![image-20200513111807956](images/image-20200513111807956.png)





## MERGE

[요구]MERGE SQL 작성 





## DML SUBQUERY

![image-20200513131330117](images/image-20200513131330117.png)

`SELECT가 먼저 실행되어` `그 값을 가지고 INSERT가 실행된다.`

⑦ INSERT를 취소



![image-20200513131341986](images/image-20200513131341986.png)

원하는 데이터를 가공처리해서 데이터에 INSERT 가능



```SQL
INSERT INTO BONUS(ENAME, JOB, SAL, COMM)
    SELECT ENAME, JOB, SAL, DECODE(DEPTNO, 10, SAL*0.3,
                                           20, SAL*0.2)+NVL(COMM,0)
    FROM EMP
    WHERE DEPTNO IN (10,20);
```

⑫ 이 상태에서는 ROLLBACK을 한다고해서 **COMMIT 된 정보가 취소되진 않는다.**



![image-20200513131351372](images/image-20200513131351372.png)

SUBQUERY가 올 수 있다.

![image-20200513131431715](images/image-20200513131431715.png)





## :star::star:TRANSACTION

:star: A logical unit of work

![image-20200513134011237](images/image-20200513134011237.png)



:star: :star: (시험)트랜잭션은 일원까지도 고지해줘야 한다 (일원고지)

모델링의 3단계 : 개념 모델링, 논리 모델링, 물리 모델링

 

![image-20200513152944020](images/image-20200513152944020.png)

:star: 트랜잭션의 시작과 종료

트랜잭션의 시작: **첫번째 실행/변경가능한 SQL(executable SQL) 실행시** 

트랜잭션의 종료: 1. 명시적 종료 - **commit** or **rollback**

​							  2. 암시적(묵시적) 종료 - 

 ②~⑦사이에 일어난 모든 변경사항을 취소하고 트랜잭션을 종료한다.

![image-20200513153001061](images/image-20200513153001061.png)



⑩ COMMIT; DBMS에 영구히 저장 후 트랜잭션 종료

⑪ ROLLBACK `WORK`;  WORK는 ANSI표준, 생략 가능하다.

⑫ ROLLBCAK 했기때문에 데이터가 변경되지 않았다.



`DDL`이 있는 경우 어떻게 될까? DDL은 ROLLBACK이 되지 않는다.

:star: DDL 구문이 시작하면 시작하기 전에 `암시적으로 COMMIT`이 이뤄진다. 그리고 시작된다.

![image-20200513160006984](images/image-20200513160006984.png)

② 성별에 아무런 값도 없으면 M을 넣는다.

**①~②**는 **③**으로 인해 취소되지 않는다.

**⑤**는 **⑥**으로 인해 취소되지 않는다.

```SQL
INSERT INTO EMP(EMPNO,ENAME,DEPTNO)  VALUES(9999,'OCPOK',20); -- DML 
ALTER  TABLE  EMP ADD( SEX   CHAR(1)  DEFAULT 'M'); -- DDL (COMMIT이 이뤄지고 시작)
ALTER  TABLE  EMP ADD( SEX2   CHAR(1)  DEFAULT 'M');  -- DDL
SELECT * FROM EMP;
ROLLBACK;
SELECT * FROM EMP;
ALTER TABLE EMP DROP COLUMN  SEX2; -- DDL
DESC EMP;
ROLLBACK;
DESC EMP;
```





![image-20200513164614427](images/image-20200513164614427.png)

ORACLE은 `AUTOCOMMIT`을 지원하진 않는다.

1) DDL 수행시 ,  데이터베이스 정상적으로 접속 종료시 

`트랜잭션의 암시적 종료` -> 오라클에서 되는 것은 아님

2) 비정상 접속 종료시, DBMS 비정상 종료시

`트랜잭션의 묵시적 종료`

진행중인 트랜잭션은

1] `클라이언트` 오류로 프로그램 비정상 종료 에러 발생시 - ROLLBACK 처리

2] `네트워크` 등등으로 인한 커넥션 비정상 접속 종료시 - 비정상적으로 종료되는 경우 DBMS가 자동으로 ROLLBACK처리한다.

3] `서버`인 DBMS 비정상 종료시 - 비정상적으로 종료되는 경우 DBMS가 자동으로 ROLLBACK처리한다. 



## ROLLBACK LEVEL



트랜잭션의 원자성을 알 수 있는 예시

![image-20200513165954390](images/image-20200513165954390.png)



③ 트랜잭션 시작

④ UPDATE  /* STATEMENT LEVEL ROLLBACK */  EMP SET SAL = 123456789 WHERE EMPNO = 7788; 

급여가 9자리

하지만 EMP의 SAL컬럼은 NUMBER(7,2)이므로 정수자리 5자리까지만 허용한다.

그래서 ERROR 발생



SQL 문장만 묶어둬서는 트랜잭션 제어를 할 수 없다.

③ 처리완료

④ 처리안됨

⑤ 처리완료





PL/SQL: BLOCK으로 구조화된 언어

![image-20200513170909834](images/image-20200513170909834.png)

SQL 문장 묶음 만으로는 트랜잭션 제어를 할 수 없어서 PL/SQL을 작성해서

예외처리를 해야한다.

그래서 예외가 발생해서 ROLLBACK 이 이뤄진다.



:star:PL/SQL에서는 `EXCEPTION`이 없으면 `오류가 난 이후의 statement`는 실행이 안된다. 그리고 PL/SQL을 빠져나온다.



## TRANSACTION과 읽기일관성(READ CONSISTENCY)

![image-20200514092934220](images/image-20200514092934220.png)



## :star:TRANSACTION 과 Row Level Lock 



![image-20200514112813879](images/image-20200514112813879.png)

② 진행된다.

③ 진행이 되지않고, 다른 세션이 트랜잭션을 commit을 하거나 rollback 하기를 기다린다.





## SELECT *  FOR UPDATE (ROW LEVEL LOCK)

![image-20200514130400257](images/image-20200514130400257.png)



select는 변경하지 않고 조회만 한다는 점이 중요

:star:`update`, `delete` 만 row level lock이 자동으로 걸린다. 그래서

`select`도 row level lock이 걸릴 수 있도록 `for update` 옵션을 붙여준다.



![image-20200514131817682](images/image-20200514131817682.png)



![image-20200514131831372](images/image-20200514131831372.png)

10초 기다리고 wait하면 ②를 종료

![image-20200514132446222](images/image-20200514132446222.png)

실행이 안되고 종료





근데,

session1에서 deptno=10에 대해서 특정 기준을 가지고 정보를 변경하고자 row level rock을 검

session2에서 insert를 deptno=10에 관련한거로 하게되면,

session1에서 다루는 내용은 session2와 상관없는 데이터를 가지고 할테니까 

데이터 무결성이 깨지는게 아닌가?







