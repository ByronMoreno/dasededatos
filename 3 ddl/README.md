# 🧠 Clase: Lenguaje DDL (Data Definition Language) en PostgreSQL

## 🎯 Objetivo
Comprender qué es el **Lenguaje de Definición de Datos (DDL)** en PostgreSQL, su función dentro del modelo relacional y cómo se utilizan sus principales **comandos SQL** para crear, modificar y eliminar estructuras de base de datos.

---

## 📘 1. ¿Qué es DDL?

**DDL (Data Definition Language)** es el conjunto de comandos SQL utilizados para **definir la estructura de la base de datos**, es decir:

- Crear bases de datos, esquemas y tablas.  
- Definir relaciones, claves y restricciones.  
- Modificar o eliminar estructuras existentes.

En PostgreSQL, los comandos DDL se ejecutan de forma **inmediata y automática**, ya que se confirman al instante (no requieren `COMMIT`).

---

## 🏗️ 2. Principales Comandos DDL en PostgreSQL

El orden lógico de uso en el diseño de una base de datos es el siguiente:

| Orden | Comando | Descripción |
|:--:|:--|:--|
| 1️⃣ | `CREATE DATABASE` | Crea una nueva base de datos |
| 2️⃣ | `CREATE SCHEMA` | Crea un esquema dentro de la base de datos |
| 3️⃣ | `CREATE TABLE` | Crea una tabla con columnas y tipos de datos |
| 4️⃣ | `ALTER TABLE` | Modifica la estructura de una tabla existente |
| 5️⃣ | `DROP TABLE` | Elimina una tabla |
| 6️⃣ | `TRUNCATE` | Elimina todos los datos de una tabla |
| 7️⃣ | `COMMENT ON` | Añade comentarios a objetos de la base de datos |
| 8️⃣ | `CREATE INDEX` | Crea índices para optimizar búsquedas |
| 9️⃣ | `DROP INDEX` | Elimina índices existentes |
| 🔟 | `CREATE SEQUENCE` / `ALTER SEQUENCE` | Crea o modifica secuencias numéricas |
| 11️⃣ | `DROP SEQUENCE` | Elimina secuencias |
| 12️⃣ | `CREATE VIEW` / `DROP VIEW` | Crea o elimina vistas (consultas almacenadas) |

---

## 🧩 3. Comando `CREATE DATABASE`

Crea una nueva base de datos.

```sql
CREATE DATABASE colegio
WITH OWNER = postgres
ENCODING = 'UTF8'
LC_COLLATE = 'es_ES.UTF-8'
LC_CTYPE = 'es_ES.UTF-8'
TEMPLATE = template0;
```

*Conectarse a la base creada:*
```sql
\c colegio
```

---

## 🧱 4. Comando `CREATE SCHEMA`

```sql
CREATE SCHEMA academico AUTHORIZATION postgres;
```

*Uso de esquema en consultas:*
```sql
SELECT * FROM academico.estudiantes;
```

---

## 🧾 5. Comando `CREATE TABLE`

Crea una tabla dentro de un esquema o base de datos.

### 🔹 Sintaxis básica
```sql
CREATE TABLE nombre_tabla (
    nombre_columna tipo_dato [restricciones],
    ...
);
```

### 🔹 Ejemplo completo con todos los constraints
```sql
CREATE TABLE academico.estudiantes (
    id SERIAL PRIMARY KEY, -- Clave primaria
    nombre VARCHAR(50) NOT NULL, -- No nulo
    apellido VARCHAR(50) NOT NULL,
    edad INTEGER CHECK (edad >= 0), -- Restricción CHECK
    correo VARCHAR(100) UNIQUE, -- Restricción UNIQUE
    activo BOOLEAN DEFAULT TRUE, -- Valor por defecto
    grupo_id INT REFERENCES academico.grupos(id), -- Clave foránea
    CONSTRAINT edad_maxima CHECK (edad <= 120), -- Constraint con nombre
    CONSTRAINT correo_unico UNIQUE (correo) -- Constraint con nombre
);
```

### 🔹 Crear tabla a partir de una consulta (`CREATE TABLE ... AS`)
```sql
CREATE TABLE estudiantes_adultos AS
SELECT id, nombre, apellido, edad
FROM academico.estudiantes
WHERE edad >= 18;
```

💡 La tabla resultante **hereda los datos**, pero no los constraints ni claves de la tabla original.

