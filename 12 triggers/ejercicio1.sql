CREATE TABLE orders_audit_update (
    audit_id SERIAL PRIMARY KEY,
    order_id_new INT,
	order_id_old INT,
    employee_id_new INT,
	employee_id_old INT,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION ft_audit_update_orders()
RETURNS TRIGGER as $$
BEGIN
	insert into orders_audit_update(order_id_new,order_id_old,
	employee_id_new,employee_id_old)
	values(new.order_id,old.order_id,
	new.employee_id,old.employee_id);
	return new;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER tg_after_update_order
AFTER UPDATE on orders
FOR EACH ROW
EXECUTE FUNCTION ft_audit_update_orders();

select * from orders
where order_id=11078;

select * from orders_audit_update;
select * from orders_audit;

CREATE OR REPLACE TRIGGER tg_after_delete_order
AFTER DELETE on orders
FOR EACH ROW 
EXECUTE FUNCTION ft_audit_update_orders();

select * from orders;
--Insertar un valor, luego lo siguiente

select * from orders
where order_id=11111;

select * from orders_audit_update;