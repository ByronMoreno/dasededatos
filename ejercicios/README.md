
# 🧩 Taller de Consultas SQL – Northwind (PostgreSQL)

Este documento contiene **33 ejercicios resueltos** para practicar consultas SQL sobre la base de datos **Northwind** en **PostgreSQL**.  
Incluye ejemplos con **funciones de agregación, cláusulas HAVING, operadores LIKE / EXISTS, subconsultas** y más.  
Ideal para estudiantes que están aprendiendo a consultar bases de datos relacionales.

---

## 🧱 Tablas principales utilizadas

| Tabla | Descripción |
|--------|--------------|
| **customers** | Clientes |
| **orders** | Pedidos |
| **employees** | Empleados |
| **products** | Productos |
| **categories** | Categorías |
| **suppliers** | Proveedores |
| **order_details** | Detalle de pedidos |

---

## 🟢 PARTE I – Funciones de agregación (sin HAVING)

1️⃣ **Precio promedio de todos los productos**
```sql
SELECT AVG(unit_price) AS precio_promedio
FROM products;
```

2️⃣ **Número total de pedidos**
```sql
SELECT COUNT(*) AS total_pedidos
FROM orders;
```

3️⃣ **Precio máximo y mínimo de los productos**
```sql
SELECT MAX(unit_price) AS precio_maximo,
       MIN(unit_price) AS precio_minimo
FROM products;
```

4️⃣ **Suma total de unidades en stock**
```sql
SELECT SUM(units_in_stock) AS total_unidades_stock
FROM products;
```

5️⃣ **Número de clientes distintos**
```sql
SELECT COUNT(DISTINCT customer_id) AS clientes_distintos
FROM customers;
```

---

## 🟡 PARTE II – Funciones de agregación con GROUP BY y HAVING

6️⃣ **Precio promedio por categoría**
```sql
SELECT category_id,
       AVG(unit_price) AS precio_promedio_categoria
FROM products
GROUP BY category_id
ORDER BY category_id;
```

7️⃣ **Total de pedidos por cliente**
```sql
SELECT o.customer_id,
       c.company_name,
       COUNT(*) AS total_pedidos
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.company_name
ORDER BY total_pedidos DESC;
```

8️⃣ **Categorías cuyo precio promedio > 40**
```sql
SELECT category_id,
       AVG(unit_price) AS precio_promedio
FROM products
GROUP BY category_id
HAVING AVG(unit_price) > 40
ORDER BY precio_promedio DESC;
```

9️⃣ **Empleados que hayan gestionado más de 50 pedidos**
```sql
SELECT o.employee_id,
       e.first_name || ' ' || e.last_name AS empleado,
       COUNT(*) AS total_pedidos
FROM orders o
JOIN employees e ON o.employee_id = e.employee_id
GROUP BY o.employee_id, e.first_name, e.last_name
HAVING COUNT(*) > 50
ORDER BY total_pedidos DESC;
```

🔟 **Proveedores que suministran más de 5 productos**
```sql
SELECT supplier_id,
       s.company_name,
       COUNT(*) AS total_productos
FROM products p
JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY supplier_id, s.company_name
HAVING COUNT(*) > 5
ORDER BY total_productos DESC;
```

---

## 🔍 PARTE III – Operadores LIKE y NOT LIKE

11️⃣ **Clientes cuya compañía empieza con "A"**
```sql
SELECT customer_id, company_name
FROM customers
WHERE company_name LIKE 'A%';
```

12️⃣ **Productos que contienen "Chocol"**
```sql
SELECT product_id, product_name
FROM products
WHERE product_name ILIKE '%Chocol%';
```

13️⃣ **Clientes cuyo nombre no contenga "Market"**
```sql
SELECT customer_id, company_name
FROM customers
WHERE company_name NOT ILIKE '%Market%';
```

14️⃣ **Empleados cuyo apellido termina en "n"**
```sql
SELECT employee_id, first_name, last_name
FROM employees
WHERE last_name ILIKE '%n';
```

---

## 🧠 PARTE IV – EXISTS y NOT EXISTS

15️⃣ **Clientes que tienen al menos un pedido**
```sql
SELECT customer_id, company_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

16️⃣ **Clientes que no tienen pedidos**
```sql
SELECT customer_id, company_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

17️⃣ **Empleados que han gestionado pedidos**
```sql
SELECT employee_id, first_name, last_name
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.employee_id = e.employee_id
);
```

