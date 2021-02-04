## 05_200509

[toc]



## 과제

:star: 한 번에 실행하는 트랜잭션 파일을 생성하기

sql -> sql script file

`sql script file` 1.**텍스트 파일이다(어떤 편집기도 읽을 수 있다).** 2. **N개의 sql을 저장하고 실행할 수 있다.** 3. 반복 실행할 수 있다.



서버별 사용 현황을 나타내는 join 구문을 작성



:star:

emp

salgrade 이용

rownum, group by 사용

SELFJOIN



:star:

rank와 dense_rank의 차이점









:star: 조인활용

급여비율 = 전체받는급여 중 개개인이 차지하는 비율

 

위 과제에 대한 내용

```SQL
-- MAKE_ENV.SQL 실습환경 구성
-- sql developer에서는 클릭으로
-- sql plus에서는
-- sqlplus / as sysdba
-- conn hr/hr
-- cd C:\Users\seung\03_SQL
-- C:\Users\seung\03_SQL> sqlplus / as sysdba
-- SQL> @MAKE_ENV
CREATE TABLE SYSTEM(
                    SYSTEM_ID VARCHAR2(5),
                    SYSTEM_NAME VARCHAR(10)
);

INSERT INTO SYSTEM  VALUES('XXX','혜화DB'); 
INSERT INTO SYSTEM  VALUES('YYY','강남DB'); 
INSERT INTO SYSTEM  VALUES('ZZZ','영등포DB'); 

CREATE TABLE RESOURCE_USAGE(SYSTEM_ID     VARCHAR2(5),
                            RESOURCE_NAME VARCHAR2(10)
);

INSERT INTO RESOURCE_USAGE  VALUES('XXX','FTP'); 
INSERT INTO RESOURCE_USAGE  VALUES('YYY','FTP'); 
INSERT INTO RESOURCE_USAGE  VALUES('YYY','TELNET'); 
INSERT INTO RESOURCE_USAGE  VALUES('YYY','EMAIL'); 
COMMIT;

SELECT  S.SYSTEM_ID,S.SYSTEM_NAME,R.RESOURCE_NAME 
  FROM   SYSTEM S, RESOURCE_USAGE R 
  WHERE  S.SYSTEM_ID = R.SYSTEM_ID; 
  
SELECT S.SYSTEM_ID,S.SYSTEM_NAME,R.RESOURCE_NAME 
 FROM   SYSTEM S,RESOURCE_USAGE R 
 WHERE  S.SYSTEM_ID = R.SYSTEM_ID(+); 
  
SELECT * FROM SYSTEM;
SELECT * FROM RESOURCE_USAGE;

--DROP TABLE SYSTEM;


-- 과제 1
SELECT  
S.SYSTEM_ID,
S.SYSTEM_NAME,
MAX(DECODE(R.RESOURCE_NAME, 'FTP', '사용', '미사용')) AS FTP,
MAX(DECODE(R.RESOURCE_NAME, 'TELNET', '사용', '미사용')) AS TELNET,
MAX(DECODE(R.RESOURCE_NAME, 'EMAIL', '사용', '미사용')) AS EMAIL
FROM   SYSTEM S, RESOURCE_USAGE R 
WHERE  S.SYSTEM_ID = R.SYSTEM_ID (+)
group by S.SYSTEM_ID, S.SYSTEM_NAME; 
-- MAX는 그룹행함수,
-- 문자는 ASCII 코드로 비교되므로 "사"용이 "미"사용보다 더 높아서 사용이 된다.
-- ㄱㄴㄷㄹㅁㅂㅅ순으로 커진다.
-- 한글의 경우 자음 < 모음 < 한글 순으로 가장 큰 값이 되고, 가-나-다-라-마-바-사 순으로 커진다.

SELECT GREATEST('사용', '미사용') FROM DUAL;
SELECT  
S.SYSTEM_ID,
S.SYSTEM_NAME,
DECODE(R.RESOURCE_NAME, 'FTP', '사용', '미사용') AS FTP,
DECODE(R.RESOURCE_NAME, 'TELNET', '사용', '미사용') AS TELNET,
DECODE(R.RESOURCE_NAME, 'EMAIL', '사용', '미사용') AS EMAIL
FROM   SYSTEM S, RESOURCE_USAGE R 
WHERE  S.SYSTEM_ID = R.SYSTEM_ID (+)
ORDER BY SYSTEM_NAME;

-- 과제 2
SELECT 
A.DEPTNO AS 부서번호, 
A.ENAME AS 이름, 
A.JOB AS 직업, 
A.SAL AS 급여,
COUNT(DISTINCT B.SAL) AS "급여순위"
FROM EMP A, EMP B 

WHERE A.DEPTNO = B.DEPTNO AND A.SAL <= B.SAL 

group by A.DEPTNO, A.ENAME, A.JOB, A.SAL 
ORDER BY A.DEPTNO ASC, A.SAL DESC;
-- 실행순서 where - group by - having - order by
-- 결과집합의 활용

-- where로 1차로 rs를 만들고,
-- group by로 select로 선택할 데이터에 대해서 2차로 rs를 만든다.
-- 그리고 order by를 하기 전에 select의 count()에서 2차로 만든 rs에 있는 b.sal을 가지고 distinct를 제외한 개수를 급여순위 데이터로 한다. 



-- 과제 3 RANK, DENSE_RANK 함수 사용
-- RANK : 동일한 값이면 중복 순위를 부여하고, 다음 순위는 해당 개수만큼 건너뛰고 반환한다.  
-- DENSE_RANK : 동일한 값이면 중복 순위를 부여하고, 다음 순위는 중복 순위와 상관없이 순차적으로 반환한다.
SELECT DEPTNO, ENAME, JOB, SAL,RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "급여순위"
FROM EMP; 

SELECT DEPTNO, ENAME, JOB, SAL,DENSE_RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "급여순위"
FROM EMP; 


-- 과제 4 
-- 급여비율 = 전체받는급여 중 개개인이 차지하는 비율
SELECT deptno, ename, job, sal, 
       to_char(round((sal/sum_sal) * 100, 2), '99.99') || '%' as sal_rate 
FROM EMP , (select sum(sal) as sum_sal from emp); 
 
SELECT deptno, ename, job, sal, 
       to_char(round((sal/(select sum(sal) from emp)) * 100, 2), '99.99') || '%' as sal_rate 
FROM EMP;
```



