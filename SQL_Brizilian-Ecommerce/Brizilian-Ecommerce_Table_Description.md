# Brizilian-Ecommerce Table Description


![HRhd2Y0.png](https://b.allthepics.net/HRhd2Y0.png)

### olist_orders
```sql
USE brizilian_ecommerce;

SELECT *
FROM olist_orders
LIMIT 5
```
| order_id | customer_id | order_status | order_purchase_timestamp | order_approved_at | order_delivered_carrier_date | order_delivered_customer_date | order_estimated_delivery_date | 
| --- | --- | --- | --- | --- | --- | --- | --- | 
| e481f51cbdc54678b7cc49136f2d6af7 | 9ef432eb6251297304e76186b10a928d | delivered | 2017-10-02 10:56:33 | 2017-10-02 11:07:15 | 2017-10-04 19:55:00 | 2017-10-10 21:25:13 | 2017-10-18 00:00:00 | 
| 53cdb2fc8bc7dce0b6741e2150273451 | b0830fb4747a6c6d20dea0b8c802d7ef | delivered | 2018-07-24 20:41:37 | 2018-07-26 03:24:27 | 2018-07-26 14:31:00 | 2018-08-07 15:27:45 | 2018-08-13 00:00:00 | 
| 47770eb9100c2d0c44946d9cf07ec65d | 41ce2a54c0b03bf3443c3d931a367089 | delivered | 2018-08-08 08:38:49 | 2018-08-08 08:55:23 | 2018-08-08 13:50:00 | 2018-08-17 18:06:29 | 2018-09-04 00:00:00 | 
| 949d5b44dbf5de918fe9c16f97b45f8a | f88197465ea7920adcdbec7375364d82 | delivered | 2017-11-18 19:28:06 | 2017-11-18 19:45:59 | 2017-11-22 13:39:59 | 2017-12-02 00:28:42 | 2017-12-15 00:00:00 | 
| ad21c59c0840e6cb83a9ceb5573f8159 | 8ab97904e6daea8866dbdbc4fb7aad2c | delivered | 2018-02-13 21:18:39 | 2018-02-13 22:20:29 | 2018-02-14 19:46:34 | 2018-02-16 18:17:02 | 2018-02-26 00:00:00 | 

| Column | Column Name | Description |
| --- | --- | --- |
| order_id | 주문 ID |  |
| customer_id | 고객 ID |  |
| order_status | 주문 상태 | delivered, shipped, processing,  unavailable, canceled,  created,  approved |
| order_purchase_timestamp | 주문 시간 |  |
| order_approved_at | 주문 승인 시간 |  |
| order_delivered_carrier_date | 배송 준비 완료 시간 |  |
| order_delivered_customer_date | 배송 시간 |  |
| order_estimated_delivery_date | 배송 도착 시간 |  |
---




### olist_order_payments
```sql
USE brizilian_ecommerce;

SELECT *
FROM olist_order_payments
LIMIT 5
```
| order_id | payment_sequential | payment_type | payment_installments | payment_value | 
| --- | ---: | --- | ---: | ---: | 
| b81ef226f3fe1789b1e8b2acac839d17 | 1 | credit_card | 8 | 99.33 | 
| a9810da82917af2d9aefd1278f1dcfa0 | 1 | credit_card | 1 | 24.39 | 
| 25e8ea4e93396b6fa0d3dd708e76c1bd | 1 | credit_card | 1 | 65.71 | 
| ba78997921bbcdc1373bb41e913ab953 | 1 | credit_card | 8 | 107.78 | 
| 42fdf880ba16b47b59251dd489d4441a | 1 | credit_card | 2 | 128.45 | 


| Column | Column Name | Description |
| --- | --- | --- | 
| order_id |주문 ID |  |
| payment_sequential | 배송 순서 |  |
| payment_type | 결제 타입 |  |
| payment_installments | 결제 할부 월 |  |
| payment_value | 결제액 |  |


### olist_order_reviews
```sql
USE brizilian_ecommerce;

SELECT *
FROM olist_order_reviews
LIMIT 5
```
| review_id | order_id | review_score | review_comment_title | review_comment_message | review_creation_date | review_answer_timestamp | 
| --- | --- | ---: | --- | --- | --- | --- | 
| 7bc2406110b926393aa56f80a40eba40 | 73fc7af87114b39712e6da79b0a377eb | 4 |  |  | 2018-01-18 00:00:00 | 2018-01-18 21:46:59 | 
| 80e641a11e56f04c1ad469d5645fdfde | a548910a1c6147796b98fdf73dbeba33 | 5 |  |  | 2018-03-10 00:00:00 | 2018-03-11 03:05:13 | 
| 228ce5500dc1d8e020d8d1322874b6f0 | f9e4b658b201a9f2ecdecbb34bed034b | 5 |  |  | 2018-02-17 00:00:00 | 2018-02-18 14:36:24 | 
| e64fb393e7b32834bb789ff8bb30750e | 658677c97b385a9be170737859d3511b | 5 |  | Recebi bem antes do prazo estipulado. | 2017-04-21 00:00:00 | 2017-04-21 22:02:06 | 
| f7c4243c7fe1938f181bec41a392bdeb | 8e6bfb81e283fa7e4f11123a3fb894f1 | 5 |  | Parabéns lojas lannister adorei comprar pela Internet seguro e prático Parabéns a todos feliz Páscoa | 2018-03-01 00:00:00 | 2018-03-02 10:26:53 | 

| Column | Column Name | Description |
| --- | --- | --- |
| review_id | 리뷰 ID |  |
| order_id | 주문 ID |  |
| review_score | 리뷰 평점 |  |
| review_comment_title | 리뷰 제목 |  |
| review_comment_message | 리뷰 본문 |  |
| review_creation_date | 리뷰일 |  |
| review_answer_timestamp | 리뷰 응답 시간 |  |
---

### olist_customers
```sql
USE brizilian_ecommerce;

SELECT *
FROM olist_customers
LIMIT 5
```
| customer_id | customer_unique_id | customer_zip_code_prefix | customer_city | customer_state | 
| --- | --- | ---: | --- | --- | 
| 06b8999e2fba1a1fbc88172c00ba8bc7 | 861eff4711a542e4b93843c6dd7febb0 | 14409 | franca | SP | 
| 18955e83d337fd6b2def6b18a428ac77 | 290c77bc529b7ac935b93aa66c333dc3 | 9790 | sao bernardo do campo | SP | 
| 4e7b3e00288586ebd08712fdd0374a03 | 060e732b5b29e8181a18229c7b0b2b5e | 1151 | sao paulo | SP | 
| b2b6027bc5c5109e529d4dc6358b12c3 | 259dac757896d24d7702b9acbbff3f3c | 8775 | mogi das cruzes | SP | 
| 4f2d8ab171c80ec8364f7c12e35b23ad | 345ecd01c38d18a9036ed96c73b8d066 | 13056 | campinas | SP | 

| Column | Column Name | Description |
| --- | --- | --- |
| customer_id | 고객 ID |  |
| customer_unique_id | 고객 Unique ID |  |
| customer_zip_code_prefix | 고객 우편번호 |  |
| customer_city | 고객 거주 도시 |  |
| customer_state | 고객 거주 주 |  |
---

### olist_order_items
```sql
USE brizilian_ecommerce;

SELECT *
FROM olist_order_items
LIMIT 5
```
| order_id | order_item_id | product_id | seller_id | shipping_limit_date | price | freight_value | 
| --- | ---: | --- | --- | --- | ---: | ---: | 
| 00010242fe8c5a6d1ba2dd792cb16214 | 1 | 4244733e06e7ecb4970a6e2683c13e61 | 48436dade18ac8b2bce089ec2a041202 | 2017-09-19 09:45:35 | 58.9 | 13.29 | 
| 00018f77f2f0320c557190d7a144bdd3 | 1 | e5f2d52b802189ee658865ca93d83a8f | dd7ddc04e1b6c2c614352b383efe2d36 | 2017-05-03 11:05:13 | 239.9 | 19.93 | 
| 000229ec398224ef6ca0657da4fc703e | 1 | c777355d18b72b67abbeef9df44fd0fd | 5b51032eddd242adc84c38acab88f23d | 2018-01-18 14:48:30 | 199 | 17.87 | 
| 00024acbcdf0a6daa1e931b038114c75 | 1 | 7634da152a4610f1595efa32f14722fc | 9d7a1d34a5052409006425275ba1c2b4 | 2018-08-15 10:10:18 | 12.99 | 12.79 | 
| 00042b26cf59d7ce69dfabb4e55b4fd9 | 1 | ac6c3623068f30de03045865e4e10089 | df560393f3a51e74553ab94004ba5c87 | 2017-02-13 13:57:51 | 199.9 | 18.14 | 

| Column | Column Name | Description |
| --- | --- | --- |
| order_id | 주문 ID |  |
| order_item_id | 주문 상품 ID |  |
| product_id | 제품 ID |  |
| seller_id | 판매원 ID |  |
| shipping_limit_date |  |  |
| price | 가격 |  |
| freight_value | 배송 비용 | 
---


### olist_products
```sql
USE brizilian_ecommerce;

SELECT *
FROM olist_products
LIMIT 5
```
| product_id | product_category_name | product_name_lenght | product_description_lenght | product_photos_qty | product_weight_g | product_length_cm | product_height_cm | product_width_cm | 
| --- | --- | --- | --- | --- | --- | --- | --- | --- | 
| 1e9e8ef04dbcff4541ed26657ea517e5 | perfumaria | 40 | 287 | 1 | 225 | 16 | 10 | 14 | 
| 3aa071139cb16b67ca9e5dea641aaa2f | artes | 44 | 276 | 1 | 1000 | 30 | 18 | 20 | 
| 96bd76ec8810374ed1b65e291975717f | esporte_lazer | 46 | 250 | 1 | 154 | 18 | 9 | 15 | 
| cef67bcfe19066a932b7673e239eb23d | bebes | 27 | 261 | 1 | 371 | 26 | 4 | 26 | 
| 9dc1a7de274444849c219cff195d0b71 | utilidades_domesticas | 37 | 402 | 4 | 625 | 20 | 17 | 13 | 

| Column | Column Name | Description |
| --- | --- | --- |
| product_id | 제품 ID |  |
| product_category_name | 제품 카테고리 이름 |
| product_name_lenght | 제품 (게시글)이름 길이 |
| product_description_lenght | 제품 (게시글)설명 길이 |  |
| product_photos_qty | 제품 사진 수 |  |
| product_weight_g |  |  |
| product_length_cm |  |  |
| product_height_cm |  |  |
| product_width_cm |  |  |
---

### olist_sellers
```sql
USE brizilian_ecommerce;

SELECT *
FROM olist_sellers
LIMIT 5
```
| seller_id | seller_zip_code_prefix | seller_city | seller_state | 
| --- | ---: | --- | --- | 
| 3442f8959a84dea7ee197c632cb2df15 | 13023 | campinas | SP | 
| d1b65fc7debc3361ea86b5f14c68d2e2 | 13844 | mogi guacu | SP | 
| ce3ad9de960102d0677a81f5d0bb7b2d | 20031 | rio de janeiro | RJ | 
| c0f3eea2e14555b6faeea3dd58c1b1c3 | 4195 | sao paulo | SP | 
| 51a04a8a6bdcb23deccc82b0b80742cf | 12914 | braganca paulista | SP | 

| Column | Column Name | Description |
| --- | --- | --- |
| seller_id  | 판매자 ID |  |
| seller_zip_code_prefix  | 판매자 우편번호 |  |
| seller_city | 판매자 거주 도시 |  |
| seller_state | 판매자 거주 시 |  |
---


### olist_geolocation
```sql
USE brizilian_ecommerce;

SELECT *
FROM olist_geolocation
LIMIT 5
```
| geolocation_zip_code_prefix | geolocation_lat | geolocation_lng | geolocation_city | geolocation_state | 
| ---: | ---: | ---: | --- | --- | 
| 1037 | -23.5456 | -46.6393 | sao paulo | SP | 
| 1046 | -23.5461 | -46.6448 | sao paulo | SP | 
| 1046 | -23.5461 | -46.643 | sao paulo | SP | 
| 1041 | -23.5444 | -46.6395 | sao paulo | SP | 
| 1035 | -23.5416 | -46.6416 | sao paulo | SP | 

| Column | Column Name | Description |
| --- | --- | --- |
| geolocation_zip_code_prefix | | |
| geolocation_lat | | |
| geolocation_lng | | |
| geolocation_city | | |
| geolocation_state | | | 
---
