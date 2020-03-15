
WITH order_payments AS (
    SELECT order_id, SUM(payment_value) payment
    FROM ecommerce_by_olist.olist_order_payments_dataset
    GROUP BY order_id
)

, orders AS (
    SELECT o.order_id, o.customer_id, o.order_status, o.order_delivered_customer_date, 
           EXTRACT(DATE FROM order_delivered_customer_date) order_delivered_customer_date_,
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



SELECT order_delivered_customer_date_,
       COUNT(order_id) order_quantity,
       ROUND(
             COUNT(order_id)/
             LAG(COUNT(order_id), 7) 
                 OVER (ORDER BY order_delivered_customer_date_)
             , 2) order_quantity_per_7day,
       ROUND(
             COUNT(order_id)/
             LAG(COUNT(order_id), 28) 
                 OVER (ORDER BY order_delivered_customer_date_)
             , 2) order_quantity_per_28day,
       ROUND(
             COUNT(order_id)/
             LAG(COUNT(order_id), 365) 
                 OVER (ORDER BY order_delivered_customer_date_)
             , 2) order_quantity_per_1year,
             
       COUNT(customer_id) customer_quantity,
       ROUND(
             COUNT(customer_id)/
             LAG(COUNT(customer_id), 7) 
                 OVER (ORDER BY order_delivered_customer_date_)
             , 2) customer_quantity_per_7day,
       ROUND(
             COUNT(customer_id)/
             LAG(COUNT(customer_id), 28) 
                 OVER (ORDER BY order_delivered_customer_date_)
             , 2) customer_quantity_per_28day,
       ROUND(
             COUNT(customer_id)/
             LAG(COUNT(customer_id), 365) 
                 OVER (ORDER BY order_delivered_customer_date_)
             , 2) customer_quantity_per_1year,
             
       ROUND(SUM(payment), 2) revenue,
       ROUND(
             SUM(payment)/
             LAG(SUM(payment), 7) 
                 OVER (ORDER BY order_delivered_customer_date_)
             , 2) revenue_per_7day,
       ROUND(
             SUM(payment)/
             LAG(SUM(payment), 28) 
                 OVER (ORDER BY order_delivered_customer_date_)
             , 2) revenue_per_28day,
       ROUND(
             SUM(payment)/
             LAG(SUM(payment), 365) 
                 OVER (ORDER BY order_delivered_customer_date_)
             , 2) revenue_per_1year
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date >= '2017-01-01 00:00:00'
  AND order_delivered_customer_date < '2018-09-01 00:00:00'
GROUP BY order_delivered_customer_date_
ORDER BY order_delivered_customer_date_;

