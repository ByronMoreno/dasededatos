# 🧑‍🏫 Clase: Lenguaje de Consulta de Datos (DQL) en PostgreSQL

## 🎯 Objetivo de la clase
Al finalizar esta sesión, el estudiante será capaz de:
- Comprender el propósito del **DQL (Data Query Language)**.  
- Utilizar correctamente la sentencia **SELECT** para consultar datos.  
- Aplicar **funciones de agregación**, **agrupamientos**, y **filtros avanzados con HAVING**.  
- Realizar consultas eficientes en PostgreSQL con múltiples condiciones y ordenamientos.

---

## 1️⃣ Introducción al DQL

### ¿Qué es DQL?

**DQL (Data Query Language)** es el subconjunto de SQL que permite **consultar y recuperar datos** almacenados en la base de datos.

El principal comando de DQL es:

| Sentencia | Descripción |
|------------|-------------|
| `SELECT` | Recupera datos de una o más tablas |

DQL **no modifica los datos**, solo los **lee**.

---

## 2️⃣ Sintaxis básica de SELECT

```sql
SELECT lista_de_columnas
FROM nombre_tabla
WHERE condición
ORDER BY columna [ASC|DESC];
```

### Ejemplo básico

```sql
SELECT nombre, edad FROM alumnos;
```

### Ejemplo con condición

```sql
SELECT nombre, apellido FROM alumnos WHERE edad > 20;
```

### Ejemplo con ordenamiento

```sql
SELECT * FROM alumnos ORDER BY edad DESC;
```

---

## 3️⃣ Uso de alias y expresiones

Puedes renombrar columnas o tablas temporalmente:

```sql
SELECT nombre AS "Nombre del Estudiante", edad AS "Edad Actual"
FROM alumnos;
```

O usar expresiones:

```sql
SELECT nombre, edad + 1 AS "Edad Siguiente"
FROM alumnos;
```

Alias para tabla:

```sql
SELECT a.nombre, a.apellido
FROM alumnos AS a;
```

---

## 4️⃣ Filtrado de resultados con WHERE

### Operadores comunes

| Tipo | Ejemplo |
|------|----------|
| Igualdad | `=`, `<>` |
| Comparación | `>`, `<`, `>=`, `<=` |
| Rango | `BETWEEN 18 AND 25` |
| Conjunto | `IN ('Quito','Guayaquil')` |
| Patrón | `LIKE 'A%'`, `ILIKE '%a%'` (no distingue mayúsculas/minúsculas) |
| Nulos | `IS NULL`, `IS NOT NULL` |

Ejemplo:

```sql
SELECT * FROM alumnos
WHERE edad BETWEEN 18 AND 25
AND apellido LIKE 'M%';
```

---

## 5️⃣ Eliminación de duplicados: DISTINCT

```sql
SELECT DISTINCT edad FROM alumnos;
```

Esto devuelve solo los valores únicos de edad.

---

## 6️⃣ Combinación de condiciones lógicas

```sql
SELECT * FROM alumnos
WHERE edad > 20 AND apellido LIKE 'M%';
```

También puedes usar:
- `OR` (una condición u otra)
- `NOT` (niega una condición)

---

## 7️⃣ Funciones de agregación

Las funciones de agregación realizan cálculos sobre un conjunto de registros.

| Función | Descripción |
|----------|--------------|
| `COUNT()` | Cuenta registros |
| `SUM()` | Suma valores numéricos |
| `AVG()` | Calcula promedio |
| `MIN()` | Mínimo valor |
| `MAX()` | Máximo valor |

### Ejemplos

```sql
SELECT COUNT(*) AS total_alumnos FROM alumnos;

SELECT AVG(edad) AS promedio_edad FROM alumnos;

SELECT MIN(edad), MAX(edad) FROM alumnos;
```

---

## 8️⃣ Agrupamiento con GROUP BY

Permite agrupar filas que tienen valores comunes en una o más columnas.

### Ejemplo

```sql
SELECT edad, COUNT(*) AS cantidad
FROM alumnos
GROUP BY edad;
```

Esto muestra cuántos alumnos hay por edad.

### Ejemplo más práctico

Si tenemos una tabla `ventas`:

```sql
CREATE TABLE ventas (
    id SERIAL PRIMARY KEY,
    producto VARCHAR(50),
    cantidad INT,
    total NUMERIC(10,2)
);
```

```sql
SELECT producto, SUM(total) AS total_vendido
FROM ventas
GROUP BY producto;
```

---

## 9️⃣ Filtrado de grupos con HAVING

`HAVING` se utiliza para filtrar los resultados **después del agrupamiento**.  
Es como un `WHERE`, pero para los grupos.

### Ejemplo

```sql
SELECT producto, SUM(total) AS total_vendido
FROM ventas
GROUP BY producto
HAVING SUM(total) > 1000;
```

Esto mostrará solo los productos cuyo total vendido supera los 1000.

---

## 🔟 Ordenar resultados: ORDER BY

Puedes ordenar por una o más columnas:

```sql
SELECT producto, SUM(total) AS total_vendido
FROM ventas
GROUP BY producto
ORDER BY total_vendido DESC;
```

---

## 1️⃣1️⃣ Limitar resultados: LIMIT y OFFSET

```sql
SELECT * FROM alumnos LIMIT 5;
```

```sql
SELECT * FROM alumnos ORDER BY id LIMIT 5 OFFSET 5;
```

👉 Esto sirve para paginar resultados.

---

## 1️⃣2️⃣ Subconsultas básicas (introducción a consultas anidadas)

```sql
SELECT nombre, edad
FROM alumnos
WHERE edad > (SELECT AVG(edad) FROM alumnos);
```

Esto devuelve los alumnos cuya edad es superior al promedio.

---

## 1️⃣3️⃣ Ejercicios prácticos guiados

1. Muestra los nombres y edades de todos los alumnos mayores de 20 años.  
2. Obtén la edad promedio de todos los alumnos.  
3. Muestra la cantidad de alumnos agrupados por edad.  
4. Muestra las edades que tienen más de 2 alumnos (usa HAVING).  
5. Crea una tabla `ventas` con campos `producto`, `cantidad` y `total`, e inserta 5 registros.  
6. Muestra el total vendido por producto y ordena los resultados de mayor a menor.  
7. Muestra solo los productos cuyo total vendido supera 1000.

---

## 1️⃣4️⃣ Buenas prácticas con DQL

- Usa alias para mejorar la legibilidad de las consultas.  
- Limita los resultados (`LIMIT`) en consultas de prueba.  
- Usa `HAVING` solo cuando trabajes con funciones de agregación.  
- Siempre verifica los resultados de una subconsulta antes de integrarla.  

---

## 1️⃣5️⃣ Autoevaluación

1. ¿Qué diferencia hay entre `WHERE` y `HAVING`?  
2. ¿Qué función usarías para calcular el valor máximo de una columna?  
3. Escribe una consulta que devuelva el promedio de edad por ciudad.  
4. ¿Qué hace la cláusula `GROUP BY`?  
5. ¿Cómo eliminarías los duplicados en una consulta?

---

## 📚 Conclusión

El **lenguaje DQL** es el núcleo de las consultas SQL.  
Dominar `SELECT`, junto con las funciones de agregación y filtros avanzados como `HAVING`, permite **analizar datos con precisión y flexibilidad**.  
PostgreSQL ofrece un entorno potente para construir consultas eficientes, claras y seguras.

---

**Autor:** Byron Moreno 