18️⃣ **Productos que nunca han sido vendidos**
```sql
SELECT p.product_id, p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_details od
    WHERE od.product_id = p.product_id
);
```

---

## ⚙️ PARTE V – BETWEEN, IN y operadores lógicos

19️⃣ **Productos con precio entre 10 y 30**
```sql
SELECT product_id, product_name, unit_price
FROM products
WHERE unit_price BETWEEN 10 AND 30
ORDER BY unit_price;
```

20️⃣ **Pedidos entre enero y marzo de 1997**
```sql
SELECT order_id, customer_id, order_date
FROM orders
WHERE order_date BETWEEN '1997-01-01' AND '1997-03-31'
ORDER BY order_date;
```

21️⃣ **Clientes en países USA, Mexico o Canada**
```sql
SELECT customer_id, company_name, country
FROM customers
WHERE country IN ('USA', 'Mexico', 'Canada');
```

22️⃣ **Productos con unidades en stock entre 0 y 10**
```sql
SELECT product_id, product_name, units_in_stock
FROM products
WHERE units_in_stock BETWEEN 0 AND 10
ORDER BY units_in_stock;
```

23️⃣ **Productos con precio > 50 o stock < 10**
```sql
SELECT product_id, product_name, unit_price, units_in_stock
FROM products
WHERE unit_price > 50 OR units_in_stock < 10
ORDER BY unit_price DESC;
```

---

## 🧩 PARTE VI – Subconsultas combinadas

24️⃣ **Producto más caro**
```sql
SELECT product_id, product_name, unit_price
FROM products
WHERE unit_price = (SELECT MAX(unit_price) FROM products)
LIMIT 1;
```

25️⃣ **Empleado con más pedidos asignados**
```sql
SELECT o.employee_id,
       e.first_name || ' ' || e.last_name AS empleado,
       COUNT(*) AS total_pedidos
FROM orders o
JOIN employees e ON o.employee_id = e.employee_id
GROUP BY o.employee_id, e.first_name, e.last_name
ORDER BY total_pedidos DESC
LIMIT 1;
```

26️⃣ **Productos con precio mayor al promedio general**
```sql
SELECT product_id, product_name, unit_price
FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products)
ORDER BY unit_price DESC;
```

27️⃣ **Cliente con el número más alto de pedidos**
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

28️⃣ **Proveedores que suministran productos con precio > promedio**
```sql
SELECT DISTINCT s.supplier_id, s.company_name
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id
WHERE p.unit_price > (SELECT AVG(unit_price) FROM products);
```

---

## 🧮 PARTE VII – Desafíos integradores

29️⃣ **Nombre del cliente, ID del pedido y empleado**
```sql
SELECT c.company_name AS cliente,
       o.order_id AS pedido,
       e.first_name || ' ' || e.last_name AS empleado
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN employees e ON o.employee_id = e.employee_id
ORDER BY o.order_id
LIMIT 100;
```

30️⃣ **Producto, categoría y proveedor**
```sql
SELECT p.product_id, p.product_name,
       cat.category_name,
       s.company_name AS proveedor
FROM products p
LEFT JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id
ORDER BY p.product_name;
```

31️⃣ **Productos vendidos por “Nancy Davolio”**
```sql
SELECT DISTINCT p.product_id, p.product_name
FROM products p
JOIN order_details od ON p.product_id = od.product_id
JOIN orders o ON od.order_id = o.order_id
JOIN employees e ON o.employee_id = e.employee_id
WHERE e.first_name = 'Nancy' AND e.last_name = 'Davolio'
ORDER BY p.product_name;
```

32️⃣ **Total de ventas por país**
```sql
SELECT c.country,
       SUM(od.unit_price * od.quantity * (1 - COALESCE(od.discount, 0))) AS total_ventas
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.country
ORDER BY total_ventas DESC;
```

33️⃣ **Productos de categorías con promedio > 40**
```sql
SELECT p.product_id, p.product_name, p.unit_price, p.category_id
FROM products p
WHERE p.category_id IN (
    SELECT category_id
    FROM products
    GROUP BY category_id
    HAVING AVG(unit_price) > 40
)
ORDER BY p.unit_price DESC;
```

---

✍️ **Autor:** Taller de consultas SQL con PostgreSQL  
🎓 **Propósito:** Desarrollar dominio en la escritura de consultas SQL mediante práctica guiada.

---
