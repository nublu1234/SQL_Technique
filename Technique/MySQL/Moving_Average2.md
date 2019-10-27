### ORDERS TABLE
```sql
USE salesorderssample;

SELECT * 
FROM ORDERS
LIMIT 5
```
| OrderNumber | OrderDate | ShipDate | CustomerID | EmployeeID | OrderTotal | 
| ---: | --- | --- | ---: | ---: | ---: | 
| 1 | 2015-09-01 | 2015-09-04 | 1018 | 707 | 12751.85 | 
| 2 | 2015-09-01 | 2015-09-03 | 1001 | 703 | 816.00 | 
| 3 | 2015-09-01 | 2015-09-04 | 1002 | 707 | 11912.45 | 
| 4 | 2015-09-01 | 2015-09-03 | 1009 | 703 | 6601.73 | 
| 5 | 2015-09-01 | 2015-09-01 | 1024 | 708 | 5544.75 | 

### Moving Average
```sql
USE salesorderssample;

SELECT OrderDate
      ,SUM(OrderTotal) AS OrderDateTotal 
      ,AVG(SUM(OrderTotal)) OVER(ORDER BY OrderDate ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS OrderDate7Total
FROM ORDERS
GROUP BY OrderDate
ORDER BY OrderDate
LIMIT 20
```
| OrderDate | OrderDateTotal | OrderDate7Total | 
| --- | ---: | ---: | 
| 2015-09-01 | 52083.52 | 52083.520000 | 
| 2015-09-02 | 56111.08 | 54097.300000 | 
| 2015-09-03 | 34505.04 | 45308.060000 | 
| 2015-09-04 | 23538.34 | 29021.690000 | 
| 2015-09-05 | 11276.12 | 17407.230000 | 
| 2015-09-06 | 5513.88 | 8395.000000 | 
| 2015-09-07 | 41061.98 | 23287.930000 | 
| 2015-09-08 | 28117.57 | 34589.775000 | 
| 2015-09-09 | 60765.25 | 44441.410000 | 
| 2015-09-10 | 45789.85 | 53277.550000 | 
| 2015-09-11 | 3307.79 | 24548.820000 | 
| 2015-09-12 | 34909.76 | 19108.775000 | 
| 2015-09-13 | 68412.17 | 51660.965000 | 
| 2015-09-14 | 25136.89 | 46774.530000 | 
| 2015-09-15 | 52230.75 | 38683.820000 | 
| 2015-09-16 | 11501.55 | 31866.150000 | 
| 2015-09-17 | 12453.11 | 11977.330000 | 
| 2015-09-18 | 6511.35 | 9482.230000 | 
| 2015-09-19 | 5276.65 | 5894.000000 | 
| 2015-09-20 | 43706.87 | 24491.760000 | 