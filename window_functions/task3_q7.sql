-- Find sellers whose revenue dropped compared to the previous month using LAG() in a CTE with a WHERE filter.

WITH MonthlyRevenue AS (
    SELECT 
        p.seller_id,
        DATE_TRUNC('month', o.created_at) AS order_month,
        SUM(oi.quantity * oi.unit_price) as monthly_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY 
        p.seller_id, 
        DATE_TRUNC('month', o.created_at)
),
RevenueWithLag AS (
    SELECT 
        seller_id,
        order_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER(PARTITION BY seller_id ORDER BY order_month) AS prev_month_revenue
    FROM 
        MonthlyRevenue
)
SELECT 
    seller_id,
    order_month,
    monthly_revenue,
    prev_month_revenue
FROM 
    RevenueWithLag
WHERE 
    monthly_revenue < prev_month_revenue
ORDER BY 
    seller_id, 
    order_month;
