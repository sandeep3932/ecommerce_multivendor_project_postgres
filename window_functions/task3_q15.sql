-- List products whose sales rank improved from last month to this month by comparing two LAG() results.

WITH MonthlyProductRevenue AS (
    SELECT 
        p.product_id,
        p.product_name,
        DATE_TRUNC('month', o.created_at) AS order_month,
        SUM(oi.quantity * oi.unit_price) AS monthly_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY 
        p.product_id, 
        p.product_name, 
        DATE_TRUNC('month', o.created_at)
),
MonthlyRanks AS (
    SELECT 
        product_id,
        product_name,
        order_month,
        monthly_revenue,
        RANK() OVER(PARTITION BY order_month ORDER BY monthly_revenue DESC) AS current_rank
    FROM 
        MonthlyProductRevenue
),
RankChanges AS (
    SELECT 
        product_id,
        product_name,
        order_month,
        current_rank,
        LAG(current_rank) OVER(PARTITION BY product_id ORDER BY order_month) AS prev_month_rank
    FROM 
        MonthlyRanks
)
SELECT 
    product_id,
    product_name,
    order_month,
    prev_month_rank,
    current_rank
FROM 
    RankChanges
WHERE 
    prev_month_rank > current_rank  -- A higher number means a worse rank, so prev > current indicates improvement
ORDER BY 
    order_month DESC, 
    current_rank ASC;
