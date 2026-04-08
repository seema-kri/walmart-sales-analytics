CREATE DATABASE walmart_sales_db;
SELECT datname FROM pg_database;

select * from clean_customer limit 5
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT COUNT(*) AS rows FROM clean_sales;
SELECT COUNT(*) AS rows FROM clean_customer;
SELECT COUNT(*) AS rows FROM clean_product;
SELECT COUNT(*) AS rows FROM clean_store;
SELECT COUNT(*) AS rows FROM clean_employee;

-- Quick preview
SELECT * FROM clean_customer LIMIT 5;
SELECT * FROM clean_employee LIMIT 5;
SELECT * FROM clean_product  LIMIT 5;
SELECT * FROM clean_store    LIMIT 5;
SELECT * FROM clean_sales    LIMIT 5;

-- Q1. OVERALL BUSINESS PERFORMANCE (Executive KPI Snapshot)
SELECT
    COUNT(*)   AS total_transactions,
    ROUND(SUM("Total_Price")::numeric, 2)   AS total_revenue,
    ROUND(AVG("Total_Price")::numeric, 2)   AS avg_order_value,
    ROUND(SUM("Quantity")::numeric, 0)  AS total_units_sold,
    ROUND(AVG("Shipping_Cost")::numeric, 2)  AS avg_shipping_cost,
    COUNT(DISTINCT "Customer_ID")  AS unique_customers,
    COUNT(DISTINCT "Product_ID")  AS unique_products,
    MIN("Sale_Date"::date)  AS first_sale_date,
    MAX("Sale_Date"::date) AS last_sale_date
FROM clean_sales;

-- Q2: Monthly Revenue Trend with MoM Growth
WITH monthly_rev AS (
    SELECT
        EXTRACT(YEAR FROM "Sale_Date"::date) AS year,
        EXTRACT(MONTH FROM "Sale_Date"::date) AS month,
        TO_CHAR("Sale_Date"::date, 'Mon') AS month_name,
        ROUND(SUM("Total_Price")::numeric, 2) AS revenue,
        COUNT(*) AS transactions
    FROM clean_sales
    GROUP BY year, month, month_name
)

SELECT
    year,
    month,
    month_name,
    revenue,
    transactions,
    ROUND(
        ((revenue - LAG(revenue) OVER (ORDER BY year, month))
         / LAG(revenue) OVER (ORDER BY year, month) * 100)::numeric, 2
    ) AS mom_growth_pct
FROM monthly_rev
ORDER BY year, month;


-- Q3: Cumulative Revenue by Month (Running Total)
WITH monthly_rev AS (
    SELECT
        EXTRACT(YEAR  FROM "Sale_Date"::date) AS year,
        EXTRACT(MONTH FROM "Sale_Date"::date) AS month,
        TO_CHAR("Sale_Date"::date, 'Mon') AS month_name,
        ROUND(SUM("Total_Price")::numeric, 2) AS revenue
    FROM clean_sales
    GROUP BY year, month, month_name
)

SELECT
    year,
    month,
    month_name,
    revenue,
    ROUND(SUM(revenue) OVER (ORDER BY year, month)::numeric, 2) AS cumulative_revenue
FROM monthly_rev
ORDER BY year, month;


--Q4. STORE TYPE AND REGION REVENUE PERFORMANCE
SELECT
    st."Region",
    st."Store_Type",
    COUNT(s."Sale_ID") AS transactions,
    ROUND(SUM(s."Total_Price")::numeric, 2) AS total_revenue,
    ROUND(AVG(s."Total_Price")::numeric, 2) AS avg_order_value,
    ROUND(
        (SUM(s."Total_Price") * 100.0 / SUM(SUM(s."Total_Price")) OVER ())::numeric, 2
    ) AS revenue_share_pct,
    RANK() OVER (ORDER BY SUM(s."Total_Price") DESC) AS revenue_rank
FROM clean_sales s
JOIN clean_store st ON s."Store_ID" = st."Store_ID"
GROUP BY st."Region", st."Store_Type"
ORDER BY total_revenue DESC;


