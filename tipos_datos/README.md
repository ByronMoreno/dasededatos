# 🧠 Clase: Tipos de Datos en PostgreSQL

## 🎯 Objetivo
Comprender los principales tipos de datos que ofrece **PostgreSQL**, su finalidad, características y ejemplos de uso en la creación de tablas y manipulación de información.

---

## 🧩 1. Introducción

En PostgreSQL, los **tipos de datos** definen el tipo de valor que puede almacenarse en cada columna de una tabla.  
Elegir el tipo adecuado:
- Optimiza el **rendimiento**.  
- Mejora la **integridad de los datos**.  
- Reduce el **espacio de almacenamiento**.  

PostgreSQL es uno de los sistemas más completos en este aspecto, pues soporta tanto **tipos estándar SQL** como **tipos avanzados** (arrays, JSON, geográficos, etc.).

---

## 📘 2. Tipos de Datos Numéricos

### 🔹 Enteros

| Tipo | Tamaño | Rango | Descripción |
|------|---------|--------|-------------|
| `smallint` | 2 bytes | -32,768 a 32,767 | Enteros pequeños |
| `integer` o `int` | 4 bytes | -2,147,483,648 a 2,147,483,647 | Enteros comunes |
| `bigint` | 8 bytes | ±9 cuatrillones | Enteros grandes |

```sql
CREATE TABLE productos (
  id SERIAL PRIMARY KEY,
  stock INTEGER,
  unidades_vendidas BIGINT
);
```

---

### 🔹 Números decimales y reales

| Tipo | Precisión | Descripción |
|------|------------|-------------|
| `numeric(p, s)` o `decimal(p, s)` | Precisión arbitraria | Ideal para finanzas |
| `real` | 6 dígitos | Punto flotante simple |
| `double precision` | 15 dígitos | Punto flotante doble |

```sql
CREATE TABLE ventas (
  id SERIAL PRIMARY KEY,
  total NUMERIC(10, 2),
  descuento REAL,
  tasa_impuesto DOUBLE PRECISION
);
```

---

## 🗓️ 3. Tipos de Datos de Fecha y Hora

| Tipo | Descripción |
|------|--------------|
| `date` | Solo la fecha (AAAA-MM-DD) |
| `time` | Solo la hora (HH:MI:SS) |
| `timestamp` | Fecha y hora |
| `timestamptz` | Fecha y hora con zona horaria |
| `interval` | Duración o diferencia de tiempo |

```sql
CREATE TABLE eventos (
  id SERIAL PRIMARY KEY,
  fecha_inicio DATE,
  hora_inicio TIME,
  creado_en TIMESTAMPTZ DEFAULT NOW(),
  duracion INTERVAL
);
```

```sql
SELECT fecha_inicio + duracion AS fecha_fin FROM eventos;
```

---

## 🔠 4. Tipos de Datos de Texto

| Tipo | Descripción |
|------|--------------|
| `char(n)` | Longitud fija |
| `varchar(n)` | Longitud variable con límite |
| `text` | Longitud variable sin límite |

```sql
CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(50),
  identificacion CHAR(10),
  observaciones TEXT
);
```

💡 **Recomendación:**  
Usa `text` o `varchar` — son equivalentes en PostgreSQL, pero `text` es más flexible.

---

## 🧾 5. Tipos Booleanos

| Tipo | Valores posibles |
|------|------------------|
| `boolean` | `TRUE`, `FALSE`, `NULL` |

```sql
CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(50),
  activo BOOLEAN DEFAULT TRUE
);
```

---

## 💬 6. Tipos de Cadena Binaria

| Tipo | Descripción |
|------|--------------|
| `bytea` | Datos binarios (archivos, imágenes, documentos) |

```sql
CREATE TABLE archivos (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  contenido BYTEA
);
```

---

## 🌐 7. Tipos de Datos de Red

| Tipo | Ejemplo | Descripción |
|------|----------|-------------|
| `inet` | `'192.168.0.1'` | Dirección IPv4 o IPv6 |
| `cidr` | `'192.168.0.0/24'` | Red IP |
| `macaddr` | `'08:00:2b:01:02:03'` | Dirección MAC |

