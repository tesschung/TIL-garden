## 11_20200526





## 참고











## PL/SQL



![image-20200526134920871](images/image-20200526134920871.png)



개발의 생산성과 효율성을 가져다준다.

procedural language

절차적 언어



1. 변수, 상수 정의 사용
2. 사용자 정의 함수/ procedure/ class -> 모듈화 가능

3. 제어문(for, while, if) 조건문과 반복문을 사용할 수 있다.

4. 예외처리





![image-20200526140422179](images/image-20200526140422179.png)

pl/sql은 블록구조화된 언어

```sql
DECLARE -- 선언부(optional)


BEGIN -- BEGIN~END 실행부


EXCEPTION -- 예외처리(optional)


END;
```



```sql
BEGIN

END; 

-- PL/SQL 블럭의 최소구성
```



```sql
declare
    v_empno number(4) := 8888; -- 변수 선언 및 초기화
    v_deptno number(2);
    v_ename varchar(10) := 'XMMAN'; -- 변수 선언 및 초기화
    v_job varchar(9);
    v_sal number(7,2);
begin
    v_deptno := 20;
    if v_job is null then
            v_job := '신입';
    end if;
    if v_job = '신입' then
            v_sal := 2000;
    elsif v_job in ('MANAGER', 'ANALYST') then
            v_sal := 3500;
    else   
            v_sal := 2500;
    end if;
    insert into emp(deptno, empno, ename, sal, job)
                values(v_deptno, v_empno, v_ename, v_sal, v_job);               
    commit;
end;
/
```





pro*C ~어디에 쓰는가? 계정계, 정보계

엔터티간의 관계 차수 

1) 1:1

**2) 1:N** 

3) M:N (다대다 관계는 더 쪼개어져야 한다.)





ERA

- entity -> relationship -> attribute

EAR

- entity -> attribute -> relationship





MMDBMS(main memory database management system) - 알티베이스

- 실시간, 주문처리, 시황, 인증

- 인증 -> 아이디 패스워드 확인

RDBMS(relation database management system)



![image-20200527101318649](images/image-20200527101318649.png)

BLOCK

- ANONYMOUS(익명의) BLOCK 

  - 한번 효율적으로 사용하기 위함

  - client prg 내에 저장 된

    

- NAMED BLOCK(**STORED** BLOCK)

  - 공통 라이브러리

  - DBMS내 server내에 저장된

  - 즉, 이름을 가지고 database 내부에 저장된다.

  - 재사용이 가능하다. -> 모듈화,라이브러리화

  - reuse

    - function
    - procedure
    - package(class)
    - trigger

    



NAME

ATTRIBUTE = 변수

METHOD





## Package

DBMS_OUTPUT

PL/SQL은 별도의 디버깅 도구가 없어서 DBMS_OUTPUT을 사용한다.



```
DESC DBMS_OUTPUT;
```



![image-20200527103638095](images/image-20200527103638095.png)



![image-20200527104056063](images/image-20200527104056063.png)

FOR안의 I는 자동정의 된다.

1..10은 1에서 10까지 10번 반복

LOOP ~ END LOOP

IF ~ END IF

![image-20200527105032370](images/image-20200527105032370.png)



SET SERVEROUTPUT ON - 서버가 실행하는 것을 ON할 것

DBMS_OUTPUT - SET SERVEROUTPUT ON와 함께









WRITE_LOG라는 NAMED_BLOCK

```SQL
CREATE OR REPLACE PROCEDURE
    WRITE_LOG(A_PROGRAM_NAME IN VARCHAR2, A_ERROR_MESSAGE IN VARCHAR2, A_DESCRIPTION IN VARCHAR2)
AS
BEGIN
    INSERT INTO EXCEPTION_LOG(PROGRAM_NANE, ERROR_MESSAGE, DESCRIPTION)
        VALUES(A_PROGRAM_NAME, A_ERROR_MESSAGE, A_DESCRIPTION);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
            NULL;
END;
/
```