:star2: 오늘 배운 것

group by 시 rs가 생성되는 점

max,min은 문자열 비교가 된다는 점



:star::star:

OLTP vs OLAP(=dss)

정의

비교(둘의 특징을 비교)



`OLTP` onLine Transaction Processing **온라인 트랜잭션 처리**

**여러 과정의 연산**이 **하나의 단위 프로세스(트랜잭션)**로 **실행**되도록 하는 프로세스입니다.



은행 9시 ~ 4시반 일어나는 작은 단위의 Transaction
A 라는 사람이 B 에게 10,000 원을 이체하는 상황을 예로 들어보겠습니다.

1. A 라는 사람의 계좌에서 10,000 원이 인출됩니다.

2. B 라는 사람의 계좌에 10,000 원이 입금됩니다.



이 단계는 하나의 프로세스로 이루어져야 하며, 중간에 오류가 발생하는경우 모든 단계를 되돌려야 합니다.



`OLAP` Online Analytical Processing **온라인 분석 처리** (=DSS=BATCH)

**다차원으로 이루어진 데이터**로부터 **통계적인 요약정보**를 **제공**할 수 있는 기술

집계, 통계 - 일괄 처리 ( 은행 4시반 이후 )



:star: 계정계 vs 정보계

한국의 금융시장은 대부분 '여러가지 법'에 의해 통제되고 있습니다. 그래서 '은행 업무'가 대부분 동일한데 기본적으로는 고유업무, 부수업무, 겸영업무로 나뉜다고 합니다.



