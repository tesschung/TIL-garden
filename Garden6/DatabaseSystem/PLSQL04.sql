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

SET SERVEROUTPUT ON;
DECLARE
    CURSOR CUR_EMP IS 
            SELECT ENAME, JOB, SAL, COMM FROM EMP WHERE DEPTNO = 10;
    
--    V_ENAME EMP.ENAME%TYPE;
--    V_JOB EMP.JOB%TYPE;
--    V_SAL EMP.SAL%TYPE;
--    V_COMM EMP.COMM%TYPE;
    
BEGIN
    FOR R_CUR_EMP IN CUR_EMP
    LOOP
        INSERT INTO BONUS(ENAME, JOB, SAL, COMM) 
                VALUES(R_CUR_EMP.ENAME, R_CUR_EMP.JOB, R_CUR_EMP.SAL, R_CUR_EMP.COMM);
                DBMS_OUTPUT.PUT_LINE(TO_CHAR(CUR_EMP%ROWCOUNT));
    END LOOP;
    -- DBMS_OUTPUT.PUT_LINE(TO_CHAR(CUR_EMP%ROWCOUNT));
    COMMIT;
END;
/

SELECT * FROM BONUS;


DELETE FROM BONUS WHERE COMM = 275;
