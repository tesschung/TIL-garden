## 10_200525





## 과제

**Data Dictionary(=system catalog)** DATA DICTIONARY에 대해서 설명

**-> DBMS 내부정보(meta data)**

dbms의 데이터 두 종류

- **시스템 데이터** : dbms가 운영되고 유지되고 관리하는 정보, 만든 테이블들을 설명하기 위한 메타데이터들, dbms 계정에 있는 유저데이터 ex) 테이블내의 컬럼 정보
- **유저 데이터** : 

데이터 사전(Data Dictionary)이란 **대부분 읽기전용으로 제공되는 테이블 및 뷰들의 집합으로 데이터베이스 전반에 대한 정보를 제공 한다.**

오라클 DB는 **명령이 실행될 때마다** **데이터 사전**을 **Access** 한다.

DB작업동안 Oracle은 데이터 사전을 읽어 객체의 존재여부와 사용자에게 적합한 Access 권한이 있는지를 확인 한다. 또한 Oracle은 데이터 사전을 계속 갱신하여 DATABASE 구조, 감사, 사용자권한, 데이터등의 변경 사항을 반영 한다.

- 오라클의 사용자 정보
- 오라클 권한과 롤 정보
- 데이터베이스 스키마 객체(TABLE, VIEW, INDEX, CLUSTER, SYNONYM, SEQUENCE..) 정보
- 무결성 제약조건에 관한 정보
- 데이터베이스의 구조 정보
- 오라클 데이터베이스의 함수 와 프로지저 및 트리거에 대한 정보
- 기타 일반적인 DATABASE 정보



(신형재님) **DBA_ , ALL_ , USER_ 에 대해서 설명 하십시요.**

`_` ~소유의

DBA_  DBMS내에 존재하는 모든

ALL_ accessible 가능한 모든

USER_ owner 모든(내소유의)



## :star:Constraint 제약사항

데이터의 **무결성** 제약사항

> 데이터에 결점이 없다.

무결성이란? 

**1) 개체 무결성 (Entity integrity)**

모든 테이블이 기본 키 (primary key)로 선택된 필드 (column)를 가져야 한다. 기본 키로 선택된 필드는 **고유한 값**을 가져야 하며, **빈 값은 허용하지 않는다**.

**2) 참조 무결성 (Referential integrity)**

관계형 데이터베이스 모델에서 참조 무결성은 참조 관계에 있는 두 테이블의 데이터가 항상 일관된 값을 갖도록 유지되는 것을 말한다. 

**3) 도메인 무결성 (Domain integrity)**

도메인 무결성은 테이블에 존재하는 필드의 무결성을 보장하기 위한 것으로 필드의 타입, NULL값의 허용 등에 대한 사항을 정의하고, 올바른 데이터의 입력 되었는지를 확인하는 것이다. 예를 들어, 주민등록번호 필드에 알파벳이 입력되는 경우는 도메인 무결성이 깨지는 경우라고 볼 수 있다. DBMS의 기본값 설정, NOT NULL 옵션 등의 제약 사항으로 도메인 무결성을 보장할 수 있다.

**4) 무결성 규칙 (Integrity rule)**

데이터베이스에서 무결성 규칙은 데이터의 무결성을 지키기 위한 모든 제약 사항들을 말한다. 비즈니스 규칙 (business rule)은 데이터베이스를 이용하는 각각의 유저에 따라 서로 다르게 적용되지만, 무결성 규칙은 데이터베이스 전체에 공통적으로 적용되는 규칙이다.



## :star: 선언적 무결성 제약사항 (모델링에 녹여낼 것)​

![image-20200525091507319](images/image-20200525091507319.png)





**P.K**: **U.K** + **N.N**의 조합, 데이터가 반드시 존재해야하고, 고유해야 한다. unique index 생성. 1개만 가능, PK는 테이블내에 단 하나여야 한다.

​	ex) ID, 주민등록번호

**U.K**: 고유성 보장, NULL 허용, 데이터는 없을 수 있지만 데이터가 존재한다면 고유해야한다. N개 가능, UK는 테이블 내에 여러개일 수 있다.

