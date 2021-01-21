```
CREATE SEQUENCE 시퀀스명
INCREMENT BY 증가 될 숫자
START WITH 시작 숫자
NOMINVALUE | MINVALUE 최솟값   -- NOMINVALUE 디폴트 값은 1, 최솟값 무한대로 설정NOMAXVALUE | MAXVALUE 최대값   -- NOMAXVALUE 디폴트 값은 1028-1, 최댓값 무한대로 설정NOCYCLE | CYCLE                -- CYCLE: 최댓값 또는 최솟값의 도달 시 최솟값 또는 최댓값 부터 시작NOCACHE | CACHE                -- CACHE: 메모리에 시퀀스 값의 할당 여부;
```