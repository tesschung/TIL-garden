BEGIN
    INSERT INTO DEPT VALUES(11, 'OUTER_BLK_PART', 'Main_Blk'); -- �Է�
     DBMS_OUTPUT.PUT_LINE('[����1]');
    <<Nested_BLOCK_1>>
    BEGIN
        INSERT INTO DEPT VALUES(12, 'LOCAL_PART_1', 'Nested_Blk1'); -- �Է�
         DBMS_OUTPUT.PUT_LINE('[����2]');
        INSERT INTO DEPT VALUES(777, 'LOCAL_PART_1', 'Nested_Blk1');
        INSERT INTO DEPT VALUES(13, 'LOCAL_PART_1', 'Nested_Blk1');
        INSERT INTO DEPT VALUES(78, 'LOCAL_PART_1', 'Nested_Blk1');
        COMMIT; -- Ŀ�� �߿�
    EXCEPTION
--        WHEN NO_DATA_FOUND THEN --  SELECT�� �����Ͱ� ������ �߻�
--            NULL; -- ���ܿ� �´� ����ó���� ������ �ʾƼ� ���ܰ� �߻��� ���� ���� ��� ROLLBACK 
        WHEN OTHERS THEN
            NULL;
    END Nested_BLOCK_1;
    <<Nested_BLOCK_2>>
    BEGIN 
        INSERT INTO DEPT VALUES(55, 'LOCAL_PART_2', 'Nested_Blk2'); -- �Է�
--        COMMIT; 
    END Nested_BLOCK_2;
    
    INSERT INTO DEPT VALUES(100, 'OUTER_BLK_PART', 'Main_Blk');   -- �Է�
    DBMS_OUTPUT.PUT_LINE('[����1]');
END;
/

-- INSERT�� DML�̹Ƿ� AUTO COMMIT�� �ȴ�.

SELECT * FROM DEPT;

DELETE FROM DEPT WHERE DEPTNO NOT IN (10,20,30,40);
DELETE FROM DEPT WHERE LOC = 'Main_Blk';


REM DEFAULT SIZE 2000 BYTES.

SET SERVEROUTPUT ON
BEGIN
    FOR I IN 1..10
    LOOP
        DBMS_OUTPUT.PUT_LINE('['||TO_CHAR(I)||']');
    END LOOP;
END;
/

SET SERVEROUTPUT OFF


SELECT DEPTNO, ENAME, JOB, SAL, (SELECT ROUND(AVG(SAL),1) FROM EMP SE WHERE SE.JOB = M.JOB) AS JOB_AVG_SAL
FROM EMP M
ORDER BY DEPTNO, JOB, JOB_AVG_SAL ASC;




DECLARE
    TYPE T_ADDRESS IS RECORD(
        ADDR1 VARCHAR2(60),
        ADDR2 VARCHAR2(60),
        ZIP VARCHAR2(7),
        PHONE VARCHAR2(14)
    );
    
    TYPE T_EMP_RECORD IS RECORD(
        EMPNO NUMBER(4),
        ENAME VARCHAR2(10),
        JOB VARCHAR2(9),
        ADDRESS T_ADDRESS,
        HIREDATE DATE
    );
    
REC_EMP T_EMP_RECORD;
BEGIN

    REC_EMP.EMPNO := '1234';
    REC_EMP.ENAME := 'XMAN';
    REC_EMP.JOB := 'DBA';
    REC_EMP.ADDRESS.ADDR1 := '������ ���ﵿ';
    REC_EMP.ADDRESS.ZIP := '150-036';
    REC_EMP.HIREDATE := SYSDATE - 336;
    
    DBMS_OUTPUT.PUT_LINE(REC_EMP.EMPNO); -- 1234

END;
/

DECLARE
        TYPE T_ADDRESS IS RECORD(   --RECORD TYPE ����
                ADDR1   VARCHAR2(60),   -- �ּ�1
                ADDR2   VARCHAR2(60),   -- �ּ�2
                ZIP     VARCHAR2(7),    -- �����ȣ
                PHONE   VARCHAR2(14)    -- ��ȭ��ȣ
        );
        TYPE T_EMP_RECORD IS RECORD (   -- RECORD TYPE ����
                EMPNO   NUMBER(4),      -- ���
                ENAME   VARCHAR2(10),   -- �̸�
                JOB     VARCHAR2(9),    -- ����
                ADDRESS T_ADDRESS,      -- �ּ�
                HIREDATE DATE);         -- �Ի���
