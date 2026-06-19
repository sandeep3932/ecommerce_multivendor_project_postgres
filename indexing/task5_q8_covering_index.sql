-- task5_q8_covering_index.sql
-- Create a covering index on order_items to enable index-only scans.

CREATE INDEX IF NOT EXISTS idx_order_items_covering 
ON order_items(order_id) INCLUDE (product_id, quantity, unit_price);
