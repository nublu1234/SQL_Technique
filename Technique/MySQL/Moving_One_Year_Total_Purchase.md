

### Moving One Year Total Purchase
```sql
WITH Daily_Purchase AS (
    SELECT *
	       ,SUBSTR(dt, 1, 4) AS YEAR
          ,SUBSTR(dt, 6, 2) AS MONTH
          ,SUBSTR(dt, 9, 2) AS DATE
    FROM Purchase_Log
)
-- SELECT * FROM Daily_Purchase;

, Monthly_Purchase AS (
    SELECT YEAR
          ,MONTH
		    ,SUM(Purchase_Amount) AS Monthly_Purchase_Amount 
		    ,SUM(SUM(Purchase_Amount))
    		     OVER(
    			       PARTITION BY YEAR
    			       ORDER BY YEAR, MONTH) AS Monthly_Cummulate_Purchase_Amount
	    	,SUM(SUM(Purchase_Amount))
    		     OVER(
    			       ORDER BY YEAR, MONTH
    					 ROWS BETWEEN CURRENT ROW
    					          AND 11 FOLLOWING) AS Month12_Purchase_Amount
    FROM Daily_Purchase
    GROUP BY YEAR, MONTH
    ORDER BY YEAR, MONTH
)
-- SELECT * FROM Monthly_Purchase;

, Purchase_Detail AS (
    SELECT *
          ,LAG(Month12_Purchase_Amount, 11)
               OVER(ORDER BY YEAR, MONTH) AS Year1_Purchase_Amount
    FROM Monthly_Purchase
)
-- SELECT * FROM Purchase_Detail;

SELECT YEAR
      ,MONTH
		,Monthly_Purchase_Amount 
		,Monthly_Cummulate_Purchase_Amount
		,Year1_Purchase_Amount
FROM Purchase_Detail
WHERE YEAR=2015
```
| YEAR | MONTH | Monthly_Purchase_Amount | Monthly_Cummulate_Purchase_Amount | Year1_Purchase_Amount | 
| --- | --- | ---: | ---: | ---: | 
| 2015 | 01 | 22111 | 22111 | 160796 | 
| 2015 | 02 | 11965 | 34076 | 144292 | 
| 2015 | 03 | 20215 | 54291 | 145608 | 
| 2015 | 04 | 11792 | 66083 | 145006 | 
| 2015 | 05 | 18087 | 84170 | 160811 | 
| 2015 | 06 | 18859 | 103029 | 169490 | 
| 2015 | 07 | 14919 | 117948 | 180382 | 
| 2015 | 08 | 12906 | 130854 | 187045 | 
| 2015 | 09 | 5696 | 136550 | 188909 | 
| 2015 | 10 | 13398 | 149948 | 195591 | 
| 2015 | 11 | 6213 | 156161 | 185360 | 
| 2015 | 12 | 26024 | 182185 | 182185 | 


> https://github.com/nublu1234/SQL_Technique/blob/master/SQL_Recipe/MySQL/data/9-6-data.sql