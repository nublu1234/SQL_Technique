### Cohort Analysis
```sql
USE salesorderssample;

WITH Order_Product_Details AS (
    SELECT OD.OrderNumber
          ,O.CustomerID
          ,O.OrderDate
          ,EXTRACT(YEAR FROM O.OrderDate) AS OrderYear
		    ,EXTRACT(MONTH FROM O.OrderDate) AS OrderMonth
		    ,EXTRACT(DAY FROM O.OrderDate) AS OrderDay
		    ,EXTRACT(MONTH FROM O.OrderDate) 
			  + 12*(EXTRACT(YEAR FROM O.OrderDate) - 2015) -8 AS CohortMonth
          ,OD.ProductNumber
          ,P.CategoryID
          ,C.CategoryDescription
    FROM Order_Details AS OD
    LEFT JOIN Orders AS O
           ON OD.OrderNumber = O.OrderNumber
    LEFT JOIN Products AS P
           ON OD.ProductNumber = P.ProductNumber
    LEFT JOIN Categories AS C
           ON P.CategoryID = C.CategoryID
)
-- SELECT * FROM Order_Product_Details ORDER BY CustomerID, OrderDate;

, Order_Cohort AS (
    SELECT CustomerID, CohortMonth, CategoryID, CategoryDescription, COUNT(CustomerID) AS Cohort_CNT
    FROM Order_Product_Details
    GROUP BY CustomerID, CohortMonth, CategoryID
    HAVING CategoryDescription = 'Skateboards' AND COUNT(CustomerID) > 1 /*
	 HAVING CategoryDescription = 'Clothing' AND COUNT(CustomerID) > 1 
	 HAVING CategoryDescription = 'Car racks' AND COUNT(CustomerID) > 1 */
)
-- SELECT * FROM Order_Cohort ORDER BY CustomerID, CohortMonth, CategoryID;
, CustomerFirstCohort AS (
    SELECT CustomerID
	       ,FIRST_VALUE(CohortMonth) 
			      OVER (PARTITION BY CustomerID 
					      ORDER BY CohortMonth) AS FirstMonth
    FROM Order_Cohort
    GROUP BY CustomerID
)
-- SELECT * FROM CustomerFirstCohort;

, Order_Cohort2 AS (
    SELECT OC.CustomerID
	       ,CFC.FirstMonth
          ,OC.CohortMonth
          ,OC.CohortMonth - CFC.FirstMonth AS CohortMonth2
          ,OC.CategoryID
          ,OC.CategoryDescription
          ,OC.Cohort_CNT
    FROM Order_Cohort AS OC
    LEFT JOIN CustomerFirstCohort AS CFC
           ON OC.CustomerID = CFC.CustomerID
)
-- SELECT * FROM Order_Cohort2 ORDER BY CustomerID;

SELECT FirstMonth
      ,SUM(CASE WHEN CohortMonth2 = 0 THEN 1 ELSE 0 END) AS Period0
      ,SUM(CASE WHEN CohortMonth2 = 1 THEN 1 ELSE 0 END) AS Period1
      ,SUM(CASE WHEN CohortMonth2 = 2 THEN 1 ELSE 0 END) AS Period2
      ,SUM(CASE WHEN CohortMonth2 = 3 THEN 1 ELSE 0 END) AS Period3
      ,SUM(CASE WHEN CohortMonth2 = 4 THEN 1 ELSE 0 END) AS Period4
      ,SUM(CASE WHEN CohortMonth2 = 5 THEN 1 ELSE 0 END) AS Period5
FROM Order_Cohort2
GROUP BY FirstMonth
```
| FirstMonth | Period0 | Period1 | Period2 | Period3 | Period4 | Period5 | 
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | 
| 1 | 15 | 10 | 8 | 8 | 11 | 8 | 
| 2 | 3 | 2 | 1 | 1 | 0 | 0 | 
| 3 | 3 | 1 | 3 | 2 | 0 | 0 | 
| 4 | 2 | 0 | 1 | 0 | 0 | 0 | 
| 6 | 1 | 0 | 0 | 0 | 0 | 0 | 