LOG란?  [운영 체제](https://ko.wikipedia.org/wiki/운영_체제)나 다른 [소프트웨어](https://ko.wikipedia.org/wiki/소프트웨어)가 실행 중에 발생하는 이벤트나 각기 다른 사용자의 [통신 소프트웨어](https://ko.wikipedia.org/wiki/통신_소프트웨어) 간의 메시지를 기록한 파일





##  Nested Block (중첩 Block) 

![image-20200527110649231](images/image-20200527110649231.png)











![image-20200527110833364](images/image-20200527110833364.png)





## 변수

변수 정의후 초기화하지 않으면 변수는 NULL이다.





## 조건식

JAVA와 달리 SQL은 조건식에 TRUE, FALSE, NULL을 가지고 있다.





## FOR LOOP

무조건 1씩 증가한다.



```SQL

DECLARE
    LOOP_INDEX NUMBER(4) := 1;
    MAX_LOOP_INDEX NUMBER(4) := 30;
BEGIN
    FOR LOOP_INDEX IN 1..30 -- 선언부의 LOOP_INDEX와 서로 다른 변수이다.
    LOOP   
            DBMS_OUTPUT.PUT_LINE('LOOP COUNT ' ||TO_CHAR(LOOP_INDEX));
    END LOOP;
END;
/

```



![image-20200527111922610](images/image-20200527111922610.png)



PL/SQL은 실행이 끝나면 한번에 다 보여준다.



## WHILE LOOP









## NULL



![image-20200527112215569](images/image-20200527112215569.png)



V_NUM1은 NULL이다

**NULL은 비교가 불가능하므로 NULL이 된다.**



IF (NULL AND TRUE) => NULL

IF (NOT NULL) => NULL





```SQL
BEGIN
    INSERT INTO DEPT VALUES(10, 'OUTER_BLK_PART', 'Main_Blk'); -- 입력
    
    <<Nested_BLOCK_1>>
    BEGIN
        INSERT INTO DEPT VALUES(11, 'LOCAL_PART_1', 'Nested_Blk1'); -- 입력
        INSERT INTO DEPT VALUES(777, 'LOCAL_PART_1', 'Nested_Blk1'); -- 예외
        INSERT INTO DEPT VALUES(13, 'LOCAL_PART_1', 'Nested_Blk1');
        INSERT INTO DEPT VALUES(78, 'LOCAL_PART_1', 'Nested_Blk1');
    EXCEPTION
        WHEN OTHERS THEN --  예외처리를 해주므로 에러가 나는 부분 전까지는 모두 입력된다.
            NULL;
    END Nested_BLOCK_1;
    <<Nested_BLOCK_2>>
    BEGIN 
        INSERT INTO DEPT VALUES(88, 'LOCAL_PART_2', 'Nested_Blk2'); -- 입력
        COMMIT;
    END Nested_BLOCK_2;
    
    INSERT INTO DEPT VALUES(99, 'OUTER_BLK_PART', 'Main_Blk');  -- 입력
END;
/

BEGIN
    INSERT INTO DEPT VALUES(11, 'OUTER_BLK_PART', 'Main_Blk');
    
    <<Nested_BLOCK_1>>
    BEGIN
        INSERT INTO DEPT VALUES(12, 'LOCAL_PART_1', 'Nested_Blk1');
--        INSERT INTO DEPT VALUES(777, 'LOCAL_PART_1', 'Nested_Blk1');
        INSERT INTO DEPT VALUES(13, 'LOCAL_PART_1', 'Nested_Blk1');
        INSERT INTO DEPT VALUES(78, 'LOCAL_PART_1', 'Nested_Blk1');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN --  SELECT한 데이터가 없을때 발생
            NULL; -- 예외에 맞는 예외처리를 해주지 않아서 예외가 발생한 구간 전을 모두 ROLLBACK 
            -- PL/SQL에서는 에러 발생시 모두 ROLLBACK된다.
    END Nested_BLOCK_1;
    <<Nested_BLOCK_2>>
    BEGIN 
        INSERT INTO DEPT VALUES(88, 'LOCAL_PART_2', 'Nested_Blk2');
        COMMIT;
    END Nested_BLOCK_2;
    
    INSERT INTO DEPT VALUES(99, 'OUTER_BLK_PART', 'Main_Blk');   
END;
/

SELECT * FROM DEPT;
```

*OTHERS는 어떤 예외든 다 잡아준다.

**:star:못잡은 예외는 바깥으로 가는데, 바깥에서도 그 예외가 잡히지 않으면 블럭 전체를 ROLLBACK한다.**



```SQL
BEGIN
    INSERT INTO DEPT VALUES(11, 'OUTER_BLK_PART', 'Main_Blk'); -- 입력
    
    <<Nested_BLOCK_1>>
    BEGIN
        INSERT INTO DEPT VALUES(12, 'LOCAL_PART_1', 'Nested_Blk1'); -- 입력
        INSERT INTO DEPT VALUES(777, 'LOCAL_PART_1', 'Nested_Blk1'); -- 에러
        INSERT INTO DEPT VALUES(13, 'LOCAL_PART_1', 'Nested_Blk1');
        INSERT INTO DEPT VALUES(78, 'LOCAL_PART_1', 'Nested_Blk1');
    EXCEPTION -- 에러 발생 후 예외처리
        WHEN NO_DATA_FOUND THEN --  SELECT한 데이터가 없을때 발생
            NULL; -- 예외에 맞는 예외처리를 해주지 않아서 예외가 발생한 구간 전을 모두 ROLLBACK 
        WHEN OTHERS THEN -- 예외처리가 CATCH된다.
            NULL;
    END Nested_BLOCK_1;
    <<Nested_BLOCK_2>>
    BEGIN 
        INSERT INTO DEPT VALUES(55, 'LOCAL_PART_2', 'Nested_Blk2'); -- 입력
        COMMIT;
    END Nested_BLOCK_2;
    
    INSERT INTO DEPT VALUES(56, 'OUTER_BLK_PART', 'Main_Blk');   -- 입력
END;
/

```



| **예외 이름**           | **에러 번호** | **설   명**                                                  |
| ----------------------- | ------------- | ------------------------------------------------------------ |
| ACCESS_INTO_NULL        | ORA-06530     | 초기화 되지않은 객체의 속성에 대해 값을 지정하는 것을 시도합니다. |
| COLLECTION_IS_NULL      | ORA-06531     | 초기화되지 않은 중첩 테이블 대해 EXISTS를 제외한 메쏘드 모음의 적용을 시도합니다. |
| CURSOR_ALREADY_OPEN     | ORA-06511     | 이미 열린 CURSOR의 열기를 시도합니다.                        |
| DUP_VAL_ON_INDEX        | ORA-00001     | 중복 값의 삽입을 시도합니다.                                 |
| INVALID_CURSOR          | ORA-01001     | 잘못된 CURSOR연산이 발생합니다.                              |
| INVALID_NUMBER          | ORA-01722     | 수의 문자열 전환은 실패입니다.                               |
| LOGIN_DENIED            | ORA-01017     | 잘못된 사용자명과 비밀 번호로 ORACLE에 로그온합니다.         |
| NO_DATA_FOUND           | ORA-01403     | 데이터를 RETURN하지 않는 SELECT문장                          |
| NOT_LOGGED ON           | ORA-01012     | PL/SQL프로그램은 ORACLE에 연결하지 않고 데이터베이스 호출을 발생합니다. |
| PROGRAM_ERROR           | ORA-06501     | PL/SQL은 내부 문제를 가지고 있습니다.                        |
| ROWTYPE_MISMATCH        | ORA-06504     | 지정문에 포함된 호스트CURSOR변수와 PL/SQL  CURSOR변수는 RETURN 유형이 다릅니다. |
| STORAGE_ERROR           | ORA-06500     | PL/SQL이 메모리를 다 써버리거나 또는 메모리가 훼손되었습니다. |
| SUBSCRIPT_BEYOND_COUNT  | ORA-06533     | 모음의 요소 개수보다 더 큰 인덱스 개수를 사용하는 중첩 테이블 참조합니다. |
| SUBSCRIPT_OUTSIDE_LIMIT | ORA-06532     | 범위 밖의 인덱스 번호를 사용하여 중첩 테이블 참조 합니다.    |
| TIMEOUT_ON_RESOURCE     | ORA-00051     | ORACLE이 리소스를 대기하는 동안 시간 초과가 발생합니다.      |
| TOO_MANY_ROWS           | ORA-01422     | 단일 행 SELECT는 하나 이상의 행을 RETURN합니다.              |
| VALUE_ERROR             | ORA-06502     | 계산,변환,절단,또는 크기 제약 오류가 발생합니다.             |
| ZERO_DIVIDE             | ORA-01476     | 0으로 배분을 시도합니다.                                     |



![image-20200601132006721](images/image-20200601132006721.png)

NUMBER 타입은 PACKED DECIMAL 형태로 데이터 저장

							- 1 BYTE = 2 DIGIT = 4BIT 1개 DIGIT
							- 24 -> **0010** **0100**





SQLCODE

- ERROR 코드 리턴

SQLERRM

- ERROR 메세지 리턴





## DATA TYPE과 참조연산자

![image-20200602092108902](images/image-20200602092108902.png)



EMP.EMPNO의 타입을 참조할 것



%ROWTYPE이라고 정의하면 **RECORD**로 정의된다.

![image-20200602093016524](images/image-20200602093016524.png)



## BLOCK 내의 SELECT



SELECT 내에 INTO를 반드시 써야 한다.



OTHERS

- 모든 예외

NO_DATA_FOUND

- 데이터가 발견되지 않았을때

TOO_MANY_ROWS

- 데이터가 많이 발견될때 -> PL/SQL에 지정된 변수가 하나의 값만 저장할 수 있는 경우라면 에러가 발생하게되는 것

```SQL
DECLARE 
    V_EMPNO EMP.EMPNO%TYPE;
    V_ENAME EMP.EMPNO%TYPE;
    V_HIREDATE EMP.HIREDATE%TYPE;
    
BEGIN
    -- V_EMPNO, V_ENAME, V_HIREDATE라는 변수에는 하나만 저장할 수 있어서 에러가 발생
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
```





```sql
-- (table)
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
```



```sql
-- (record)
SET SERVEROUTPUT ON
declare
    type t_emp is record(
        t_empno     emp.empno%type,
        t_ename     emp.ename%type,
        t_hiredate  emp.hiredate%type
    );
    
rec_emp t_emp;
l binary_integer := 0;
begin
    -- record의 field에 값을 대입
    for k in (select empno, ename, hiredate from emp where empno >= 1) loop
        
        rec_emp.t_empno := k.empno;
        rec_emp.t_ename := k.ename;
        rec_emp.t_hiredate := k.hiredate;
        
        dbms_output.put_line(rec_emp.t_empno || ' / ' ||rec_emp.t_ename || ' / ' || rec_emp.t_hiredate);
        
    end loop;
    
exception
    when no_data_found then
            dbms_output.put_line('no data found !!!');
    when too_many_rows then
            dbms_output.put_line('too many rows found !!!');
end;
/
```





## :star:CURSOR

PL/SQL의 주된 목적: 데이터 처리 그리고 **CURSOR**!



**CURSOR** - RECORD, TABLE

dynamic array





![image-20200602112830568](images/image-20200602112830568.png)



BEGIN~END 사이에서 사용한 모든 SQL이 암시적인 커서

CURSOR이라고 명시한 것이 명시적인 커서



*FILE 입출력과 같다

(1) CURSOR 정의

(2-1) CURSOR OPEN (LOOP 시작) -> RESULT SET 생성

(2-2) CURSOR FETCH

(2-3) CURSOR CLOSE (LOOP 종료) -> RESULT SET 삭제

![커서](images/download.png)

DECLARE : 커서를 정의하는 등 커서에 관련된 선언을 하는 명령입니다.

OPEN : 커서가 질의 결과의 첫번째 튜플을 포인트하도록 설정하는 명령입니다.

FETCH : 질의 결과의 튜플들 중 현재의 다음 튜플로 커서를 이동시키는 명령입니다.

CLOSE : 질의 수행 결과에 대한 처리 종료 시 커서를 닫기 위해 사용하는 명령입니다.



![image-20200602132412615](images/image-20200602132412615.png)

1) binding = bind variables

