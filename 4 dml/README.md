# 🧑‍🏫 Clase: Sentencias DML en PostgreSQL

## 🎯 Objetivo de la clase
Al finalizar esta sesión, el estudiante será capaz de:
- Comprender el propósito y alcance de las sentencias **DML**.  
- Aplicar correctamente los comandos **INSERT**, **UPDATE**, **DELETE** y **SELECT**.  
- Manipular datos de manera segura y eficiente en PostgreSQL.  
- Diferenciar entre las operaciones **DDL** y **DML**.

---

## 1️⃣ Introducción a DML

### ¿Qué es DML?

**DML (Data Manipulation Language)** es el subconjunto del lenguaje SQL que se utiliza para **manipular los datos** dentro de las tablas de una base de datos.

Estas sentencias permiten:
- **Insertar** nuevos registros.  
- **Actualizar** registros existentes.  
- **Eliminar** registros.  
- **Consultar** la información almacenada.

| Sentencia | Descripción |
|------------|--------------|
| `INSERT` | Agrega nuevos registros a una tabla |
| `UPDATE` | Modifica datos existentes |
| `DELETE` | Elimina registros |
| `SELECT` | Recupera datos de una o más tablas |

---

## 2️⃣ Preparación del entorno

Antes de comenzar, asegúrate de tener:
- **PostgreSQL** instalado (versión 13 o superior).  
- **pgAdmin** o **psql** como cliente para ejecutar las consultas.  
- Una base de datos creada, por ejemplo:  

```sql
CREATE DATABASE escuela;
```

Conéctate a la base de datos:

```sql
\c escuela
```

---

## 3️⃣ Creación de la tabla base para ejemplos

```sql
CREATE TABLE alumnos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    edad INT CHECK (edad > 0),
    correo VARCHAR(100) UNIQUE
);
```

---

## 4️⃣ Comando INSERT

### Sintaxis general

```sql
INSERT INTO nombre_tabla (columna1, columna2, ...)
VALUES (valor1, valor2, ...);
```

### Ejemplo

```sql
INSERT INTO alumnos (nombre, apellido, edad, correo)
VALUES ('María', 'Pérez', 21, 'maria.perez@unib.edu.ec');
```

También puedes insertar varios registros a la vez:

```sql
INSERT INTO alumnos (nombre, apellido, edad, correo) VALUES
('Juan', 'Lopez', 19, 'juan.lopez@unib.edu.ec'),
('Andrea', 'Mora', 22, 'andrea.mora@unib.edu.ec');
```

Consulta de verificación:

```sql
SELECT * FROM alumnos;
```

---

## 5️⃣ Comando UPDATE

### Sintaxis general

```sql
UPDATE nombre_tabla
SET columna1 = valor1, columna2 = valor2, ...
WHERE condición;
```

⚠️ **Importante:** siempre usar `WHERE` para evitar modificar todos los registros.

### Ejemplo

```sql
UPDATE alumnos
SET edad = 23
WHERE nombre = 'María';
```

Verificación:

```sql
SELECT * FROM alumnos WHERE nombre = 'María';
```

Ejemplo con más de un campo:

```sql
UPDATE alumnos
SET apellido = 'Pérez Andrade', correo = 'maria.perez@unib.ec'
WHERE id = 1;
```

---

## 6️⃣ Comando DELETE

### Sintaxis general

```sql
DELETE FROM nombre_tabla WHERE condición;
```

### Ejemplo

```sql
DELETE FROM alumnos WHERE nombre = 'Juan';
```

⚠️ Si omites el `WHERE`, se eliminarán **todos los registros**:

```sql
DELETE FROM alumnos; -- ¡Cuidado!
```

---

## 7️⃣ Comando SELECT

### Sintaxis general

```sql
SELECT columnas FROM tabla WHERE condición;
```

### Ejemplos

```sql
-- Todos los registros
SELECT * FROM alumnos;

-- Solo ciertos campos
SELECT nombre, edad FROM alumnos;

-- Filtros
SELECT * FROM alumnos WHERE edad > 20;

-- Ordenar
SELECT * FROM alumnos ORDER BY edad DESC;

-- Contar registros
SELECT COUNT(*) FROM alumnos;
```

---

## 8️⃣ Ejercicios prácticos guiados

1. Inserta 5 nuevos alumnos con diferentes edades.  
2. Actualiza el correo electrónico del alumno con `id = 3`.  
3. Elimina el alumno que tenga el nombre ‘Andrea’.  
4. Muestra solo los nombres y apellidos de los alumnos mayores de 20 años.  
5. Cuenta cuántos alumnos hay en total.  

---

## 9️⃣ Buenas prácticas con DML

- Usa **transacciones** cuando realices varias operaciones relacionadas:

```sql
BEGIN;
UPDATE alumnos SET edad = 22 WHERE id = 1;
DELETE FROM alumnos WHERE edad < 18;
COMMIT;
```

Si algo falla:

```sql
ROLLBACK;
```

- Valida siempre con un `SELECT` antes de un `DELETE` o `UPDATE`.  
- Usa restricciones (`CHECK`, `UNIQUE`, `NOT NULL`) para mantener integridad.  
- Usa `RETURNING *` en `INSERT`, `UPDATE` o `DELETE` para ver los cambios realizados:

```sql
UPDATE alumnos SET edad = edad + 1 RETURNING *;
```

---

## 🔟 Autoevaluación

1. ¿Qué comando se usa para insertar registros en una tabla?  
2. ¿Qué sucede si no colocas la cláusula `WHERE` en un `DELETE`?  
3. ¿Qué comando usarías para modificar el correo de un alumno específico?  
4. ¿Qué diferencia hay entre DDL y DML?  
5. Escribe un ejemplo de sentencia `UPDATE` con dos columnas modificadas.

---

## 🧩 Desafío adicional

Crea una tabla llamada `cursos`:

```sql
CREATE TABLE cursos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    creditos INT
);
```

- Inserta 3 cursos.  
- Actualiza el número de créditos de uno de ellos.  
- Elimina un curso.  
- Muestra todos los cursos restantes.

---

## 📚 Conclusión

El **lenguaje DML** es esencial para cualquier aplicación que maneje datos.  
Dominar `INSERT`, `UPDATE`, `DELETE` y `SELECT` te permitirá interactuar de manera eficaz con bases de datos PostgreSQL y crear aplicaciones dinámicas basadas en datos reales.

---

**Autor:** Byron Moreno 
