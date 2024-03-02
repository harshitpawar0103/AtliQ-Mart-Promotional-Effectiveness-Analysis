/*Generate a report that displays each campaign along with the total revenue generated before and after 
the campaign? The report includes three key fields: campaign_name, total_revenue(before_promotion), 
total_revenue(after_promotion). This report should help in evaluating the financial impact of our promotional
 campaigns. (Display the values in millions)*/

ALTER TABLE fact_events
RENAME COLUMN `quantity_sold(before_promo)` TO quantity_sold_before_promo,
RENAME COLUMN `quantity_sold(after_promo)` TO quantity_sold_after_promo;


select campaign_name as "Campaign",
concat(round(
		sum(base_price*f.quantity_sold_before_promo)/1000000,
        2)," M" ) as Total_Revenue_BP,
concat(
		round(
				sum(
					if(promo_type='50% OFF',base_price*0.5*f.quantity_sold_after_promo,0)+
					if(promo_type='25% OFF',base_price*0.75*f.quantity_sold_after_promo,0)+
					if(promo_type='BOGOF',base_price*0.5*f.quantity_sold_after_promo,0)+
					if(promo_type='500 Cashback',(base_price-500)*f.quantity_sold_after_promo,0)+
					if(promo_type='33% OFF',base_price*0.67*f.quantity_sold_after_promo,0)
					)/1000000,
			  2),
	  " M") as Total_Revenue_AP
from dim_campaigns c
join fact_events f using (campaign_id)
group by campaign_name;

