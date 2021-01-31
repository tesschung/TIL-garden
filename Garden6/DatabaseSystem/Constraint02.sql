DROP    TABLE  CUSTOMER;       
CREATE  TABLE  CUSTOMER ( 
  ID VARCHAR2(8)   NOT NULL , 
  PWD VARCHAR2(8) CONSTRAINT  CUSTOMER_PWD_NN  NOT  NULL, 
  NAME  VARCHAR2(20), -- 이름  
SEX CHAR(1),  -- 성별 [M|F]  M:MALE   F: FEMALE 
  AGE NUMBER(3) -- 나이 
);

select * from customer;

desc customer;

insert into customer(id, pwd, name, sex, age) values('xman', 'ok', 'kang', 'M', 21);
insert into customer(id, pwd, name, sex, age) values('XMAN', 'no', 'kim', 'T', -21);
-- 제약조건이 부실해서 이러한 쓰레기값도 insert된다.
insert into customer(id, name, age) values('zman', 'son', 99);
-- pwd의 not null 조건으로 인해 값이 insert되지 않는다.

INSERT INTO CUSTOMER(ID,PWD,NAME,AGE)  VALUES('rman',NULL,'jjang',24);
-- pwd의 not null 조건으로 인해 값이 insert되지 않는다.
INSERT INTO CUSTOMER(ID,PWD,NAME,AGE)  VALUES('', 'pwd' ,'jjang',24); 
-- ID의 not null 조건으로 인해 값이 insert되지 않는다.

update customer set age=-1, name = null;
-- where로 특정 pk를 정해주지 않아서 모든 age가 -1이 되었다.
UPDATE  CUSTOMER SET PWD = NULL WHERE ID = 'XMAN';
-- not null 제약조건으로 인해 update가 될 수 없다.
UPDATE  CUSTOMER SET PWD = NULL;   
-- not null 제약조건으로 인해 update가 될 수 없다.

-- TABLE의 이름, CONSTRAINT의 이름, CONSTRAINT의 타입, SEARCH할때의 CONDITION
SELECT TABLE_NAME,CONSTRAINT_NAME,CONSTRAINT_TYPE,SEARCH_CONDITION 
FROM   USER_CONSTRAINTS  
WHERE TABLE_NAME = 'CUSTOMER'; 

SELECT TABLE_NAME,CONSTRAINT_NAME,POSITION,COLUMN_NAME   
FROM  USER_CONS_COLUMNS 
WHERE  TABLE_NAME = 'CUSTOMER'   
ORDER  BY  CONSTRAINT_NAME,POSITION; 

DROP TABLE CUSTOMER2;
CREATE  TABLE  CUSTOMER2( 
  ID VARCHAR2(8)  NOT NULL, 
   PWD VARCHAR2(8) CONSTRAINT  CUSTOMER2_PWD_NN  NOT  NULL, 
  NAME  VARCHAR2(20), 
  SEX CHAR(1)  CONSTRAINT CUSTOMER2_SEX_CK CHECK (SEX IN ('M','F')), 
AGE NUMBER(3) CHECK  ( AGE > 0 AND AGE < 100) 
); 

SELECT * FROM CUSTOMER2;

INSERT INTO CUSTOMER2(ID,PWD,NAME,SEX, AGE)  VALUES('xman','ok','kang', 'M',21); 

INSERT INTO CUSTOMER2(ID,PWD,NAME,SEX,AGE)  VALUES('xman','ok', 'jjang','M',20);
-- insert되었다.
 
INSERT INTO CUSTOMER2(ID,PWD,NAME,SEX,AGE)  VALUES('XMAN','no','kim', 'M',-20);
-- check제약 조건을 위배했다.
 
INSERT INTO CUSTOMER2(ID,PWD,NAME,AGE)      VALUES('asura','ok', 'joo',99); 
-- 삽입되었다, 성별에 null이 추가되었다.

INSERT INTO CUSTOMER2(ID,PWD,NAME,SEX,AGE)  VALUES('harisu','ok', 'susu','T',33);
-- check에서 T가 걸러진다.
-- 체크 제약조건(DA08.CUSTOMER2_SEX_CK)이 위배되었습니다

INSERT INTO CUSTOMER2(ID,PWD,NAME,SEX,AGE)  VALUES('shinsun','ok', '도사', 'M',999); 
-- ORA-02290: 체크 제약조건(DA08.SYS_C009939)이 위배되었습니다

UPDATE  CUSTOMER  SET  AGE = AGE + 1;   
UPDATE  CUSTOMER2  SET  AGE = AGE + 1;   
-- ORA-02290: 체크 제약조건(DA08.SYS_C009939)이 위배되었습니다
select * from customer;
select * from customer2;
--ORA-02290: 체크 제약조건(DA08.SYS_C009939)이 위배되었습니다



DROP    TABLE  CUSTOMER3; 
CREATE  TABLE  CUSTOMER3( 
 ID VARCHAR2(8) NOT NULL  CONSTRAINT  CUSTOMER3_ID_UK UNIQUE, 
 PWD VARCHAR2(8) NOT  NULL, 
 NAME  VARCHAR2(20), 
 SEX CHAR(1) DEFAULT 'M'  CONSTRAINT CUSTOMER_SEX_CK CHECK (SEX IN ('M','F')), 
 MOBILE VARCHAR2(14) UNIQUE,  -- 핸드폰 번호 
 AGE NUMBER(3) DEFAULT 18 
);

