

### NULL to Zero
```sql
USE sql_recipe;

SELECT *
/* COALESCE(expr1, expr2): CASE WHEN expr1 IS NULL THEN expr2 ELSE expr1 END */
/* IF(expr1, expr2): CASE WHEN expr1 IS TRUE THEN expr2 ELSE expr3 END */
/* IFNULL(expr1, expr2): CASE WHEN expr1 IS NULL THEN expr2 ELSE expr3 END */
/* NULLIF(expr1, expr2): CASE WHEN expr1=expr2 THEN NULL ELSE expr1 END */
      ,amount - coupon AS discount_amount1
      ,amount - COALESCE(coupon, 0) AS discount_amount2
      ,amount - IF(coupon, coupon, 0) AS discount_amount3
      ,amount - IFNULL(coupon, 0) AS discount_amount4
FROM purchase_log_with_coupon
```
| purchase_id | amount | coupon | discount_amount1 | discount_amount2 | discount_amount3 | discount_amount4 | 
| --- | ---: | ---: | ---: | ---: | ---: | ---: | 
| 10001 | 3280 | \N | \N | 3280 | 3280 | 3280 | 
| 10002 | 4650 | 500 | 4150 | 4150 | 4150 | 4150 | 
| 10003 | 3870 | \N | \N | 3870 | 3870 | 3870 | 