은행의 고유업무는 저축을 받고 돈을 빌려주는 업무로 수신(저축), 여신(대출), 외환으로 구성되어 있습니다. 부수업무는 보증을 서주거나 어음을 인수하는 등의 일이고 겸영업무는 채권회수(추심)을 대행하거나 기업 M&A를 중개하는 등 은행업은 아니지만 자본과 관련된 기타 일들을 말합니다. 하지만 은행의 거의 모든 업무는 금융위원회의 신고를 해야해서 실제로는 정부의 관리 감독 하에서 영업을 한ㄷ자고 볼 수 있습니다.



그래서 은행마다 조금씩 다르긴 하지만 대부분 아래와 같이 시스템이 구성되어 있습니다.

출처: https://12bme.tistory.com/237 

![img](images/99E4F83359C840F026.jfif)



**1) 계정계(Core Banking)** [OLTP]

금융권의 다양한 시스템 중 **`고객의 거래를 처리하는 핵심 시스템`**입니다. 특히 개인/법인/기타 고객들이 가진 ‘통장’에 관한 정보를 가지고 있기 때문에 입금/출금/계좌이체/지로 신규개설/폐쇄 등의 전반적인 금융업무가 모두 여기에 해당합니다.따라서 은행 내 시스템의 여러 범주 가운데 가장 거대하고 중요하다고 볼 수 있겠죠?

은행의 전통적인 핵심 업무는 통장이 중심이 됩니다. 이 통장을 계좌, 계정이라고 합니다. 한 사람이 여러개의 통장을 만들수도 있고 돌아가신 분의 통장도 있기 때문에 기본 데이터가 1억 건이 가뿐히 넘습니다. 통장별 거래 기록을 포함하면 수백억건의 데이터들이 있습니다. 계정계 데이터는 곧 돈과 거래 기록이기 때문에 장애는 바로 금전적 피해로 이어집니다. 따라서 데이터를 이중 삼중으로 백업하며 시스템이 매우 보수적으로 운영됩니다.

계정계 시스템은 '공통업무, 수신업무, 신탁업무, 보험업무, 카드업무, 여신업무, 외환업무, 대행업무 시스템'등으로 구성됩니다. 대부분 마스터테이블인 거대한 원장들이 있고, 다양한 업무 처리를 보장하는 정형화된 트랜잭션들이 있습니다. 기본적으로원장들에 트랜잭션이 집중되는 구조이기때문에 안정적으로 트랜잭션을 처리하기 위한 미들웨어(Middleware)가 발달해 있습니다.





**2) 정보계** [BATCH/OLAP]

**계정계에서 있었던 일을 가져와서 정보분석을 한다.** (계정계가 작동하는 **시간 외**에 한다.)

계정계가 고객의 거래를 관리한다면 정보계는 **`거래의 '기록'을 관리하고 기록의 '통계' 등을 관리하는 시스템`**입니다. 정보계 시스템은 기록을 바탕으로 예측, 성과측정, 결산 등의 업무를 처리합니다. 흔히 데이터웨어하우스라고 부르는 시스템이 정보계 시스템의 중심입니다. 정보계에서 데이터로의 접근성에 대한 속도가 중요시되며 DW에 비해 정보를 저장하는 기간이 짧다는 것이 특징입니다.

정보계는 거래활동 및 성과를 분석하고 측정하기 위한 목적으로 구축되었습니다. 

정보계는 1980년대에 은행업무가 발전하면서 그 개념이 등장하기 시작했습니다. 기본적으로 통계처리 기법을 많이 사용하기 때문에 대량 데이터 결합조회(JOIN), 배치처리, 대량 데이터 전송 기술 등을 많이 사용합니다. 최근에는 빅데이터 기술의 도입이 많이 검토되고 있습니다.





