# E-commerce Sales Status Moving Average

### E-commerce Order Quantity
```sql
USE brizilian_ecommerce;

WITH orders AS (
    SELECT *
          ,EXTRACT(YEAR FROM order_delivered_customer_date) order_year
		    ,EXTRACT(MONTH FROM order_delivered_customer_date) order_month
    FROM olist_orders
    WHERE order_status = 'delivered'
)
SELECT order_year
      ,order_month
		,COUNT(order_year) AS order_quantity
		,CONCAT(ROUND(COUNT(order_year)/
		LAG(COUNT(order_year), 1) OVER (
		     /* PARTITION BY ordered_year */
           ORDER BY order_year, order_month
			  )*100, 0), '%') AS order_qntt_compared_previous_month
		,CONCAT(ROUND(COUNT(order_year)/
		LAG(COUNT(order_year), 12) OVER (
		     /* PARTITION BY order_year */
           ORDER BY order_year, order_month
			  )*100, 0), '%') AS order_qntt_compared_previous_year
FROM orders
WHERE order_year IS NOT NULL
GROUP BY order_year, order_month
ORDER BY order_year, order_month
```
| order_year | order_month | order_quantity | order_qntt_compared_previous_month | order_qntt_compared_previous_year | 
| ---: | ---: | ---: | --- | --- | 
| 2016 | 10 | 205 | \N | \N | 
| 2016 | 11 | 58 | 28% | \N | 
| 2016 | 12 | 4 | 7% | \N | 
| 2017 | 1 | 283 | 7075% | \N | 
| 2017 | 2 | 1351 | 477% | \N | 
| 2017 | 3 | 2382 | 176% | \N | 
| 2017 | 4 | 1849 | 78% | \N | 
| 2017 | 5 | 3751 | 203% | \N | 
| 2017 | 6 | 3223 | 86% | \N | 
| 2017 | 7 | 3455 | 107% | \N | 
| 2017 | 8 | 4302 | 125% | \N | 
| 2017 | 9 | 3965 | 92% | \N | 
| 2017 | 10 | 4494 | 113% | 2192% | 
| 2017 | 11 | 4670 | 104% | 8052% | 
| 2017 | 12 | 7205 | 154% | 180125% | 
| 2018 | 1 | 6597 | 92% | 2331% | 
| 2018 | 2 | 5850 | 89% | 433% | 
| 2018 | 3 | 6824 | 117% | 286% | 
| 2018 | 4 | 7850 | 115% | 425% | 
| 2018 | 5 | 7111 | 91% | 190% | 
| 2018 | 6 | 6829 | 96% | 212% | 
| 2018 | 7 | 5839 | 86% | 169% | 
| 2018 | 8 | 8314 | 142% | 193% | 
| 2018 | 9 | 56 | 1% | 1% | 
| 2018 | 10 | 3 | 5% | 0% | 


### E-commerce Order Total Purchase
---
```sql
USE brizilian_ecommerce;

WITH order_items AS (
    SELECT *
          ,EXTRACT(YEAR FROM shipping_limit_date) order_year
    		 ,EXTRACT(MONTH FROM shipping_limit_date) order_month
    FROM olist_order_items
)
-- SELECT * FROM order_items;

SELECT order_year
      ,order_month
		,ROUND(SUM(price),0) total_purchase
		,CONCAT(ROUND(SUM(price)/
		LAG(SUM(price), 1) OVER (
		     /* PARTITION BY ordered_year */
           ORDER BY order_year, order_month
			  )*100, 0), '%') AS purchase_compared_previous_month
		,CONCAT(ROUND(SUM(price)/
		LAG(SUM(price), 12) OVER (
		     /* PARTITION BY order_year */
           ORDER BY order_year, order_month
			  )*100, 0), '%') AS purchase_compared_previous_year
FROM order_items
WHERE order_year NOT IN (2016, 2020)
GROUP BY order_year, order_month
ORDER BY order_year, order_month
```
| order_year | order_month | total_purchase | purchase_compared_previous_month | purchase_compared_previous_year | 
| ---: | ---: | ---: | --- | --- | 
| 2017 | 1 | 80125 | \N | \N | 
| 2017 | 2 | 245982 | 307% | \N | 
| 2017 | 3 | 343243 | 140% | \N | 
| 2017 | 4 | 308148 | 90% | \N | 
| 2017 | 5 | 505655 | 164% | \N | 
| 2017 | 6 | 469001 | 93% | \N | 
| 2017 | 7 | 465282 | 99% | \N | 
| 2017 | 8 | 560093 | 120% | \N | 
| 2017 | 9 | 617046 | 110% | \N | 
| 2017 | 10 | 658020 | 107% | \N | 
| 2017 | 11 | 883352 | 134% | \N | 
| 2017 | 12 | 898921 | 102% | \N | 
| 2018 | 1 | 845279 | 94% | 1055% | 
| 2018 | 2 | 819229 | 97% | 333% | 
| 2018 | 3 | 1030528 | 126% | 300% | 
| 2018 | 4 | 958730 | 93% | 311% | 
| 2018 | 5 | 1084359 | 113% | 214% | 
| 2018 | 6 | 870737 | 80% | 186% | 
| 2018 | 7 | 811132 | 93% | 174% | 
| 2018 | 8 | 1072148 | 132% | 191% | 
| 2018 | 9 | 14503 | 1% | 2% | 

