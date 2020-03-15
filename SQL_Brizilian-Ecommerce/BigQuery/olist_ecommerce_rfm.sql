
WITH customers AS (
    SELECT customer_id, customer_unique_id
    FROM ecommerce_by_olist.olist_customers_dataset
)

, orders AS (
    SELECT order_id, customer_id, order_status, order_delivered_customer_date
    FROM ecommerce_by_olist.olist_orders_dataset 
)

, order_items AS (
    SELECT order_id, order_item_id, product_id, price, freight_value
    FROM ecommerce_by_olist.olist_order_items_dataset
)

, order_items2 AS (
    SELECT order_id, 
           MAX(order_item_id) order_quantity,
           SUM(price) purchase_amount
    FROM order_items
    GROUP BY order_id
)

, coi AS (
    SELECT c.customer_unique_id, c.customer_id,
           o.order_id, o.order_status, o.order_delivered_customer_date,
           oi.order_quantity, oi.purchase_amount, 
           DATE_DIFF(DATE(o.order_delivered_customer_date),
                     DATE(LAG(o.order_delivered_customer_date, 1) 
                              OVER(PARTITION BY c.customer_unique_id ORDER BY c.customer_unique_id, o.order_delivered_customer_date)),
                     DAY) order_date_interval, 
           (SELECT MAX(o.order_delivered_customer_date) 
            FROM customers AS c
            LEFT JOIN orders AS o
                   ON c.customer_id = o.customer_id
            LEFT JOIN order_items2 AS oi
                   ON o.order_id = oi.order_id) nearest_date
    FROM customers AS c
    LEFT JOIN orders AS o
           ON c.customer_id = o.customer_id
    LEFT JOIN order_items2 AS oi
           ON o.order_id = oi.order_id
)
-- SELECT *
-- FROM coi
-- WHERE customer_unique_id IN (SELECT customer_unique_id 
--                              FROM coi 
--                              GROUP BY customer_unique_id 
--                              HAVING COUNT(customer_unique_id) > 3)
-- ORDER BY customer_unique_id, order_delivered_customer_date;

-- SELECT customer_unique_id, 
--        COUNT(customer_unique_id) number_of_purchases,
--        AVG(order_date_interval) avg_order_date_interval
-- FROM coi
-- WHERE order_status = 'delivered'
-- GROUP BY customer_unique_id
-- HAVING COUNT(customer_unique_id) > 1 AND AVG(order_date_interval) IS NULL
-- ORDER BY COUNT(customer_unique_id) DESC;

-- SELECT *
-- FROM coi
-- WHERE customer_unique_id IN (SELECT customer_unique_id
--                              FROM coi
--                              WHERE order_status = 'delivered'
--                              GROUP BY customer_unique_id
--                              HAVING COUNT(customer_unique_id) > 1 AND AVG(order_date_interval) IS NULL);

                            
, coi2 AS (
    SELECT customer_unique_id, 
           COUNT(customer_unique_id) number_of_purchases,
           
           SUM(order_quantity) sum_order_quantity,
           AVG(order_quantity) avg_order_quantity,
           MAX(order_quantity) max_order_quantity,
           MIN(order_quantity) min_order_quantity,
           
           SUM(purchase_amount) sum_purchase_amount,
           AVG(purchase_amount) avg_purchase_amount,
           MAX(purchase_amount) max_purchase_amount,
           MIN(purchase_amount) min_purchase_amount,
           
           /*??purchase_amount_per_product??*/
           SUM(purchase_amount)/SUM(order_quantity) avg_papp,
           MAX(purchase_amount)/MAX(order_quantity) max_papp,
           MIN(purchase_amount)/MIN(order_quantity) min_papp,
           
           DATE(MAX(order_delivered_customer_date)) last_order_date,
           DATE(MIN(order_delivered_customer_date)) first_order_date,
           (SELECT DATE(MAX(order_delivered_customer_date)) FROM coi) all_nearest_order_date,
           DATE_DIFF((SELECT DATE(MAX(order_delivered_customer_date)) FROM coi),
                     DATE(MAX(order_delivered_customer_date)),
                     DAY) order_interval,
           AVG(order_date_interval) avg_order_date_interval,
           MAX(order_date_interval) max_order_date_interval,
           MIN(order_date_interval) min_order_date_interval,
           DATE_DIFF(DATE(MAX(order_delivered_customer_date)), 
                     DATE(MIN(order_delivered_customer_date)),
                     DAY) all_order_date_interval
           
    FROM coi
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date >= '2017-01-01 00:00:00'
      AND order_delivered_customer_date < '2018-09-01 00:00:00'
    GROUP BY customer_unique_id
)
-- SELECT * FROM coi2;
-- SELECT * FROM coi2 WHERE number_of_purchases > 2;
-- SELECT number_of_purchases, PERCENT_RANK() OVER (ORDER BY number_of_purchases DESC) as PER_RANK 
-- FROM coi2;


-- SELECT DISTINCT *
-- FROM (
-- SELECT avg_order_date_interval, PERCENT_RANK() OVER (ORDER BY avg_order_date_interval DESC) pr FROM coi2
-- )
-- /* WHERE pr < 0.3 */
-- ORDER BY pr;


/* 
sum_purchase_amount: ~ 280 (0~10%), 280 ~ 139 (10~30%),  139 ~ (30~100%)
order_interval: ~ 83 (0~10%), 83 ~ 170 (10~30%), 170 ~ 
number_of_purchases: ~ 2, 1
 */

, coi3 AS (
    SELECT *, 
           CASE WHEN order_interval <= 83 THEN 3
                WHEN order_interval <= 170 AND order_interval > 83 THEN 2
                ELSE 1 END r_indicator,
           CASE WHEN number_of_purchases >= 2 THEN 2
                ELSE 1 END f_indicator,
           CASE WHEN sum_purchase_amount >= 280 THEN 3
                WHEN sum_purchase_amount < 280 AND sum_purchase_amount >= 139 THEN 2
                ELSE 1 END m_indicator
    FROM coi2
)
SELECT * FROM coi3;