2) execute sql



```sql
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
```



```sql
DECLARE
    CURSOR CUR_EMP IS 
    SELECT ENAME/*EMPNO*/, JOB, SAL, COMM FROM EMP WHERE DEPTNO = 10; -- R.S. 테이블 생성
    
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
```



bulk binding

array processing





## 커서와 참조변수



![image-20200603091225694](images/image-20200603091225694.png)





## Cursor for Loop



![image-20200603091752087](images/image-20200603091752087.png)

in 다음에 cursor의 이름이 왔는데,

이를 보면 암시적으로 cursor를 open해서 사용하고

for .. loop이 끝나면 암시적으로 cursor을 close 했음을 알 수 있다.

![image-20200603092102079](images/image-20200603092102079.png)

에러가 나는 이유는, cursor for loop이 끝나서 cursor가 끝나서 더이상 cursor을 사용할 수 없기 때문이다.



![image-20200603092212259](images/image-20200603092212259.png)



cursor for loop라는 건 cursor의 힘을 빌려서 loop을 제어하는 것

in 다음에 cursor가 참조할 데이터의 범위가 나온다.



![image-20200603094902217](images/image-20200603094902217.png)

![image-20200603094958378](images/image-20200603094958378.png)

parameter mode

in mode (default)

out mode

in-out mode



