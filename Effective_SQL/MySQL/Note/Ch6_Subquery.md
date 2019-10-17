## Ch 6. Subquery

### Subquery with EXISTS
```sql
USE SalesOrdersSample;

SELECT Customers.CustomerID, Customers.CustFirstName, 
  Customers.CustLastName, Orders.OrderNumber, Orders.OrderDate
FROM Customers
  INNER JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
WHERE EXISTS 
  (SELECT NULL
   FROM (Orders AS O2
      INNER JOIN Order_Details
        ON O2.OrderNumber = Order_Details.OrderNumber)
      INNER JOIN Products
        ON Products.ProductNumber = Order_Details.ProductNumber 
   WHERE Products.ProductName LIKE '%Skateboard%' 
    AND O2.OrderNumber = Orders.OrderNumber)
AND EXISTS 
  (SELECT NULL
   FROM (Orders AS O3 
      INNER JOIN Order_Details
        ON O3.OrderNumber = Order_Details.OrderNumber)
      INNER JOIN Products
        ON Products.ProductNumber = Order_Details.ProductNumber 
   WHERE Products.ProductName LIKE '%Helmet%'
      AND O3.OrderNumber = Orders.OrderNumber)
LIMIT 10
```
| CustomerID | CustFirstName | CustLastName | OrderNumber | OrderDate | 
| ---: | --- | --- | ---: | --- | 
| 1018 | David | Smith | 1 | 2015-09-01 | 
| 1002 | William | Thompson | 3 | 2015-09-01 | 
| 1020 | Joyce | Johnson | 11 | 2015-09-02 | 
| 1027 | Luke | Patterson | 19 | 2015-09-02 | 
| 1004 | Doug | Steele | 39 | 2015-09-07 | 
| 1008 | Neil | Patterson | 45 | 2015-09-08 | 
| 1014 | Sam | Johnson | 56 | 2015-09-09 | 
| 1004 | Doug | Steele | 59 | 2015-09-09 | 
| 1021 | Deborah | Smith | 69 | 2015-09-11 | 
| 1002 | William | Thompson | 74 | 2015-09-12 | 
---

### Subquery with SELECT & WHERE
```sql
USE RecipesSample;

SELECT Recipe_Classes.RecipeClassDescription,
       (SELECT COUNT(*)
        FROM Recipes
        WHERE Recipes.RecipeClassID =  
           Recipe_Classes.RecipeClassID) AS RecipeCount
FROM Recipe_Classes
```
| RecipeClassDescription | RecipeCount | 
| --- | ---: | 
| Main course | 7 | 
| Vegetable | 2 | 
| Starch | 1 | 
| Salad | 1 | 
| Hors d'oeuvres | 2 | 
| Dessert | 2 | 
| Soup | 0 | 
---

### Subquery with EXISTS
```sql
SELECT Recipes.RecipeTitle
FROM Recipes
WHERE EXISTS 
  (SELECT NULL
   FROM Ingredients INNER JOIN Recipe_Ingredients
     ON Ingredients.IngredientID = 
          Recipe_Ingredients.IngredientID
   WHERE Ingredients.IngredientName = 'Beef'
      AND Recipe_Ingredients.RecipeID = Recipes.RecipeID)
AND EXISTS 
  (SELECT NULL
   FROM Ingredients INNER JOIN Recipe_Ingredients
     ON Ingredients.IngredientID = 
          Recipe_Ingredients.IngredientID
   WHERE Ingredients.IngredientName = 'Garlic'
       AND Recipe_Ingredients.RecipeID = Recipes.RecipeID)
```
| RecipeTitle | 
| --- | 
| Roast Beef | 

### RECURSIVE CTE
```sql
WITH RECURSIVE SeqNumTbl(SeqNum) AS 
  (SELECT 1
   UNION ALL
   SELECT SeqNum + 1 AS SeqNum
   FROM SeqNumTbl
   WHERE SeqNum < 10)
SELECT SeqNum 
FROM SeqNumTbl
```
| SeqNum | 
| ---: | 
| 1 | 
| 2 | 
| 3 | 
| 4 | 
| 5 | 
| 6 | 
| 7 | 
| 8 | 
| 9 | 
| 10 | 

