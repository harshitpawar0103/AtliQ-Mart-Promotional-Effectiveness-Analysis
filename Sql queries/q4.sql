/*Produce a report that calculates the Incremental Sold Quantity (ISU%) for each category during the Diwali campaign. 
Additionally, provide rankings for the categories based on their ISU%. The report include three key fields: category, 
isu%, and rank order. This information will assist in assessing the category-wise success and impact of the Diwali campaign 
on incremental sales.*/

with 
total_qs_bp(category,qs) as (
                             select category,sum(quantity_sold_before_promo) 
                             from fact_events 
                             join dim_products p using(product_code)
							 join dim_campaigns c using(campaign_id)
                             where campaign_name='Diwali' 
							 group by category
                             ),
total_qs_ap(category,qs) as(
                            select category,sum(quantity_sold_after_promo) 
							from fact_events 
							join dim_products p using(product_code)
                            join dim_campaigns c using(campaign_id)
                            where campaign_name='Diwali' 
                            group by category 
                            )
select pd.category,
	   round(
			 ((select qs from total_qs_ap where category=pd.category)-(select qs from total_qs_bp where category=pd.category))
             /(select qs from total_qs_bp where category=pd.category)*100,
			2) as ISU_PCT,
	   rank() over(order by round(
			((select qs from total_qs_ap where category=pd.category)-
			(select qs from total_qs_bp where category=pd.category))/(select qs from total_qs_bp where category=pd.category)*100,
			2) desc) as ranking
from fact_events f
join dim_campaigns camp using(campaign_id)
join dim_products pd using(product_code)
group by pd.category;