REC_EMP T_EMP_RECORD;

BEGIN
        -- RECORD�� FIELD�� ���� ����
        REC_EMP.EMPNO := 1234;
        REC_EMP.ENAME := 'XMAN';
        REC_EMP.JOB := 'DBA';
        REC_EMP.ADDRESS.ADDR1 := '������ ���ﵿ';
        REC_EMP.ADDRESS.ZIP := '150-036';
        REC_EMP.HIREDATE := SYSDATE - 365;
        
        -- RECORD�� FIELD���� ��ȸ
        DBMS_OUTPUT.PUT_LINE('*********************************************');
        DBMS_OUTPUT.PUT_LINE('��� : '|| REC_EMP.EMPNO);
        DBMS_OUTPUT.PUT_LINE('�̸� : '|| REC_EMP.ENAME);
        DBMS_OUTPUT.PUT_LINE('���� : '|| REC_EMP.JOB);
        DBMS_OUTPUT.PUT_LINE('�ּ� : '|| REC_EMP.ADDRESS.ADDR1);
        DBMS_OUTPUT.PUT_LINE('�ּ� : '|| REC_EMP.ADDRESS.ZIP);
        DBMS_OUTPUT.PUT_LINE('�Ի��� : '|| TO_CHAR(REC_EMP.HIREDATE, 'YYYY/MM/DD'));
        DBMS_OUTPUT.PUT_LINE('*********************************************');
END;
/


DECLARE 
    TYPE T_EMP_LIST IS TABLE OF VARCHAR(20)
        INDEX BY BINARY_INTEGER;
    TBL_EMP_LIST T_EMP_LIST;
    V_TMP VARCHAR2(20);
    V_INDEX NUMBER(10);
BEGIN
    TBL_EMP_LIST(1) := 'SCOTT';
    TBL_EMP_LIST(1000) := 'MILLER';
    TBL_EMP_LIST(-2134) := 'ALLEN';
    
    TBL_EMP_LIST(10) := 'XMAN';
    
    V_TMP := TBL_EMP_LIST(1000);
    
    DBMS_OUTPUT.PUT_LINE(TBL_EMP_LIST(1000)); -- MILLER
    DBMS_OUTPUT.PUT_LINE(TBL_EMP_LIST(-2134)); -- ALLEN
    DBMS_OUTPUT.PUT_LINE(TBL_EMP_LIST(1)); -- SCOTT

    IF NOT TBL_EMP_LIST.EXISTS(888) THEN
        DBMS_OUTPUT.PUT_LINE('DATA OF KEY 888 IS NOT EXIST'); -- DATA OF KEY 888 IS NOT EXIST
    END IF;
    
    V_INDEX := TBL_EMP_LIST.FIRST;
    LOOP
        DBMS_OUTPUT.PUT_LINE(V_INDEX); -- -2134, 1, 10, 1000
        V_INDEX := TBL_EMP_LIST.NEXT(V_INDEX);
        EXIT WHEN V_INDEX IS NULL;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('DATA OF KEY 999 IS'||TBL_EMP_LIST(999)); -- ��� X -> ���ܷ� ������.
    DBMS_OUTPUT.PUT_LINE('DATA OF KEY 0 IS'||TBL_EMP_LIST(0)); -- ��� X
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SQLCODE)); -- 100
        DBMS_OUTPUT.PUT_LINE(SQLERRM); -- ORA-01403: �����͸� ã�� �� �����ϴ�.
END;
/
    

DECLARE 
    V_EMPNO EMP.EMPNO%TYPE;
    V_ENAME EMP.EMPNO%TYPE;
    V_HIREDATE EMP.HIREDATE%TYPE;
    
BEGIN
    -- �ϳ��� �������� �ϳ��� ������ �� �־ ������ �߻�
    -- SELECT �Ǵ� ��� �����Ͱ� 1�� �̻��� ��ȸ
    SELECT EMPNO, ENAME, HIREDATE INTO V_EMPNO, V_ENAME, V_HIREDATE
    FROM EMP
    WHERE EMPNO >= 1;
    
    DBMS_OUTPUT.PUT_LINE('SELECTED EXCATLY ONE ROW' || V_EMPNO);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS');
END;
/


