-- task5_q10_orders_partitioning.sql
-- Apply range partitioning on the orders table by year (e.g. orders_2023, orders_2024) 
-- and verify that queries on a single year use partition pruning

-- 1. Backup the old table
ALTER TABLE orders RENAME TO orders_old;

-- 2. Create the new partitioned table
-- PostgreSQL requires the partition key to be part of the primary key constraint 
-- when enforcing constraints across partitions natively.
CREATE TABLE orders (
    order_id SERIAL,
    customer_id INT REFERENCES customer_profiles(customer_id),
    order_status VARCHAR(50),
    total_amount NUMERIC(10,2),
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    PRIMARY KEY (order_id, created_at)
) PARTITION BY RANGE (created_at);

-- 3. Create partitions by Year
CREATE TABLE orders_2023 PARTITION OF orders
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE orders_2024 PARTITION OF orders
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE orders_2025 PARTITION OF orders
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- 4. Migrate data
INSERT INTO orders (order_id, customer_id, order_status, total_amount, created_at)
SELECT order_id, customer_id, order_status, total_amount, created_at 
FROM orders_old;

-- 5. Verification Query (Partition Pruning demonstration)
-- Run this with EXPLAIN to see partition pruning in action:
-- EXPLAIN SELECT * FROM orders WHERE created_at >= '2024-05-01' AND created_at < '2024-06-01';
-- The output will show that only the 'orders_2024' partition is scanned.
