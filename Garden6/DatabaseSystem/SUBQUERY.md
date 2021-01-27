subquery의 장점

-효율성

-동적으로 결과집합을 만들어서 사용할 수 있는 유연성



## SINGLE COLUMN, SINGLE ROW

①  스미스랑 같은 부서에 근무하는 사람들의 정보를 보는 쿼리

② EMP 테이블의 총급여 평균보다 급여가 낮은 사람들의 정보를 보는 쿼리



SUB QUERY가 있으면 중간 결과 집합이 서버에서 작성되어 

MAIN QUERY가 처리된 집합을 가지고 최종적인 결과를 조회할 수 있게 한다.



## SINGLE COLUMN, MULTIPLE ROW RETURN  SUBQUERY



① 

```SQL
SELECT  ENAME,JOB  FROM  EMP WHERE  DEPTNO =  10,30;      
-- ERROR 발생
-- = 연산자는 같니?안같니?를 의미하기 때문이다.
```



## MULTIPLE COLUMN, MULTIPLE ROW RETURN

![image-20200512165247933](images/image-20200512165247933.png)

서브쿼리가 MULTIPLE 컬럼을 리턴하면, 메인쿼리도 같이 잡아줘야 한다.



## Scalar Subquery: 한개의 컬럼 위치

JOB의 개수만큼 scalar subquery가 실행되며, 데이터를 가져오는 것이 14번 실행된다.

scalar subquery가 실행되기 위해서는 M.JOB이 필요하다.

때문에 main query가 먼저 실행되어 M.JOB을 넘겨줄 수 있게 된다.

이를 통해 급여 평균이 계산된다.

`QUERY EXECUTION CACHING`이 발생되어 메모리에 저장한다. 이를 재사용하게 된다.



Scalar 한개의 값을 가지고 있는

M.JOB - MAIN QUERY 의 JOB을 참조



:star:`scalar subquery`의 실행횟수와 방식

**매번 실행되지 않는다.**

**실행 된 결과를 어딘가에 cache해서 똑같은 쿼리가 발생하면 재사용한다.**

**실행 결과를 재사용한다.**





1. HASH TABLE
2. QUERY TRANSFORMATION (ex) scalar subquery -> join으로 변형)





