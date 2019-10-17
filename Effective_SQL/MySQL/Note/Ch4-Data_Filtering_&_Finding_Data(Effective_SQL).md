## Ch 4. Data Filtering & Finding Data(Effective SQL)
### INTERSECT in MySQL
<!-- code 4-1 -->
<!-- 수정하기 -->
```sql
USE SalesOrdersSample;

WITH Order_All AS (
	SELECT o.*, p.ProductNumber, p.ProductName
	FROM Orders AS o
	INNER JOIN Order_Details AS od
		ON o.OrderNumber = od.OrderNumber
	INNER JOIN Products AS p
		ON p.ProductNumber = od.ProductNumber
)
-- SELECT * FROM Order_All; 

, Order_Bike AS (
	SELECT *
	FROM Order_All
	WHERE ProductName LIKE '%Bike%'
)
-- SELECT * FROM Order_Bike;

, Order_Skateboard AS (
	SELECT *
	FROM Order_All
	WHERE ProductName LIKE '%Skateboard%'
)
-- SELECT * FROM Order_Skateboard;

SELECT c1.CustFirstName, c1.CustLastName
FROM Customers AS c1
WHERE c1.CustomerID IN
	(SELECT CustomerID 
	 FROM Order_Bike
	 UNION
	 SELECT CustomerID 
	 FROM Order_Skateboard)
LIMIT 5;
```
| CustFirstName | CustLastName | 
| --- | --- | 
| Suzanne | Viescas | 
| William | Thompson | 
| Gary | Hallmark | 
| Doug | Steele | 
| Tom | Wickerath | 
---

### NOT EXIST 1
<!-- code 4-5 -->
```sql
USE SalesOrdersSample;

SELECT p.ProductNumber, p.ProductName
FROM Products AS p
WHERE NOT EXISTS
	(SELECT *
	 FROM Order_Details AS od
	 WHERE p.ProductNumber = od.ProductNumber);
```
| ProductNumber | ProductName | 
| ---: | --- | 
| 4 | Victoria Pro All Weather Tires | 
| 23 | Ultra-Pro Skateboard |  
---

### NOT EXIST 2
<!-- code 4-5 -->
```sql
USE SalesOrdersSample;

SELECT p.ProductNumber, p.ProductName
FROM Products AS p
LEFT JOIN Order_Details AS od
	ON p.ProductNumber = od.ProductNumber
WHERE od.ProductNumber IS NULL;
```
| ProductNumber | ProductName | 
| ---: | --- | 
| 4 | Victoria Pro All Weather Tires | 
| 23 | Ultra-Pro Skateboard | 

---

### Customers Ordered Skateboards, Helmets, Knee pads and Gloves(Using INNER JOIN)
<!-- code 4-12 -->
```sql
USE SalesOrdersSample;

WITH Order_All AS (
	SELECT o.*, p.ProductNumber, p.ProductName
	FROM Orders AS o
	INNER JOIN Order_Details AS od
		ON o.OrderNumber = od.OrderNumber
	INNER JOIN Products AS p
		ON p.ProductNumber = od.ProductNumber
)
-- SELECT * FROM Order_All;

, Order_Skateboard AS (
	SELECT *
	FROM Order_All
	WHERE ProductName LIKE '%Skateboard%'
)

, Order_Helmet AS (
	SELECT *
	FROM Order_All
	WHERE ProductName LIKE '%Helmet%'
)
-- SELECT * FROM Order_Helmet;

, Order_Knee_Pads AS (
	SELECT *
	FROM Order_All
	WHERE ProductName LIKE '%Knee Pads%'
)
-- SELECT * FROM Order_Knee_Pads;

, Order_Gloves AS (
	SELECT *
	FROM Order_All
	WHERE ProductName LIKE '%Gloves%'
)
-- SELECT * FROM Order_Gloves;

SELECT C.CustomerID, C.CustFirstName, C.CustLastName
FROM Customers AS C
    INNER JOIN
        (SELECT DISTINCT CustomerID
         FROM Order_Skateboard) AS OS
    ON C.CustomerID = OS.CustomerID
    
    INNER JOIN
        (SELECT DISTINCT CustomerID
         FROM Order_Helmet) AS OH
    ON C.CustomerID = OH.CustomerID
    
    INNER JOIN
        (SELECT DISTINCT CustomerID
         FROM Order_Knee_Pads) AS OK
    ON C.CustomerID = OK.CustomerID
    
    INNER JOIN
        (SELECT DISTINCT CustomerID
         FROM Order_Gloves) AS OG
    ON C.CustomerID = OG.CustomerID
LIMIT 5
```
| CustomerID | CustFirstName | CustLastName | 
| ---: | --- | --- | 
| 1001 | Suzanne | Viescas | 
| 1002 | William | Thompson | 
| 1003 | Gary | Hallmark | 
| 1004 | Doug | Steele | 
| 1005 | Tom | Wickerath | 
---