---

## 🔐 6. Tipos de Constraints en PostgreSQL

| Constraint | Descripción | Ejemplo |
|------------|------------|---------|
| `PRIMARY KEY` | Identificador único de fila | `id SERIAL PRIMARY KEY` |
| `FOREIGN KEY` | Relación con otra tabla | `grupo_id INT REFERENCES grupos(id)` |
| `UNIQUE` | Valores únicos en columna | `correo VARCHAR(100) UNIQUE` |
| `NOT NULL` | No permite valores nulos | `nombre VARCHAR(50) NOT NULL` |
| `CHECK` | Validación de condición | `CHECK (edad >= 0)` |
| `DEFAULT` | Valor por defecto | `activo BOOLEAN DEFAULT TRUE` |
| `EXCLUDE` | Restricción de exclusión avanzada | `EXCLUDE USING gist (campo WITH =)` |

---

## 🧱 7. Comando `ALTER TABLE`

```sql
-- Agregar columna
ALTER TABLE academico.estudiantes ADD COLUMN telefono VARCHAR(15);

-- Cambiar tipo de dato
ALTER TABLE academico.estudiantes ALTER COLUMN edad TYPE SMALLINT;

-- Renombrar columna
ALTER TABLE academico.estudiantes RENAME COLUMN nombre TO nombres;

-- Eliminar columna
ALTER TABLE academico.estudiantes DROP COLUMN telefono;

-- Agregar constraint
ALTER TABLE academico.estudiantes ADD CONSTRAINT edad_minima CHECK (edad >= 5);
```

---

## ❌ 8. Comando `DROP TABLE`

```sql
DROP TABLE IF EXISTS academico.cursos CASCADE;
```

💡 `CASCADE` elimina dependencias automáticamente.

---

## 🧹 9. Comando `TRUNCATE`

```sql
TRUNCATE TABLE academico.estudiantes RESTART IDENTITY CASCADE;
```

💡 Borra todos los datos y reinicia contadores de secuencia.

---

## 🗒️ 10. Comando `COMMENT ON`

```sql
COMMENT ON TABLE academico.estudiantes IS 'Tabla de estudiantes del módulo académico';
COMMENT ON COLUMN academico.estudiantes.nombre IS 'Nombre completo del estudiante';
```

---

## ⚙️ 11. Comando `CREATE INDEX`

```sql
CREATE INDEX idx_estudiantes_nombre ON academico.estudiantes (nombre);
CREATE UNIQUE INDEX idx_estudiantes_correo ON academico.estudiantes (correo);
```

```sql
-- Eliminar índice
DROP INDEX idx_estudiantes_nombre;
```

---

## 🔢 12. Secuencias

```sql
CREATE SEQUENCE seq_factura START 1 INCREMENT 1;

ALTER SEQUENCE seq_factura RESTART WITH 1000;

DROP SEQUENCE seq_factura;
```

---

## 🔍 13. Vistas

```sql
CREATE VIEW vista_estudiantes AS
SELECT nombre, apellido, correo
FROM academico.estudiantes
WHERE edad >= 18;

SELECT * FROM vista_estudiantes;

DROP VIEW vista_estudiantes;
```

---

## 🧾 14. Buenas Prácticas DDL

- Usar **nombres claros y consistentes**.  
- Definir **constraints** desde el inicio.  
- Mantener **comentarios con COMMENT ON**.  
- Separar módulos mediante **schemas**.  
- Guardar los DDL en archivos `.sql` para **versionamiento**.  

---

## 📊 15. Resumen de Comandos DDL en PostgreSQL

| Comando | Función Principal |
|----------|-----------------|
| `CREATE DATABASE` | Crear base de datos |
| `CREATE SCHEMA` | Crear esquema |
| `CREATE TABLE` | Crear tabla |
| `ALTER TABLE` | Modificar tabla |
| `DROP TABLE` | Eliminar tabla |
| `TRUNCATE` | Vaciar tabla |
| `COMMENT ON` | Documentar objeto |
| `CREATE INDEX` | Crear índice |
| `DROP INDEX` | Eliminar índice |
| `CREATE SEQUENCE` | Crear secuencia |
| `ALTER SEQUENCE` | Modificar secuencia |
| `DROP SEQUENCE` | Eliminar secuencia |
| `CREATE VIEW` | Crear vista |
| `DROP VIEW` | Eliminar vista |
