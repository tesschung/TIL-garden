 -- PL/SQL in JAVA
 
 
-- SELECT DECODE(CEIL(DBMS_RANDOM.VALUE(0.1, 21.1)), 1, '������', 2, '������', 3, '���Ǹ�', 4, '�����', 5, '�̻���', 
--6, '������', 7, '������', 8, '���¿�', 9, '������', 10, '�ѹ���', 11, 'ȫ�α�', 12, '������', 13, '�踮��', 14, '������', 
--15, '������', 16, '��õȣ', 17, '������', 18, '������', 19, '���ٿ�', 20, '������', 21, '������', 22, 'ȫ����') AS VICTIM
--FROM DUAL
--
--1, '������', 2, '������', 3, '���Ǹ�', 4, '�����', 5, '�̻���', 6, '������', 7, '������', 8, '���¿�', 9, '������', 10, '�ѹ���', 11, 'ȫ�α�', 12, '������', 13, '�踮��', 14, '������', 15, '������', 16, '��õȣ', 17, '������', 18, '������', 19, '���ٿ�', 20, '������', 21, '������', 22, 'ȫ����')



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
--    SET    COMM =  ROUND(R_CUR_EMP.SAL * 0.05,0) -- �޿��� 5���θ� COMM���� �� ��
--    WHERE  EMPNO = R_CUR_EMP.EMPNO; -- �̰� �ӵ��� �� ������.
--         -- WHERE  CURRENT OF CUR_EMP; -- ���� WHERE�� ���� ����, Ŀ���� ���� ����� ���ڵ��� ����
-- 
--    INSERT INTO BONUS(ENAME,JOB,SAL,COMM)
--               VALUES(R_CUR_EMP.ENAME,R_CUR_EMP.JOB,R_CUR_EMP.SAL, 
--    ROUND(R_CUR_EMP.SAL * 0.05,0)); 
-- 
----    DBMS_LOCK.SLEEP(5); -- ������ ��� ������ ����
--    END LOOP; 
--        COMMIT; 
--END; 
--/ 

--CREATE [OR REPLACE] FUNCTION �Լ���(�Ű����� ����)
--		RETURN �ڷ���
--		IS
--			��������
--		BEGIN
--			(����������)������ SQL��
--			RETURN ������;
--END;
--/ -- �߿�!

create or replace function
                  getBusinessDay(lastDay in date, strDay in char)
                  return char
    is 
    
    begin
        if strDay = '�Ͽ���' then return to_char(lastDay-2);
        elsif strDay = '�����' then return to_char(lastDay-1);
        else return lastDay;
        end if;
end;
/ 
-- �߿�!

select getBusinessDay(to_char(LAST_DAY(SYSDATE)),to_char(LAST_DAY(SYSDATE), 'day')) businessDay from dual;
--
--
--set serveroutput on -- ���� 1
--execute selection; -- ���� 2

--SET SERVEROUTPUT ON
--    CREATE OR REPLACE PROCEDURE SELECTION
--            IS SELECTION VARCHAR2(9)
--            BEGIN 
--            	SELECT DECODE(RAN, �л� ��ȣ)
--            INTO SELECTION
--                FROM ( SELECTION TRUNC(DBMS_RANDOM.VALUE(1,22),0) AS RAN FROM DUAL);
--                
--            DBMS_OUTPUT.PUT_LINE(SELECTION||�� ���ϵ帳�ϴ�.)
--            END;
--/



--PROCEDURE
