-- task4_q9_return_inventory_restore.sql
-- Trigger to restore inventory when a return is recorded.

CREATE OR REPLACE FUNCTION trg_restore_inventory_on_return()
RETURNS TRIGGER AS $$
DECLARE
    v_product_id INT;
    v_quantity INT;
BEGIN
    -- Retrieve product_id and quantity from order_items
    SELECT product_id, quantity INTO v_product_id, v_quantity
    FROM order_items
    WHERE order_item_id = NEW.order_item_id;

    -- Restore inventory
    UPDATE inventory
    SET quantity_available = quantity_available + v_quantity
    WHERE product_id = v_product_id;

    -- Log stock movement
    INSERT INTO stock_movements (product_id, warehouse_id, movement_type, quantity, movement_date)
    SELECT v_product_id, warehouse_id, 'returned', v_quantity, NOW()
    FROM inventory
    WHERE product_id = v_product_id
    LIMIT 1;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_after_insert_return
AFTER INSERT ON returns
FOR EACH ROW
EXECUTE FUNCTION trg_restore_inventory_on_return();
