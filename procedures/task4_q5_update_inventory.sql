-- task4_q5_update_inventory.sql
-- Safely adjust inventory quantity and log movement.

CREATE OR REPLACE PROCEDURE update_inventory(
    p_product_id INT,
    p_warehouse_id INT,
    p_quantity_change INT,
    p_movement_type VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_stock INT;
BEGIN
    SELECT quantity_available INTO v_current_stock
    FROM inventory
    WHERE product_id = p_product_id AND warehouse_id = p_warehouse_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Inventory record not found for product % and warehouse %', p_product_id, p_warehouse_id;
    END IF;

    IF v_current_stock + p_quantity_change < 0 THEN
        RAISE EXCEPTION 'Inventory cannot go negative. Current: %, Requested Change: %', v_current_stock, p_quantity_change;
    END IF;

    UPDATE inventory
    SET quantity_available = quantity_available + p_quantity_change
    WHERE product_id = p_product_id AND warehouse_id = p_warehouse_id;

    INSERT INTO stock_movements (product_id, warehouse_id, movement_type, quantity, movement_date)
    VALUES (p_product_id, p_warehouse_id, p_movement_type, ABS(p_quantity_change), NOW());

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;
