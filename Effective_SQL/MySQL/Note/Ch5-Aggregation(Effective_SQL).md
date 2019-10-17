## Ch 5. Aggregation (Effective SQL)

### Complex Grouping
*[Raw Data]*
```sql
USE Item30Example;

SELECT * FROM Inventory
```
| Color | Dimension | Quantity | 
| --- | --- | ---: | 
| Red | L | 10 | 
| Blue | M | 20 | 
| Red | M | 15 | 
| Blue | L | 5 | 
---
*[Grouping 1]*
```sql
USE Item30Example;

SELECT Color, Dimension, SUM(Quantity) AS TotalQuantity
FROM Inventory 
GROUP BY Color, Dimension WITH ROLLUP
```
| Color | Dimension | TotalQuantity | 
| --- | --- | ---: | 
| Blue | L | 5 | 
| Blue | M | 20 | 
| Blue | \N | 25 | 
| Red | L | 10 | 
| Red | M | 15 | 
| Red | \N | 25 | 
| \N | \N | 50 | 

---
*[Grouping 2]*
```sql
USE Item30Example;

SELECT Color, NULL AS Dimension, SUM(Quantity) AS TotalQuantity
FROM Inventory 
GROUP BY Color
UNION
SELECT NULL, Dimension, SUM(Quantity)
FROM Inventory 
GROUP BY Dimension
UNION
SELECT NULL, NULL, SUM(Quantity)
FROM Inventory
```
| Color | Dimension | TotalQuantity | 
| --- | --- | ---: | 
| Red | \N | 25 | 
| Blue | \N | 25 | 
| \N | L | 15 | 
| \N | M | 35 | 
| \N | \N | 50 | 
---

### Self Join 1
```sql
USE Item30Example;

SELECT L.Category, L.Country, L.Style, L.MaxABV AS MaxAlcohol
FROM BeerStyles AS L LEFT JOIN BeerStyles AS R
  ON L.Category = R.Category
    AND L.MaxABV < R.MaxABV
WHERE R.MaxABV IS NULL
ORDER BY L.Category
```
| Category | Country | Style | MaxAlcohol | 
| --- | --- | --- | ---: | 
| American Beers | United States | American Barley Wine | 12 | 
| British or Irish Ales | England | English Barley Wine | 12 | 
| European Ales | France | Bière de Garde | 8.5 | 
| European Lagers | Germany | Maibock | 7.5 | 


### Use 'COUNT()' Carefully
- The Number of Recipes by Cooking Type  

*[Wrong Solution]*
```sql
USE RecipesSample;

SELECT Recipe_Classes.RecipeClassDescription, 
  COUNT(*) AS RecipeCount
FROM Recipe_Classes 
  LEFT OUTER JOIN Recipes 
    ON Recipe_Classes.RecipeClassID = Recipes.RecipeClassID
GROUP BY Recipe_Classes.RecipeClassDescription
```
| RecipeClassDescription | RecipeCount | 
| --- | ---: | 
| Main course | 7 | 
| Vegetable | 2 | 
| Starch | 1 | 
| Salad | 1 | 
| Hors d'oeuvres | 2 | 
| Dessert | 2 | 
| Soup | 1 | 

*[Right Solution]*
```sql
USE RecipesSample;

SELECT Recipe_Classes.RecipeClassDescription, COUNT(Recipes.RecipeClassID) AS RecipeCount
FROM Recipe_Classes 
  LEFT OUTER JOIN Recipes 
    ON Recipe_Classes.RecipeClassID = Recipes.RecipeClassID
GROUP BY Recipe_Classes.RecipeClassDescription
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
*[Effective Solution]*
```sql
USE RecipesSample;

SELECT Recipe_Classes.RecipeClassDescription, 
  (SELECT COUNT(Recipes.RecipeClassID) 
   FROM Recipes
   WHERE Recipes.RecipeClassID = Recipe_Classes.RecipeClassID) 
    AS RecipeCount
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

### INNER JOIN *vs* LEFT JOIN
- Main course dish with less than three spices  

