DB2 SELECT 결과 중 몇개의 데이터만 검색할 때 

DB TOP 기능은 DB2에서 사용할 수 없고..

FETCH FIRST N ROWS ONLY를 사용해야 한다.



SELECT * FROM 테이블명 WHERE 조건 

**FETCH FIRST N ROWS ONLY**

****

EX) JASON 중 나이가 많은 상위 5명만 검색 

SELECT * FROM MEMBER WHERE NAME ='JASON' ORDER BY AGE DESC 

**FETCH FIRST 5 ROWS ONLY**

****

서브쿼리쓸때 유용하게 사용가능.

**FETCH FIRST 1 ROWS ONLY**