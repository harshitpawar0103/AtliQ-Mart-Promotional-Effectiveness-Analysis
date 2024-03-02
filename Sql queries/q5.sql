/*Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage (IR%), across all 
campaigns. The report will provide essential information including product name, category, and ir%. 
This analysis helps identify the most successful products in terms of incremental revenue across our campaigns,
 assisting in product optimization.*/

select product_code as "Product Code",
product_name as "Product Name",
category,
round( 
       (
		sum(
			if(promo_type='50% OFF',base_price*0.5*f.quantity_sold_after_promo,0)+
			if(promo_type='25% OFF',base_price*0.75*f.quantity_sold_after_promo,0)+
			if(promo_type='BOGOF',base_price*0.5*f.quantity_sold_after_promo,0)+
			if(promo_type='500 Cashback',(base_price-500)*f.quantity_sold_after_promo,0)+
			if(promo_type='33% OFF',base_price*0.67*f.quantity_sold_after_promo,0)
			) 
		- sum(base_price*f.quantity_sold_before_promo) 
		)/sum(base_price*f.quantity_sold_before_promo)*100
	  ,2) as IR_pct
from  fact_events f
join dim_products p using(product_code)
group by product_code
order by ir_pct desc limit 5;