### Customers Ordered Skateboards, Helmets, Knee pads and Gloves(Using WHERE EXISTS)
<!-- code 4-14 -->
```sql
USE SalesOrdersSample;

WITH Order_All AS (
	SELECT o.*, p.ProductNumber, p.ProductName
	FROM Orders AS o
	INNER JOIN Order_Details AS od
		ON o.OrderNumber = od.OrderNumber
	INNER JOIN Products AS p
		ON p.ProductNumber = od.ProductNumber
)
-- SELECT * FROM Order_All;

SELECT C.CustomerID, C.CustFirstName, C.CustLastName
FROM Customers AS C
WHERE EXISTS
        (SELECT DISTINCT OS.CustomerID
         FROM Order_All AS OS
         WHERE OS.ProductName LIKE '%Skateboard%'
			AND C.CustomerID = OS.CustomerID)
AND EXISTS
        (SELECT DISTINCT OH.CustomerID
         FROM Order_All AS OH
         WHERE OH.ProductName LIKE '%Helmet%'
			AND C.CustomerID = OH.CustomerID)
AND EXISTS      
        (SELECT DISTINCT OK.CustomerID
         FROM Order_All AS OK
         WHERE OK.ProductName LIKE '%Knee Pads%'
			AND C.CustomerID = OK.CustomerID)
AND EXISTS      
        (SELECT DISTINCT OG.CustomerID
         FROM Order_All AS OG
         WHERE OG.ProductName LIKE '%Gloves%'
			AND C.CustomerID = OG.CustomerID)
LIMIT 5
```
| CustomerID | CustFirstName | CustLastName | 
| ---: | --- | --- | 
| 1001 | Suzanne | Viescas | 
| 1002 | William | Thompson | 
| 1003 | Gary | Hallmark | 
| 1004 | Doug | Steele | 
| 1005 | Tom | Wickerath | 

---

