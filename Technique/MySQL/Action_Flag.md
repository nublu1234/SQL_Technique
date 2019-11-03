### Action Flag
```sql
WITH Order_Product_Details AS (
    SELECT OD.OrderNumber
          ,O.CustomerID
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
-- SELECT * FROM Order_Product_Details;

, Order_Product_Flag AS (
    SELECT CustomerID
          ,SIGN(SUM(CASE WHEN CategoryID = 1 
			                THEN 1 ELSE 0 END)) AS Buy_Accessories
          ,SIGN(SUM(CASE WHEN CategoryID = 2 
			                THEN 1 ELSE 0 END)) AS Buy_Bikes
          ,SIGN(SUM(CASE WHEN CategoryID = 3 
			                THEN 1 ELSE 0 END)) AS Buy_Clothing
          ,SIGN(SUM(CASE WHEN CategoryID = 4 
			                THEN 1 ELSE 0 END)) AS Buy_Components
          ,SIGN(SUM(CASE WHEN CategoryID = 5 
			                THEN 1 ELSE 0 END)) AS Buy_Car_racks
          ,SIGN(SUM(CASE WHEN CategoryID = 6 
			                THEN 1 ELSE 0 END)) AS Buy_Tires
          ,SIGN(SUM(CASE WHEN CategoryID = 7 
			                THEN 1 ELSE 0 END)) AS Buy_Skateboards
    FROM Order_Product_Details
    GROUP BY CustomerID
    ORDER BY CustomerID
)
SELECT * FROM Order_Product_Flag
```
| CustomerID | Buy_Accessories | Buy_Bikes | Buy_Clothing | Buy_Components | Buy_Car_racks | Buy_Tires | Buy_Skateboards | 
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | 
| 1001 | 1 | 0 | 1 | 1 | 1 | 1 | 1 | 
| 1002 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1003 | 1 | 0 | 1 | 1 | 1 | 1 | 1 | 
| 1004 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1005 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1006 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1007 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1008 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1009 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1010 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1011 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1012 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1013 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1014 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1015 | 1 | 0 | 1 | 1 | 1 | 1 | 1 | 
| 1016 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1017 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1018 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1019 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1020 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1021 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1022 | 1 | 0 | 1 | 1 | 1 | 0 | 1 | 
| 1023 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1024 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1025 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1026 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
| 1027 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 