![image-20200603095303783](images/image-20200603095303783.png)







*FOR UPDATE 사용시 주의









```SQL
--REM  5_CURSOR_forupdate.SQL 
SET  TIMING  ON 
SELECT  TO_CHAR(SYSDATE,'HH24:MI:SS') AS START_TIME FROM DUAL; 
 
DECLARE 
 CURSOR  CUR_EMP(P_DEPTNO IN NUMBER) IS 
   SELECT EMPNO,ENAME,JOB,SAL,COMM FROM EMP  
  WHERE  DEPTNO = P_DEPTNO  
           FOR  UPDATE; 
--   FOR  UPDATE  WAIT  10;         
--   FOR   UPDATE  NOWAIT; 
--               FOR  UPDATE  OF EMP.JOB         
 V_DEPTNO DEPT.DEPTNO%TYPE; 
BEGIN 
 V_DEPTNO  :=  20; 
 
    FOR  R_CUR_EMP IN CUR_EMP(V_DEPTNO) 
    LOOP 
    UPDATE EMP 
    SET    COMM =  ROUND(R_CUR_EMP.SAL * 0.05,0) -- 급여의 5프로를 COMM으로 줄 것
    WHERE  EMPNO = R_CUR_EMP.EMPNO; -- 이게 속도가 더 빠르다.
         -- WHERE  CURRENT OF CUR_EMP; -- 위의 WHERE과 같은 역할, 커서가 현재 갖고온 레코드의 현재
 
    INSERT INTO BONUS(ENAME,JOB,SAL,COMM)
               VALUES(R_CUR_EMP.ENAME,R_CUR_EMP.JOB,R_CUR_EMP.SAL, 
    ROUND(R_CUR_EMP.SAL * 0.05,0)); 
 
--    DBMS_LOCK.SLEEP(5); -- 권한이 없어서 지금은 못씀
 END LOOP; 
        COMMIT; 
END; 
/ 
 
SELECT  TO_CHAR(SYSDATE,'HH24:MI:SS') AS END_TIME FROM DUAL; 
```