```sql
CREATE TABLE dispositivos (
  id SERIAL PRIMARY KEY,
  ip INET,
  red CIDR,
  mac MACADDR
);
```

---

## 📦 8. Tipos JSON y JSONB

| Tipo | Descripción |
|------|--------------|
| `json` | Texto sin indexar |
| `jsonb` | Binario optimizado para consultas |

```sql
CREATE TABLE pedidos (
  id SERIAL PRIMARY KEY,
  datos JSONB
);

INSERT INTO pedidos (datos)
VALUES ('{"cliente":"Juan","productos":["Pan","Leche"],"total":8.50}');
```

```sql
SELECT datos->>'cliente' AS cliente FROM pedidos;
```

---

## 🧰 9. Tipos Enumerados (ENUM)

Permiten definir **valores limitados**.

```sql
CREATE TYPE estado_pedido AS ENUM ('pendiente', 'enviado', 'entregado');

CREATE TABLE pedidos_estado (
  id SERIAL PRIMARY KEY,
  estado estado_pedido
);
```

---

## 🧮 10. Tipos de Datos de Matriz (Arrays)

Permiten almacenar **varios valores en una sola columna**.

```sql
CREATE TABLE cursos (
  id SERIAL PRIMARY KEY,
  estudiantes TEXT[]
);

INSERT INTO cursos (estudiantes)
VALUES ('{"Ana", "Luis", "Carlos"}');
```

```sql
SELECT estudiantes[1] AS primer_estudiante FROM cursos;
```

---

## 🗺️ 11. Tipos Geométricos

| Tipo | Descripción |
|------|--------------|
| `point` | Punto (x, y) |
| `line` | Línea infinita |
| `lseg` | Segmento de línea |
| `box` | Rectángulo |
| `circle` | Círculo |

```sql
CREATE TABLE ubicaciones (
  id SERIAL PRIMARY KEY,
  coordenadas POINT
);
```

---

## 🧠 12. Tipos de Datos Personalizados

PostgreSQL permite crear **tipos definidos por el usuario (UDT)**.

```sql
CREATE TYPE direccion AS (
  calle VARCHAR(50),
  ciudad VARCHAR(30),
  codigo_postal CHAR(6)
);

CREATE TABLE personas (
  id SERIAL PRIMARY KEY,
  domicilio direccion
);
```

---

## 🧩 13. Tipos de Identificadores

| Tipo | Descripción |
|------|--------------|
| `serial` | Entero autoincremental (4 bytes) |
| `bigserial` | Entero autoincremental (8 bytes) |
| `uuid` | Identificador único universal |

```sql
CREATE TABLE empleados (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nombre VARCHAR(50)
);
```

*(Para usar `gen_random_uuid()`, instala la extensión `pgcrypto`)*

---

## 💰 14. Tipos Monetarios

| Tipo | Descripción |
|------|--------------|
| `money` | Valores monetarios con formato local |

```sql
CREATE TABLE facturas (
  id SERIAL PRIMARY KEY,
  total MONEY
);
```

---

## 🧾 Conclusión

| Categoría | Ejemplos |
|------------|-----------|
| Numéricos | `int`, `bigint`, `numeric`, `real` |
| Texto | `char`, `varchar`, `text` |
| Fecha/Hora | `date`, `timestamp`, `interval` |
| Booleanos | `boolean` |
| JSON | `json`, `jsonb` |
| Binarios | `bytea` |
| Red | `inet`, `macaddr` |
| Enumerados | `ENUM` |
| Matrices | `int[]`, `text[]` |
| Geométricos | `point`, `circle`, `box` |
| Identificadores | `serial`, `uuid` |

---

**👨‍🏫 Nota para el docente:**  
Esta clase puede complementarse con ejercicios prácticos en PgAdmin o DBeaver, invitando a los estudiantes a **crear una tabla con al menos un campo de cada tipo** y realizar consultas básicas de inserción y selección.
