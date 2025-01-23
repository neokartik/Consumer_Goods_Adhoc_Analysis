-- 1.  Provide the list of markets in which customer  "Atliq  Exclusive"  operates its 
-- business in the  APAC  region. 

SELECT DISTINCT
    market
FROM
    dim_customer
WHERE
    customer = 'Atliq Exclusive'
        AND region = 'APAC';

-- 2.  What is the percentage of unique product increase in 2021 vs. 2020? The 
-- final output contains these fields, 
-- unique_products_2020 
-- unique_products_2021 
-- percentage_chg

WITH a AS (
    SELECT COUNT(DISTINCT product_code) AS products_2020
    FROM fact_sales_monthly
    WHERE fiscal_year = 2020
),
b AS (
    SELECT COUNT(DISTINCT product_code) AS products_2021
    FROM fact_sales_monthly
    WHERE fiscal_year = 2021
)
SELECT 
    a.products_2020,
    b.products_2021,
    ROUND((b.products_2021 - a.products_2020) * 100.0 / a.products_2020, 2) AS percentage_chg
FROM a, b;

-- 3.  Provide a report with all the unique product counts for each  segment  and 
-- sort them in descending order of product counts. The final output contains 
-- 2 fields, 
-- segment 
-- product_count 

SELECT 
    segment, COUNT(DISTINCT product_code) AS product_count
FROM
    dim_product
GROUP BY segment
ORDER BY product_count DESC;

-- 4.  Follow-up: Which segment had the most increase in unique products in 
-- 2021 vs 2020? The final output contains these fields, 
-- segment 
-- product_count_2020 
-- product_count_2021 
-- difference 

WITH cte1 as (select
p.segment,
count(distinct p.product_code) as product_count_2020
from dim_product p
join fact_sales_monthly f
on p.product_code = f.product_code
where fiscal_year = 2020
group by p.segment
order by product_count_2020 desc),
cte2 as (select
p.segment,
count(distinct p.product_code) as product_count_2021
from dim_product p
join fact_sales_monthly f
on p.product_code = f.product_code
where fiscal_year = 2021
group by p.segment
order by product_count_2021 desc)
 
select
cte1.segment,
cte1.product_count_2020,
cte2.product_count_2021,
((cte2.product_count_2021)-(cte1.product_count_2020)) as difference

from cte1, cte2
where cte1.segment = cte2.segment
group by cte1.segment
order by difference desc;

-- 5.  Get the products that have the highest and lowest manufacturing costs. 
-- The final output should contain these fields, 
-- product_code 
-- product 
-- manufacturing_cost
WITH cte1 AS (
    SELECT 
        d.product_code,
        d.product,
        ROUND(m.manufacturing_cost, 2) AS manufacturing_cost
    FROM dim_product d
    JOIN fact_manufacturing_cost m
        ON m.product_code = d.product_code
    WHERE m.manufacturing_cost = (
        SELECT MAX(manufacturing_cost) FROM fact_manufacturing_cost
    )
),
cte2 AS (
    SELECT 
        d.product_code,
        d.product,
        ROUND(m.manufacturing_cost, 2) AS manufacturing_cost
    FROM dim_product d
    JOIN fact_manufacturing_cost m
        ON m.product_code = d.product_code
    WHERE m.manufacturing_cost = (
        SELECT MIN(manufacturing_cost) FROM fact_manufacturing_cost
    )
)

SELECT cte1.product_code,
       cte1.product,
       cte1.manufacturing_cost
FROM cte1
UNION
SELECT cte2.product_code,
       cte2.product,
       cte2.manufacturing_cost
FROM cte2;

-- 6.  Generate a report which contains the top 5 customers who received an 
-- average high  pre_invoice_discount_pct  for the  fiscal  year 2021  and in the 
-- Indian  market. The final output contains these fields, 
-- customer_code 
-- customer 
-- average_discount_percentage
SELECT 
    d.customer_code,
    d.customer,
    ROUND(AVG(f.pre_invoice_discount_pct) * 100, 2) AS average_discount_percentage
FROM dim_customer d
JOIN fact_pre_invoice_deductions f
    ON d.customer_code = f.customer_code
