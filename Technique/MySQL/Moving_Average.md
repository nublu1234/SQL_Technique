
### Moving Average  
```sql
USE item39example;

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
USE item39example;

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
| --- | --- | --- | --- | --- | --- | --- | --- | 
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
