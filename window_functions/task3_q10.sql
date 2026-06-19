-- Use NTILE(4) to split all products into four revenue quartiles and display the quartile for each product.

WITH ProductRevenue AS (
    SELECT 
        p.product_id,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM 
        products p
    LEFT JOIN 
        order_items oi ON p.product_id = oi.product_id
    GROUP BY 
        p.product_id, 
        p.product_name
)
SELECT 
    product_id,
    product_name,
    COALESCE(total_revenue, 0) AS total_revenue,
    NTILE(4) OVER(ORDER BY COALESCE(total_revenue, 0) DESC) AS revenue_quartile
FROM 
    ProductRevenue
ORDER BY 
    revenue_quartile, 
    total_revenue DESC;
