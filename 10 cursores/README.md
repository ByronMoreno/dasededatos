# 🎯 Cursores en PostgreSQL: Explícitos vs Implícitos  

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Cursores-blue.svg)
![PLpgSQL](https://img.shields.io/badge/PL%252FpgSQL-Advanced-green.svg)

---

## 📋 Tabla de Contenidos
- 🎯 [Introducción](#-introducción)
- 🔍 [Cursores Explícitos](#-cursores-explícitos)
- ⚡ [Cursores Implícitos](#-cursores-implícitos)
- 🔄 [FOR Loop con Cursores](#-for-loop-con-cursores)
- 📊 [Comparación: Explícitos vs Implícitos](#-comparación-explícitos-vs-implícitos)
- 🎯 [Casos de Uso Prácticos](#-casos-de-uso-prácticos)
- ⚡ [Ejemplos Avanzados](#-ejemplos-avanzados)
- 🏆 [Resumen Final](#-resumen-final)

---

## 🎯 Introducción

### ¿Qué son los Cursores? 🤔
Los **cursores** en PostgreSQL permiten recorrer los resultados de una consulta **fila por fila**, brindando control total sobre la manipulación de datos dentro de un bloque `PL/pgSQL`.

```sql
-- Tipos principales de cursores
-- 1️⃣ Cursores Explícitos → Control total (abrir, recorrer, cerrar)
-- 2️⃣ Cursores Implícitos → Se manejan automáticamente con FOR loops
```

---

## 🔍 Cursores Explícitos

### 🧱 Estructura general
```sql
DO $$
DECLARE
    cur CURSOR FOR SELECT product_id, product_name, unit_price FROM products;
    rec RECORD;
BEGIN
    OPEN cur; -- Abrir cursor
    LOOP
        FETCH cur INTO rec; -- Obtener fila
        EXIT WHEN NOT FOUND; -- Salir cuando no haya más filas
        RAISE NOTICE 'Producto: %, Precio: %', rec.product_name, rec.unit_price;
    END LOOP;
    CLOSE cur; -- Cerrar cursor
END $$;
```

🔹 **Ventajas:**
- Control completo sobre cuándo abrir y cerrar el cursor.  
- Permite lógica condicional avanzada dentro del bucle.

🔹 **Desventajas:**
- Más código y propenso a errores si no se cierra correctamente.

---

## ⚡ Cursores Implícitos

Los cursores implícitos se manejan automáticamente con un bucle `FOR`.  
No es necesario abrir, recorrer ni cerrar el cursor.

### 🧩 Ejemplo práctico
```sql
DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN SELECT customer_id, company_name FROM customers LOOP
        RAISE NOTICE 'Cliente: %', rec.company_name;
    END LOOP;
END $$;
```

🔹 **Ventajas:**
- Código más limpio y legible.  
- Ideal para operaciones simples.  

🔹 **Desventajas:**
- No se puede controlar manualmente el ciclo del cursor.

---

## 🔄 FOR Loop con Cursores

También se pueden usar **cursores explícitos** dentro de un `FOR`:

```sql
DO $$
DECLARE
    cur CURSOR FOR SELECT first_name, last_name FROM employees;
BEGIN
    FOR rec IN cur LOOP
        RAISE NOTICE 'Empleado: % %', rec.first_name, rec.last_name;
    END LOOP;
END $$;
```

Esto combina la **simplicidad del FOR** con la **flexibilidad del cursor explícito**.

---

## 📊 Comparación: Explícitos vs Implícitos

| Característica | Cursor Explícito | Cursor Implícito |
|-----------------|------------------|------------------|
| Apertura manual | ✅ Sí | ❌ No |
| Cierre manual | ✅ Sí | ❌ No |
| Control de flujo detallado | ✅ Completo | ⚠️ Limitado |
| Simplicidad | ⚠️ Menor | ✅ Alta |
| Rendimiento | Similar | Similar |
| Uso recomendado | Procesos complejos | Recorridos simples |

---

## 🎯 Casos de Uso Prácticos

### 1️⃣ Calcular totales por cliente
```sql
--Calcular totale por clientes
DO $$
DECLARE
	curs CURSOR FOR
		select customer_id, sum(od.unit_price*od.quantity) as total
		from orders o, order_details od
		where od.order_id = o.order_id
		group by customer_id;
BEGIN
	FOR fila in curs Loop
		raise notice 'Cliente: % --> Total: %',
		fila.customer_id, fila.total;
	end loop;
END $$
LANGUAGE plpgsql;
```

### 2️⃣ Registrar empleados activos (implícito)
```sql
DO $$
BEGIN
    FOR emp IN SELECT employee_id, first_name, last_name FROM employees WHERE status = 'ACTIVE' LOOP
        RAISE NOTICE 'Empleado activo: % %', emp.first_name, emp.last_name;
    END LOOP;
END $$;
```

---

## ⚡ Ejemplos Avanzados

### 1️⃣ Cursor con parámetro
```sql
DO $$
DECLARE
    cur CURSOR (min_price NUMERIC) FOR
        SELECT product_name, unit_price FROM products WHERE unit_price > min_price;
    rec RECORD;
BEGIN
    OPEN cur(20);
    LOOP
        FETCH cur INTO rec;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Producto: % ($%)', rec.product_name, rec.unit_price;
    END LOOP;
    CLOSE cur;
END $$;
```

### 2️⃣ Cursor que actualiza datos
```sql
DO $$
DECLARE
    cur CURSOR FOR SELECT product_id, stock FROM products WHERE stock < 10;
    rec RECORD;
BEGIN
    FOR rec IN cur LOOP
        UPDATE products SET stock = stock + 10 WHERE product_id = rec.product_id;
        RAISE NOTICE 'Producto % actualizado. Nuevo stock: %', rec.product_id, rec. stock + 10;
    END LOOP;
END $$;
```

---

## 🏆 Resumen Final

| Tipo | Control | Código | Uso Ideal |
|------|----------|---------|------------|
| **Explícito** | Completo | Extenso | Procesos detallados o parametrizados |
| **Implícito** | Automático | Simple | Recorridos o reportes rápidos |

---

## 🧩 Recomendación Final
- Usa **cursores implícitos** cuando solo necesites recorrer resultados.  
- Usa **cursores explícitos** cuando necesites manipular o condicionar datos durante la iteración.  
- Siempre **cierra los cursores explícitos** para evitar fugas de memoria.

---

🧠 **Consejo:** Practica con ambas versiones de cursores para dominar el flujo de control en PL/pgSQL y optimizar operaciones sobre grandes conjuntos de datos.