*[Wrong Solution]*
```sql
USE RecipesSample;

SELECT Recipes.RecipeTitle, 
  COUNT(Recipe_Ingredients.RecipeID) AS IngredCount
FROM (((Recipe_Classes 
  INNER JOIN Recipes
    ON Recipe_Classes.RecipeClassID = Recipes.RecipeClassID) 
  INNER JOIN Recipe_Ingredients
    ON Recipes.RecipeID = Recipe_Ingredients.RecipeID)
  INNER JOIN Ingredients
    ON Recipe_Ingredients.IngredientID = 
    Ingredients.IngredientID)
  INNER JOIN Ingredient_Classes 
    ON Ingredients.IngredientClassID = 
    Ingredient_Classes.IngredientClassID
WHERE Recipe_Classes.RecipeClassDescription = 'Main Course' 
  AND Ingredient_Classes.IngredientClassDescription = 'Spice'
GROUP BY Recipes.RecipeTitle
HAVING COUNT(Recipe_Ingredients.RecipeID) < 3
```
| RecipeTitle | IngredCount | 
| --- | ---: | 
| Salmon Filets in Parchment Paper | 2 | 
| Fettuccini Alfredo | 2 | 
- Problems caused by executing INNER JOIN and not LEFT JOIN while joining 'Recipes' and 'Recipe_Ingredients'.  
- Note the relationship between the tables.  

*[Right Solution]*
```sql
USE RecipesSample;

SELECT Recipes.RecipeTitle, 
  COUNT(RI.RecipeID) AS IngredCount
FROM (Recipe_Classes 
  INNER JOIN Recipes
    ON Recipe_Classes.RecipeClassID = Recipes.RecipeClassID) 
  LEFT OUTER JOIN
  (SELECT Recipe_Ingredients.RecipeID, 
    Ingredient_Classes.IngredientClassDescription
   FROM (Recipe_Ingredients
    INNER JOIN Ingredients
      ON Recipe_Ingredients.IngredientID = 
       Ingredients.IngredientID) 
    INNER JOIN Ingredient_Classes 
      ON Ingredients.IngredientClassID = 
       Ingredient_Classes.IngredientClassID
   WHERE 
     Ingredient_Classes.IngredientClassDescription = 'Spice') 
    AS RI
      ON Recipes.RecipeID = RI.RecipeID 
WHERE Recipe_Classes.RecipeClassDescription = 'Main course' 
GROUP BY Recipes.RecipeTitle
HAVING COUNT(RI.RecipeID) < 3
```
| RecipeTitle | IngredCount | 
| --- | ---: | 
| Irish Stew | 0 | 
| Fettuccini Alfredo | 2 | 
| Salmon Filets in Parchment Paper | 2 | 
---

### Moving Average
```sql
USE SalesOrdersSample;

SELECT
  o.OrderNumber, o.CustomerID, o.OrderTotal,
  SUM(o.OrderTotal) OVER (
    PARTITION BY o.CustomerID
    ORDER BY o.OrderNumber, o.CustomerID
    RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS TotalByCustomer,
  SUM(o.OrderTotal) OVER (
    PARTITION BY o.CustomerID
    /* RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING */
    ) AS TotalOverall,
  SUM(o.OrderTotal) OVER (
    PARTITION BY o.CustomerID
     RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS TotalOverall2
FROM Orders o
ORDER BY o.CustomerID, o.OrderNumber
LIMIT 10
```
| OrderNumber | CustomerID | OrderTotal | TotalByCustomer | TotalOverall | TotalOverall2 | 
| ---: | ---: | ---: | ---: | ---: | ---: | 
| 2 | 1001 | 816.00 | 816.00 | 34807.96 | 34807.96 | 
| 7 | 1001 | 467.85 | 1283.85 | 34807.96 | 34807.96 | 
| 16 | 1001 | 2007.54 | 3291.39 | 34807.96 | 34807.96 | 
| 52 | 1001 | 261.90 | 3553.29 | 34807.96 | 34807.96 | 
| 55 | 1001 | 36.00 | 3589.29 | 34807.96 | 34807.96 | 
| 107 | 1001 | 1240.40 | 4829.69 | 34807.96 | 34807.96 | 
| 137 | 1001 | 1235.65 | 6065.34 | 34807.96 | 34807.96 | 
| 138 | 1001 | 1122.70 | 7188.04 | 34807.96 | 34807.96 | 
| 151 | 1001 | 276.00 | 7464.04 | 34807.96 | 34807.96 | 
| 154 | 1001 | 1360.05 | 8824.09 | 34807.96 | 34807.96 | 
---

