### IBM DB2

IBM DB2는 IBM에서 1983년에 발표된 상업용 관계 데이터베이스 관리 시스템이다. MVS/XA와 MVS/370 운영체제에서 사용되며 SQL을 데이터 언어로 사용하여 다수의 사용자들이 여러 개의 관계 데이터베이스를 동시에 접근할 수 있는 대형 데이터베이스를 위한 시스템이다.

```
// 그냥 Shell에서 실행
# db2 "Query"

OR

// Shell에서 db2 콘솔 실행
# db2
db2 => Query // db2 콘솔에서 쿼리 실행
```

예를 들면 다음과 같다.

```
# db2 "select * from table;"

OR

# db2
db2 => select * from table;
```

어느 방법이든 쿼리와 결과는 동일하기 때문에 편한 방식으로 사용하면 될 것 같다.

- 데이터베이스 생성

```
create database DB_NAME
```

- 테이블 생성

```
create table DB_NAME.TABLE_NAME(COL_1 char(30) not null, COL_2 varchar(100) not null);
```

- insert

```
insert into DB_NAME.TABLE_NAME(COL_1, COL_2, ...) values('VAL1_1', 'VAL1_2', '...'), ('VAL1_1', 'VAL1_2', '...'), (...);
```

- select

```
select * from DB_NAME.TABLE_NAME where CONDITION;
```

------

#### 참고사항

- where절 사용 시, 문자는 작은따옴표(‘)로 묶어야 하고, 조건은 대소문자를 구분한다.

```
select * from table where col='CONDITION';
```

이 때, ‘CONDITION’은 대소문자를 구분하기 때문에 `col='condition'`과 `col='CONDITION'`은 다른 결과를 얻는다.

- 전체 데이터베이스 리스트 출력

```
list database directory
```

- 전체 테이블 리스트 확인

```
select * from sysibm.systables;
```

이 때, `name` 컬럼은 `테이블 명`, `creator` 컬럼은 `데이터베이스 명`이다. 따라서 아래와 같이 사용하면 특정 데이터베이스 내의 테이블 명만 추출할 수 있다.

```
select name from sysibm.systables where creator='DB_NAME';
```

- 특정 개수만큼 select

```
select * from TABLE_NAME fetch first NUM rows only;
```

이렇게 하면 각 테이블의 `첫 행부터 NUM개의 행`을 `select` 한다. 만약 `마지막 행부터 특정 개수의 행을 추출`하고 싶다면, 특정 column을 기준으로 `order by desc`한 후 `fetch first NUM rows only`를 사용해야 한다.
(IBM 공식 답변에 따르면 테이블의 마지막 행부터 특정 개수의 행을 추출하는 쿼리는 따로 만들어져 있지 않다고 함)







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



DB2 procedure

```sql
/** 프로시저 생성 **/
CREATE OR REPLACE PROCEDURE SCHEMA_NAME.PROCEDURE_NAME (
    /** 파라미터 설정( IN, OUT, INOUT ) **/
    IN    I_STRD_DT    VARCHAR(8),
    IN    I_PARAM_1    VARCHAR(50),
    IN    I_PARAM_2    BIGINT,
    OUT   O_MESSAGE    VARCHAR(1000)
)
BEGIN
    /** 시작시간을 담은 변수 **/
    DECLARE V_STA_TIME VARCHAR(14);
    
    /** 파마리터를 담을 변수 **/
    DECLARE V_STRD_DT VARCHAR(8);
    DECLARE V_PARAM_1 VARCHAR(50);
    DECLARE V_PARAM_2 BIGINT;
    
    /** 계산값을 담을 변수 **/
    DECLARE V_NUM     BIGINT;
    DECLARE V_TOT     BIGINT;
    
    /** 묵시적 커서의 결과 변수 **/
    DECLARE V_INSERT_CNT DECIMAL(13, 0);
    DECLARE V_UPDATE_CNT DECIMAL(13, 0);
    DECLARE V_DELETE_CNT DECIMAL(13, 0);
    
    /** 오류 메시지 변수 **/
    DECLARE V_ERR_MSG VARCHAR(50);
    
    /** 동적쿼리 변수 **/
    DECLARE V_QRY VARCHAR(4000);
    
    /** 커서 **/
    DECLARE CUR1 CURSOR;
    
    /** SQL상태변수 **/
    DECLARE SQLCODE INT;
    DECLARE SQLSTATE CHAR(5) DEFAULT '00000';
    
    
    BEGIN
        /** 예외처리 **/
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET V_ERR_MSG = 'EXCEPTION > SQLSTATE=['||SQLSTATE||'], SQLCODE=['||TO_CHAR(SQLCODE)||']';
            SET O_MESSAGE = V_ERR_MSG;
            CALL DBMS_OUTPUT.PUT_LINE( O_MESSAGE );
        END
        ;
        
        /** 변수 초기화 **/
        SET V_STA_TIME = TO_CHAR(CURRENT TIMESTAMP, 'YYYYMMDDHH24MISS');
        
        SET V_STRD_DT = I_STRD_DT;
        SET V_PARAM_1 = I_PARAM_1;
        SET V_PARAM_2 = I_PARAM_2;
        
        SET V_NUM = 0;
        SET V_TOT = 0;
        
        SET V_INSERT_CNT = 0;
        SET V_UPDATE_CNT = 0;
        SET V_DELETE_CNT = 0;
        
        SET V_ERR_MSG = '';
        SET O_MESSAGE = 'SUCCESS';
        
        /** 
         * WITH순환절
         * 1~N 까지의 수를 출력하고 모두 더하시오.
         * N은 V_PARAM_2을 사용.
         **/
         
        /** 동적쿼리 생성 **/
        SET V_QRY = '
        WITH COUNTING ( NUM ) AS (
            SELECT 1 AS NUM
              FROM SYSIBM.SYSDUMMY1
             UNION ALL
            SELECT T1.NUM + 1 NUM
              FROM COUNTING T1
             WHERE 1=1
               AND T1.NUM < '||V_PARAM_2||'
        )
        SELECT T1.NUM
          FROM COUNTING
        ';
        
        /** 동적쿼리 커서 생성 **/
        PREPARE STMT1 FROM V_QRY;
        SET CUR1 = CURSOR WITH HOLD FOR STMT1;
        
        /** 커서 실행 **/
        OPEN CUR1;
            FETCH FROM CUR1 INTO V_NUM;
            WHILE SQLCODE = '00000' DO
                
                SET V_TOT = V_TOT + V_NUM;
                
                CALL DBMS_OUTPUT.PUT_LINE( 'NUM = '||V_NUM );
                
                FETCH FROM CUR1 INTO V_NUM;
            END WHILE;
        CLOSE CUR1;
        
        CALL DBMS_OUTPUT.PUT_LINE( '================');
        CALL DBMS_OUTPUT.PUT_LINE( 'TOT = '||V_TOT );
        
    END
    ;
END
;
```