### Customers Ordered Skateboards, Helmets, Knee pads and Gloves(Using WHERE IN)
```sql
WITH Order_All AS (
	SELECT o.*, p.ProductNumber, p.ProductName
	FROM Orders AS o
	INNER JOIN Order_Details AS od
		ON o.OrderNumber = od.OrderNumber
	INNER JOIN Products AS p
		ON p.ProductNumber = od.ProductNumber
)
-- SELECT * FROM Order_All;

, Order_Skateboard AS (
	SELECT *
	FROM Order_All
	WHERE ProductName LIKE '%Skateboard%'
)

, Order_Helmet AS (
	SELECT *
	FROM Order_All
	WHERE ProductName LIKE '%Helmet%'
)
-- SELECT * FROM Order_Helmet;

, Order_Knee_Pads AS (
	SELECT *
	FROM Order_All
	WHERE ProductName LIKE '%Knee Pads%'
)
-- SELECT * FROM Order_Knee_Pads;

, Order_Gloves AS (
	SELECT *
	FROM Order_All
	WHERE ProductName LIKE '%Gloves%'
)
-- SELECT * FROM Order_Gloves;

SELECT C.CustomerID, C.CustFirstName, C.CustLastName
FROM Customers AS C
WHERE C.CustomerID IN
        (SELECT DISTINCT OS.CustomerID
         FROM Order_Skateboard AS OS)
AND C.CustomerID IN
        (SELECT DISTINCT OS.CustomerID
         FROM Order_Helmet AS OS)
AND C.CustomerID IN
        (SELECT DISTINCT OS.CustomerID
         FROM Order_Knee_Pads AS OS)
AND C.CustomerID IN
        (SELECT DISTINCT OS.CustomerID
         FROM Order_Gloves AS OS)
LIMIT 5
```
| CustomerID | CustFirstName | CustLastName | 
| ---: | --- | --- | 
| 1001 | Suzanne | Viescas | 
| 1002 | William | Thompson | 
| 1003 | Gary | Hallmark | 
| 1004 | Doug | Steele | 
| 1005 | Tom | Wickerath | 
---
### Advanced EXISTS
<!-- code 4-18  -->
```sql
WITH CustomerProducts AS (
    SELECT DISTINCT Customers.CustomerID, Customers.CustFirstName,
           Customers.CustLastName,
           CASE WHEN Products.ProductName LIKE '%Skateboard%' THEN 'Skateboard'
                WHEN Products.ProductName LIKE '%Helmet%' THEN 'Helmet'
                WHEN Products.ProductName LIKE '%Knee Pads%' THEN 'Knee Pads'
                WHEN Products.ProductName LIKE '%Gloves%' THEN 'Gloves'
                ELSE NULL
                END AS ProductCategory
    FROM Customers 
	 INNER JOIN Orders
          ON Customers.CustomerID = Orders.CustomerID
    INNER JOIN Order_Details
          ON Orders.OrderNumber = Order_Details.OrderNumber
    INNER JOIN Products
          ON Products.ProductNumber = Order_Details.ProductNumber)
  
-- SELECT * FROM CustomerProducts;

, ProdsOfInterest AS (
    SELECT DISTINCT CASE WHEN Products.ProductName LIKE '%Skateboard%' THEN 'Skateboard'
                         WHEN Products.ProductName LIKE '%Helmet%' THEN 'Helmet'
                         WHEN Products.ProductName LIKE '%Knee Pads%' THEN 'Knee Pads'
                         WHEN Products.ProductName LIKE '%Gloves%' THEN 'Gloves'
                         ELSE NULL
                         END AS ProductCategory
    FROM Products
    WHERE ProductName LIKE '%Skateboard%'
       OR ProductName LIKE '%Helmet%'
       OR ProductName LIKE '%Knee Pads%'
       OR ProductName LIKE '%Gloves%')
-- SELECT * FROM ProdsOfInterest;

SELECT DISTINCT CustomerID, CustFirstName, CustLastName
FROM CustomerProducts AS CP1
WHERE NOT EXISTS
  (SELECT ProductCategory FROM ProdsOfInterest AS PofI
    WHERE NOT EXISTS
    (SELECT CustomerID FROM CustomerProducts AS CP2
      WHERE CP2.CustomerID = CP1.CustomerID
      AND CP2.ProductCategory = PofI.ProductCategory))
LIMIT 5
```
| CustomerID | CustFirstName | CustLastName | 
| ---: | --- | --- | 
| 1001 | Suzanne | Viescas | 
| 1002 | William | Thompson | 
| 1003 | Gary | Hallmark | 
| 1004 | Doug | Steele | 
| 1005 | Tom | Wickerath | 
---
### Advanced SQL (Cross Join, Group By, Having)
<!-- code 4-19 -->
```sql
WITH CustomerProducts AS (
    SELECT DISTINCT Customers.CustomerID, Customers.CustFirstName,
           Customers.CustLastName,
           CASE WHEN Products.ProductName LIKE '%Skateboard%' THEN 'Skateboard'
                WHEN Products.ProductName LIKE '%Helmet%' THEN 'Helmet'
                WHEN Products.ProductName LIKE '%Knee Pads%' THEN 'Knee Pads'
                WHEN Products.ProductName LIKE '%Gloves%' THEN 'Gloves'
                ELSE NULL
                END AS ProductCategory
    FROM Customers 
	 INNER JOIN Orders
          ON Customers.CustomerID = Orders.CustomerID
    INNER JOIN Order_Details
          ON Orders.OrderNumber = Order_Details.OrderNumber
    INNER JOIN Products
          ON Products.ProductNumber = Order_Details.ProductNumber)
  
-- SELECT * FROM CustomerProducts;

, ProdsOfInterest AS (
    SELECT DISTINCT CASE WHEN Products.ProductName LIKE '%Skateboard%' THEN 'Skateboard'
                         WHEN Products.ProductName LIKE '%Helmet%' THEN 'Helmet'
                         WHEN Products.ProductName LIKE '%Knee Pads%' THEN 'Knee Pads'
                         WHEN Products.ProductName LIKE '%Gloves%' THEN 'Gloves'
                         ELSE NULL
                         END AS ProductCategory
    FROM Products
    WHERE ProductName LIKE '%Skateboard%'
       OR ProductName LIKE '%Helmet%'
       OR ProductName LIKE '%Knee Pads%'
       OR ProductName LIKE '%Gloves%')
-- SELECT * FROM ProdsOfInterest;

SELECT CP.CustomerID, CP.CustFirstName, CP.CustLastName
FROM CustomerProducts CP, ProdsOfInterest PofI
WHERE CP.ProductCategory = PofI.ProductCategory /* CROSS JOIN WHERE == INNER JOIN ON */
GROUP BY CP.CustomerID, CP.CustFIrstName, CP.CustLastName
HAVING COUNT(CP.ProductCategory) =
  (SELECT COUNT(ProductCategory) FROM ProdsOfInterest)
LIMIT 5
/* CROSS JOIN WHERE == INNER JOIN ON */
/* (SELECT COUNT(ProductCategory) FROM ProdsOfInterest) == 4 */
```
| CustomerID | CustFirstName | CustLastName | 
| ---: | --- | --- | 
| 1001 | Suzanne | Viescas | 
| 1002 | William | Thompson | 
| 1003 | Gary | Hallmark | 
| 1004 | Doug | Steele | 
| 1005 | Tom | Wickerath | 
---

