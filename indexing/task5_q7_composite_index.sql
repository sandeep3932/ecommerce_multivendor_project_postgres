-- task5_q7_composite_index.sql
-- Create a composite index to optimize seller dashboard date-range queries.
-- Note: As instructed by requirements, adding index on orders(seller_id, created_at DESC).
-- Ensure that your 'orders' table schema has the 'seller_id' column added prior to running this,
-- or adjust to target customer_id/products if seller_id operates purely on the product relation level.

CREATE INDEX IF NOT EXISTS idx_orders_seller_date ON orders(seller_id, created_at DESC);
