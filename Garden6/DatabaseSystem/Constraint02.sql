DROP    TABLE  CUSTOMER;       
CREATE  TABLE  CUSTOMER ( 
  ID VARCHAR2(8)   NOT NULL , 
  PWD VARCHAR2(8) CONSTRAINT  CUSTOMER_PWD_NN  NOT  NULL, 
  NAME  VARCHAR2(20), -- �̸�  
SEX CHAR(1),  -- ���� [M|F]  M:MALE   F: FEMALE 
  AGE NUMBER(3) -- ���� 
);

select * from customer;

desc customer;

insert into customer(id, pwd, name, sex, age) values('xman', 'ok', 'kang', 'M', 21);
insert into customer(id, pwd, name, sex, age) values('XMAN', 'no', 'kim', 'T', -21);
-- ���������� �ν��ؼ� �̷��� �����Ⱚ�� insert�ȴ�.
insert into customer(id, name, age) values('zman', 'son', 99);
-- pwd�� not null �������� ���� ���� insert���� �ʴ´�.

INSERT INTO CUSTOMER(ID,PWD,NAME,AGE)  VALUES('rman',NULL,'jjang',24);
-- pwd�� not null �������� ���� ���� insert���� �ʴ´�.
INSERT INTO CUSTOMER(ID,PWD,NAME,AGE)  VALUES('', 'pwd' ,'jjang',24); 
-- ID�� not null �������� ���� ���� insert���� �ʴ´�.

update customer set age=-1, name = null;
-- where�� Ư�� pk�� �������� �ʾƼ� ��� age�� -1�� �Ǿ���.
UPDATE  CUSTOMER SET PWD = NULL WHERE ID = 'XMAN';
-- not null ������������ ���� update�� �� �� ����.
UPDATE  CUSTOMER SET PWD = NULL;   
-- not null ������������ ���� update�� �� �� ����.

-- TABLE�� �̸�, CONSTRAINT�� �̸�, CONSTRAINT�� Ÿ��, SEARCH�Ҷ��� CONDITION
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
-- insert�Ǿ���.
 
INSERT INTO CUSTOMER2(ID,PWD,NAME,SEX,AGE)  VALUES('XMAN','no','kim', 'M',-20);
-- check���� ������ �����ߴ�.
 
INSERT INTO CUSTOMER2(ID,PWD,NAME,AGE)      VALUES('asura','ok', 'joo',99); 
-- ���ԵǾ���, ������ null�� �߰��Ǿ���.

INSERT INTO CUSTOMER2(ID,PWD,NAME,SEX,AGE)  VALUES('harisu','ok', 'susu','T',33);
-- check���� T�� �ɷ�����.
-- üũ ��������(DA08.CUSTOMER2_SEX_CK)�� ����Ǿ����ϴ�

INSERT INTO CUSTOMER2(ID,PWD,NAME,SEX,AGE)  VALUES('shinsun','ok', '����', 'M',999); 
-- ORA-02290: üũ ��������(DA08.SYS_C009939)�� ����Ǿ����ϴ�

UPDATE  CUSTOMER  SET  AGE = AGE + 1;   
UPDATE  CUSTOMER2  SET  AGE = AGE + 1;   
-- ORA-02290: üũ ��������(DA08.SYS_C009939)�� ����Ǿ����ϴ�
select * from customer;
select * from customer2;
--ORA-02290: üũ ��������(DA08.SYS_C009939)�� ����Ǿ����ϴ�



DROP    TABLE  CUSTOMER3; 
CREATE  TABLE  CUSTOMER3( 
 ID VARCHAR2(8) NOT NULL  CONSTRAINT  CUSTOMER3_ID_UK UNIQUE, 
 PWD VARCHAR2(8) NOT  NULL, 
 NAME  VARCHAR2(20), 
 SEX CHAR(1) DEFAULT 'M'  CONSTRAINT CUSTOMER_SEX_CK CHECK (SEX IN ('M','F')), 
 MOBILE VARCHAR2(14) UNIQUE,  -- �ڵ��� ��ȣ 
 AGE NUMBER(3) DEFAULT 18 
);

select * from customer3;

 INSERT INTO CUSTOMER3(ID,PWD,NAME,MOBILE, AGE) VALUES('xman','ok','kang', '011-3333',21); 
 -- ������ �ȵ��� M�� ����.

INSERT INTO CUSTOMER3(ID,PWD,NAME, MOBILE,AGE) VALUES('yman','yes','lee', '011-3333',28);  --����? 
-- �ڵ��� ��ȣ�� �ߺ��Ǿ� �������� ���� �߻�

