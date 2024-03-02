/*Provide a list of products with a base price greater than 500 and that are featured in promo type
 of 'BOGOF' (Buy One Get One Free). This information will help us identify high-value products that are
 currently being heavily discounted, which can be useful for  evaluating our pricing and promotion strategies.*/
 
 
select distinct product_name as "Product Name"
from fact_events f
join dim_products p using (product_code)
where base_price>500 and promo_type="BOGOF";