USE brizilian_ecommerce;

SELECT OOI.Order_ID
      ,OO.Customer_ID
      ,OC.Customer_Unique_ID
      ,OO.Order_Status
      ,OO.order_purchase_timestamp
      ,OO.order_delivered_carrier_date
      ,OO.order_delivered_customer_date
      ,OO.order_estimated_delivery_date
      ,OOI.Order_Item_ID
	  ,OOI.Product_ID
	  ,OP.product_category_name
      ,OOI.Seller_ID
      ,OOI.Price
      ,OOI.freight_value
      ,OOP.payment_installments
      ,OOP.payment_sequential
      ,OOP.payment_type
      ,OOP.payment_value
      ,OOR.review_id
      ,OOR.review_score
      ,OOR.review_creation_date
      ,OOR.review_answer_timestamp
FROM olist_order_items AS OOI
LEFT JOIN olist_orders AS OO
ON OOI.Order_ID = OO.Order_ID
LEFT JOIN olist_products AS OP
ON OOI.Product_ID = OP.Product_ID
LEFT JOIN olist_customers AS OC
ON OO.Customer_ID = OC.Customer_ID
LEFT JOIN olist_order_reviews AS OOR
ON OOI.Order_ID = OOR.Order_ID
LEFT JOIN olist_order_payments AS OOP
ON OOI.Order_ID = OOP.Order_ID;

