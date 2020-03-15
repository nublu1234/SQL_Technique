
WITH order_items AS (
    SELECT order_id, SUM(price) sum_price, SUM(freight_value) sum_freight_value
    FROM ecommerce_by_olist.olist_order_items_dataset 
    GROUP BY order_id
)
-- SELECT * FROM order_items LIMIT 5;
-- SELECT order_id, COUNT(order_id) order_id_cnt FROM order_items GROUP BY order_id HAVING COUNT(order_id) > 1 LIMIT 5;
-- order_id 중목 0

, orders AS (
    SELECT order_id, customer_id, order_status, order_delivered_customer_date
    FROM ecommerce_by_olist.olist_orders_dataset 
    WHERE order_status = 'delivered'
)
-- SELECT * FROM orders LIMIT 5;
-- SELECT order_id, COUNT(order_id) order_id_cnt FROM orders GROUP BY order_id HAVING COUNT(order_id) > 1 LIMIT 5;
/*
SELECT DISTINCT EXTRACT(YEAR FROM order_delivered_customer_date) order_completed_year, 
       EXTRACT(MONTH FROM order_delivered_customer_date) order_completed_month
FROM orders
ORDER BY order_completed_year, order_completed_month;
*/
-- order_id 중목 0

, customers AS (
    SELECT customer_unique_id, customer_id
    FROM ecommerce_by_olist.olist_customers_dataset
)
-- SELECT * FROM customers LIMIT 5;

, customer_order AS (
    SELECT c.customer_unique_id, c.customer_id,
           o.order_id, o.order_status, o.order_delivered_customer_date,
           EXTRACT(YEAR FROM o.order_delivered_customer_date) order_completed_year, 
           EXTRACT(QUARTER FROM o.order_delivered_customer_date) order_completed_quarter, 
           oi.sum_price, oi.sum_freight_value           
    FROM customers AS c
    LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
    LEFT JOIN order_items AS oi
    ON o.order_id = oi.order_id
)
-- SELECT * FROM customer_order;
-- SELECT order_id, COUNT(order_id) order_id_cnt FROM customer_order GROUP BY order_id HAVING COUNT(order_id) > 1 LIMIT 5;
-- order_id 중목 0
/* 
SELECT DISTINCT order_completed_year, order_completed_quarter 
FROM customer_order WHERE order_delivered_customer_date IS NULL 
ORDER BY order_completed_year, order_completed_quarter; 
*/
-- SELECT * FROM customer_order WHERE order_delivered_customer_date IS NULL;
/*
SELECT order_completed_year, order_completed_quarter, COUNT(order_completed_year) order_completed_year_cnt FROM customer_order 
GROUP BY order_completed_year, order_completed_quarter 
ORDER BY order_completed_year, order_completed_quarter; 
*/
-- SELECT SUM(CASE WHEN order_id IS NULL THEN 1 END), SUM(CASE WHEN order_id IS NOT NULL THEN 1 END) FROM customer_order;
-- 주문을 아예 안한 고객도 존재

, customer_monthly_order AS (
    SELECT customer_unique_id, order_completed_year, order_completed_quarter,
           SUM(sum_price) monthly_sum_price, SUM(sum_freight_value) monthly_sum_freight_value
    FROM customer_order
    GROUP BY customer_unique_id, order_completed_year, order_completed_quarter
    HAVING order_completed_year IS NOT NULL
)
-- SELECT * FROM customer_monthly_order WHERE order_completed_year IS NOT NULL;
-- SELECT DISTINCT order_completed_year, order_completed_quarter FROM customer_order ORDER BY order_completed_year, order_completed_quarter;


, customer_monthly_order2 AS (
SELECT *, 
       
       FIRST_VALUE(order_completed_year) 
           OVER (PARTITION BY customer_unique_id 
                 ORDER BY order_completed_year, order_completed_quarter) first_order_year,
       FIRST_VALUE(order_completed_quarter) 
           OVER (PARTITION BY customer_unique_id 
                 ORDER BY order_completed_year, order_completed_quarter) first_order_quarter,
                 
       4*(order_completed_year - 2016) + order_completed_quarter - 3 
       - FIRST_VALUE(4*(order_completed_year - 2016) + order_completed_quarter - 3) 
             OVER (PARTITION BY customer_unique_id 
                   ORDER BY 4*(order_completed_year - 2016) + order_completed_quarter - 3) cohort_order_quarter
FROM customer_monthly_order
ORDER BY customer_unique_id, order_completed_year, order_completed_quarter
)

-- SELECT * FROM customer_monthly_order2;

/*
SELECT * 
FROM customer_monthly_order2 
WHERE customer_unique_id IN (SELECT customer_unique_id 
                             FROM customer_monthly_order2 
                             GROUP BY customer_unique_id
                             HAVING COUNT(customer_unique_id) > 1);
*/

/*
SELECT first_order_year, first_order_quarter,
       SUM(CASE WHEN cohort_order_quarter = 0 THEN 1 END) AS period0,
       SUM(CASE WHEN cohort_order_quarter = 1 THEN 1 END) AS period1,
       SUM(CASE WHEN cohort_order_quarter = 2 THEN 1 END) AS period2,
       SUM(CASE WHEN cohort_order_quarter = 3 THEN 1 END) AS period3,
       SUM(CASE WHEN cohort_order_quarter = 4 THEN 1 END) AS period4,
       SUM(CASE WHEN cohort_order_quarter = 5 THEN 1 END) AS period5,
       SUM(CASE WHEN cohort_order_quarter = 6 THEN 1 END) AS period6,
       SUM(CASE WHEN cohort_order_quarter = 7 THEN 1 END) AS period7,
       SUM(CASE WHEN cohort_order_quarter = 8 THEN 1 END) AS period8
FROM customer_monthly_order2
GROUP BY first_order_year, first_order_quarter
ORDER BY first_order_year, first_order_quarter;
*/

SELECT * FROM customer_monthly_order2;