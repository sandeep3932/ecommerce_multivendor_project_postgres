-- task5_q6_foreign_key_indexes.sql
-- Add B-Tree indexes on all foreign key columns across major tables to speed up joins.

-- Indexes for orders
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);

-- Indexes for order_items
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

-- Indexes for payments
CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);

-- Indexes for inventory
CREATE INDEX IF NOT EXISTS idx_inventory_product_id ON inventory(product_id);
CREATE INDEX IF NOT EXISTS idx_inventory_warehouse_id ON inventory(warehouse_id);
