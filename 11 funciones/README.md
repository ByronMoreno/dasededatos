# 🧠 Funciones en PostgreSQL con ejemplos (Base de datos Northwind)

Este documento explica los **tipos de funciones en PostgreSQL** y cómo utilizarlas, con ejemplos **basados en la base de datos Northwind**.  
Ideal para estudiantes que están aprendiendo SQL a nivel práctico.

---

## 📘 1. ¿Qué es una función en PostgreSQL?

Una **función** en PostgreSQL es un bloque de código que realiza una operación y devuelve un valor o conjunto de valores.  
Las funciones pueden ser:
- **Integradas (nativas)**: ya vienen incluidas en PostgreSQL.
- **Definidas por el usuario (UDFs)**: creadas por el usuario.

---

## ⚙️ 2. Tipos de funciones

### 🔹 2.1 Funciones de cadena (string functions)

Estas funciones manipulan o transforman texto.

| Función | Descripción | Ejemplo |
|----------|--------------|----------|
| `UPPER(text)` | Convierte texto a mayúsculas | `SELECT UPPER('northwind');` → **NORTHWIND** |
| `LOWER(text)` | Convierte texto a minúsculas | `SELECT LOWER('NorthWind');` → **northwind** |
| `INITCAP(text)` | Primera letra de cada palabra en mayúscula | `SELECT INITCAP('northwind traders');` → **Northwind Traders** |
| `LENGTH(text)` | Devuelve longitud de la cadena | `SELECT LENGTH('Producto');` → **8** |
| `CONCAT(a, b)` | Une cadenas de texto | `SELECT CONCAT('Cliente: ', company_name) FROM customers;` |
| `SUBSTRING(text FROM start FOR count)` | Extrae parte de una cadena | `SELECT SUBSTRING(company_name FROM 1 FOR 5) FROM customers;` |

---

### 🔹 2.2 Funciones numéricas

Sirven para realizar operaciones matemáticas o estadísticas simples.

| Función | Descripción | Ejemplo |
|----------|--------------|----------|
| `ROUND(num, n)` | Redondea un número a *n* decimales | `SELECT ROUND(123.4567, 2);` → **123.46** |
| `CEIL(num)` o `CEILING(num)` | Redondea hacia arriba | `SELECT CEIL(4.2);` → **5** |
| `FLOOR(num)` | Redondea hacia abajo | `SELECT FLOOR(4.9);` → **4** |
| `ABS(num)` | Valor absoluto | `SELECT ABS(-15);` → **15** |
| `POWER(x, y)` | Potencia de un número | `SELECT POWER(2, 3);` → **8** |
| `SQRT(num)` | Raíz cuadrada | `SELECT SQRT(81);` → **9** |

💡 Ejemplo aplicado con Northwind:
```sql
SELECT product_name, ROUND(unit_price, 2) AS precio_redondeado
FROM products;
```

---

### 🔹 2.3 Funciones de fecha y hora

Manejan valores de tipo fecha (`DATE`), hora (`TIME`) y timestamp (`TIMESTAMP`).

| Función | Descripción | Ejemplo |
|----------|--------------|----------|
| `CURRENT_DATE` | Fecha actual | `SELECT CURRENT_DATE;` |
| `CURRENT_TIME` | Hora actual | `SELECT CURRENT_TIME;` |
| `AGE(date1, date2)` | Diferencia entre dos fechas | `SELECT AGE(CURRENT_DATE, order_date) FROM orders;` |
| `EXTRACT(field FROM source)` | Extrae parte de una fecha | `SELECT EXTRACT(YEAR FROM order_date) FROM orders;` |
| `NOW()` | Fecha y hora actuales | `SELECT NOW();` |
| `DATE_PART('month', date)` | Devuelve el mes numérico | `SELECT DATE_PART('month', order_date) FROM orders;` |

📘 Ejemplo aplicado:
```sql
SELECT order_id, order_date, AGE(CURRENT_DATE, order_date) AS dias_transcurridos
FROM orders
LIMIT 5;
```

---

### 🔹 2.4 Funciones de agregación

Se utilizan para realizar cálculos sobre conjuntos de filas (como SUM, AVG, COUNT...).