-- Q5: Product Category and Sub-Category Performance
WITH cat_summary AS (
    SELECT
        p."Category",
        p."Sub_Category",
        COUNT(s."Sale_ID") AS transactions,
        SUM(s."Quantity") AS units_sold,
        ROUND(SUM(s."Total_Price")::numeric, 2) AS revenue,
        ROUND(AVG(s."Unit_Price")::numeric, 2) AS avg_unit_price,
        ROUND(AVG(s."Total_Price")::numeric, 2) AS avg_order_value
    FROM clean_sales s
    JOIN clean_product p ON s."Product_ID" = p."Product_ID"
    GROUP BY p."Category", p."Sub_Category"
)
SELECT
    *,
    RANK() OVER (PARTITION BY "Category" ORDER BY revenue DESC) AS rank_in_category,
    ROUND(
        (revenue * 100.0 / SUM(revenue) OVER (PARTITION BY "Category"))::numeric, 2
    ) AS pct_of_category
FROM cat_summary
ORDER BY "Category", rank_in_category;

-- Q6: Top Customers by Lifetime Value (LTV)
-- For CRM team building VIP loyalty program

WITH customer_ltv AS (
    SELECT
        s."Customer_ID",
        c."Customer_Name",
        c."Segment",
        COUNT(s."Sale_ID") AS total_orders,
        ROUND(SUM(s."Total_Price")::numeric, 2) AS lifetime_value,
        ROUND(AVG(s."Total_Price")::numeric, 2) AS avg_order_value,
        ROUND(SUM(s."Quantity")::numeric, 0) AS total_units
    FROM clean_sales s
    JOIN clean_customer c ON s."Customer_ID" = c."Customer_ID"
    GROUP BY s."Customer_ID", c."Customer_Name", c."Segment"
)
SELECT
    *,
    RANK() OVER (ORDER BY lifetime_value DESC) AS ltv_rank,
    RANK() OVER (PARTITION BY "Segment" ORDER BY lifetime_value DESC) AS rank_in_segment
FROM customer_ltv
ORDER BY lifetime_value DESC;

-- Q7: Customer Segment Summary
-- Marketing team comparing segment profitability

SELECT
    c."Segment",
    COUNT(DISTINCT s."Customer_ID") AS unique_customers,
    COUNT(s."Sale_ID") AS total_orders,
    ROUND(SUM(s."Total_Price")::numeric, 2) AS total_revenue,
    ROUND(AVG(s."Total_Price")::numeric, 2) AS avg_order_value,
    ROUND(SUM(s."Total_Price")::numeric / COUNT(DISTINCT s."Customer_ID"), 2) AS revenue_per_customer,
    ROUND(COUNT(s."Sale_ID")::numeric / COUNT(DISTINCT s."Customer_ID"), 1) AS orders_per_customer
FROM clean_sales s
JOIN clean_customer c ON s."Customer_ID" = c."Customer_ID"
GROUP BY c."Segment"
ORDER BY revenue_per_customer DESC;


-- Q8: Year-over-Year Revenue Growth by Category
-- Strategy team spotting category trends

WITH yearly_cat AS (
    SELECT
        EXTRACT(YEAR FROM "Sale_Date"::date) AS year,
        p."Category",
        ROUND(SUM("Total_Price")::numeric, 2) AS revenue
    FROM clean_sales s
    JOIN clean_product p ON s."Product_ID" = p."Product_ID"
    GROUP BY year, p."Category"
)

SELECT
    *,
    LAG(revenue) OVER (PARTITION BY "Category" ORDER BY year) AS prev_year_revenue,
    ROUND(
        ((revenue - LAG(revenue) OVER (PARTITION BY "Category" ORDER BY year))
        / LAG(revenue) OVER (PARTITION BY "Category" ORDER BY year) * 100)::numeric, 2
    ) AS yoy_growth_pct
FROM yearly_cat
ORDER BY "Category", year;


--Q9: Overall Yearly Revenue Growth
WITH yearly AS (
    SELECT
        EXTRACT(YEAR FROM "Sale_Date"::date) AS year,
        ROUND(SUM("Total_Price")::numeric, 2) AS revenue
    FROM clean_sales
    GROUP BY year
)
SELECT
    *,
    LAG(revenue) OVER (ORDER BY year) AS prev_year_revenue,
    ROUND(((revenue - LAG(revenue) OVER (ORDER BY year))
           / LAG(revenue) OVER (ORDER BY year) * 100)::numeric, 2) AS yoy_growth_pct,
    ROUND(SUM(revenue) OVER (ORDER BY year)::numeric, 2) AS cumulative_revenue
FROM yearly
ORDER BY year;

