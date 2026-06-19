-- Identify the single best-selling month per seller using RANK() on monthly revenue with PARTITION BY seller_id.

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
RankedMonths AS (
    SELECT 
        seller_id,
        order_month,
        monthly_revenue,
        RANK() OVER(PARTITION BY seller_id ORDER BY monthly_revenue DESC) AS revenue_rank
    FROM 
        MonthlyRevenue
)
SELECT 
    seller_id,
    order_month AS best_selling_month,
    monthly_revenue
FROM 
    RankedMonths
WHERE 
    revenue_rank = 1
ORDER BY 
    seller_id;
