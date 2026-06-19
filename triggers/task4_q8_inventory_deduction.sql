-- task4_q8_inventory_deduction.sql
-- Trigger to automatically deduct inventory after an order item is inserted.

CREATE OR REPLACE FUNCTION trg_deduct_inventory()
RETURNS TRIGGER AS $$
BEGIN
    -- Deduct quantity available from inventory
    -- Assuming a default warehouse_id of 1 for simplicity if not tracked per order_item
    UPDATE inventory
    SET quantity_available = quantity_available - NEW.quantity
    WHERE product_id = NEW.product_id;

    -- Log stock movement
    INSERT INTO stock_movements (product_id, warehouse_id, movement_type, quantity, movement_date)
    SELECT NEW.product_id, warehouse_id, 'stock_out', NEW.quantity, NOW()
    FROM inventory
    WHERE product_id = NEW.product_id
    LIMIT 1;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_after_insert_order_item
AFTER INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION trg_deduct_inventory();
