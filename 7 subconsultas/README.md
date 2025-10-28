
# Ejemplos básicos de subconsultas con la base de datos Northwind (PostgreSQL)

Este documento presenta ejemplos **básicos** de subconsultas en SQL que devuelven **un solo valor (subconsultas escalares)**, utilizando la base de datos **Northwind** adaptada a **PostgreSQL**.

---

## 🧱 Tablas utilizadas

- **products** → productos (`product_id`, `product_name`, `unit_price`, `supplier_id`, `category_id`)  
- **orders** → pedidos (`order_id`, `customer_id`, `employee_id`, `order_date`)  
- **customers** → clientes (`customer_id`, `company_name`, `country`)  
- **employees** → empleados (`employee_id`, `first_name`, `last_name`)

---

## 🟢 1. Subconsulta en la cláusula WHERE

Mostrar los productos cuyo precio sea mayor al **precio promedio** de todos los productos.

```sql
SELECT product_name, unit_price
FROM products
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM products
);
```

🔹 **Explicación:**  
La subconsulta calcula el precio promedio; el `WHERE` compara cada producto con ese valor único.

---

## 🟡 2. Subconsulta en la cláusula SELECT

Mostrar el nombre del producto junto con el **precio promedio general** (como columna adicional).

```sql
SELECT
    product_name,
    unit_price,
    (SELECT AVG(unit_price) FROM products) AS precio_promedio_general
FROM products;
```

🔹 **Explicación:**  
Cada fila muestra el precio del producto y, al lado, el precio promedio general calculado una sola vez.

---

## 🔵 3. Subconsulta con comparación a un valor único

Mostrar los empleados que tienen un **ID mayor** al del empleado con nombre “Nancy”.

```sql
SELECT employee_id, first_name, last_name
FROM employees
WHERE employee_id > (
    SELECT employee_id
    FROM employees
    WHERE first_name = 'Nancy'
);
```

🔹 **Explicación:**  
La subconsulta obtiene el `employee_id` de Nancy (un solo valor), y luego se comparan los demás.

---

## 🟣 4. Subconsulta con valores agregados

Mostrar el cliente con el **número más alto de pedidos**.

```sql
SELECT customer_id, company_name
FROM customers
WHERE customer_id = (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);
```

🔹 **Explicación:**  
La subconsulta devuelve un único `customer_id`: el del cliente con más pedidos.

---

## 🔶 5. Subconsulta en FROM (tabla derivada básica)

Mostrar el precio promedio de productos **por categoría**, y filtrar solo la categoría con el **mayor promedio**.

```sql
SELECT category_id, promedio
FROM (
    SELECT category_id, AVG(unit_price) AS promedio
    FROM products
    GROUP BY category_id
) AS promedios
WHERE promedio = (
    SELECT MAX(AVG(unit_price))
    FROM products
    GROUP BY category_id
);
```

🔹 **Explicación:**  
La subconsulta interna (`promedios`) calcula el promedio por categoría, y la subconsulta en `WHERE` devuelve el promedio máximo.

---

📘 **Autor:** Ejemplos elaborados para practicar SQL con la base de datos Northwind en PostgreSQL.
