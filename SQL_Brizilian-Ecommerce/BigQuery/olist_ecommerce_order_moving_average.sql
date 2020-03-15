
WITH order_payments AS (
SELECT order_id, SUM(payment_value) payment
FROM ecommerce_by_olist.olist_order_payments_dataset
GROUP BY order_id
)

, orders AS (
SELECT o.order_id, o.customer_id, o.order_status, o.order_delivered_customer_date, 
       EXTRACT(YEAR FROM order_delivered_customer_date) order_delivered_customer_year, 
       EXTRACT(MONTH FROM order_delivered_customer_date) order_delivered_customer_month, 
       CASE WHEN CAST(EXTRACT(MONTH FROM order_delivered_customer_date) AS int64) < 10 
            THEN CAST(
                      CONCAT(
                             CONCAT(EXTRACT(YEAR FROM order_delivered_customer_date), 
                                    '0'),
                             EXTRACT(MONTH FROM order_delivered_customer_date)
                            ) AS int64
                     ) 
            ELSE CAST(
                      CONCAT(
                             EXTRACT(YEAR FROM order_delivered_customer_date), 
                             EXTRACT(MONTH FROM order_delivered_customer_date)
                            ) AS int64
                      ) 
            END order_delivered_ym,
       op.payment 
FROM ecommerce_by_olist.olist_orders_dataset AS o
LEFT JOIN order_payments AS op
ON o.order_id = op.order_id
)
-- SELECT * FROM orders;

SELECT order_delivered_customer_year, order_delivered_customer_month, order_delivered_ym,
       COUNT(order_id) order_quantity,
       ROUND(
             100 * COUNT(order_id)/
             LAG(COUNT(order_id), 1) 
                 OVER (ORDER BY order_delivered_customer_year, 
                                order_delivered_customer_month)
             , 2) order_quantity_per_1month,
       ROUND(
             100 * COUNT(order_id)/
             LAG(COUNT(order_id), 12) 
                 OVER (ORDER BY order_delivered_customer_year, 
                                order_delivered_customer_month)
             , 2) order_quantity_per_1year,
       ROUND(SUM(payment), 2) revenue,
       ROUND(
             100 * SUM(payment)/
             LAG(SUM(payment), 1) 
                 OVER (ORDER BY order_delivered_customer_year, 
                                order_delivered_customer_month)
             , 2) revenue_per_1month,
       ROUND(
             100 * SUM(payment)/
             LAG(SUM(payment), 12) 
                 OVER (ORDER BY order_delivered_customer_year, 
                                order_delivered_customer_month)
             , 2) revenue_per_1year
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_year IS NOT NULL
GROUP BY order_delivered_customer_year, order_delivered_customer_month, order_delivered_ym
ORDER BY order_delivered_customer_year, order_delivered_customer_month, order_delivered_ym;