3. DTP 분산시스템





:star:

트랜잭션: 단말에서 주 컴퓨터로 보내는 처리 단위 1회의 메시지로, 보통 여러 개의 데이터베이스 조작을 포함하는 하나의 논리 단위이다.

예를 들어, 데이터베이스 내의 어떤 표의 수치를 변경하는 경우, 그 표와 관련된 다른 표의 수치도 변경하지 않으면 **데이터 무결성**을 유지할 수 없다.

이런 경우에는 2개의 처리를 1개의 논리단위로 연속해서 행해야 하는데 이 논리 단위가 트랜잭션이다. **1개의 트랜잭션은 그 전체가 완전히 행해지든지, 아니면 전혀 행해지지 않든지 둘 중 하나여야 한다.**







:star: (시험은 안나옴) SDLC 소프트웨어 개발 생명 주기

software development lifecycle

1. 계획(기획)
2. 분석 - 고객의 (기능, 성능, 보안, 안전성 등)요구사항을 분석하는 단계, WHAT을 도출하고 정의하는 과정
3. 설계 - HOW를 도출하고 정의하는 과정
4. 구현(개발)
5. 테스트 - 단위, 통합, 시스템 
6. 이행(릴리즈) - 배포하여 사용자가 사용 가능

7. 운영&유지보수 





## JOIN

두 테이블의 데이터를 **수평적**으로 결합한다.

*이와 달리 집합연산자는 수직적으로 결합한다.



```sql
select d.dname, e.empno, e.ename, e.sal
from dept d, emp e
where d.deptno = e.deptno;
```



## EQUI-JOIN



```sql
① 
SELECT DNAME,ENAME,JOB,SAL FROM EMP, DEPT WHERE  DEPTNO = DEPTNO; -- error
-- emp와 dept 모두에 deptno라는 컬럼이 존재해서 어느 테이블의 deptno를 비교해야하는지 모르므로 이러한 에러가 발생한다.

SELECT d.DNAME,e.ENAME,e.JOB,e.SAL FROM EMP e, DEPT d WHERE  e.DEPTNO = d.DEPTNO;
-- 이처럼 "공통된 데이터"를 가지고 수평적 결합을 하기위해서는 어느 테이블에 존재하는 데이터인지 명시해주어야 한다.
-- 즉, 컬럼이름이 같지않아도 같은 데이터가 있으면, 그것도 비교가 가능하다.
-- 스키마명.오브젝트명.속성명
-- scott.dept.deptno
```



③ 실행 조건이 어떻게 되는가?

**:star:필터링 조건 후 결합 조건을 실행한다.** 왜냐하면 결합 조건은 비용이 많이 들기 때문이다.

```sql
SELECT  DNAME,ENAME,JOB,SAL 
FROM EMP, DEPT 
WHERE  EMP.DEPTNO = DEPT.DEPTNO AND  -- 2. 테이블 결합 조건
EMP.JOB IN ('MANAGER','CLERK') -- 1. 데이터 필터링 조건
ORDER BY DNAME; 
```



② [ANSI/ISO] EQUI-JOIN

JOIN조건을 사용하게 되면 ON에 조건을 작성한다.

```sql
select d.dname, e.ename, e.job, e.sal
from emp e inner join dept d
on e.deptno = d.deptno;
```



③ 

```sql
select d.dname, e.ename, e.job, e.sal
from emp e inner join dept d
on e.deptno = d.deptno
where e.deptno in (10,20) and d.dname = 'RESEARCH';
```



## NON EQUI-JOIN

④ 

```sql
select * from salgrade;
```

```sql
select e.ename, e.job , e.sal, s.grade 
from emp e, salgrade s 
where e.sal between s.losal and s.hisal;
```

⑤ :star: 3개의 테이블을 JOIN

