# 📘 Clase: Triggers en PostgreSQL con la base de datos Northwind

## 🎯 Objetivo de la clase
Al finalizar esta clase, el estudiante será capaz de:
- Comprender qué es un *trigger* (disparador) y cuándo usarlo.  
- Crear, modificar y eliminar *triggers* en PostgreSQL.  
- Aplicar triggers a tablas reales de la base de datos **Northwind**, como `orders`, `order_details` y `products`.

---

## 🧠 1. ¿Qué es un Trigger?

Un **trigger** (o disparador) es un mecanismo que permite ejecutar una acción **automáticamente** cuando ocurre un evento en una tabla o vista, como:
- Una **inserción (INSERT)**  
- Una **actualización (UPDATE)**  
- Una **eliminación (DELETE)**

👉 En resumen:  
> Un *trigger* vigila una tabla y actúa por sí mismo cuando se cumple una condición específica.

---

## 🧩 2. Sintaxis general de un Trigger en PostgreSQL

```sql
CREATE TRIGGER nombre_del_trigger
{ BEFORE | AFTER | INSTEAD OF } { INSERT | UPDATE | DELETE | TRUNCATE }
ON nombre_tabla
[ FOR EACH ROW | FOR EACH STATEMENT ]
EXECUTE FUNCTION nombre_funcion();
```

🔹 **BEFORE / AFTER** → Define si el trigger se ejecuta **antes** o **después** del evento.  
🔹 **FOR EACH ROW** → Ejecuta el trigger una vez por cada fila afectada.  
🔹 **FOR EACH STATEMENT** → Ejecuta el trigger una sola vez por instrucción SQL.  
🔹 **EXECUTE FUNCTION** → Es la función PL/pgSQL que contiene la lógica.

---

## 🧮 3. Ejemplo práctico 1: Registrar auditoría de pedidos

### 📄 Escenario
Cada vez que se inserte un nuevo pedido (`orders`), queremos guardar automáticamente un registro de auditoría en una tabla `orders_audit` con:
- el `order_id`,  
- el `employee_id`,  
- la fecha y hora de inserción.

### 🧰 Paso 1. Crear la tabla de auditoría

```sql
CREATE TABLE orders_audit (
    audit_id SERIAL PRIMARY KEY,
    order_id INT,
    employee_id INT,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 🧰 Paso 2. Crear la función del trigger

```sql
CREATE OR REPLACE FUNCTION fn_audit_new_order()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO orders_audit (order_id, employee_id)
    VALUES (NEW.order_id, NEW.employee_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### 🧰 Paso 3. Crear el trigger

```sql
CREATE TRIGGER trg_audit_new_order
AFTER INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION fn_audit_new_order();
```

✅ Prueba:
```sql
INSERT INTO orders (order_id, customer_id, employee_id, order_date)
VALUES (11078, 'ALFKI', 5, NOW());
```

---

## 🧮 4. Ejemplo práctico 2: Actualizar stock de productos

### 📄 Escenario
Cuando se inserta un registro en `order_details`, queremos que el campo `units_in_stock` de `products` se reduzca según la cantidad del pedido.

### 🧰 Paso 1. Crear la función

```sql
CREATE OR REPLACE FUNCTION fn_update_stock()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE products
    SET units_in_stock = units_in_stock - NEW.quantity
    WHERE product_id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### 🧰 Paso 2. Crear el trigger

```sql
CREATE TRIGGER trg_update_stock
AFTER INSERT ON order_details
FOR EACH ROW
EXECUTE FUNCTION fn_update_stock();
```

✅ Prueba:
```sql
INSERT INTO order_details (order_id, product_id, unit_price, quantity, discount)
VALUES (11078, 1, 18.00, 5, 0);
```

---

## 🧮 5. Ejemplo práctico 3: Evitar eliminación de productos con stock

### 📄 Escenario
Queremos **evitar** que se eliminen productos que todavía tienen unidades en inventario (`units_in_stock > 0`).

### 🧰 Paso 1. Crear la función

```sql
CREATE OR REPLACE FUNCTION fn_prevent_delete_products()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.units_in_stock > 0 THEN
        RAISE EXCEPTION 'No se puede eliminar el producto %, aún tiene stock disponible.', OLD.product_id;
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;
```

### 🧰 Paso 2. Crear el trigger

```sql
CREATE TRIGGER trg_prevent_delete_products
BEFORE DELETE ON productsgit 
FOR EACH ROW
EXECUTE FUNCTION fn_prevent_delete_products();
```

✅ Prueba:
```sql
DELETE FROM products WHERE product_id = 1;
```

---

## 🧹 6. Cómo eliminar un Trigger

```sql
DROP TRIGGER trg_update_stock ON order_details;
DROP FUNCTION fn_update_stock();
```

---

## 🧭 7. Buenas prácticas

1. Usa nombres descriptivos.  
2. Evita lógica compleja dentro de la función.  
3. Documenta cada trigger.  
4. Prueba antes de activar en producción.  
5. Evita ciclos infinitos.

---

## 🧩 8. Actividad práctica para los alumnos

Crea un trigger que:
- Cada vez que se **actualice** el campo `unit_price` en `products`,  
- Inserte un registro en una tabla `product_price_history` con:
  - el `product_id`,
  - el precio anterior,
  - el precio nuevo,
  - la fecha de modificación.

---

## 🏁 Conclusión

Los *triggers* en PostgreSQL son una herramienta poderosa para **automatizar tareas**, **mantener la integridad de los datos** y **registrar auditorías** sin intervención manual.  
En la base Northwind, resultan especialmente útiles para controlar inventarios, registrar operaciones y aplicar políticas de negocio automáticamente.
