
WITH mql AS (
    SELECT mql_id, landing_page_id, origin, 
           CAST(CONCAT(EXTRACT(YEAR FROM first_contact_date),
                  EXTRACT(QUARTER FROM first_contact_date)) AS int64) contact_year_quarter
    FROM ecommerce_by_olist.olist_marketing_qualified_leads_dataset
)
-- SELECT * FROM mql;

SELECT origin,
       COUNT(mql_id) total,
       SUM(CASE WHEN contact_year_quarter = 20172 THEN 1 END) yq_201702, 
       SUM(CASE WHEN contact_year_quarter = 20173 THEN 1 END) yq_201703, 
       SUM(CASE WHEN contact_year_quarter = 20174 THEN 1 END) yq_201704, 
       SUM(CASE WHEN contact_year_quarter = 20181 THEN 1 END) yq_201801, 
       SUM(CASE WHEN contact_year_quarter = 20182 THEN 1 END) yq_201802
FROM mql
GROUP BY origin
ORDER BY total DESC;