| Función | Descripción | Ejemplo |
|----------|--------------|----------|
| `COUNT(*)` | Cuenta filas | `SELECT COUNT(*) FROM customers;` |
| `SUM(columna)` | Suma valores | `SELECT SUM(quantity) FROM order_details;` |
| `AVG(columna)` | Promedio | `SELECT AVG(unit_price) FROM products;` |
| `MAX(columna)` | Valor máximo | `SELECT MAX(unit_price) FROM products;` |
| `MIN(columna)` | Valor mínimo | `SELECT MIN(unit_price) FROM products;` |

📘 Ejemplo con GROUP BY:
```sql
SELECT category_id, AVG(unit_price) AS precio_promedio
FROM products
GROUP BY category_id;
```

📘 Ejemplo con HAVING:
```sql
SELECT category_id, AVG(unit_price) AS promedio
FROM products
GROUP BY category_id
HAVING AVG(unit_price) > 30;
```

---

### 🔹 2.5 Funciones condicionales

Permiten aplicar lógica en las consultas.

| Función | Descripción | Ejemplo |
|----------|--------------|----------|
| `CASE WHEN ... THEN ... ELSE ... END` | Condicional general | ```sql SELECT product_name, CASE WHEN unit_price > 50 THEN 'Caro' ELSE 'Económico' END AS tipo FROM products; ``` |
| `COALESCE(valor1, valor2, ...)` | Devuelve el primer valor no nulo | `SELECT COALESCE(region, 'Sin región') FROM customers;` |
| `NULLIF(a, b)` | Devuelve NULL si ambos valores son iguales | `SELECT NULLIF(10, 10);` → **NULL** |

---

### 🔹 2.6 Funciones de conversión de tipo

| Función | Descripción | Ejemplo |
|----------|--------------|----------|
| `CAST(valor AS tipo)` | Convierte entre tipos | `SELECT CAST('123' AS INTEGER);` |
| `TO_CHAR(valor, formato)` | Convierte a texto con formato | `SELECT TO_CHAR(order_date, 'DD-MM-YYYY') FROM orders;` |
| `TO_DATE(text, formato)` | Convierte texto a fecha | `SELECT TO_DATE('14-10-2025', 'DD-MM-YYYY');` |

📘 Ejemplo aplicado:
```sql
SELECT order_id, TO_CHAR(order_date, 'DD Mon YYYY') AS fecha_formateada
FROM orders
LIMIT 5;
```

---

### 🔹 2.7 Funciones de agrupación avanzada (con JOIN)

Podemos combinar funciones agregadas con uniones entre tablas.

```sql
SELECT c.company_name, COUNT(o.order_id) AS total_pedidos
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.company_name
ORDER BY total_pedidos DESC
LIMIT 5;
```

---

## 🧪 3. Funciones definidas por el usuario (UDFs)

Puedes crear tus propias funciones usando `CREATE FUNCTION`.

### 🔸 Ejemplo: función que devuelve el precio con IVA
```sql
CREATE OR REPLACE FUNCTION precio_con_iva(precio NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
  RETURN precio * 1.12;
END;
$$ LANGUAGE plpgsql;
```

📘 Uso:
```sql
SELECT product_name, unit_price, precio_con_iva(unit_price) AS precio_iva
FROM products
LIMIT 5;
```

---

## 🧩 4. Ejercicio práctico final

1. Muestra el **precio promedio de productos por categoría**.  
2. Muestra los **cinco clientes con más pedidos**.  
3. Calcula cuántos días han pasado desde la última orden (`orders`).  
4. Crea una función que **devuelva el total con descuento aplicado** (10%).  
5. Usa `COALESCE` para mostrar “Sin Región” cuando el campo `region` sea `NULL`.

---

## 👨‍🏫 Conclusión

Las funciones en PostgreSQL son herramientas poderosas para manipular datos y realizar cálculos complejos directamente en las consultas SQL.

> 🐘 Con práctica constante y ejemplos aplicados como en Northwind, podrás dominar su uso y aplicarlas en tus propios proyectos.

---

**Autor:** Profesor Byron Moreno  