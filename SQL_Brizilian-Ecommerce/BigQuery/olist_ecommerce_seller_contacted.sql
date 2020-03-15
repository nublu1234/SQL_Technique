WITH mql AS (
    SELECT mql_id, landing_page_id, origin, 
           CAST(CONCAT(EXTRACT(YEAR FROM first_contact_date),
                  EXTRACT(QUARTER FROM first_contact_date)) AS int64) contact_year_quarter
    FROM ecommerce_by_olist.olist_marketing_qualified_leads_dataset
)

, olist_closed_deals AS (
    SELECT mql_id, seller_id, sdr_id, sr_id/*, 
           won_date, business_segment,lead_type, lead_behaviour_profile, has_company, 
           has_gtin, average_stock, business_type, 
           declared_product_catalog_size, declared_monthly_revenue 
            */
    FROM ecommerce_by_olist.olist_closed_deals_dataset
)

, seller_contacted AS (
    SELECT mql.mql_id, mql.origin, mql.contact_year_quarter, mql.landing_page_id, 
           ocd.seller_id, ocd.sdr_id, ocd.sr_id
    FROM mql
    LEFT JOIN olist_closed_deals AS ocd
           ON mql.mql_id = ocd.mql_id
)


SELECT origin,
       COUNT(mql_id) total_seller,
       ROUND(SUM(CASE WHEN sr_id IS NOT NULL THEN 1 END)/COUNT(mql_id) * 100, 2) total_contacted_rate,
       
       ROUND( SUM(CASE WHEN contact_year_quarter = 20172 AND sr_id IS NOT NULL THEN 1 END) /
       SUM(CASE WHEN contact_year_quarter = 20172 THEN 1 END) * 100, 2) contacted_rate_201702, 
       
       ROUND( SUM(CASE WHEN contact_year_quarter = 20173 AND sr_id IS NOT NULL THEN 1 END) /
       SUM(CASE WHEN contact_year_quarter = 20173 THEN 1 END) * 100, 2) contacted_rate_201703,
       
       ROUND( SUM(CASE WHEN contact_year_quarter = 20174 AND sr_id IS NOT NULL THEN 1 END) /
       SUM(CASE WHEN contact_year_quarter = 20174 THEN 1 END) * 100, 2) contacted_rate_201704,
       
       ROUND( SUM(CASE WHEN contact_year_quarter = 20181 AND sr_id IS NOT NULL THEN 1 END) / 
       SUM(CASE WHEN contact_year_quarter = 20181 THEN 1 END) * 100, 2) contacted_rate_201801,
       
       ROUND( SUM(CASE WHEN contact_year_quarter = 20182 AND sr_id IS NOT NULL THEN 1 END) / 
       SUM(CASE WHEN contact_year_quarter = 20182 THEN 1 END) * 100, 2) contacted_rate_201802,
FROM seller_contacted
GROUP BY origin
ORDER BY total_seller DESC;
