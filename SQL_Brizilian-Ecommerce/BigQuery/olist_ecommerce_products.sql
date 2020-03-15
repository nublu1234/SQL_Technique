WITH order_items AS (
    SELECT product_id, order_id, price, freight_value
    FROM ecommerce_by_olist.olist_order_items_dataset
)

, orders AS (
    SELECT order_id, customer_id, order_status, order_delivered_customer_date
    FROM ecommerce_by_olist.olist_orders_dataset 
)

, products AS (
    SELECT 	product_id,	product_category_name
    FROM ecommerce_by_olist.olist_products_dataset
)

, product_category_name AS (
    SELECT string_field_0 product_category_name, string_field_1 product_category_name_translation
    FROM ecommerce_by_olist.product_category_name_translation
)

, products_order AS (
    SELECT oi.product_id, oi.price, oi.freight_value,
           o.order_id, o.order_status, o.order_delivered_customer_date,
           pcn.product_category_name_translation
    FROM order_items AS oi 
    LEFT JOIN orders AS o
           ON oi.order_id = o.order_id
    LEFT JOIN products AS p
           ON oi.product_id = p.product_id
    LEFT JOIN product_category_name AS pcn
           ON p.product_category_name = pcn.product_category_name
    WHERE o.order_status = 'delivered'
      AND order_delivered_customer_date >= '2017-01-01 00:00:00'
      AND order_delivered_customer_date < '2018-09-01 00:00:00'
      AND pcn.product_category_name_translation IS NOT NULL
      AND o.order_delivered_customer_date IS NOT NULL
)

-- WHERE order_delivered_customer_date >= '2018-08-01 00:00:00'
--   AND order_delivered_customer_date < '2018-08-08 00:00:00';
 
-- SELECT product_category_name_translation, SUM(price) sum_price
-- FROM products_order
-- WHERE order_delivered_customer_date >= '2018-08-01 00:00:00'
-- AND order_delivered_customer_date < '2018-08-08 00:00:00'
-- GROUP BY product_category_name_translation;

SELECT * FROM products_order