*Rowid - index

- **데이터베이스 내 *데이터 공유의 주소***
- **데이터베이스에서 데이터마다의 주소를 의미하는 개념**
- **각각의 데이터를 구분할 수 있는 유일한 ID**

http://www.gurubee.net/lecture/2927

index => 존재이유, 데이터를 quick search 하기 위함

rowid가 index에 들어간다.

rowid를 이해해야지 index의 실체를 이해할 수 있다.

index를 제대로 이해하려면 dbms의 아키텍쳐 저장구조를 반드시 이해해야한다.



`SELECT ENAME, SAL, ROWID FROM EMP;`

![image-20200605142139022](images/image-20200605142139022.png)

AAAR+F

AAH

AAAAC7

AAA - 데이터 번호



`행을 찾는 가장 빠른 방법 ROWID`

```SQL
UPDATE EMP SET SAL = 999
WHERE ROWID IN (SELECT ROWID FROM EMP WHERE ENAME LIKE 'A%');

SELECT ENAME, SAL FROM EMP WHERE ENAME LIKE 'A%';

ROLLBACK;
```



## pro*C

![image-20200604092208314](images/image-20200604092208314.png)![image-20200604095559226](images/image-20200604095559226.png)

c언어 안에서 sql을 사용한 것





 SELECT * FROM USER_ERRORS; 



