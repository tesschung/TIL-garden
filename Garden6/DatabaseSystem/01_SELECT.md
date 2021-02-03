## 03_200507

[toc]





## 과제

**pdf 요구에 적힌 (파란색으로 하이라이트한) 과제**​



:star::star: ​다음날 발표

:star: 다른사람이 발표​



-- 암기해서 작성하게 됨, 어차피 외우게 된다.

```sql
SELECT
TO_CHAR(SYSDATE ,'yyyy/mm/dd'), --오늘 날짜  
TO_CHAR(SYSDATE + 1 ,'yyyy/mm/dd'), --내일 날짜  
TO_CHAR(SYSDATE -1 ,'yyyy/mm/dd'), --어제 날짜  
TO_CHAR(TRUNC(SYSDATE,'dd') ,'yyyy/mm/dd hh24:mi:ss'), -- 오늘 정각 날짜
TO_CHAR(TRUNC(SYSDATE,'dd') + 1,'yyyy/mm/dd hh24:mi:ss'), -- 내일 정각 날짜
TO_CHAR(SYSDATE + 1/24/60/60 ,'yyyy/mm/dd hh24:mi:ss'), -- 1초 뒤 시간
TO_CHAR(SYSDATE + 1/24/60 ,'yyyy/mm/dd hh24:mi:ss'), -- 1분 뒤 시간
TO_CHAR(SYSDATE + 1/24 ,'yyyy/mm/dd hh24:mi:ss'), -- 1일 뒤 시간
TO_CHAR(TRUNC(SYSDATE,'mm') ,'yyyy/mm/dd'), --이번 달 시작날짜
TO_CHAR(LAST_DAY(SYSDATE) ,'yyyy/mm/dd'), --이번 달 마지막 날
TO_CHAR(trunc(ADD_MONTHS(SYSDATE, + 1),'mm') ,'yyyy/mm/dd'), --다음 달 시작날짜
TO_CHAR(ADD_MONTHS(SYSDATE, 1) ,'yyyy/mm/dd hh24:mi:ss'), -- 다음달 오늘 날자
TO_CHAR(TRUNC(SYSDATE, 'yyyy') ,'yyyy/mm/dd'), --올해 시작 일
TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, -12), 'dd'),'yyyy/mm/dd'), --작년 현재 일
TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE('19930315'), -- 두 날짜 사이 일수 계산
MONTHS_BETWEEN(SYSDATE, '19930315'), -- 두 날짜 사이의 월수 계산
TRUNC(MONTHS_BETWEEN(SYSDATE, '19930315')/12,0) --두 날짜 사이의 년수 계산
FROM
DUAL; 

SELECT

TO_CHAR(SYSDATE,'YYYY/MM/DD HH24:MI:SS')||':'

||TO_CHAR(SYSTIMESTAMP,'FF4') AS NOW

FROM DUAL;

'FF1' : 1/10 초

'FF2' : 1/100초

'FF3' : 1/1000초

'FF4' : 1/10000초

-- FF는 밀리세컨드를 의미
```



:star::star: 현재 시간,분,초,1/100초 까지 표현하는 SQL 작성   

```sql
SELECT TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF2') as TIME FROM DUAL;
```



:star: :star:현재 시간,분,초,1/1000초 까지 표현하는 SQL 작성  

```sql
SELECT TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') as TIME FROM DUAL;
```

-> FF: fractical seconds



![image-20200507095428122](images/image-20200507095428122.png)

```sql
select ename, sal, comm, comm + sal*0.3 as bonus from emp;
```

![image-20200507102804512](images/image-20200507102804512.png)

보면, COMM과 SAL중에 둘 중하나가 NULL인 경우 연산시 NULL이 반환되는 것을 볼 수 있다. 때문에 이를 예외처리 해주어야 한다.



![image-20200507101448845](images/image-20200507101448845.png)

```sql
-- nvl 사용
select ename, sal, comm, 
nvl(comm,0) + sal*0.3 as bonus from emp;
```

![image-20200507103140150](images/image-20200507103140150.png)

```sql
-- decode 사용
select ename, sal, comm, 
decode(comm, null, 0, comm) + sal*0.3 as bonus from emp;
```