select * from customer3;

 INSERT INTO CUSTOMER3(ID,PWD,NAME,MOBILE, AGE) VALUES('xman','ok','kang', '011-3333',21); 
 -- 성별이 안들어가서 M이 들어갔다.

INSERT INTO CUSTOMER3(ID,PWD,NAME, MOBILE,AGE) VALUES('yman','yes','lee', '011-3333',28);  --핸폰? 
-- 핸드폰 번호가 중복되어 제약조건 위배 발생

INSERT INTO CUSTOMER3(ID,PWD,NAME, MOBILE,AGE) VALUES('XMAN','yes','kim','011-3334',33);
-- 대소문자 구분이 없어서 insert 된다.

INSERT INTO CUSTOMER3(ID,PWD,NAME, MOBILE,AGE) VALUES(lower('XMAN'),'yes','kim','011-3334',33);
-- lower()함수를 사용하여 제약조건을 유지한다.

INSERT INTO CUSTOMER3(ID,PWD,NAME, MOBILE,AGE) VALUES('xman','yes','lee', '011-3335',-21);
-- 무결성 제약 조건(DA08.CUSTOMER3_ID_UK)에 위배됩니다



INSERT INTO CUSTOMER3(ID,PWD,NAME, MOBILE)     VALUES('무명인','yes',NULL, NULL);
-- "DA08"."CUSTOMER3"."ID" 열에 대한 값이 너무 큼(실제: 9, 최대값: 8)


ALTER TABLE CUSTOMER3 ADD CONSTRAINT CUSTOMER_NAME_SEX_UK UNIQUE(NAME,SEX); 
-- 컬럼의 조합의 ~~
-- 테이블 생성후에 제약사항 추가
desc customer3;

ALTER TABLE CUSTOMER3  MODIFY(NAME NOT NULL);
-- name에 null을 허용하지 않는다.

INSERT INTO CUSTOMER3(ID,PWD,NAME, SEX)   VALUES('rman','yes','ksh', 'M'); 
INSERT INTO CUSTOMER3(ID,PWD,NAME, SEX )  VALUES('Rman','yes','ksh', 'F');   
INSERT INTO CUSTOMER3(ID,PWD,NAME, SEX)   VALUES('RmaN','yes','ksh', 'M'); 
-- ORA-00001: 무결성 제약 조건(DA08.CUSTOMER_NAME_SEX_UK)에 위배됩니다
-- name과 sex의 조합에 대한 unique index가 만들어진다.

SELECT * FROM CUSTOMER3; 




SELECT INDEX_NAME,INDEX_TYPE,UNIQUENESS FROM USER_INDEXES 
WHERE  TABLE_NAME = 'CUSTOMER3'; 
-- 내소유의 모든 인덱스 확인

SELECT INDEX_NAME,COLUMN_POSITION,COLUMN_NAME FROM USER_IND_COLUMNS 
WHERE  TABLE_NAME = 'CUSTOMER3'  ORDER BY INDEX_NAME,COLUMN_POSITION; 
-- USER_IND_COLUMNS: 내 소유의 인덱스 중에 걸려있는 인덱스





DROP    TABLE  CUSTOMER4; 
CREATE  TABLE  CUSTOMER4( 
 ID VARCHAR2(8)    CONSTRAINT CUSTOMER_ID_PK PRIMARY KEY, 
 PWD VARCHAR2(8) NOT  NULL, 
 NAME  VARCHAR2(20), 
SEX CHAR(1)  DEFAULT 'M'  CONSTRAINT CUSTOMER_SEX_CK CHECK (SEX IN ('M','F')), 
 MOBILE VARCHAR2(14) CONSTRAINT CUSTOMER_MOBILE_UK UNIQUE,  
 AGE NUMBER(3) DEFAULT 18 
); 

select * from customer4; 

INSERT INTO CUSTOMER4(ID,PWD,NAME,MOBILE)  VALUES('zman','ok','한국', '011'); 
 INSERT INTO CUSTOMER4(ID,PWD,NAME)  VALUES('xman','ok','king'); 
 
 INSERT INTO CUSTOMER4(ID,PWD,NAME)  VALUES(lower('xMan'),'ok','zzang'); 
-- values절에 함수를 사용할 수 있다.

INSERT INTO CUSTOMER4(ID,PWD,NAME)  VALUES('Xman','korea','dbzzang');

INSERT INTO CUSTOMER4(ID,PWD,NAME)  VALUES(lower('xMan'),'ok','zzang'); 
-- ORA-00001: 무결성 제약 조건(DA08.CUSTOMER_ID_PK)에 위배됩니다

INSERT INTO CUSTOMER4(PWD,NAME)   VALUES('ok','kim');
-- ORA-01400: NULL을 ("DA08"."CUSTOMER4"."ID") 안에 삽입할 수 없습니다
-- 제약사항 이름은 테이블끼리 공유하는가? 계정/스키마안에서 공유한다.

UPDATE  CUSTOMER SET ID = NULL;

--START C:\Users\HP\Desktop\DB모델링\T_CONS3.SQL; 



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

select * from emp;


