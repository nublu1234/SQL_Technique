## Ch 1. Retrieving Records

### 1.7 Concatenating Column Values
```sql
USE SQL_CookBook;

SELECT CONCAT(ENAME, ' WORKS AS A ',JOB) AS MSG 
FROM EMP 
WHERE DEPTNO=10
```
| MSG | 
| --- | 
| CLARK WORKS AS A MANAGER | 
| KING WORKS AS A PRESIDENT | 
| MILLER WORKS AS A CLERK | 
---

### 1.10 Returning n Random Records from a Table
```sql
USE SQL_CookBook;

SELECT ENAME,JOB
FROM EMP
ORDER BY RAND( ) LIMIT 5
```
| ENAME | JOB | 
| --- | --- | 
| SCOTT | ANALYST | 
| FORD | ANALYST | 
| JONES | MANAGER | 
| MILLER | CLERK | 
| CLARK | MANAGER | 
---

### 1.12 Transforming Nulls into Real Values
```sql
USE SQL_CookBook;

SELECT COMM, COALESCE(COMM,0) AS COMM_0
FROM EMP
```
| COMM | COMM_0 | 
| ---: | ---: | 
| \N | 0 | 
| 300 | 300 | 
| 500 | 500 | 
| \N | 0 | 
| 1400 | 1400 | 
| \N | 0 | 
| \N | 0 | 
| \N | 0 | 
| \N | 0 | 
| 0 | 0 | 
| \N | 0 | 
| \N | 0 | 
| \N | 0 | 
| \N | 0 | 
---