![image-20200507103222850](images/image-20200507103222850.png)





![image-20200507101424350](images/image-20200507101424350.png)

```sql
select count(*) from scott.emp;
```

![image-20200507100511611](images/image-20200507100511611.png)

scott.emp에서 count(*)는 group row 함수로 해당 테이블에 존재하는 데이터 개수를 하나의 값으로 출력된다.



```sql
select count(*) from scott.emp where 1=1;
```

![image-20200507100625135](images/image-20200507100625135.png)

scott.emp에서 count(*)는 group row 함수로 해당 테이블에 존재하는 데이터 개수를 하나의 값으로 출력된다. where절이 true이므로 모든 값이 그 대상이 된다. 



`=`는 NULL을 비교하지 않으므로, 그 테이블에 NULL 값이 있는 경우 해당 행을 제외하고 비교한 결과를 출력한다. 그래서 앞의 3 종류의 SQL은 다른 결과를 출력한다. *NULL은 비교불가

```sql
select count(*) from scott.emp where empno = empno; -- 14 출력 , empno에는 NULL이 없다
select count(*) from scott.emp where mgr = mgr; -- 13 출력 , mgr에는 1개의 NULL이 있다.
select count(*) from scott.emp where comm = comm; -- 4 출력 , comm에는 10개의 NULL이 있다.
```



![image-20200507101409195](images/image-20200507101409195.png)

```sql
select sal, comm, nvl(comm, sal), nvl2(comm, sal, 0), nullif(job, 'MANAGER') from emp;
```



`NVL` 함수는 값이 null인 경우 지정값을 출력한다.

\- 함수 : **NVL(**"값", "지정값"**)**

`NVL2` 함수는 null이 아닌경우 지정값1을 출력하고, null인 경우 지정값2을 출력 한다.

\- 함수 : **NVL2(**"값", "지정값1", "지정값2"**)**

`NULLIF`

\- 함수 : **NULLIF**("exp1", "exp2")

\- exp1값과 exp2값이 동일하면 NULL을 그렇지 않으면 exp1을 반환



\- CASE WHEN expr1 = expr2 THEN NULL ELSE expr1 END



:star:③ SELECT DISTINCT JOB FROM EMP;     // 차이점?  ANSI ? 

③ 실행 결과가 Oracle 9i 에서는 정렬되어 나타나지만 Oracle 10g이후 버전부터는 정렬된 결과가 나타나지 않는다. 이유를 찾아 설명 하십시요 

DISTINCT가 9i일때랑 10`g`일때 다르다. `g `= grid 분산컴퓨팅, `c` =  cloud

```sql
select distinct job from emp; -- oracle 9i 버전
-- sort가 없이 보여진다.
```

![image-20200507132701563](images/image-20200507132701563.png)

9i는 sort, 이진탐색

10g는 hash



Hash

- value to address (값을 주소로 변경해준다.)

Hash 용도

- **무결성 (검증)**
- **DAM (Direct Access Method) 원하는 위치에 직접**
- **보안 (단방향 고정길이 출력)**







:star: :star:다음의 집합 연산자 UNION, UNION ALL,INTERSECT, MINUS를 공부한 후 각각의 예제 SQL을 만든후 결과가 왜 정렬되는지 설명 하십시오.

![image-20200508092426512](images/image-20200508092426512.png)

수직결합: 집합연산자 					:star: 가로결합: JOIN



```sql
-- 데이터베이스 준비

CREATE TABLE A (
    ACOUNTRY VARCHAR2(40),
    AAGE NUMBER(3)
);

-- 오라클은 다중 INSERT가 안된다.
INSERT INTO A VALUES ('argenina', 1);
INSERT INTO A VALUES ('australia', 2);
INSERT INTO A VALUES ('belgium', 3);
INSERT INTO A VALUES ('brazil', 4);
INSERT INTO A VALUES ('canada', 5);
INSERT INTO A VALUES ('switzerland', 6);

select * from A;


CREATE TABLE B (
    BNCOUNTRY VARCHAR2(40),
    BAGE NUMBER(3)
);

INSERT INTO B VALUES ('china', 7);
INSERT INTO B VALUES ('germany', 8);
INSERT INTO B VALUES ('denmark', 9);
INSERT INTO B VALUES ('egypt', 10);
INSERT INTO B VALUES ('france', 11);
INSERT INTO B VALUES ('argentina', 1);

select * from B;
```

