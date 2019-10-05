## Ch 3. Working with Multiple Tables

### 3.1 Stacking One Rowset Atop Another
```sql
USE SQL_CookBook;

SELECT ENAME AS ENAME_AND_DNAME, DEPTNO
FROM EMP
WHERE DEPTNO = 10
UNION ALL
SELECT '----------', NULL
FROM T1
UNION ALL 
SELECT DNAME, DEPTNO 
FROM DEPT
```
| ENAME_AND_DNAME | DEPTNO | 
| --- | ---: | 
| CLARK | 10 | 
| KING | 10 | 
| MILLER | 10 | 
| ---------- | \N | 
| ACCOUNTING | 10 | 
| RESEARCH | 20 | 
| SALES | 30 | 
| OPERATIONS | 40 | 
---

### 3.7 Determining Whether Two Tables Have the Same Data
```sql
WITH V AS (
    SELECT * 
    FROM EMP 
    WHERE DEPTNO != 10 
    UNION ALL 
    SELECT * 
    FROM EMP 
    WHERE ENAME = 'WARD'
)
-- SELECT * FROM V;
-- SELECT * FROM EMP;

, EMP_GRB AS (
    SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO, COUNT(*) AS CNT
    FROM EMP
    GROUP BY EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO
)
-- SELECT * FROM EMP_GRB;

, V_GRB AS (
    SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO, COUNT(*) AS CNT 
    FROM V 
    GROUP BY EMPNO,ENAME,JOB,MGR,HIREDATE, SAL,COMM,DEPTNO
)
-- SELECT * FROM V_GRB;

SELECT *
FROM EMP_GRB AS EG
WHERE NOT EXISTS (SELECT NULL
                  FROM V_GRB AS VG
                  WHERE VG.EMPNO = EG.EMPNO 
						  AND VG.ENAME = EG.ENAME 
						  AND VG.JOB = EG.JOB 
						  AND COALESCE(VG.MGR,0) = COALESCE(EG.MGR,0) 
						  AND VG.HIREDATE = EG.HIREDATE 
						  AND VG.SAL = EG.SAL 
						  AND VG.DEPTNO = EG.DEPTNO  
						  AND VG.CNT = EG.CNT 
						  AND COALESCE(VG.COMM,0) = COALESCE(EG.COMM,0)
						 )
UNION ALL
SELECT *
FROM V_GRB AS VG
WHERE NOT EXISTS (SELECT NULL
                  FROM EMP_GRB AS EG
                  WHERE VG.EMPNO = EG.EMPNO 
						  AND VG.ENAME = EG.ENAME 
						  AND VG.JOB = EG.JOB 
						  AND COALESCE(VG.MGR,0) = COALESCE(EG.MGR,0) 
						  AND VG.HIREDATE = EG.HIREDATE 
						  AND VG.SAL = EG.SAL 
						  AND VG.DEPTNO = EG.DEPTNO  
						  AND VG.CNT = EG.CNT 
						  AND COALESCE(VG.COMM,0) = COALESCE(EG.COMM,0)
						 )
```
| EMPNO | ENAME | JOB | MGR | HIREDATE | SAL | COMM | DEPTNO | CNT | 
| ---: | --- | --- | ---: | --- | ---: | ---: | ---: | ---: | 
| 7521 | WARD | SALESMAN | 7698 | 1981-02-22 | 1250 | 500 | 30 | 1 | 
| 7782 | CLARK | MANAGER | 7839 | 1981-06-09 | 2450 | \N | 10 | 1 | 
| 7839 | KING | PRESIDENT | \N | 1981-11-17 | 5000 | \N | 10 | 1 | 
| 7934 | MILLER | CLERK | 7782 | 1982-01-23 | 1300 | \N | 10 | 1 | 
| 7521 | WARD | SALESMAN | 7698 | 1981-02-22 | 1250 | 500 | 30 | 2 | 
- Alternative to <u>*'EXCEPT clause'*</u>

1. First, find rows in table EMP that do not exist in view V.
2. Then combine (UNION ALL) those rows with rows from view V that do not exist in table EMP.
---

### 3.12 Using NULLs in Operations and Comparisons
```sql
WITH WARD AS (
    SELECT COMM 
    FROM EMP
    WHERE ENAME = 'WARD')
-- SELECT * FROM WARD;

SELECT ENAME,COMM 
FROM EMP 
WHERE COALESCE(COMM,0) < (SELECT COMM FROM WARD)
/* (SELECT COMM FROM WARD) = 500 */
```
| ENAME | COMM | 
| --- | ---: | 
| SMITH | \N | 
| ALLEN | 300 | 
| JONES | \N | 
| BLAKE | \N | 
| CLARK | \N | 
| SCOTT | \N | 
| KING | \N | 
| TURNER | 0 | 
| ADAMS | \N | 
| JAMES | \N | 
| FORD | \N | 
| MILLER | \N | 