INSERT INTO CUSTOMER3(ID,PWD,NAME, MOBILE,AGE) VALUES('XMAN','yes','kim','011-3334',33);
-- ��ҹ��� ������ ��� insert �ȴ�.

INSERT INTO CUSTOMER3(ID,PWD,NAME, MOBILE,AGE) VALUES(lower('XMAN'),'yes','kim','011-3334',33);
-- lower()�Լ��� ����Ͽ� ���������� �����Ѵ�.

INSERT INTO CUSTOMER3(ID,PWD,NAME, MOBILE,AGE) VALUES('xman','yes','lee', '011-3335',-21);
-- ���Ἲ ���� ����(DA08.CUSTOMER3_ID_UK)�� ����˴ϴ�



INSERT INTO CUSTOMER3(ID,PWD,NAME, MOBILE)     VALUES('������','yes',NULL, NULL);
-- "DA08"."CUSTOMER3"."ID" ���� ���� ���� �ʹ� ŭ(����: 9, �ִ밪: 8)


ALTER TABLE CUSTOMER3 ADD CONSTRAINT CUSTOMER_NAME_SEX_UK UNIQUE(NAME,SEX); 
-- �÷��� ������ ~~
-- ���̺� �����Ŀ� ������� �߰�
desc customer3;

ALTER TABLE CUSTOMER3  MODIFY(NAME NOT NULL);
-- name�� null�� ������� �ʴ´�.

INSERT INTO CUSTOMER3(ID,PWD,NAME, SEX)   VALUES('rman','yes','ksh', 'M'); 
INSERT INTO CUSTOMER3(ID,PWD,NAME, SEX )  VALUES('Rman','yes','ksh', 'F');   
INSERT INTO CUSTOMER3(ID,PWD,NAME, SEX)   VALUES('RmaN','yes','ksh', 'M'); 
-- ORA-00001: ���Ἲ ���� ����(DA08.CUSTOMER_NAME_SEX_UK)�� ����˴ϴ�
-- name�� sex�� ���տ� ���� unique index�� ���������.

SELECT * FROM CUSTOMER3; 




SELECT INDEX_NAME,INDEX_TYPE,UNIQUENESS FROM USER_INDEXES 
WHERE  TABLE_NAME = 'CUSTOMER3'; 
-- �������� ��� �ε��� Ȯ��

SELECT INDEX_NAME,COLUMN_POSITION,COLUMN_NAME FROM USER_IND_COLUMNS 
WHERE  TABLE_NAME = 'CUSTOMER3'  ORDER BY INDEX_NAME,COLUMN_POSITION; 
-- USER_IND_COLUMNS: �� ������ �ε��� �߿� �ɷ��ִ� �ε���





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

INSERT INTO CUSTOMER4(ID,PWD,NAME,MOBILE)  VALUES('zman','ok','�ѱ�', '011'); 
 INSERT INTO CUSTOMER4(ID,PWD,NAME)  VALUES('xman','ok','king'); 
 
 INSERT INTO CUSTOMER4(ID,PWD,NAME)  VALUES(lower('xMan'),'ok','zzang'); 
-- values���� �Լ��� ����� �� �ִ�.

INSERT INTO CUSTOMER4(ID,PWD,NAME)  VALUES('Xman','korea','dbzzang');

INSERT INTO CUSTOMER4(ID,PWD,NAME)  VALUES(lower('xMan'),'ok','zzang'); 
-- ORA-00001: ���Ἲ ���� ����(DA08.CUSTOMER_ID_PK)�� ����˴ϴ�

INSERT INTO CUSTOMER4(PWD,NAME)   VALUES('ok','kim');
-- ORA-01400: NULL�� ("DA08"."CUSTOMER4"."ID") �ȿ� ������ �� �����ϴ�
-- ������� �̸��� ���̺��� �����ϴ°�? ����/��Ű���ȿ��� �����Ѵ�.

UPDATE  CUSTOMER SET ID = NULL;

--START C:\Users\HP\Desktop\DB�𵨸�\T_CONS3.SQL; 



declare
    v_empno number(4) := 8888; -- ���� ���� �� �ʱ�ȭ
    v_deptno number(2);
    v_ename varchar(10) := 'XMMAN'; -- ���� ���� �� �ʱ�ȭ
    v_job varchar(9);
    v_sal number(7,2);
begin
    v_deptno := 20;
    if v_job is null then
            v_job := '����';
    end if;
    if v_job = '����' then
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