![image-20200507173619381](images/image-20200507173619381.png)

`union` 합집합 - 중복된 행은 하나의 행으로 만든다. **중복 제거**

```SQL
SELECT * FROM A
UNION
SELECT * FROM B;
```



![image-20200507173649850](images/image-20200507173649850.png)





UNION 연산결과가 정렬된 이유는 두 집합의 중복데이터를 걸러내기 위해, SORT-UNIQUE연산을 수행하기때문이다.

*SORT-UNIQUE이란?  선택된 결과집합에서 중복 레코드를 제거하고자 할 때 나타남. (Union/distinct연산)

*컬럼의 개수가 같고 데이터 형식이 같아야한다

`union all` 합집합 - 중복된 행이 결과에 표시된다. 중복을 제거하지 않는다.

```SQL
SELECT * FROM A
UNION ALL
SELECT * FROM B;
```

![image-20200507173700917](images/image-20200507173700917.png)

그래서 sort가 일어나지 않는다.



`intersect` 교집합 - A와 B에서 **중복되는 결과**만 출력한다.

```SQL
SELECT * FROM A
INTERSECT
SELECT * FROM B;
```

![image-20200507173710887](images/image-20200507173710887.png)

INTERSECT 연산결과가 정렬된 이유는 두 집합의 중복데이터를 찾기위해 SORT-UNIQUE연산을 수행하기 때문이다.



`minus` 차집합 - A와 B에서 **중복된 결과**를 제외한 A를 출력한다.

```SQL
SELECT * FROM A
MINUS
SELECT * FROM B;
```

![image-20200507173731711](images/image-20200507173731711.png)



```sql
SELECT ENAME,JOB,SAL,DEPTNO FROM EMP WHERE SAL > 2000  OR  SAL > 2000;  
```



![SQLite Query Language: SELECT](images/compound-select-stmt.gif)



A compound SELECT created using UNION ALL operator returns all the rows from the SELECT to the left of the UNION ALL operator, and all the rows from the SELECT to the right of it. The UNION operator works the same way as UNION ALL, except that duplicate rows are removed from the final result set. The INTERSECT operator returns the intersection of the results of the left and right SELECTs. The EXCEPT operator returns the subset of rows returned by the left SELECT that are not also returned by the right-hand SELECT. Duplicate rows are removed from the results of INTERSECT and EXCEPT operators before the result set is returned.



:star: :star:Interactive SQL 과 Embeded SQL를 **설명** 하고 각각의 **사용예**를 찾아서 기록하고 해석 하십시요 

`Interactive SQL (대화식 SQL)`

수업시간에 사용하는 SQL. DBMS와 의사소통(요청)하기 위해 사용한다.

```sql
select * from emp;
```



> > :star: sql은 dbms에 접근하는 유일한 언어라는 특징을 갖고 있다고 했다!
> >
> > 결국 python, java 프로그램에서 dbms에 접근하기 위해 sql을 사용한다.라고 이해했습니다.



`Embedded SQL(내포된 SQL)`

https://movefast.tistory.com/89?category=792378

**고급 프로그래밍 언어<호스트 프로그래밍 언어>에 내포되어 사용되는 SQL을 말한다.**

`호스트 언어`란 `C`, `Java`같은 프로그래밍 언어를 의미한다.

\* DECLARE : 커서를 정의하는 등 커서에 관련된 선언을 하는 명령어

\* OPEN : 커서가 질의 결과의 첫 번째 튜플을 가리키도록 설정하는 명령어

\* FETCH : 질의 결과에 대한 튜플들 중 현재의 다음 튜플로 커서를 이동시키는 명령어

\* CLOSE : 질의 실행 결과에 대한 처리 종료 시 커서를 닫기 위해 사용하는 명령어

필요이유: **애플리케이션에서 sql을 사용해야하는 경우 사용하기 위해서 호스팅언어에 내재한 sql**



