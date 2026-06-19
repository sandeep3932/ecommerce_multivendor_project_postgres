-- Calculate each order item's contribution as a percentage of the order's total using SUM() OVER(PARTITION BY order_id).

SELECT 
    order_id,
    order_item_id,
    product_id,
    (quantity * unit_price) AS item_total,
    SUM(quantity * unit_price) OVER(PARTITION BY order_id) AS order_total,
    ROUND(((quantity * unit_price) / SUM(quantity * unit_price) OVER(PARTITION BY order_id)) * 100, 2) AS contribution_percentage
FROM 
    order_items
ORDER BY 
    order_id, 
    order_item_id;
