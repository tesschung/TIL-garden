SET SERVEROUTPUT ON
DECLARE 
    V_EMPNO EMP.EMPNO%TYPE;
    V_ENAME EMP.EMPNO%TYPE;
    V_HIREDATE EMP.HIREDATE%TYPE;
BEGIN
    -- 하나의 변수에는 하나만 저장할 수 있어서 에러가 발생
    -- SELECT 되는 대상 데이터가 1개 이상인 조회
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


DECLARE 
    V_EMPNO EMP.EMPNO%TYPE;
    V_ENAME EMP.EMPNO%TYPE;
    V_HIREDATE EMP.HIREDATE%TYPE;
BEGIN
    SELECT EMPNO, ENAME, HIREDATE INTO V_EMPNO, V_ENAME, V_HIREDATE
    FROM EMP
    WHERE EMPNO = 1; -- SELECT 되는 대상 데이터가 없다. --> 연산할 수 없다.
    
    DBMS_OUTPUT.PUT_LINE('SELECTED EXCATLY ONE ROW' || V_EMPNO);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS');
END;
/


declare
    -- 테이블 타입 정의
    type t_empno_list is table of emp.empno%type        index by binary_integer;
    -- index by -> table의 타입 정의
    type t_ename_list is table of emp.ename%type        index by binary_integer;
    type t_hiredate_list is table of emp.hiredate%type  index by binary_integer;

    --테이블 변수 선언
    tbl_empno_list      t_empno_list;
    tbl_ename_list      t_ename_list;
    tbl_hiredate_list   t_hiredate_list;
    
    l binary_integer := 1;
begin
    for k in (select empno, ename, hiredate from emp where empno >= 1) loop
        
        tbl_empno_list(l) := k.empno;
        tbl_ename_list(l) := k.ename;
        tbl_hiredate_list(l) := k.hiredate;
        dbms_output.put_line(tbl_empno_list(l) || ' / ' ||tbl_ename_list(l) || ' / ' || tbl_hiredate_list(l));
        l := l + 1;
        
    end loop;

    
exception
    when no_data_found then
            dbms_output.put_line('no data found !!!');
    when too_many_rows then
            dbms_output.put_line('too many rows found !!!');
end;
/



DECLARE
    CURSOR CUR_EMP IS 
    SELECT EMPNO, JOB, SAL, COMM FROM EMP WHERE DEPTNO = 10;
    
    V_ENAME VARCHAR(10);
    V_JOB VARCHAR(9);
    V_SAL NUMBER(7,2);
    V_COMM NUMBER(7,2);
    
BEGIN
    OPEN CUR_EMP;
    LOOP
        FETCH CUR_EMP INTO V_ENAME, V_JOB, V_SAL, V_COMM;
        EXIT WHEN CUR_EMP%NOTFOUND;
        
        INSERT INTO BONUS(ENAME, JOB, SAL, COMM) 
        VALUES(V_ENAME, V_JOB, V_SAL, V_COMM);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(CUR_EMP%ROWCOUNT));
    CLOSE CUR_EMP;
    COMMIT;
END;
/

SELECT * FROM BONUS;





DECLARE
    CURSOR CUR_EMP IS 
    SELECT ENAME/*EMPNO*/, JOB, SAL, COMM FROM EMP WHERE DEPTNO = 10;
    
    V_ENAME EMP.ENAME%TYPE;
    V_JOB EMP.JOB%TYPE;
    V_SAL EMP.SAL%TYPE;
    V_COMM EMP.COMM%TYPE;
    
BEGIN
    OPEN CUR_EMP;
    LOOP
        FETCH CUR_EMP INTO V_ENAME, V_JOB, V_SAL, V_COMM;
        EXIT WHEN CUR_EMP%NOTFOUND;
        
        INSERT INTO BONUS(ENAME, JOB, SAL, COMM) 
        VALUES(V_ENAME, V_JOB, V_SAL, V_COMM);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(CUR_EMP%ROWCOUNT));
    CLOSE CUR_EMP;
    COMMIT;
END;
/

SELECT * FROM BONUS;



DECLARE
    CURSOR CUR_EMP IS 
    SELECT ENAME/*EMPNO*/, JOB, SAL, COMM FROM EMP WHERE DEPTNO = 10;
    
    V_ENAME EMP.ENAME%TYPE;
    V_JOB EMP.JOB%TYPE;
    V_SAL EMP.SAL%TYPE;
    V_COMM EMP.COMM%TYPE;
    
BEGIN
    OPEN CUR_EMP;
    LOOP
        FETCH CUR_EMP INTO V_ENAME, V_JOB, V_SAL, V_COMM;
        EXIT WHEN CUR_EMP%NOTFOUND;
        
        INSERT INTO BONUS(ENAME, JOB, SAL, COMM) 
        VALUES(V_ENAME, V_JOB, V_SAL, V_COMM);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(CUR_EMP%ROWCOUNT));
    CLOSE CUR_EMP;
    COMMIT;
END;
/

SELECT * FROM BONUS;