### Include Zero-Value Rows
<!-- code 5-24, 25, 26 --> 
```sql
USE RecipesSample;

WITH Recipes_All AS (
SELECT R_C.*
      ,RCP.RecipeID, RCP.RecipeTitle, RCP.Preparation ,RCP.Notes
      ,R_I.RecipeSeqNo, R_I.IngredientID, R_I.MeasureAmountID, R_I.Amount
      ,IGRDNT.IngredientName, IGRDNT.IngredientClassID
      ,I_C.IngredientClassDescription
FROM Recipe_Classes AS R_C
INNER JOIN Recipes AS RCP
    ON R_C.RecipeClassID = RCP.RecipeClassID
INNER JOIN Recipe_Ingredients AS R_I
    ON RCP.RecipeID = R_I.RecipeID
INNER JOIN Ingredients AS IGRDNT
    ON R_I.IngredientID = IGRDNT.IngredientID
INNER JOIN Ingredient_Classes AS I_C
    ON IGRDNT.IngredientClassID = I_C.IngredientClassID
)
-- SELECT * FROM Recipes_All;

, Recipes_and_Classes AS (
SELECT R_C.*
      ,RCP.RecipeID, RCP.RecipeTitle, RCP.Preparation ,RCP.Notes
FROM Recipe_Classes AS R_C
INNER JOIN Recipes AS RCP
    ON R_C.RecipeClassID = RCP.RecipeClassID
)
-- SELECT * FROM Recipes_and_Classes;

, Recipes_and_Ingredients_and_Classes AS (
SELECT R_I.RecipeID ,R_I.RecipeSeqNo, R_I.IngredientID, R_I.MeasureAmountID, R_I.Amount
      ,IGRDNT.IngredientName, IGRDNT.IngredientClassID
      ,I_C.IngredientClassDescription
FROM Recipe_Ingredients AS R_I
INNER JOIN Ingredients AS IGRDNT
    ON R_I.IngredientID = IGRDNT.IngredientID
INNER JOIN Ingredient_Classes AS I_C
    ON IGRDNT.IngredientClassID = I_C.IngredientClassID
)
-- SELECT * FROM Recipes_and_Ingredients_and_Classes;

, Recipes_and_Ingredients_and_Classes_Spice AS (
SELECT *
FROM Recipes_and_Ingredients_and_Classes
WHERE IngredientClassDescription = 'Spice'
)
-- SELECT * FROM Recipes_and_Ingredients_and_Classes_Spice;

, Wrong_Query1 AS (
SELECT RecipeTitle, 
  COUNT(RecipeID) AS IngredCount
FROM Recipes_All
WHERE RecipeClassDescription = 'Main Course' 
  AND IngredientClassDescription = 'Spice'
GROUP BY RecipeTitle
HAVING COUNT(RecipeID) < 3
)
-- SELECT * FROM Wrong_Query1;

, Wrong_Query2 AS (
SELECT RnC.RecipeTitle, 
  COUNT(RnInC.RecipeID) AS IngredCount
FROM Recipes_and_Classes AS RnC
LEFT JOIN Recipes_and_Ingredients_and_Classes AS RnInC
ON RnC.RecipeID = RnInC.RecipeID
WHERE RnC.RecipeClassDescription = 'Main Course' 
  AND RnInC.IngredientClassDescription = 'Spice'
GROUP BY RnC.RecipeTitle
HAVING COUNT(RnC.RecipeID) < 3
)
-- SELECT * FROM Wrong_Query2;


, IngredCount_WrongCount AS (
SELECT RnC.RecipeID, RnInC_S.RecipeID AS RecipeID_RIGHT, RnC.RecipeTitle, RnC.RecipeClassID, RnC.RecipeClassDescription, RnC.Preparation, RnC.Notes
      ,RnInC_S.RecipeSeqNo, RnInC_S.IngredientID, RnInC_S.MeasureAmountID, RnInC_S.Amount
		,RnInC_S.IngredientName, RnInC_S.IngredientClassID, RnInC_S.IngredientClassDescription
FROM Recipes_and_Classes AS RnC
LEFT JOIN Recipes_and_Ingredients_and_Classes_Spice AS RnInC_S
ON RnC.RecipeID = RnInC_S.RecipeID)
# Must be sure to check!
-- SELECT * FROM IngredCount_WrongCount;

, Correct_Query1 AS (
SELECT RnC.RecipeTitle, 
  COUNT(RnInC_S.RecipeID) AS IngredCount, 
  COUNT(RnC.RecipeID) AS IngredCount_Wrong  /* Caution!! */
FROM Recipes_and_Classes AS RnC
LEFT JOIN Recipes_and_Ingredients_and_Classes_Spice AS RnInC_S
ON RnC.RecipeID = RnInC_S.RecipeID
WHERE RnC.RecipeClassDescription = 'Main Course' 
GROUP BY RnC.RecipeTitle
HAVING COUNT(RnC.RecipeID) < 3
)
SELECT * FROM Correct_Query1
```
*[Correct_Query1]*
| RecipeTitle | IngredCount | IngredCount_Wrong | 
| --- | ---: | ---: | 
| Irish Stew | 0 | 1 | 
| Fettuccini Alfredo | 2 | 2 | 
| Salmon Filets in Parchment Paper | 2 | 2 | 

