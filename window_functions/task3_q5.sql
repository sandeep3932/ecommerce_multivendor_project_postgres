-- Compute month-over-month revenue change per seller using LAG() partitioned by seller_id.

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
)
SELECT 
    seller_id,
    order_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER(PARTITION BY seller_id ORDER BY order_month) AS prev_month_revenue,
    monthly_revenue - LAG(monthly_revenue) OVER(PARTITION BY seller_id ORDER BY order_month) AS revenue_change
FROM 
    MonthlyRevenue
ORDER BY 
    seller_id, 
    order_month;
