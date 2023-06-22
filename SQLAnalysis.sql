select * from customers LIMIT 10 ;

select * from date limit 10 ;

select * from markets limit 10 ;

select * from products limit 10 ;

select * from transactions limit 10;

select distinct currency from transactions ;

alter table transactions rename column profit_margin to profit;
alter table transactions rename column profit_margin_percentage to profit_percentage;

select distinct market_code from transactions;

/* Total Revenue */


select sum(case when currency ='USD' then sales_amount*83 else sales_amount end ) as TotalReveune from transactions;

/* Total Revenue per Market */
with my_CTE as ( select T.market_code, T.order_date, case when currency = 'INR' then sales_amount
when currency = 'USD' then sales_amount*82 end as normalisedrevenue
from transactions T) 
select M.markets_name, sum(C.normalisedrevenue) TotalSalesPerMarket
from Markets M, my_cte C
where C.market_code = M.markets_code
group by M.markets_name
order by TotalSalesPerMarket desc;

/* Total Sales per Market  */

select M.markets_name, sum(T.sales_qty)
from Markets M, transactions t
where M.markets_code = T.market_code
group by M.markets_name;

/* Total Profit*/
select sum(case when currency = 'USD' then profit*83 else profit end) as TotalProfit from transactions where currency = 'USD';

/* Total Profit per Market */

with my_CTE as ( select T.market_code, T.order_date, case when currency = 'INR' then profit
when currency = 'USD' then profit*82 end as normalisedprofit
from transactions T) 
select M.markets_name, sum(C.normalisedprofit) TotalProfitPerMarket
from Markets M, my_cte C
where C.market_code = M.markets_code
group by M.markets_name
order by TotalProfitPerMarket desc;


/* Profit Share per Customer Type i.e. Brick&Mortar and Ecommerce */

with 
 my_cte1 as ( select customer_type, sum(profit) as profitshare
from Customers C, transactions T
where C.customer_code = T.customer_code
group by customer_type),
 my_cte2 as ( select sum(profit) as totalprofit from transactions)
select c1.customer_type, profitshare/totalprofit as ProfitPercentage
from my_cte1 C1, my_cte2 ;

/* profit per Customers per year per Market*/

with cte as ( select M.markets_name, year(T.order_date) as ordyear, C.customer_code, case when currency = 'INR' then sales_amount
when currency = 'USD' then sales_amount*82 end as normalisedrevenue
from 
transactions T, customers C , Markets M
where T.customer_code = C.customer_code and T.market_code = M.markets_code ) 
select  markets_name, ordyear, customer_code, sum(normalisedrevenue) as TotalSales
from cte
group by markets_name, ordyear, customer_code
order by TotalSales desc ;

/* Profit per product */ 
select product_code, sum(profit) as ProfitPerProduct from 
(select product_code, (case when currency = 'USD' then profit*83 else profit end) as profit
from transactions ) T
group by product_code
order by ProfitPerProduct desc;


select * from products limit 5;