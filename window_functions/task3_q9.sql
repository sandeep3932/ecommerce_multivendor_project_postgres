-- Rank customers by total lifetime spend using DENSE_RANK() — handle ties without gaps in ranking.

WITH CustomerSpend AS (
    SELECT 
        customer_id,
        SUM(total_amount) as lifetime_spend
    FROM 
        orders
    GROUP BY 
        customer_id
)
SELECT 
    customer_id,
    lifetime_spend,
    DENSE_RANK() OVER(ORDER BY lifetime_spend DESC) as spend_rank
FROM 
    CustomerSpend
ORDER BY 
    spend_rank;