​	ex) 이메일, 전화번호

​	**unique index**란? unique key는 정의하는 순간에 자동으로 unique **index**를 생성한다. index가 dbms에 존재하는 목적은 quick search를 위함이다. 이를 통해 데이터의 중복을 빠르게 찾을 수 있다.

**N.N**: 

**CHECK**: If boolean, 데이터가 맞는지

​	ex) 남여

**F.K**: 참조 무결성,



## NOT NULL

![image-20200525094632835](images/image-20200525094632835.png)



`,` 컬럼과 컬럼을 구분

**pwd**에서 **constraint**란? customer_pwd_nn -> customer 데이블의 pwd는 not null 이다. 

constraint에서 명시적으로 이름을 안붙이면 sys_cXXXX 이런식으로 묵시적으로 이름을 시스템에서 붙여준다.



**sql script 실행방법 두가지**

![image-20200525095225490](images/image-20200525095225490.png)



![image-20200525095438120](images/image-20200525095438120.png)



![image-20200525101416136](images/image-20200525101416136.png)

```SQL
DROP    TABLE  CUSTOMER;       
CREATE  TABLE  CUSTOMER ( 
  ID VARCHAR2(8)     NOT NULL, 
  PWD VARCHAR2(8) CONSTRAINT  CUSTOMER_PWD_NN  NOT  NULL, 
  NAME  VARCHAR2(20), -- 이름  
SEX CHAR(1),  -- 성별 [M|F]  M:MALE   F: FEMALE 
  AGE NUMBER(3) -- 나이 
);
-- 오류발생시 CUSTOMER_PWD_NN이 보인다.


select * from customer;

desc customer;

insert into customer(id, pwd, name, sex, age) values('xman', 'ok', 'kang', 'M', 21);
insert into customer(id, pwd, name, sex, age) values('XMAN', 'no', 'kim', 'T', -21);
-- 제약조건이 부실해서 이러한 쓰레기값도 insert된다.
--  id 대소문자 구분이 없어야 한다. 성별에는 M과 F만 들어가야 한다. 나이에는 양수만 들어가야 한다.
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

-- dbms내에 meta 정보들을 확인할 수 있다.
-- TABLE의 이름, CONSTRAINT의 이름, CONSTRAINT의 타입, SEARCH할때의 CONDITION
SELECT TABLE_NAME,CONSTRAINT_NAME,CONSTRAINT_TYPE,SEARCH_CONDITION 
FROM   USER_CONSTRAINTS  
WHERE TABLE_NAME = 'CUSTOMER'; 
-- USER_CONSTRAINTS  내가 가진 제약 사항
-- USER_TABLES -> 나의 모든 테이블 조회
-- USER_SEQUENCES -> 내 소유의 모든 SEQUENCE

SELECT TABLE_NAME,CONSTRAINT_NAME,POSITION,COLUMN_NAME   
FROM  USER_CONS_COLUMNS 
WHERE  TABLE_NAME = 'CUSTOMER'   
ORDER  BY  CONSTRAINT_NAME,POSITION; 
```



`제약사항(constraint)`을 위반하는 경우 `rollback` 처리가 된다.

select는 조회만 하므로 constraint와 상관없다.



## CHECK: BOOLEAN CHECK





⑤ UPDATE  CUSTOMER  SET  AGE = AGE + 1;   --?? 

asura가 100이 되면, statement의 rollback발생, 수정했던 레코드들을 모두 전체 취소 시킨다.





## UNIQUE: 컬럼 또는 컬럼조합의 고유한 값을 보장 



![image-20200525104512112](images/image-20200525104512112.png)

제약사항 constraint [제약사항명] 제약사항







## PRIMARY KEY : ROW(RECORD)의 유일성을 보장하는 :star:식별자 

![image-20200526095124949](images/image-20200526095124949.png)

![image-20200526095822148](images/image-20200526095822148.png)

1. 선언적 무결성 제약사항 - pk, uk, fk, nn, check
2. Trigger - PL/SQL
3. Application Logic







## FOREIGN KEY : 테이블간(테이블내)의 참조 무결성(REFERNTIAL INTEGRITY)을 보장 

























