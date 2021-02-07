## DATATYPE_TABLE

*column 하나에도 4기가까지 저장 가능



④ BINARY

사진, 음성, 영상, ETC



BLOB





## CHAR

![image-20200514141749069](images/image-20200514141749069.png)

:star: 최대 2000bytes까지 저장



이름에 SMITH만 입력하면 나머지에 공백문자가 채워진다. 그러므로 비효율성 발생





## VARCHAR2



![image-20200514142027929](images/image-20200514142027929.png)

:star:최대 4000bytes까지 저장



char(100) - 숫자는 할당의 의미

varchar2(100) - 숫자는 최대라는 의미

가변길이는 저장 공간을 아끼고 장기적인 관점에서 보면 성능을 향상시킨다. 사용하는 블록이 줄어들기 때문이다. 



1개의 공간만 필요한 경우 char(1)로 지정하는 것이 필요하다.

![image-20200514143756654](images/image-20200514143756654.png)





## NUMBER

![image-20200514143843634](images/image-20200514143843634.png)



*최대 38자까지 가능하다.

NUMBER 은 자리수가 없기때문에 들어오는 데이터를 전부 저장한다. 38자리까지, 하지만 좋은 방식은 아니다.



## 테이블 생성(문자 DATA TYPE) 

```SQL
 CREATE TABLE CUSTOMERS(  -- 고객정보 관리 테이블 
 ID VARCHAR2(8),  -- 가변길이 데이터 타입 
 PWD CHAR(8),   -- 고정길이 데이터 타입 
 SEX CHAR(1)   -- 성별 [M|F]  성별은 항상 고정된 크기의 데이터가 저장 
);
SELECT * FROM CUSTOMERS;
INSERT INTO CUSTOMERS(ID, PWD, SEX) VALUES('ORACLE','OCM', 'F');
SELECT LENGTH(ID), LENGTH(PWD) FROM CUSTOMERS WHERE ID='ORACLE';
```

![image-20200514152352238](images/image-20200514152352238.png)





## 고정길이와 가변길이의 차이점 비교 



![image-20200514145153097](images/image-20200514145153097.png)



![image-20200514145159172](images/image-20200514145159172.png)



⑬ 조회안된다. 가변길이는 저장할때 공백을 채우지 않아서 조회가 되지 않는다. 둘이 다른데이터다.

⑭ 안된다. 가변길이, 가변길이와 고정길이가 충돌난다. 둘중에 하나의 방식으로 바뀌어야하는데

`형변환`이 되지 않는다. `가변길이 데이터 타입이 우선순위가 높다.`



⑮ 된다.



① 된다. 고정길이 - 상수

고정길이를 비교할때도 `BLANK PADDING`을 통해서 비교

자동으로 길이가 짧은쪽 길이를 확장, 즉 'XMAN공백4'을 채워서 조회한다.

공백을 넘어서 비교해도 비교가 된다.

암시적 테이터 형변환 발생

'XMAN공백10'을 하면 길이가 짧은 것을 길게 해서 비교



② 안된다.

형변환이 되지 않는다.

`SUBSTR('XMAN',1,2)||SUBSTR('XMAN',3,2)`를 가변길이라고 인식하고 비교한다.



③ 된다.

형변환이 된다.

단순하게 LIKE는 그냥 문자를 찾는 거라서 가능하다.

XMAN으로 시작하는 모든 것, 공백문자도 포함된다.

SELECT * FROM  CUSTOMER   
WHERE PWD  LIKE SUBSTR('XMAN',1,2)||SUBSTR('XMAN',3,2)||'____';

이것도 조회가 된다.



## 테이블 생성(숫자 DATA TYPE)

![image-20200514160353336](images/image-20200514160353336.png)

⑥ INSERT INTO TST_NUMBER  VALUES(123.5,**123.5**,123.5);

`124`로 된다.

⑧ INSERT INTO TST_NUMBER  VALUES(123,  12345,123); 

정수자리 초과시 에러

⑨ INSERT INTO TST_NUMBER  VALUES(123,  123,123.56789); 

실수자리 초과시 라운드





## 테이블 생성(:calendar: 날짜 DATA TYPE) 



![image-20200514162432708](images/image-20200514162432708.png)

[요구] 
ⓐ DEFAULT 에 TO_CHAR(SYSDATE,'YY/MM/DD')를 사용할수 있는지 확인 하는 SQL을 작성하십시요 

⑮ INSERT INTO TST_DATE(CHAR_HIREDATE,DATE_HIREDATE) VALUES(TO_CHAR(SYSDATE,'YYYYMMDD'),SYSDATE); 

①  INSERT INTO TST_DATE(CHAR_HIREDATE,DATE_HIREDATE) VALUES('19990921',TO_DATE('990921','YYMMDD')); 

②  SELECT * FROM TST_DATE; 





## ALTER

③ ALTER TABLE TST_DATE ADD(NAME  VARCHAR2(20), AGE NUMBER(3));

DESC  TST_DATE   



④ ALTER TABLE TST_DATE DROP COLUMN AGE; 

DESC  TST_DATE





## DROP

SELECT * FROM TAB; 

⑤ DROP  TABLE  TST_DATE; 

DESC TST_DATE 

SELECT * FROM TAB; 





## SUBQUERY에 의한  TABLE 생성 

물리적인 테이블 생성

![image-20200514170008576](images/image-20200514170008576.png)



CTAS 시타스

CREATE TABLE AS ~;



CVAS 시바스

CREATE VIEW AS ~;



## DELETE, TRUNCATE, DROP 의 차이점











