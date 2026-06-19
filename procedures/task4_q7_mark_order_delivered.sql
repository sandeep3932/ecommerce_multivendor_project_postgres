-- task4_q7_mark_order_delivered.sql
-- Mark order as delivered and dynamically handle delivered_at timestamp.

CREATE OR REPLACE PROCEDURE mark_order_delivered(
    p_order_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM orders WHERE order_id = p_order_id) THEN
        RAISE EXCEPTION 'Order % not found', p_order_id;
    END IF;

    UPDATE orders 
    SET order_status = 'delivered'
    WHERE order_id = p_order_id;
    
    -- Dynamically set delivered_at if column exists
    BEGIN
        EXECUTE 'UPDATE orders SET delivered_at = NOW() WHERE order_id = $1' USING p_order_id;
    EXCEPTION
        WHEN undefined_column THEN
            NULL; -- Ignore if missing
    END;

    -- Generate invoice
    INSERT INTO invoices (order_id, invoice_date, total_amount)
    SELECT order_id, CURRENT_DATE, total_amount
    FROM orders 
    WHERE order_id = p_order_id
    ON CONFLICT DO NOTHING;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;
