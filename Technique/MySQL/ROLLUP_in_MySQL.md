### ROLLUP in MySQL
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

알 수 없는 테이블
---
```sql
USE Item30Example;

SELECT COALESCE(Color, 'All') AS Color
      ,COALESCE(Dimension, 'All') AS DIMENSION
      ,SUM(Quantity) AS TotalQuantity
FROM Inventory 
GROUP BY Color, Dimension WITH ROLLUP
```
| Color | DIMENSION | TotalQuantity | 
| --- | --- | ---: | 
| Blue | L | 5 | 
| Blue | M | 20 | 
| Blue | All | 25 | 
| Red | L | 10 | 
| Red | M | 15 | 
| Red | All | 25 | 
| All | All | 50 | 
