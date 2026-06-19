-- Use a CTE to rank sellers by number of unique customers served, then display the top 10.

WITH SellerCustomerCounts AS (
    -- Count the number of distinct customers each seller has sold to
    SELECT 
        p.seller_id,
        COUNT(DISTINCT o.customer_id) AS unique_customers_served
    FROM 
        products p
    JOIN 
        order_items oi ON p.product_id = oi.product_id
    JOIN 
        orders o ON oi.order_id = o.order_id
    GROUP BY 
        p.seller_id
),
RankedSellers AS (
    -- Assign a rank based on the number of unique customers served
    SELECT 
        seller_id,
        unique_customers_served,
        DENSE_RANK() OVER(ORDER BY unique_customers_served DESC) as seller_rank
    FROM 
        SellerCustomerCounts
)
SELECT 
    rs.seller_rank,
    sp.business_name,
    rs.unique_customers_served
FROM 
    RankedSellers rs
JOIN 
    seller_profiles sp ON rs.seller_id = sp.seller_id
WHERE 
    rs.seller_rank <= 10
ORDER BY 
    rs.seller_rank;
