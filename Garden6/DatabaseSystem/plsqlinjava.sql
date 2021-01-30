 -- PL/SQL in JAVA
 
 
-- SELECT DECODE(CEIL(DBMS_RANDOM.VALUE(0.1, 21.1)), 1, '김윤후', 2, '김혜주', 3, '문건모', 4, '소재원', 5, '이상현', 
--6, '이진희', 7, '전혜원', 8, '정승원', 9, '조영남', 10, '한미희', 11, '홍민기', 12, '구재희', 13, '김리나', 14, '나성주', 
--15, '박진우', 16, '박천호', 17, '신형재', 18, '양은희', 19, '윤다영', 20, '이초희', 21, '최윤선', 22, '홍현택') AS VICTIM
--FROM DUAL
--
--1, '김윤후', 2, '김혜주', 3, '문건모', 4, '소재원', 5, '이상현', 6, '이진희', 7, '전혜원', 8, '정승원', 9, '조영남', 10, '한미희', 11, '홍민기', 12, '구재희', 13, '김리나', 14, '나성주', 15, '박진우', 16, '박천호', 17, '신형재', 18, '양은희', 19, '윤다영', 20, '이초희', 21, '최윤선', 22, '홍현택')



--
--DECLARE 
-- CURSOR  CUR_EMP(P_DEPTNO IN NUMBER) IS 
--   SELECT EMPNO,ENAME,JOB,SAL,COMM FROM EMP  
--  WHERE  DEPTNO = P_DEPTNO  
--           FOR  UPDATE; 
----   FOR  UPDATE  WAIT  10;         
----   FOR   UPDATE  NOWAIT; 
----               FOR  UPDATE  OF EMP.JOB         
-- V_DEPTNO DEPT.DEPTNO%TYPE; 
--BEGIN 
-- V_DEPTNO  :=  20; 
-- 
--    FOR  R_CUR_EMP IN CUR_EMP(V_DEPTNO) 
--    LOOP 
--    UPDATE EMP 
--    SET    COMM =  ROUND(R_CUR_EMP.SAL * 0.05,0) -- 급여의 5프로를 COMM으로 줄 것
--    WHERE  EMPNO = R_CUR_EMP.EMPNO; -- 이게 속도가 더 빠르다.
--         -- WHERE  CURRENT OF CUR_EMP; -- 위의 WHERE과 같은 역할, 커서가 현재 갖고온 레코드의 현재
-- 
--    INSERT INTO BONUS(ENAME,JOB,SAL,COMM)
--               VALUES(R_CUR_EMP.ENAME,R_CUR_EMP.JOB,R_CUR_EMP.SAL, 
--    ROUND(R_CUR_EMP.SAL * 0.05,0)); 
-- 
----    DBMS_LOCK.SLEEP(5); -- 권한이 없어서 지금은 못씀
--    END LOOP; 
--        COMMIT; 
--END; 
--/ 

--CREATE [OR REPLACE] FUNCTION 함수명(매개변수 선언)
--		RETURN 자료형
--		IS
--			변수선언
--		BEGIN
--			(순차적으로)실행할 SQL문
--			RETURN 데이터;
--END;
--/ -- 중요!

create or replace function
                  getBusinessDay(lastDay in date, strDay in char)
                  return char
    is 
    
    begin
        if strDay = '일요일' then return to_char(lastDay-2);
        elsif strDay = '토요일' then return to_char(lastDay-1);
        else return lastDay;
        end if;
end;
/ 
-- 중요!

select getBusinessDay(to_char(LAST_DAY(SYSDATE)),to_char(LAST_DAY(SYSDATE), 'day')) businessDay from dual;
--
--
--set serveroutput on -- 실행 1
--execute selection; -- 실행 2

--SET SERVEROUTPUT ON
--    CREATE OR REPLACE PROCEDURE SELECTION
--            IS SELECTION VARCHAR2(9)
--            BEGIN 
--            	SELECT DECODE(RAN, 학생 번호)
--            INTO SELECTION
--                FROM ( SELECTION TRUNC(DBMS_RANDOM.VALUE(1,22),0) AS RAN FROM DUAL);
--                
--            DBMS_OUTPUT.PUT_LINE(SELECTION||님 축하드립니다.)
--            END;
--/



--PROCEDURE
