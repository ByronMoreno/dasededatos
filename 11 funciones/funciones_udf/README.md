# 🧠 Funciones Definidas por el Usuario (UDF) en PostgreSQL
**Ejemplos prácticos con la base de datos Northwind**

---

## 📘 1. Introducción

En PostgreSQL, las **funciones definidas por el usuario (User Defined Functions, UDFs)** permiten encapsular lógica de negocio o tareas repetitivas dentro de una base de datos.  
Estas funciones se crean con `CREATE FUNCTION` y pueden:
- Tener o no parámetros.
- Retornar o no un valor.
- Ser escritas en SQL o PL/pgSQL (el lenguaje procedimental de PostgreSQL).

---

## ⚙️ 2. Sintaxis general

```sql
CREATE [OR REPLACE] FUNCTION nombre_funcion(parámetros)
RETURNS tipo_retorno AS $$
BEGIN
    -- Bloque de instrucciones
    RETURN valor;
END;
$$ LANGUAGE plpgsql;
```

---

## 🧩 3. Tipos de funciones según parámetros y retorno

### 🔹 3.1 Función sin parámetros y sin retorno

Esta función solo ejecuta una acción (por ejemplo, insertar un registro o mostrar un mensaje con `RAISE NOTICE`).

```sql
CREATE OR REPLACE FUNCTION saludar()
RETURNS void AS $$
BEGIN
    RAISE NOTICE '¡Hola! Esta es una función sin parámetros ni retorno.';
END;
$$ LANGUAGE plpgsql;

-- Ejecución
SELECT saludar();
```
📘 *Salida esperada:*  
`NOTICE: ¡Hola! Esta es una función sin parámetros ni retorno.`

---

### 🔹 3.2 Función con parámetros y sin retorno

Ejemplo: Registrar una categoría nueva en la tabla `categories` de **Northwind**.

```sql
CREATE OR REPLACE FUNCTION f_insertar_categoria(id integer, 
nombre TEXT, descripcion TEXT)
RETURNS void as $$
BEGIN
	insert into categories(category_id, category_name, 
	description)
	values(id, nombre, descripcion);
END;
$$ LANGUAGE plpgsql;


-- Ejecución
select f_insertar_categoria(9,'PRUE1','Inserto desde funcion');
```

📘 *Salida esperada:*  
`NOTICE: Categoría "Nuevos Productos" agregada correctamente.`

---

### 🔹 3.3 Función sin parámetros y con retorno

Ejemplo: Retornar el número total de productos registrados.

```sql
CREATE OR REPLACE FUNCTION contar_productos()
RETURNS INTEGER AS $$
DECLARE
    total INTEGER;
BEGIN
    SELECT COUNT(*) INTO total FROM products;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- Ejecución
SELECT contar_productos();
```

📘 *Salida esperada:*  
`contar_productos = 77` (o el número de productos actual).

---

### 🔹 3.4 Función con parámetros y con retorno

Ejemplo: Calcular el total vendido por un empleado.

```sql
CREATE OR REPLACE FUNCTION total_vendido_por_empleado(id_empleado INT)
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT SUM(od.unitprice * od.quantity * (1 - od.discount))
    INTO total
    FROM orders o
    JOIN order_details od ON o.orderid = od.orderid
    WHERE o.employeeid = id_empleado;

    RETURN COALESCE(total, 0);
END;
$$ LANGUAGE plpgsql;

-- Ejecución
SELECT total_vendido_por_empleado(1);
```

📘 *Salida esperada:*  
`total_vendido_por_empleado = 12500.45` (dependiendo de los datos).

---

## 🧠 4. Buenas prácticas

✅ Usa `OR REPLACE` para actualizar funciones existentes sin tener que borrarlas.  
✅ Usa `RAISE NOTICE` para depurar el comportamiento de tus funciones.  
✅ Evita lógica compleja dentro de una sola función: mejor divide el código en funciones más pequeñas.  
✅ Declara siempre el tipo de retorno correcto (`void`, `integer`, `text`, `numeric`, etc.).  
✅ Usa `COALESCE` para manejar posibles valores nulos.

---

## 💡 5. Ejemplo combinado: creación y ejecución

```sql
-- Crear todas las funciones
CREATE OR REPLACE FUNCTION saludar()
RETURNS void AS $$
BEGIN
    RAISE NOTICE '¡Hola desde PostgreSQL!';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insertar_categoria(nombre_categoria TEXT, descripcion TEXT)
RETURNS void AS $$
BEGIN
    INSERT INTO categories(categoryname, description)
    VALUES (nombre_categoria, descripcion);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_productos()
RETURNS INTEGER AS $$
DECLARE
    total INTEGER;
BEGIN
    SELECT COUNT(*) INTO total FROM products;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION total_vendido_por_empleado(id_empleado INT)
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT SUM(od.unitprice * od.quantity * (1 - od.discount))
    INTO total
    FROM orders o
    JOIN order_details od ON o.orderid = od.orderid
    WHERE o.employeeid = id_empleado;

    RETURN COALESCE(total, 0);
END;
$$ LANGUAGE plpgsql;
```

---

## 💡 6 Otras funciones(Retornar registros genéricos (SETOF RECORD)) 

```sql
CREATE OR REPLACE FUNCTION obtener_customers()
RETURNS SETOF customers
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM customers;
END;
$$ LANGUAGE plpgsql;

```

### 🧪 Prueba

```sql
--Ejecutar la funcion
select obtener_customers();
```

---

## 🧾 7. Conclusión

Las **funciones definidas por el usuario** en PostgreSQL son una poderosa herramienta para encapsular lógica de negocio directamente dentro del motor de base de datos.  
Permiten reutilizar código, mejorar la organización y reducir errores en las consultas SQL.

---

**Autor:** Profesor Byron Moreno