![Embedded SQL Host Language (images/slide_1.jpg) DBMS (set-oriented) 1 ...](https://images.slideplayer.com/18/6173803/slides/slide_1.jpg)



C/C++에서 내장 SQL문은 "EXEC SQL"과 세미콜론(;) 문자 사이에 기술한다.

```c
salaryIncrease()
{
 EXEC SQL BEGIN declare section;
 char SQLSTATE[6];
 EXEC SQL END declare section;
 
 EXEC SQL DECLARE employeeCur CURSOR FOR 직원;
 
 EXEC SQL OPEN employeeCur;
  while(1) {
   EXEC SQL FETCH employeeCur;
   if(!(strcmp(SQLSTATE,"02000"))) break;
    if(2011 - 입사년도 >= 15)
     EXEC SQL UPDATE 직원
     SET 연봉 = 연봉 + (연봉*0.15)
     WHERE CURRENT OF employeeCur;
    else if (2011 - 입사년도 >= 10)
     EXEC SQL UPDATE 직원
     SET 연봉 = 연봉 + (연봉*0.1)
     WHERE CURRENT OF employeeCur;
    else if (2011 - 입사년도 >= 5)
     EXEC SQL UPDATE 직원
     SET 연봉 = 연봉 + (연봉*0.05)
     WHERE CURRENT OF employeeCur;
  }
  EXEC SQL CLOSE employeeCur;;
}

출처: https://androphil.tistory.com/341?category=455850
```

java

![image-20200508081707489](images/image-20200508081707489.png)





***먼저 interactive하게 sql을 만들어서 host language에서 가져와서 작성하는 것이 중요.**

embedded sql으로 작성하면 sql에서 오류가 나는지, 호스트 언어에서 오류가 나는지 알 수 없기 때문이다.

interactive하게 sql을 만들면 오류를 바로 바로 확인가능해서 1. 기능검증 2. 성능검증을 통해 정상적인 sql 작성이 가능하다.



:star: 급여가 2500인경우 어떤걸 리턴하는지 HIGH? MID? LOW?



![image-20200507135346104](images/image-20200507135346104.png)

`MID` 리턴

바뀌면 `LOW` 리턴





:star:

victim 이름 출력

select ceil(dbms_random.value(0.1,21.1)) as victim from dual;

decode or case사용





:star::star: :star:

![image-20200507144229953](images/image-20200507144229953.png)

*rownum의 실행순서 때문에 문제 발생

Top-N, Bottom-M 최상위 데이터, 최하위 데이터 출력할 것

rownum, **subquery**, order by



Top-N

```SQL
-- 실행순서 때문에 
-- 결과집합에 ROWNUM을 추가해주자
-- subquery에서 * 으로 해야 main query에서 해당 테이블 확인 가능
SELECT DEPTNO, ENAME, SAL 
  FROM(SELECT * 
       FROM EMP 
       ORDER BY SAL DESC
  	   ) 
 WHERE ROWNUM <= 5;
```

![image-20200507150140191](images/image-20200507150140191.png)



Bottom-M 

```SQL
SELECT DEPTNO, ENAME, SAL 
  FROM(SELECT * 
       FROM EMP 
       ORDER BY SAL ASC
       ) 
WHERE ROWNUM <= 5;
```

![image-20200507150223394](images/image-20200507150223394.png)



서브쿼리(**Subquery**)란 하나의 SQL 문 안에 포함되어 있는 또 다른 SQL문을 말한다. 서브쿼리는 메인쿼리가 서브쿼리를 포함하는 종속적인 관계이다.

다른 `SQL문` 안에 포함된 `SELECT문`이 `subquery`이다.

Main Query -> `select`, `insert`, `delete`, `update`

Sub Query -> 반드시 `select`만 올 수 있다.

*Sub Query가 먼저 실행된다. -> 결과집합(메타데이터)가 생성된다. 이를 통해서 Main Query가 실행된다.



:star:*Pseudo Column에 대한 정의를 설명하고 사용예제 SQL을 작성 하십시요

가짜의, 가상의

데이터가 테이블 내에 저장되지 않는 컬럼

예시 ROWNUM



:star:결과집합(result set)이란?

SQL 결과 집합은 데이터베이스의 행 집합뿐만 아니라 열 이름, 각 열의 유형 및 크기와 같은 쿼리에 대한 **메타 데이터**(데이터를 위한 데이터)입니다.









## 참고

**과제설명**



**sql syntax diagram**

![image-20200507091135200](images/image-20200507091135200.png)



DISTINCT(ORACLE)/UNIQUE(ANSI표준) 같은 기능

FROM절에 여러개의 데이터 집합이 올 수 있고, 구분은 `,`할 수 있다.



![image-20200507091804625](images/image-20200507091804625.png)



order_by_clause

:star:order by는 select 문장의 가장 마지막에 위치하고(문법적), 가장 마지막에 실행된다(실행순서).



**데이터와 정보의 차이 (데이터->정보->지식)**

데이터(data) - 현실세계에서 특정 수집된 사실(fact) 또는 값(value)

정보(information) - 사용자의 의사결정에 도움을 주는 가공된 데이터들의 집단.

지식(knowledge) - :star:유의미한 정보를 모아서 실생활에 적용하는 지식이 된다.





**데이터베이스와 데이터베이스관리시스템**

데이터베이스 - 조직의 응용시스템들이 공유해서 사용하는 운영데이터들이 구조적으로 통합된 집합체, 

학사행정DB, 인사DB, 회계DB



데이터베이스관리시스템 - 데이터베이스를 관리하는 소프트웨어 프로그램, sql developer, DB2







## SELECT 실습 





## NULL

:star:

![image-20200507093350682](images/image-20200507093350682.png)

*`NULL`은 숫자타입인 0이나 공백문자가 아니다. 0이나 공백문자는 데이터이다.

*:star: **제** 어 불가

​		**비**  교 불가

​		**연**  산 불가

![image-20200507093426989](images/image-20200507093426989.png)

*:star: **함수와의 관계** 외울 것

​		함수에 입력되는게 한개인지 n개인지에 따라 single row인지 group row인지 달라진다.

​		1. single row -> NULL을 반환한다.		

​		2. group row -> NULL을 무시하고 나머지 연산을 한다.

​		3. NULL 무시함수 -> concat() ,  nvl() ,  decode()

*5번 error

*6번 NULL

*7번 NULL

![image-20200507093955046](images/image-20200507093955046.png)

![image-20200507093524401](images/image-20200507093524401.png)

*10번, NULL인 데이터는 조회가 안된다.

![image-20200507094122866](images/image-20200507094122866.png)

*13번 14번처럼 :star: `IS NULL`, `IS NOT NULL` 연산자를 사용해서 비교해야한다. (암기)



![image-20200507094245174](images/image-20200507094245174.png)

*`적용불가`==`제어불가`

*1번 LENGTH(COMM)

LENGTH는 문자열의 길이를 리턴하는 함수, COMM은 숫자. 때문에 묵시적(암시적) 형변환이 발생한다.

![image-20200507094445977](images/image-20200507094445977.png)

![image-20200507094525417](images/image-20200507094525417.png)

TO_CHAR()으로 명시적 형변환을 통해 연산하는 것이 바람직하다.

*2번 ABS(SAL-COMM) `둘 중 하나라도 NULL이 있는 경우 NULL을 반환`



![image-20200507094735394](images/image-20200507094735394.png)

*3번 CONCAT()문자+문자

```sql
select concat(ENAME||' is ', COMM) from emp;
```

![image-20200507100127221](images/image-20200507100127221.png)



*:star: NVL(COMM, -1) 만약 `NULL` 이면 `-1`로 바꿔주기

*:star: DECODE(COMM, 

​						NULL, 

​						-999, 

​						COMM) sql의 `조건문`, 만약에 `COMM`이 `NULL`이면 `-999` 그렇지 않다면 `COMM`





![image-20200507111744301](images/image-20200507111744301.png)



sqldeveloper이 `(null)`으로 표시해준 것, 사용하는 tool마다 다르게 표시될 수 있다는 점

```sql
select empno, sal, comm, length(comm) from emp;
```

![image-20200507111957357](images/image-20200507111957357.png)



```sql
select sum(comm), avg(comm), count(comm) /*null이 아닌 데이터 4건을 출력*/, count(*) from emp;
-- comm에는 null이 존재
-- grouping 함수는 null을 무시하고 연산
-- 그래서 0으로 nvl함수나 그런걸 쓴 후 avg를 사용해야 한다.
```





## ORDER BY



다음과 같이 네 가지가 ORDER BY 뒤에 올 수 있다.

> name

⑨ SELECT ENAME,SAL,HIREDATE FROM EMP ORDER BY ENAME;  

> position

⑩ SELECT ENAME,**SAL**,HIREDATE FROM EMP ORDER BY **2**;  

*SAL이라는 컬럼으로 정렬

> :star: alias

⑪ SELECT ENAME,SAL*12 as **annual_SAL** FROM EMP ORDER BY **annual_SAL**;

> expression

⑫ SELECT EMPNO,ENAME,COMM,JOB  FROM EMP ORDER BY COMM * 12; 



아래의 SQL은 선택하지 않은 column을 기준으로 정렬이 가능한가? 

```sql
SELECT ENAME,HIREDATE  FROM EMP ORDER BY SAL desc; 
```



ORDER BY시 NULL의 위치는? NULL은 가장 큰값인가?

```sql
SELECT EMPNO,COMM FROM EMP ORDER BY COMM asc; 
SELECT EMPNO,COMM FROM EMP ORDER BY COMM desc;
```

*`NULL`은 크다 작다가 아니라 `NULL`을 `제일 큰 값으로 간주하므로` oracle의 sql developer에서는

`asc`를 할 경우 맨 아래에 출력된다.

`desc`를 할 경우 맨 윗줄에 출력된다.





## DISTINCT

![image-20200507131851477](images/image-20200507131851477.png)

*아니다. 조회하는 것



![image-20200507131916172](images/image-20200507131916172.png)

*DISTINCT ANSI

*UNIQUE oracle

![image-20200507131951845](images/image-20200507131951845.png)



```sql
select distinct comm from emp;
```

![image-20200507132044213](images/image-20200507132044213.png)

```sql
select count(distinct comm) from emp;
```

![image-20200507132152276](images/image-20200507132152276.png)

*count()를 하게되면 NULL을 제외한 4가 결과가 된다.





> 이미 해서 통과

⑥ SELECT DISTINCT JOB, DISTINCT DEPTNO FROM EMP;   범위?

⑦ SELECT JOB, DISTINCT DEPTNO FROM EMP;  위치?

⑥⑦ SQL이 왜 에러가 나는지 2페이지의 Select Syntax Diagram을 보고 설명 하십시요 







## DECODE, CASE



DECODE가 처음 나옴

DECODE 조건절



```SQL
① SELECT DEPTNO, ENAME, DECODE(DEPTNO,10,'ACCOUNTING',20,'RESEARCH',30,'SALES','ETC') FROM  EMP   ORDER BY DEPTNO; 
-- 만약에 부서번호가 10이면 ACCOUNTING, 20이면 RESEARCH, 30이면 SALES, ELSE ETC
-- 부서번호가 아닌 이름을 리턴하게 된다.
```



```SQL
② SELECT COMM, DECODE(COMM,NULL,-99,COMM) FROM EMP; 
```



```SQL
③ SELECT GREATEST(3000,1500,2100,5000),LEAST(3000,1500,2100,5000) FROM DUAL ; 

SELECT DEPTNO, ENAME, SAL,     
DECODE(GREATEST(SAL,5000),SAL,'HIGH',
       DECODE(GREATEST(SAL,2500),SAL,'MID','LOW')) 
FROM EMP
ORDER BY DEPTNO; 

-- DECODE안에 DECODE를 중첩으로 작성
-- 범위연산
-- DECODE는 IF조건절에서 ==만 가능하다는 것을 위 SQL문으로 확인할 수 있다.

④ SELECT DEPTNO, ENAME, SAL,COMM,          // NULL ??       DECODE(GREATEST(COMM,5000),COMM,'HIGH',                                 DECODE(GREATEST(COMM,2500),COMM,'MID','LOW')) FROM EMP ORDER BY DEPTNO; 
-- NULL이 들어가면 GREATEST에서 문제가 발생
```





![image-20200507134944019](images/image-20200507134944019.png)

*WHEN SAL BETWEEN 300 AND 2500

300에서 2500사이면 LOW를 결과로 출력

*NULL인 경우 비교가 안되므로 NULL이 출력된다.



![image-20200507135605696](images/image-20200507135605696.png)



![image-20200507135616454](images/image-20200507135616454.png)

*:star: 8번이 정상적인 것, 왜냐하면 7번으로 할 경우 모든 급여를 1로 처리하게되기때문이다.

![image-20200507135735098](images/image-20200507135735098.png)







## ROWNUM

레코드에 부여된 번호

rownum은 where절로 레코드가 결정되고 난 후 부여된다.

![image-20200507142910994](images/image-20200507142910994.png)



```sql
-- from -> where -> rownum -> order by 순으로 실행된다.
select rownum, ename, deptno, sal from emp where deptno in (10,20) order by deptno,sal;
```

![image-20200507143541730](images/image-20200507143541730.png)



④ :star:

```sql
select ename, deptno, sal from emp where rownum = 1;

select ename, deptno, sal from emp where rownum = 5; -- 결과 안뜸
select ename, deptno, sal from emp where rownum > 5; -- 결과 안뜸

select ename, deptno, sal from emp where rownum <= 5;
select ename, deptno, sal from emp where rownum < 5;

-- rownum은 작거나 같다 혹은 1과 같다만 가능
```

*rownum은 1씩 증가하면서 과거의 비교대상을 확인하며 값을 갖게된다. 그래서 1부터 시작하는 뭐보다 작은~은 비교대상인 1부터 쭉 결과를 얻어가며 진행되기때문에 값이 도출된다. 하지만 비교대상이 없는 5보다 큰~ 같은 경우는 결과가 뜨지 않게된다.







## 논리 연산자 AND OR NOT



```sql
// 논리 연산자를 통해 여러 조건 사용 
⑤ 
SELECT ENAME,JOB,SAL,DEPTNO FROM EMP WHERE DEPTNO = 10 AND SAL > 2000
```



```sql
⑥
SELECT ENAME,JOB,SAL,DEPTNO FROM EMP WHERE DEPTNO = 10 OR  SAL > 2000; 
SELECT ENAME,JOB,SAL,DEPTNO FROM EMP WHERE SAL > 2000  OR  SAL > 2000;  
SELECT ENAME,JOB,SAL,DEPTNO FROM EMP WHERE SAL > 1000  OR  SAL > 2000;  
```

*or 연산자는 중복데이터를 걸러내서 보여준다.

![image-20200507145448863](images/image-20200507145448863.png)

`A and B or C`

\- :star: A and B가 먼저 연산된다.

\- 후보 결과집합(result set)이 덜 생성되기때문에 AND가 더 효율적이라고 OPTIMIZER가 판단하기 때문에 먼저 연산한다.

\- where절에 or을 많이 쓰면 성능이 느려진다.



[SQL] `OPTIMIZER(최적화기)`란? 

SQL을 가장 빠르고 효율적으로 수행할 최적(최저비용)의 처리경로를 생성해 주는 DBMS 내부의 핵심엔진이다. 사용자가 구조화된 질의언어(SQL)로 결과집합을 요구하면, 이를 생성하는데 필요한 처리경로는 DBMS에 내장된 옵티마이저가 자동으로 생성해준다. 옵티마이저가 생성한 SQL 처리경로를 실행계획(Execution Plan)이라고 부른다. 



```sql
⑨
SELECT ENAME,JOB,SAL FROM EMP WHERE JOB  != 'CLERK'; -- NOT EQUAL
SELECT ENAME,JOB,SAL FROM EMP WHERE JOB NOT IN('CLERK','MANAGER'); 
```





## BETWEEN 

범위연산자



BETWEEN A(하한) and B(상한)

자리 위치가 고정된 의미를 갖고있다. 왜냐하면 정해진 자리에 있는 값을 가지고 >=, <= 으로 변환해서 처리하기 때문이다.



① SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL BETWEEN 1000 AND 2000; 

1000에서 2000사이에 급여

② SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL >= 1000 and SAL <= 2000;

1000에서 2000사이에 급여

① 과 ②는 같은 결과를 나타낸다



③ SELECT EMPNO,ENAME,HIREDATE,SAL FROM EMP WHERE SAL between 2000 and 1000;    // ? 

큰수가 먼저 나와서 에러 발생

항상 상한이 왼쪽에 나와야한다.



④ SELECT EMPNO,ENAME,HIREDATE,SAL FROM EMP WHERE ENAME  between 'C' and 'K';    // 문자 

⑤ SELECT EMPNO,HIREDATE,SAL FROM EMP WHERE HIREDATE between '81/02/20' and '82/12/09'; // 날짜?? 
묵시적 형변환이 발생해서 날짜로 인식한다.



⑥ SELECT ENAME,HIREDATE,SAL FROM EMP WHERE HIREDATE between to_date('81/02/20','yy/mm/dd') and to_date('82/12/09','yy/mm/dd');   // ? 

1981인지 2081인지 yy로 할경우 sql이 알 수 없어서 데이터가 나오지 않는다.



SELECT ENAME,HIREDATE,SAL FROM EMP WHERE HIREDATE between to_date('1981/02/20','yyyy/mm/dd') and to_date('82/12/09','yy/mm/dd'); 

네 자리로 변경하면 데이터가 잘 나온다.



⑦ SELECT ENAME,HIREDATE,SAL FROM EMP WHERE  HIREDATE between to_date('81/02/20','rr/mm/dd') and to_date('82/12/09','rr/mm/dd');    

제대로된 데이터가 나온다.



```sql
select * from salgrade;
select * from salgrade where 3000 between losal and hisal;
```

![image-20200507160022810](images/image-20200507160022810.png)



![image-20200507160037758](images/image-20200507160037758.png)



## IN

리스트 연산자



![image-20200507164733594](images/image-20200507164733594.png)



⑧ 7369 OR 7521 OR 7654

⑩ 대소문자로 인해서 데이터가 출력되지 않는다.

```SQL
SELECT EMPNO,ENAME,JOB FROM EMP WHERE JOB in ('CLERK','MANAGER');   
-- 대문자로 수정
```

⑪ SELECT EMPNO,ENAME,HIREDATE FROM EMP WHERE HIREDATE IN ('81/05/01','81/02/20'); // 날짜? 

원래 HIREDATE의 타입이 `DATE`이므로 `DATE타입`과 `rr`로 `묵시적 형변환`이 이뤄진것을 알 수 있다.

⑬ SELECT EMPNO,ENAME,JOB FROM EMP WHERE EMPNO IN (`7369`,`7369`,7654); 

`7369`가 두 번있지만, 결과에서 중복되어서 나오진 않는다.

![image-20200507165235622](images/image-20200507165235622.png)





## ANY(=SOME), ALL





## LIKE

![image-20200507170449906](images/image-20200507170449906.png)

```sql
⑭ SELECT ENAME,SAL FROM EMP WHERE SAL like 2%; -- error발생
-- like는 문자 패턴 매칭 연산자 이므로 like 앞에는 반드시 문자가 와야한다.
```



*이름에 _ 가 들어가 있는 사원들을 전부 찾고 싶다.. 방법은 ? -힌트 : escape option 

```sql
select ename from emp where ename like '*_' escape '*';

-- 위를 활용해서 %가 들어가있는 사원들도 찾을 수 있다.
select ename from emp where ename like '*%' escape '*';
```



```sql
⑬ SELECT ENAME,HIREDATE FROM EMP WHERE HIREDATE like '81%';   
⑮ SELECT ENAME,SAL FROM EMP WHERE SAL like '2%';  
-- sal은 타입이 숫자, like는 문자
-- 타입이 다르면 항상 맞춰놓고 연산을 한다.
-- like 연산자 특징에 의해서 문자가 숫자로 바뀌지는 않고, 숫자인 sal이 문자로 바뀐다.

select empno, ename from emp where empno = '7369';
-- 숫자인데 결과가 나온다.
```

*묵시적 형변환 발생해서 에러없이 결과를 조회할 수 있다.