*[Wrong_Query1 & 2]*
| RecipeTitle | IngredCount 
| --- | ---: | ---: | 
| Fettuccini Alfredo | 2 | 
| Salmon Filets in Parchment Paper | 2 | 
--

### Window Function with PARTITION BY
<!-- code 5-29 -->
```sql
SELECT
  OrderNumber, CustomerID, OrderTotal,
  SUM(OrderTotal) OVER (
    PARTITION BY CustomerID
    ORDER BY OrderNumber, CustomerID
    ) AS TotalByCustomer,
  SUM(OrderTotal) OVER (
    ORDER BY OrderNumber
    ) AS TotalOverall 
FROM Orders
ORDER BY OrderNumber, CustomerID
LIMIT 5
```
| OrderNumber | CustomerID | OrderTotal | TotalByCustomer | TotalOverall | 
| ---: | ---: | ---: | ---: | ---: | 
| 1 | 1018 | 12751.85 | 12751.85 | 12751.85 | 
| 2 | 1001 | 816.00 | 816.00 | 13567.85 | 
| 3 | 1002 | 11912.45 | 11912.45 | 25480.30 | 
| 4 | 1009 | 6601.73 | 6601.73 | 32082.03 | 
| 5 | 1024 | 5544.75 | 5544.75 | 37626.78 | 

<!-- On Going! -->


```sql
USE SalesOrdersSample;

SELECT
  OrderNumber, CustomerID, OrderTotal,
  SUM(OrderTotal) OVER (
    PARTITION BY CustomerID
    ORDER BY OrderNumber, CustomerID
    ) AS TotalByCustomer,
  SUM(OrderTotal) OVER (
    ORDER BY OrderNumber
    ) AS TotalOverall 
FROM Orders
ORDER BY OrderNumber, CustomerID;
```