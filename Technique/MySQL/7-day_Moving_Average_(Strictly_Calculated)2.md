

### 7-day Moving Average (Strictly Calculated)2
```sql
USE salesorderssample;

SELECT OrderDate /*
      ,YEAR(OrderDate) AS Year_ */
      ,DAYOFWEEK(OrderDate) AS Date7 /*
      ,WEEKOFYEAR(OrderDate) AS Week_ */
      ,YEARWEEK(OrderDate) AS Year_Week
      ,COUNT(OrderDate) AS Daily_Order
      ,AVG(OrderTotal) AS Daily_Purchase_Aveage
      ,SUM(OrderTotal) AS Daily_Purchase_Amount
      ,CASE WHEN 28 = SUM(DAYOFWEEK(OrderDate)) 
			                 OVER(PARTITION BY YEARWEEK(OrderDate)) 
			   THEN SUM(SUM(OrderTotal))
			            OVER(PARTITION BY YEARWEEK(OrderDate)
                          ORDER BY DAYOFWEEK(OrderDate) 
							     ROWS BETWEEN 7 PRECEDING 
							              AND CURRENT ROW) END AS Cummulate_Purchase_Amount_In_Week 
          
      /* ,CASE WHEN 28 = SUM(DAYOFWEEK(OrderDate)) 
			                     OVER(PARTITION BY YEARWEEK(OrderDate)) 
			       THEN LAG(SUM(OrderTotal), 7)       
			                OVER(ORDER BY OrderDate) END AS Last_Week_Purchase_Amount2 */
      ,LAG(SUM(OrderTotal), 1) 
		     OVER(PARTITION BY DAYOFWEEK(OrderDate)
			       ORDER BY OrderDate) AS Last_Week_Purchase_Amount
	 /* Last_Week_Purchase_Amount == Last_Week_Purchase_Amount2 */
FROM Orders
GROUP BY OrderDate
ORDER BY OrderDate
LIMIT 30
```
| OrderDate | Date7 | Year_Week | Daily_Order | Daily_Purchase_Aveage | Daily_Purchase_Amount | Cummulate_Purchase_Amount_In_Week | Last_Week_Purchase_Amount | 
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | 
| 2015-09-01 | 3 | 201535 | 10 | 5208.352000 | 52083.52 | \N | \N | 
| 2015-09-02 | 4 | 201535 | 10 | 5611.108000 | 56111.08 | \N | \N | 
| 2015-09-03 | 5 | 201535 | 5 | 6901.008000 | 34505.04 | \N | \N | 
| 2015-09-04 | 6 | 201535 | 5 | 4707.668000 | 23538.34 | \N | \N | 
| 2015-09-05 | 7 | 201535 | 3 | 3758.706667 | 11276.12 | \N | \N | 
| 2015-09-06 | 1 | 201536 | 3 | 1837.960000 | 5513.88 | 5513.88 | \N | 
| 2015-09-07 | 2 | 201536 | 8 | 5132.747500 | 41061.98 | 46575.86 | \N | 
| 2015-09-08 | 3 | 201536 | 7 | 4016.795714 | 28117.57 | 74693.43 | 52083.52 | 
| 2015-09-09 | 4 | 201536 | 10 | 6076.525000 | 60765.25 | 135458.68 | 56111.08 | 
| 2015-09-10 | 5 | 201536 | 6 | 7631.641667 | 45789.85 | 181248.53 | 34505.04 | 
| 2015-09-11 | 6 | 201536 | 2 | 1653.895000 | 3307.79 | 184556.32 | 23538.34 | 
| 2015-09-12 | 7 | 201536 | 8 | 4363.720000 | 34909.76 | 219466.08 | 11276.12 | 
| 2015-09-13 | 1 | 201537 | 10 | 6841.217000 | 68412.17 | 68412.17 | 5513.88 | 
| 2015-09-14 | 2 | 201537 | 7 | 3590.984286 | 25136.89 | 93549.06 | 41061.98 | 
| 2015-09-15 | 3 | 201537 | 10 | 5223.075000 | 52230.75 | 145779.81 | 28117.57 | 
| 2015-09-16 | 4 | 201537 | 5 | 2300.310000 | 11501.55 | 157281.36 | 60765.25 | 
| 2015-09-17 | 5 | 201537 | 2 | 6226.555000 | 12453.11 | 169734.47 | 45789.85 | 
| 2015-09-18 | 6 | 201537 | 3 | 2170.450000 | 6511.35 | 176245.82 | 3307.79 | 
| 2015-09-19 | 7 | 201537 | 2 | 2638.325000 | 5276.65 | 181522.47 | 34909.76 | 
| 2015-09-20 | 1 | 201538 | 7 | 6243.838571 | 43706.87 | 43706.87 | 68412.17 | 
| 2015-09-21 | 2 | 201538 | 2 | 5523.240000 | 11046.48 | 54753.35 | 25136.89 | 
| 2015-09-22 | 3 | 201538 | 9 | 3830.475556 | 34474.28 | 89227.63 | 52230.75 | 
| 2015-09-23 | 4 | 201538 | 3 | 5828.433333 | 17485.30 | 106712.93 | 11501.55 | 
| 2015-09-24 | 5 | 201538 | 4 | 5431.622500 | 21726.49 | 128439.42 | 12453.11 | 
| 2015-09-25 | 6 | 201538 | 3 | 3883.500000 | 11650.50 | 140089.92 | 6511.35 | 
| 2015-09-26 | 7 | 201538 | 4 | 4384.820000 | 17539.28 | 157629.20 | 5276.65 | 
| 2015-09-27 | 1 | 201539 | 3 | 5382.250000 | 16146.75 | 16146.75 | 43706.87 | 
| 2015-09-28 | 2 | 201539 | 1 | 6067.400000 | 6067.40 | 22214.15 | 11046.48 | 
| 2015-09-29 | 3 | 201539 | 7 | 4441.221429 | 31088.55 | 53302.70 | 34474.28 | 
| 2015-09-30 | 4 | 201539 | 4 | 7760.335000 | 31041.34 | 84344.04 | 17485.30 | 
