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
           EXTRACT(YEAR FROM o.order_delivered_customer_date) order_delivered_year, 
           EXTRACT(QUARTER FROM o.order_delivered_customer_date) order_delivered_quarter, 
           pcn.product_category_name_translation
    FROM order_items AS oi 
    LEFT JOIN orders AS o
           ON oi.order_id = o.order_id
    LEFT JOIN products AS p
           ON oi.product_id = p.product_id
    LEFT JOIN product_category_name AS pcn
           ON p.product_category_name = pcn.product_category_name
    WHERE o.order_status = 'delivered'
      AND pcn.product_category_name_translation IS NOT NULL
      AND o.order_delivered_customer_date IS NOT NULL
)
-- SELECT * FROM products_order;


, products_order2 AS (
    SELECT product_category_name_translation, order_delivered_year, order_delivered_quarter, 
           CAST(CONCAT(order_delivered_year, order_delivered_quarter) AS int64) order_delivered_yq,
           COUNT(product_category_name_translation) order_quantity,
           SUM(price) revenue,
           ROW_NUMBER() OVER(
               PARTITION BY CONCAT(order_delivered_year, order_delivered_quarter) 
               ORDER BY COUNT(product_category_name_translation) DESC, SUM(price) DESC) rn
    FROM products_order
    GROUP BY product_category_name_translation, order_delivered_year, order_delivered_quarter
    HAVING revenue >= 10000
)

-- SELECT * FROM products_order2 ORDER BY order_delivered_year, order_delivered_quarter, rn;


SELECT rn_table.rn,
       t20171.product_category_name_translation product2017_01, 
       t20172.product_category_name_translation product2017_02, 
       t20173.product_category_name_translation product2017_03, 
       t20174.product_category_name_translation product2017_04, 
       t20181.product_category_name_translation product2018_01, 
       t20182.product_category_name_translation product2018_02, 
       t20183.product_category_name_translation product2018_03
FROM (SELECT ROW_NUMBER() OVER() rn 
      FROM products_order2 
      WHERE rn <= (SELECT max(rn) FROM products_order2)) AS rn_table
LEFT JOIN (SELECT * FROM products_order2 WHERE order_delivered_yq = 20171) AS t20171
       ON rn_table.rn = t20171.rn
LEFT JOIN (SELECT * FROM products_order2 WHERE order_delivered_yq = 20172) AS t20172
       ON rn_table.rn = t20172.rn
LEFT JOIN (SELECT * FROM products_order2 WHERE order_delivered_yq = 20173) AS t20173
       ON rn_table.rn = t20173.rn
LEFT JOIN (SELECT * FROM products_order2 WHERE order_delivered_yq = 20174) AS t20174
       ON rn_table.rn = t20174.rn
LEFT JOIN (SELECT * FROM products_order2 WHERE order_delivered_yq = 20181) AS t20181
       ON rn_table.rn = t20181.rn
LEFT JOIN (SELECT * FROM products_order2 WHERE order_delivered_yq = 20182) AS t20182
       ON rn_table.rn = t20182.rn
LEFT JOIN (SELECT * FROM products_order2 WHERE order_delivered_yq = 20183) AS t20183
       ON rn_table.rn = t20183.rn
WHERE t20171.product_category_name_translation IS NOT NULL
   OR t20172.product_category_name_translation IS NOT NULL
   OR t20173.product_category_name_translation IS NOT NULL
   OR t20174.product_category_name_translation IS NOT NULL
   OR t20181.product_category_name_translation IS NOT NULL
   OR t20182.product_category_name_translation IS NOT NULL
   OR t20183.product_category_name_translation IS NOT NULL
ORDER BY rn_table.rn;