WHERE f.fiscal_year = 2021
  AND d.market = 'India'
GROUP BY d.customer_code, d.customer
ORDER BY average_discount_percentage DESC
LIMIT 5;

-- 7.  Get the complete report of the Gross sales amount for the customer  “Atliq 
-- Exclusive”  for each month  .  This analysis helps to  get an idea of low and 
-- high-performing months and take strategic decisions. 
-- The final report contains these columns: 
-- Month 
-- Year 
-- Gross sales Amount 

WITH cte1 AS (
    SELECT 
        MONTHNAME(s.date) AS Month,
        s.fiscal_year AS Fiscal_year,
        s.customer_code,
        s.sold_quantity,
        g.gross_price
    FROM fact_sales_monthly s
    JOIN fact_gross_price g
        ON s.product_code = g.product_code
        AND s.fiscal_year = g.fiscal_year
    JOIN dim_customer c
        ON c.customer_code = s.customer_code
    WHERE c.customer = 'Atliq Exclusive'
)

SELECT 
    Month,
    Fiscal_year,
    ROUND(SUM(sold_quantity * gross_price)) AS Gross_Sales_Amount
FROM cte1
GROUP BY Month, Fiscal_year
ORDER BY Fiscal_year;

-- 8.  In which quarter of 2020, got the maximum total_sold_quantity? The final 
-- output contains these fields sorted by the total_sold_quantity, 
-- Quarter 
-- total_sold_quantity 
WITH cte1 AS (
    SELECT 
        MONTH(date) AS month_no, 
        SUM(sold_quantity) AS Total_Sold_Quantity 
    FROM fact_sales_monthly
    WHERE fiscal_year = 2020
    GROUP BY MONTH(date)
    ORDER BY month_no
)
SELECT 
    CASE 
        WHEN month_no IN (9,10,11) THEN 'Q1'
        WHEN month_no IN (12,1,2) THEN 'Q2'
        WHEN month_no IN (3,4,5) THEN 'Q3'
        WHEN month_no IN (6,7,8) THEN 'Q4'
    END AS quarter,
    SUM(Total_Sold_Quantity) AS sold_qty
FROM cte1
GROUP BY quarter
ORDER BY sold_qty DESC;

-- 9.  Which channel helped to bring more gross sales in the fiscal year 2021 
-- and the percentage of contribution?  The final output  contains these fields, 
-- channel 
-- gross_sales_mln 
-- percentage

WITH cte1 AS (
    SELECT 
        c.channel,
        ROUND(SUM(s.sold_quantity * g.gross_price) / 1000000, 2) AS gross_sales_mln
    FROM fact_sales_monthly s
    JOIN fact_gross_price g
        ON s.product_code = g.product_code
        AND s.fiscal_year = g.fiscal_year
    JOIN dim_customer c
        ON c.customer_code = s.customer_code
    WHERE s.fiscal_year = 2021
    GROUP BY c.channel
)

SELECT 
    channel,
    gross_sales_mln,
    ROUND(gross_sales_mln * 100 / SUM(gross_sales_mln) OVER(), 2) AS percentage_contribution
FROM cte1
ORDER BY percentage_contribution DESC;

-- 10.  Get the Top 3 products in each division that have a high 
-- total_sold_quantity in the fiscal_year 2021? The final output contains these 
-- fields, 
-- division 
-- product_code 
-- product 
-- total_sold_quantity 
-- rank_order 

WITH cte1 AS ( 
    SELECT 
        p.division,
        p.product_code,
        p.product,
        SUM(s.sold_quantity) AS total_sold_quantity
    FROM dim_product p
    JOIN fact_sales_monthly s
        ON p.product_code = s.product_code
    WHERE s.fiscal_year = 2021
    GROUP BY 
        p.division, 
        p.product, 
        p.product_code
    ORDER BY total_sold_quantity DESC
),

cte2 AS (
    SELECT 
        *,
        DENSE_RANK() OVER (PARTITION BY division ORDER BY total_sold_quantity DESC) AS rank_order
    FROM cte1
)

SELECT * 
FROM cte2 
WHERE rank_order <= 3;




