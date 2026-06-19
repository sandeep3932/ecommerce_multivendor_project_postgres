-- task4_q10_cancel_order_restore.sql
-- Trigger to restore inventory when an order status changes to 'cancelled'.

CREATE OR REPLACE FUNCTION trg_restore_inventory_on_cancel()
RETURNS TRIGGER AS $$
DECLARE
    v_item RECORD;
BEGIN
    IF NEW.order_status = 'cancelled' AND OLD.order_status != 'cancelled' THEN
        FOR v_item IN SELECT product_id, quantity FROM order_items WHERE order_id = NEW.order_id LOOP
            -- Restore inventory
            UPDATE inventory
            SET quantity_available = quantity_available + v_item.quantity
            WHERE product_id = v_item.product_id;

            -- Log movement
            INSERT INTO stock_movements (product_id, warehouse_id, movement_type, quantity, movement_date)
            SELECT v_item.product_id, warehouse_id, 'restored_cancellation', v_item.quantity, NOW()
            FROM inventory
            WHERE product_id = v_item.product_id
            LIMIT 1;
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_after_update_order_cancel
AFTER UPDATE OF order_status ON orders
FOR EACH ROW
EXECUTE FUNCTION trg_restore_inventory_on_cancel();
