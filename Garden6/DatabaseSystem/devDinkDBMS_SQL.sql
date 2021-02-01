-- THREE
---- 1095���� ���� 3�� ��~����
---- 17/05/18~18/07/15
---- FIVE
---- 3��� 5��~���� ����
---- 15/05/19~17/05/17
---- MORE
---- ���̻�����
---- 08/07/17~15/05/18
--SELECT A.ADDRESS, A.THREE, B.FIVE, C.MORE FROM 
--
--(select D.ADDRESS AS ADDRESS, COUNT(M.ADDRESS1) THREE
--from customer M, (select distinct substr(address1,1,2) AS ADDRESS, ID from customer) D
--where M.ID=D.ID AND M.enroll_dt >= to_char(sysdate-1095, 'yy/mm/dd')
--GROUP BY D.ADDRESS
--) A
--,
--
--
--(select D.ADDRESS AS ADDRESS, COUNT(M.ADDRESS1) FIVE
--from customer M, (select distinct substr(address1,1,2) AS ADDRESS, ID from customer) D
--where M.ID=D.ID AND  M.ENROLL_DT between TO_CHAR(sysdate-1825, 'yy/mm/dd') and TO_CHAR(sysdate-1095, 'yy/mm/dd')
--GROUP BY D.ADDRESS
--) B,
--
--
--(select D.ADDRESS AS ADDRESS, COUNT(M.ADDRESS1) MORE
--from customer M, (select distinct substr(address1,1,2) AS ADDRESS, ID from customer) D
--where M.ID=D.ID AND M.enroll_dt <= to_char(sysdate-1825, 'yy/mm/dd')
--GROUP BY D.ADDRESS
--) C
--
--WHERE A.ADDRESS = B.ADDRESS AND B.ADDRESS = C.ADDRESS  AND A.ADDRESS != 'uC'
--
--ORDER BY A.ADDRESS;
--
--
--
--
---- THREE
---- 1095���� ���� 3�� ��~����
---- 17/05/18~18/07/15
---- FIVE
---- 3��� 5��~���� ����
---- 15/05/19~17/05/17
---- MORE
---- ���̻�����
---- 08/07/17~15/05/18
--SELECT A.ADDRESS, A.THREE, B.FIVE, C.MORE FROM 
--
--(select D.ADDRESS AS ADDRESS, COUNT(M.ADDRESS1) THREE
--from customer M, (select distinct substr(address1,1,2) AS ADDRESS, ID from customer) D
--where M.ID=D.ID AND M.enroll_dt >= to_char(sysdate-1095, 'yy/mm/dd')
--GROUP BY D.ADDRESS
--) A
--,
--
--
--(select D.ADDRESS AS ADDRESS, COUNT(M.ADDRESS1) FIVE
--from customer M, (select distinct substr(address1,1,2) AS ADDRESS, ID from customer) D
--where M.ID=D.ID AND  M.ENROLL_DT between TO_CHAR(sysdate-1825, 'yy/mm/dd') and TO_CHAR(sysdate-1095, 'yy/mm/dd')
--GROUP BY D.ADDRESS
--) B,
--
--
--(select D.ADDRESS AS ADDRESS, COUNT(M.ADDRESS1) MORE
--from customer M, (select distinct substr(address1,1,2) AS ADDRESS, ID from customer) D
--where M.ID=D.ID AND M.enroll_dt <= to_char(sysdate-1825, 'yy/mm/dd')
--GROUP BY D.ADDRESS
--) C
--
--WHERE A.ADDRESS = B.ADDRESS AND B.ADDRESS = C.ADDRESS  AND A.ADDRESS != 'uC'
--
--ORDER BY A.ADDRESS;


-- �Ϸ�
-- 1095���� ���� 3�� ��~����
-- 17/05/18~18/07/15
-- 3��� 5��~���� ����
-- 15/05/19~17/05/17
-- ���̻�����
-- 08/07/17~15/05/18
SELECT YEAR YEAR, ADDRESS ����, THREE ���� FROM (
SELECT A.ADDRESS, A.ADDRESSNUM AS THREE, '3��̸�' YEAR
FROM 
(select D.ADDRESS AS ADDRESS, COUNT(M.ADDRESS1) ADDRESSNUM
from customer M, (select distinct  substr(address1,1,2) AS ADDRESS, ID from customer) D
where M.ID=D.ID AND M.enroll_dt >= to_char(sysdate-1095, 'yy/mm/dd')
GROUP BY D.ADDRESS) A

UNION

SELECT A.ADDRESS, A.ADDRESSNUM AS FIVE, '5��̸�' YEAR
FROM 
(select D.ADDRESS AS ADDRESS, COUNT(M.ADDRESS1) ADDRESSNUM
from customer M, (select distinct substr(address1,1,2) ADDRESS, ID from customer) D
where M.ID=D.ID AND  M.ENROLL_DT between TO_CHAR(sysdate-1825, 'yy/mm/dd') and TO_CHAR(sysdate-1095, 'yy/mm/dd')
GROUP BY D.ADDRESS) A

UNION

SELECT A.ADDRESS, A.ADDRESSNUM AS MORE, '5���̻�' YEAR
FROM 
(select D.ADDRESS AS ADDRESS, COUNT(M.ADDRESS1) ADDRESSNUM
from customer M, (select distinct  substr(address1,1,2) AS ADDRESS, ID from customer) D
where M.ID=D.ID AND M.enroll_dt <= to_char(sysdate-1825, 'yy/mm/dd')
GROUP BY D.ADDRESS) A
)
WHERE ADDRESS != 'uC'
ORDER BY YEAR, ����;