```sql
select dname, ename, job, sal, grade
from emp e, dept d, salgrade s 
where e.deptno = d.deptno and 
	  e.sal between s.losal and s.hisal;
```

JOIN은 반드시 그 데이터 집합 간에만 JOIN이 가능하다.

A B C

1. A B 를 조인 후 만들어진 RESULT SET으로, 2. (A B) C를 조인된 RESULT SET이 생성된다.

때문에 최소 필요한 조인 조건은 최소 두개인 N-1개가 되어야 한다는 의미



⑥

```SQL
SELECT  E.ENAME, E.JOB,E.SAL,E.GRADE   
FROM  EMP E, SALGRADE S 
WHERE  E.SAL BETWEEN S.LOSAL AND S.HISAL 
AND 
E.DEPTNO IN (10,30) ORDER  BY E.ENAME; 
```



⑦

```sql
SELECT   E.ENAME, E.JOB,E.SAL,S.GRADE  
FROM  EMP E, SALGRADE S 
WHERE   E.SAL  <  S.LOSAL AND -- 의미없는 부분
E.DEPTNO IN (10,30) 
ORDER BY E.ENAME; 
```

![image-20200512103709608](images/image-20200512103709608.png)

중복된 이름을 가진 인스턴스가 반환된다.

S.LOSAL의 기준은 `700`, `1201`, `1401`, `2001`, `3001`이 존재하고,  `E.SAL이 다섯 가지의 기준과 비교해서 충족되는 데이터를 반환`한다.

때문에 조건에 만족하면 반환되는 데이터가 여러번이므로 중복되는 데이터가 발생하게 된다.





## OUTER-JOIN

*`(+)`가 없는 쪽이 기준이 된다. 



```sql
select deptno from dept;
```

dept에는 10, 20, 30, 40번 까지 부서 번호가 존재한다.

```sql
select distinct deptno from emp;
```

하지만 emp에서는 10, 20, 30번 까지만 부서 번호가 존재한다.

```sql
select distinct d.deptno
from emp e, dept d
where e.deptno = d.deptno
order by d.deptno;
```

이렇게 inner-join을 하는 경우 40번 부서 번호가 나오지 않는다. 왜냐하면 emp 내에 40번 부서에 배치된 인스턴스가 존재하지 않기때문이다.

```sql
select distinct d.deptno
from emp e, dept d
where e.deptno(+) = d.deptno -- outer-join 사용
order by d.deptno;
```

그래서 outer-join을 사용하면 40번까지의 정보가 추가되어 조회할 수 있다.

⑬

```sql
SELECT  D.DNAME,NVL(E.ENAME,'비상근 부서'),E.JOB,E.SAL -- nvl로 null처리
FROM EMP E,DEPT D 
WHERE  E.DEPTNO(+) = D.DEPTNO 
ORDER  BY D.DNAME;   
```



## [ANSI-SQL : 

## LEFT OUTER JOIN , 

## RIGHT OUTER JOIN , 

## FULL OUTER JOIN] 

:star:left, right은 무엇을 의미하는지?

`기준`을 의미한다.



```sql
 ① 
 SELECT E.DEPTNO,D.DNAME,E.ENAME  
 FROM   SCOTT.EMP E LEFT OUTER JOIN SCOTT.DEPT D 
 ON      E.DEPTNO = D.DEPTNO 
 ORDER  BY E.DEPTNO; 

```



```sql
-- DEPT을 기준 테이블(Driving Table)으로  JOIN 연산 수행 ,40번 부서의 정보 표기? E.DEPTNO 에 나타나는 값 
-- 표기되지 않는다. EMP테이블에는 40번에 대한 정보가 없다.

② 
SELECT E.DEPTNO,D.DNAME,E.ENAME    
FROM   SCOTT.EMP E RIGHT OUTER JOIN SCOTT.DEPT D 
ON      E.DEPTNO = D.DEPTNO 
ORDER  BY E.DEPTNO; 

```