```sql
SELECT NAME,LINE,TEXT FROM USER_SOURCE  WHERE  NAME = 'getBusinessDayProcedure' -- 대문자로 고쳐야 확인가능
-- DBMS 내부의 오브젝트 이름은 모두 대문자이다.
```

![image-20200604110035874](images/image-20200604110035874.png)





### Procedure VS Function

1. Procedure는 Return값이 없어도 되지만, Function은 Return값이 반드시 존재한다.

  (정확하게 말해서 Procedure는 Return값이 없거나 2개이상일수도 있지만, Function은 반드시 1개의 Return값이 존재합니다.)

2. Procedure의 처리 속도는 Function에 비해 빠르다.

  (Procedure는 서버단에서 값을 처리하지만, Function은 클라이언트단에서 처리한다고 합니다.)

3. Function은 Select문에서 호출이 가능하지만, Procedure는 Select문에서 호출이 불가능하다.



## Log

![image-20200605094018254](images/image-20200605094018254.png)





## package

연관된 **변수**

연관된 **프로시저**

연관된 **함수**

들의 꾸러미



자바의 class와 같다.



모듈화가 가능하다.



```sql
create or replace package p_employee
as
    procedure delete_emp(p_empno emp.empno%type);
    
    procedure insert_emp(p_emp number, p_ename varchar2, p_job varchar2, p_sal number, p_deptno number);
    -- 프로시져는 리턴값이 없어서 받을 필요도 없을뿐더러,
    -- 그냥 실행하고 끝난다.
    fuction search_mng(p_empno emp.empno%type) return varchar2;
    -- 함수가 리턴한 값을 받아야 한다.
    gy_rows number(6);
end p_employee;
/
```



## trigger

자동으로 실행되는

![image-20200605130904945](images/image-20200605130904945.png)

![image-20200605131815529](images/image-20200605131815529.png)

emp테이블의 sal을 update하기 전에 반드시 실행될 

insert/delete/update를 발생한 후, 혹은 발생하기 전에 무엇을 할 지 지정할 수 있다.

> 즉 위 TRIGGER은 9000 초과의 정보가 들어오면 9000으로 바뀐다.

:NEW.SAL은?

새로운(NEW) 레코드(ROW)가 들어온다는 뜻

|                             | :NEW | :OLD |
| --------------------------- | ---- | ---- |
| INSERT (새로운 데이터 삽입) | O    |      |
| UPDATE                      | O    | O    |
| DELETE (기존 데이터 삭제)   |      | O    |









