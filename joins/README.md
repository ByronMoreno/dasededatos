
# Ejemplos de JOIN con la base de datos Northwind (PostgreSQL)

Este documento contiene ejemplos sencillos de los principales tipos de **JOIN** en SQL, utilizando la base de datos **Northwind** adaptada a **PostgreSQL**.

---

## 🧱 Tablas utilizadas

- **customers** → información de los clientes (`customer_id`, `company_name`, etc.)  
- **orders** → pedidos realizados (`order_id`, `customer_id`, `employee_id`, etc.)  
- **employees** → empleados que gestionaron los pedidos (`employee_id`, `first_name`, `last_name`)

---

## 🟢 1. INNER JOIN  

Muestra solo los registros que tienen coincidencias en ambas tablas.

```sql
SELECT
    c.company_name AS cliente,
    o.order_id AS pedido
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY cliente;
```

🔹 **Explicación:**  
Solo aparecen los clientes que tienen pedidos registrados.

---

## 🟡 2. LEFT JOIN  

Muestra todos los clientes, aunque no tengan pedidos.

```sql
SELECT
    c.company_name AS cliente,
    o.order_id AS pedido
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY cliente;
```

🔹 **Explicación:**  
Los clientes sin pedidos aparecerán con el campo `pedido` en `NULL`.

---

## 🔵 3. RIGHT JOIN  

Muestra todos los pedidos, incluso si no existe un cliente asociado (raro, pero posible).

```sql
SELECT
    c.company_name AS cliente,
    o.order_id AS pedido
FROM customers c
RIGHT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY pedido;
```

🔹 **Explicación:**  
Si hubiera un pedido sin cliente (por error o datos faltantes), también se mostraría.

---

## 🟣 4. FULL JOIN  

Combina ambos: muestra todos los clientes y todos los pedidos, incluso si no hay coincidencia.

```sql
SELECT
    c.company_name AS cliente,
    o.order_id AS pedido
FROM customers c
FULL JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY cliente;
```

🔹 **Explicación:**  
- Si un cliente no tiene pedido → `pedido` será `NULL`.  
- Si un pedido no tiene cliente → `cliente` será `NULL`.

---

## 🔶 5. JOIN con tres tablas (BONUS)

Relaciona cliente, pedido y empleado (INNER JOIN en cadena).

```sql
SELECT
    c.company_name AS cliente,
    o.order_id AS pedido,
    e.first_name || ' ' || e.last_name AS empleado
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN employees e
    ON o.employee_id = e.employee_id
ORDER BY cliente;
```

🔹 **Explicación:**  
Muestra qué empleado gestionó cada pedido de cada cliente.

---
