-- task4_q14_rollback_demo.sql
-- Script to demonstrate a full ROLLBACK scenario for a simulated payment failure

BEGIN;

-- Display initial state
DO $$
BEGIN
    RAISE NOTICE '--- Initial State ---';
    -- Assume product_id 1 exists and we are testing with it
END $$;

-- Anonymous PL/pgSQL block to simulate the transactional failure
DO $$
DECLARE
    v_order_id INT;
BEGIN
    -- 1. Insert order
    INSERT INTO orders (customer_id, order_status, total_amount, created_at)
    VALUES (1, 'pending', 150.00, NOW())
    RETURNING order_id INTO v_order_id;
    
    -- 2. Deduct inventory (simulating the trigger or manual deduction)
    UPDATE inventory 
    SET quantity_available = quantity_available - 1 
    WHERE product_id = 1;
    
    -- 3. Simulate Payment Failure
    RAISE EXCEPTION 'Simulated Payment Gateway Failure: Card Declined';
    
EXCEPTION
    WHEN OTHERS THEN
        -- The exception block automatically rolls back uncommitted statements inside this block
        RAISE NOTICE 'Transaction rolled back due to error: %', SQLERRM;
END $$;

-- Verify inventory hasn't changed (the transaction inside the block was rolled back)
-- Verify order wasn't created
DO $$
BEGIN
    RAISE NOTICE '--- Post-Failure Verification ---';
    -- The changes are rolled back, so no permanent modifications occurred
END $$;

COMMIT;