### Advanced Moving Average
```sql
USE Item39Example;

WITH PurchaseStatistics AS (
	SELECT 
		p.CustomerID,
		EXTRACT(YEAR FROM p.PurchaseDate) AS PurchaseYear,
		EXTRACT(MONTH FROM p.PurchaseDate) AS PurchaseMonth,
		SUM(p.PurchaseAmount) AS PurchaseTotal,
		COUNT(p.PurchaseID) AS PurchaseCount
	FROM Purchases p
	GROUP BY 
		p.CustomerID, 
		EXTRACT(YEAR FROM p.PurchaseDate),
		EXTRACT(MONTH FROM p.PurchaseDate)
)
SELECT
  s.CustomerID, s.PurchaseYear, s.PurchaseMonth, s.PurchaseTotal,
  LAG(s.PurchaseTotal, 1) OVER (
    PARTITION BY s.CustomerID, s.PurchaseMonth
    ORDER BY s.PurchaseYear
    ) AS PreviousMonthTotal,
  s.PurchaseTotal AS CurrentMonthTotal,
  LEAD(s.PurchaseTotal, 1) OVER (
    PARTITION BY s.CustomerID, s.PurchaseMonth
    ORDER BY s.PurchaseYear
    ) AS NextMonthTotal,
  AVG(s.PurchaseTotal) OVER (
    PARTITION BY s.CustomerID, s.PurchaseMonth
    ORDER BY s.PurchaseYear
    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS MonthOfYearAverage
FROM PurchaseStatistics s
ORDER BY s.CustomerID, s.PurchaseMonth, s.PurchaseYear
LIMIT 20
```
| CustomerID | PurchaseYear | PurchaseMonth | PurchaseTotal | PreviousMonthTotal | CurrentMonthTotal | NextMonthTotal | MonthOfYearAverage | 
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | 
| 1 | 2011 | 1 | 9660.8633 | \N | 9660.8633 | 5899.8256 | 7780.34445000 | 
| 1 | 2012 | 1 | 5899.8256 | 9660.8633 | 5899.8256 | 14072.7776 | 9877.82216667 | 
| 1 | 2013 | 1 | 14072.7776 | 5899.8256 | 14072.7776 | 2649.3516 | 7540.65160000 | 
| 1 | 2014 | 1 | 2649.3516 | 14072.7776 | 2649.3516 | 7345.6435 | 8022.59090000 | 
| 1 | 2015 | 1 | 7345.6435 | 2649.3516 | 7345.6435 | \N | 4997.49755000 | 
| 1 | 2011 | 2 | 5056.6903 | \N | 5056.6903 | 6067.5733 | 5562.13180000 | 
| 1 | 2012 | 2 | 6067.5733 | 5056.6903 | 6067.5733 | 11144.9308 | 7423.06480000 | 
| 1 | 2013 | 2 | 11144.9308 | 6067.5733 | 11144.9308 | 1791.1255 | 6334.54320000 | 
| 1 | 2014 | 2 | 1791.1255 | 11144.9308 | 1791.1255 | 7311.2505 | 6749.10226667 | 
| 1 | 2015 | 2 | 7311.2505 | 1791.1255 | 7311.2505 | \N | 4551.18800000 | 
| 1 | 2011 | 3 | 3191.9213 | \N | 3191.9213 | 5574.9718 | 4383.44655000 | 
| 1 | 2012 | 3 | 5574.9718 | 3191.9213 | 5574.9718 | 16852.4723 | 8539.78846667 | 
| 1 | 2013 | 3 | 16852.4723 | 5574.9718 | 16852.4723 | 3162.0568 | 8529.83363333 | 
| 1 | 2014 | 3 | 3162.0568 | 16852.4723 | 3162.0568 | 8212.1067 | 9408.87860000 | 
| 1 | 2015 | 3 | 8212.1067 | 3162.0568 | 8212.1067 | \N | 5687.08175000 | 
| 1 | 2011 | 4 | 1830.6725 | \N | 1830.6725 | 7749.3873 | 4790.02990000 | 
| 1 | 2012 | 4 | 7749.3873 | 1830.6725 | 7749.3873 | 11159.1464 | 6913.06873333 | 
| 1 | 2013 | 4 | 11159.1464 | 7749.3873 | 11159.1464 | 5030.7186 | 7979.75076667 | 
| 1 | 2014 | 4 | 5030.7186 | 11159.1464 | 5030.7186 | 13660.2927 | 9950.05256667 | 
| 1 | 2015 | 4 | 13660.2927 | 5030.7186 | 13660.2927 | \N | 9345.50565000 | 