--Q10: Employee & Department Performance
WITH emp_summary AS (
    SELECT
        e."Employee_ID",
        e."Employee_Name",
        e."Department",
        COUNT(s."Sale_ID") AS total_transactions,
        ROUND(SUM(s."Total_Price")::numeric, 2) AS total_revenue,
        ROUND(AVG(s."Total_Price")::numeric, 2) AS avg_sale_value
    FROM clean_sales s
    JOIN clean_employee e ON s."Employee_ID" = e."Employee_ID"
    GROUP BY e."Employee_ID", e."Employee_Name", e."Department"
)
SELECT
    *,
    RANK() OVER (ORDER BY total_revenue DESC) AS overall_rank,
    RANK() OVER (PARTITION BY "Department" ORDER BY total_revenue DESC) AS dept_rank,
    ROUND(total_revenue * 100.0 / SUM(total_revenue) OVER ()::numeric, 2) AS revenue_share_pct
FROM emp_summary
ORDER BY total_revenue DESC;

--Q11: Department Summary
SELECT
    e."Department",
    COUNT(DISTINCT e."Employee_ID") AS headcount,
    COUNT(s."Sale_ID") AS total_transactions,
    ROUND(SUM(s."Total_Price")::numeric, 2) AS total_revenue,
    ROUND(SUM(s."Total_Price")::numeric / COUNT(DISTINCT e."Employee_ID"), 2) AS revenue_per_employee
FROM clean_sales s
JOIN clean_employee e ON s."Employee_ID" = e."Employee_ID"
GROUP BY e."Department"
ORDER BY total_revenue DESC;

--Q12: Payment Method & Shipping Cost

SELECT
    "Payment_Method",
    COUNT(*) AS transactions,
    ROUND(AVG("Total_Price")::numeric, 2) AS avg_order_value,
    ROUND(AVG("Shipping_Cost")::numeric, 2) AS avg_shipping_cost,
    ROUND(SUM("Total_Price")::numeric, 2) AS total_revenue,
    ROUND(SUM("Shipping_Cost")::numeric, 2) AS total_shipping_cost,
    ROUND((SUM("Shipping_Cost") * 100.0 / SUM("Total_Price"))::numeric, 2) AS shipping_pct_of_revenue,
    ROUND(COUNT(*)::numeric / SUM(COUNT(*)) OVER () * 100, 2) AS transaction_share_pct
FROM clean_sales
GROUP BY "Payment_Method"
ORDER BY total_revenue DESC;

--Q13: Top 10 Products by Revenue
SELECT
    p."Product_ID",
    p."Product_Name",
    p."Category",
    p."Sub_Category",
    COUNT(s."Sale_ID") AS transactions,
    ROUND(SUM(s."Total_Price")::numeric, 2) AS total_revenue,
    ROUND(AVG(s."Unit_Price")::numeric, 2) AS avg_unit_price,
    RANK() OVER (ORDER BY SUM(s."Total_Price") DESC) AS revenue_rank
FROM clean_sales s
JOIN clean_product p ON s."Product_ID" = p."Product_ID"
GROUP BY p."Product_ID", p."Product_Name", p."Category", p."Sub_Category"
ORDER BY revenue_rank
LIMIT 10;

--Q14: Day of Week Revenue Pattern
SELECT
    TO_CHAR("Sale_Date"::date, 'Day') AS day_of_week,
    EXTRACT(DOW FROM "Sale_Date"::date) AS day_number,
    COUNT(*) AS transactions,
    ROUND(SUM("Total_Price")::numeric, 2) AS total_revenue,
    ROUND(AVG("Total_Price")::numeric, 2) AS avg_order_value
FROM clean_sales
GROUP BY day_of_week, day_number
ORDER BY day_number;


-- Q15: Quarterly Revenue Breakdown
SELECT
    EXTRACT(YEAR FROM "Sale_Date"::date) AS year,
    EXTRACT(QUARTER FROM "Sale_Date"::date) AS quarter,
    COUNT(*) AS transactions,
    ROUND(SUM("Total_Price")::numeric, 2) AS revenue,
    ROUND(AVG("Total_Price")::numeric, 2) AS avg_order_value,
    ROUND(
        (SUM("Total_Price") * 100.0
         / SUM(SUM("Total_Price")) OVER (PARTITION BY EXTRACT(YEAR FROM "Sale_Date"::date)))::numeric, 2
    ) AS pct_of_annual_revenue
FROM clean_sales
GROUP BY year, quarter
ORDER BY year, quarter;