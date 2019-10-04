## Ch 2. Sorting Query Results

### 2.5 Dealing with Nulls When Sorting
```sql
USE SQL_CookBook;

WITH EMP2 AS (
    SELECT *, CASE WHEN COMM IS NULL THEN 0 ELSE 1 END AS IS_NULL
    FROM EMP
)
SELECT ENAME, SAL, COMM
FROM EMP2
ORDER BY IS_NULL DESC, COMM
```
| ENAME | SAL | COMM | 
| --- | ---: | ---: | 
| TURNER | 1500 | 0 | 
| ALLEN | 1600 | 300 | 
| WARD | 1250 | 500 | 
| MARTIN | 1250 | 1400 | 
| SMITH | 800 | \N | 
| JONES | 2975 | \N | 
| BLAKE | 2850 | \N | 
| CLARK | 2450 | \N | 
| SCOTT | 3000 | \N | 
| KING | 5000 | \N | 
| ADAMS | 1100 | \N | 
| JAMES | 950 | \N | 
| FORD | 3000 | \N | 
| MILLER | 1300 | \N | 
---

### 2.6 Sorting on a Data Dependent Key
```sql
USE SQL_CookBook;

SELECT ENAME,SAL,JOB,COMM 
FROM EMP 
ORDER BY CASE WHEN JOB = 'SALESMAN' THEN COMM ELSE SAL END
```
| ENAME | SAL | JOB | COMM | 
| --- | ---: | --- | ---: | 
| TURNER | 1500 | SALESMAN | 0 | 
| ALLEN | 1600 | SALESMAN | 300 | 
| WARD | 1250 | SALESMAN | 500 | 
| SMITH | 800 | CLERK | \N | 
| JAMES | 950 | CLERK | \N | 
| ADAMS | 1100 | CLERK | \N | 
| MILLER | 1300 | CLERK | \N | 
| MARTIN | 1250 | SALESMAN | 1400 | 
| CLARK | 2450 | MANAGER | \N | 
| BLAKE | 2850 | MANAGER | \N | 
| JONES | 2975 | MANAGER | \N | 
| SCOTT | 3000 | ANALYST | \N | 
| FORD | 3000 | ANALYST | \N | 
| KING | 5000 | PRESIDENT | \N | 
---