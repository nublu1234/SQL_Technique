### GREATEST and LEAST
```sql
USE sql_recipe;

SELECT YEAR, q1, q2, q3, q4
      ,GREATEST(q1, q2, q3, q4) AS greatest_sales
      ,LEAST(q1, q2, q3, q4) AS least_sales
FROM quarterly_sales
```
| YEAR | q1 | q2 | q3 | q4 | greatest_sales | least_sales | 
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | 
| 2015 | 82000 | 83000 | 78000 | 83000 | 83000 | 78000 | 
| 2016 | 85000 | 85000 | 80000 | 81000 | 85000 | 80000 | 
| 2017 | 92000 | 81000 | \N | \N | \N | \N | 