```sql
-- DEPT을 기준 테이블(Driving Table)으로  JOIN 연산 수행 ,40번 부서의 정보 표기? D.DEPTNO 에 나타나는 값 
-- 40번이 표기된다.

③ 
SELECT D.DEPTNO,D.DNAME,E.ENAME  
FROM   SCOTT.EMP E RIGHT OUTER JOIN SCOTT.DEPT D 
ON      E.DEPTNO = D.DEPTNO 
ORDER  BY E.DEPTNO; 
```

```sql
--양방향 FULL OUTER JOIN  !!!!!      

④ 
SELECT D.DEPTNO,D.DNAME,E.ENAME  
FROM   SCOTT.EMP E  FULL OUTER JOIN SCOTT.DEPT D 
ON     E.DEPTNO = D.DEPTNO 
ORDER  BY E.DEPTNO; 
```



## SELF-JOIN



```SQL
SELECT E.ENAME, E.JOB, NVL(M.ENAME, 'NOBODY') AS "MANAGER NAME",
E.ENAME||'"S MANAGER IS '||NVL(M.ENAME, 'NOBODY')
FROM EMP E LEFT OUTER JOIN EMP M -- LEFT인 E를 기준으로 OUTER JOIN
ON E.MGR = M.EMPNO;
```

```SQL
SELECT M.ENAME, NVL(E.ENAME, 'NOBODY') AS "MANAGER NAME", M.JOB
FROM EMP E, EMP M
WHERE M.MGR = E.EMPNO(+);
-- WHERE 조건절에서 연산이 되면, MGR과 EMPNO가 같은 RS가 생성된다.
-- 해당 생성 RS는 E.ENAME을 하게되면 조회가 가능하다. -> 같은 것을 가진 테이블이 나오기 때문
-- 그 E.ENAME은 MANAGER의 이름이 된다.
-- M.ENAME은 원래 이름 데이터이다.
```









## CARTESIAN PRODUCT



:star:AND하고 OR일때 레코드 개수가 다르다.



카티션 프로덕트가 생기는 이유

1. 조건이 없을때
2. 조인 조건이 없을때
3. 조인 조건이 의미가 없는게 쓰였을때(잘못된게 쓰였을때)

곱집합 연산이 발생하게 된다.



```SQL
SELECT ENAME, JOB, DNAME FROM EMP/*14건*/, DEPT/*4건*/;
SELECT COUNT(ENAME) FROM EMP, DEPT; -- 56건

SELECT ENAME, JOB, DNAME FROM EMP, DEPT
WHERE EMP.SAL > 2000 AND DEPT.DEPTNO IN (10, 20);
SELECT COUNT(ENAME) FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO AND EMP.SAL > 2000 AND DEPT.DEPTNO IN (10, 20); -- 12건

SELECT ENAME, JOB, DNAME FROM EMP, DEPT
WHERE EMP.SAL > 2000 OR DEPT.DEPTNO IN (10, 20);
SELECT COUNT(ENAME) FROM EMP, DEPT
WHERE EMP.SAL > 2000 OR DEPT.DEPTNO IN (10, 20); -- 40건, 해당하는 조건에 대한 모든 집합이 나온다.

SELECT E.ENAME, E.JOB, E.SAL, S.GRADE FROM EMP E, SALGRADE S
WHERE E.SAL < S.LOSAL AND E.DEPTNO IN (10, 30)
ORDER BY E.ENAME;
SELECT COUNT(E.ENAME) FROM EMP E, SALGRADE S
WHERE E.SAL < S.LOSAL AND E.DEPTNO IN (10, 30)
ORDER BY E.ENAME; -- 19건


SELECT ENAME FROM EMP JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO -- JOIN된 상태, 기준을 잡아준다.
WHERE EMP.SAL > 2000 AND DEPT.DEPTNO IN (10, 20); -- 5건, 정상출력
```















