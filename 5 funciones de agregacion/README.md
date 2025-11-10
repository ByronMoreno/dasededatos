# 🧑‍🏫 Clase: Funciones de Agregación en PostgreSQL

## 🎯 Objetivo de aprendizaje
Al finalizar la clase, el estudiante será capaz de:
- Comprender qué son las funciones de agregación en SQL.  
- Aplicar correctamente las funciones `COUNT`, `SUM`, `AVG`, `MIN` y `MAX`.  
- Combinar funciones de agregación con `GROUP BY` y `HAVING`.  
- Resolver consultas de resumen en bases de datos relacionales.

---

## 🧩 1. Introducción teórica
Las **funciones de agregación** permiten **resumir o calcular valores sobre conjuntos de filas**.  
A diferencia de las funciones escalares (que trabajan fila por fila), las de agregación **operan sobre múltiples registros** y devuelven **un solo valor**.

### Ejemplos de uso:
- Obtener el total de ventas del mes.  
- Calcular el promedio de calificaciones.  
- Contar cuántos estudiantes hay en una carrera.

---

## 📘 2. Principales funciones de agregación

| Función | Descripción | Ejemplo |
|----------|--------------|----------|
| `COUNT()` | Cuenta cuántas filas hay. | `COUNT(*)` |
| `SUM()` | Suma los valores numéricos. | `SUM(precio)` |
| `AVG()` | Calcula el promedio. | `AVG(salario)` |
| `MIN()` | Devuelve el valor mínimo. | `MIN(edad)` |
| `MAX()` | Devuelve el valor máximo. | `MAX(edad)` |

---

## 🧱 3. Ejemplo de tabla: empleados

```sql
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    departamento VARCHAR(30),
    salario NUMERIC(10,2),
    edad INT
);

INSERT INTO empleados (nombre, departamento, salario, edad) VALUES
('Ana', 'Ventas', 1200.50, 25),
('Luis', 'Ventas', 1500.00, 30),
('María', 'Contabilidad', 2000.00, 28),
('Carlos', 'Contabilidad', 2500.00, 40),
('Sofía', 'Recursos Humanos', 1800.00, 35),
('Pedro', 'Ventas', 1300.00, 27);
```

---

## 🧮 4. Uso básico de las funciones de agregación

### a) Contar registros
```sql
SELECT COUNT(*) AS total_empleados FROM empleados;
```

### b) Sumar salarios
```sql
SELECT SUM(salario) AS total_salarios FROM empleados;
```

### c) Promedio de salarios
```sql
SELECT AVG(salario) AS salario_promedio FROM empleados;
```

### d) Mínimo y máximo salario
```sql
SELECT MIN(salario) AS salario_minimo, MAX(salario) AS salario_maximo
FROM empleados;
```

---

## 🧩 5. Agrupación de resultados con GROUP BY

El **`GROUP BY`** permite aplicar funciones de agregación **por grupo** (por ejemplo, por departamento).

### Ejemplo:
```sql
SELECT departamento, COUNT(*) AS total_empleados
FROM empleados
GROUP BY departamento;
```

📊 Resultado:
| departamento       | total_empleados |
|--------------------|----------------|
| Ventas             | 3 |
| Contabilidad       | 2 |
| Recursos Humanos   | 1 |

### Otro ejemplo: salario promedio por departamento
```sql
SELECT departamento, AVG(salario) AS promedio_salario
FROM empleados
GROUP BY departamento;
```

---

## 🚧 6. Filtrado de grupos con HAVING

`HAVING` funciona como un **WHERE**, pero se aplica **después del GROUP BY**.  
Permite filtrar **grupos completos**, no filas individuales.

### Ejemplo:
Mostrar solo los departamentos con un salario promedio mayor a 1500:

```sql
SELECT departamento, AVG(salario) AS promedio_salario
FROM empleados
GROUP BY departamento
HAVING AVG(salario) > 1500;
```

---

## ⚙️ 7. Combinando WHERE, GROUP BY y HAVING

```sql
SELECT departamento, COUNT(*) AS cantidad, SUM(salario) AS total_salarios
FROM empleados
WHERE edad > 25
GROUP BY departamento
HAVING SUM(salario) > 3000;
```

Explicación:
- `WHERE edad > 25` filtra filas antes de agrupar.  
- `GROUP BY departamento` agrupa los resultados.  
- `HAVING SUM(salario) > 3000` muestra solo los departamentos con salario total mayor a 3000.

---

## 📊 8. Ordenando resultados con ORDER BY

Puedes ordenar los resultados después de aplicar funciones de agregación.

```sql
SELECT departamento, AVG(salario) AS promedio
FROM empleados
GROUP BY departamento
ORDER BY promedio DESC;
```

---

## 🧠 9. Ejercicios propuestos

1. Muestra el número total de empleados y el salario promedio general.  
2. Lista los departamentos con su total de empleados y el salario máximo.  
3. Obtén los departamentos cuyo promedio salarial supere los 1800.  
4. Muestra la edad promedio de los empleados de “Ventas”.  
5. Cuenta cuántos empleados tienen un salario superior a 1500.

---

## 🧩 10. Desafío final

> ¿Cuál es el departamento con el **mayor salario promedio**?

Pista:
```sql
SELECT departamento, AVG(salario) AS promedio
FROM empleados
GROUP BY departamento
ORDER BY promedio DESC
LIMIT 1;
```

---

## 💡 Conclusión

- Las **funciones de agregación** permiten **resumir datos** y son esenciales para informes y análisis.  
- Se usan comúnmente con `GROUP BY`, `HAVING` y `ORDER BY`.  
- Dominar su uso te prepara para crear consultas analíticas y dashboards empresariales.

---

## 📚 Tarea adicional

Crea una tabla `ventas` con campos `(id, producto, cantidad, precio, fecha)`  
e intenta resolver:

1. Total de ventas del mes actual.  
2. Promedio de cantidad por producto.  
3. Productos más vendidos.  
4. Día con mayores ingresos.
