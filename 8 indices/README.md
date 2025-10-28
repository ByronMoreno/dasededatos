# 🧠 Clase práctica: Índices en PostgreSQL

Este taller te permite **experimentar de forma práctica** cómo los índices aceleran las consultas en PostgreSQL.

## 🎯 Objetivos

1. Crear una tabla con datos masivos.
2. Ejecutar consultas sin índice y medir su rendimiento.
3. Crear índices adecuados.
4. Volver a ejecutar las consultas y comparar resultados.

---

## 🧩 1. Crear la tabla de ejemplo

```sql
DROP TABLE IF EXISTS usuarios;
CREATE TABLE usuarios (
  id bigserial PRIMARY KEY,
  nombre text,
  apellido text,
  email text,
  creado_at timestamp without time zone
); 
```

## ⚙️ 2. Insertar miles o millones de filas
### Utilizamos la función ```sql generate_series()``` para generar datos de forma rápida.

```sql 
-- Inserta 1 millón de registros (ajusta el número si deseas menos)
INSERT INTO usuarios (nombre, apellido, email, creado_at)
SELECT
  'Nombre_' || (i % 1000) AS nombre,           -- genera 1000 nombres distintos
  'Apellido_' || (i % 500) AS apellido,        -- genera 500 apellidos distintos
  'user' || i || '@ejemplo.com' AS email,      -- crea un email único por registro
  NOW() - (i % 365) * INTERVAL '1 day' AS creado_at -- fechas aleatorias del último año
FROM generate_series(1, 1000000) AS s(i);      -- genera los números del 1 al 1,000,000
``` 
#### 💡 Si tu máquina tiene pocos recursos, empieza con generate_series(1,10000) o generate_series(1,100000).

## 🧹 3. Analizar y preparar las estadísticas
### Después de insertar muchos datos:
```sql 
VACUUM ANALYZE usuarios;
```
#### Esto actualiza las estadísticas del optimizador para obtener mediciones reales.

## 🧮 4. Medir la consulta antes del índice
### Activa el cronómetro en psql con `sql \timing `, luego ejecuta:

```sql
EXPLAIN ANALYZE
SELECT id, nombre, apellido, email, creado_at
FROM usuarios
WHERE apellido = 'Apellido_123'
ORDER BY creado_at DESC
LIMIT 100;
```

**Observa:**

- Si el plan indica **Seq Scan**, PostgreSQL recorre toda la tabla.  
- Anota el **Execution Time** para comparar luego.

## ⚡ 5. Crear distintos tipos de índices
### 🔹 Índice simple (columna de filtro)
```sql
CREATE INDEX idx_usuarios_apellido ON usuarios(apellido);
```
### 🔹 Índice compuesto (filtro + ordenamiento)
```sql
CREATE INDEX idx_usuarios_apellido_creado
ON usuarios(apellido, creado_at DESC);
```
**Ideal si filtras por apellido y ordenas por creado_at.**

### 🔹 Índice parcial (solo registros recientes)
```sql
CREATE INDEX idx_usuarios_recientes
ON usuarios(creado_at)
WHERE creado_at > now() - interval '30 days';
```

## 🧾 6. Volver a medir después del índice
```sql
VACUUM ANALYZE usuarios;

EXPLAIN ANALYZE
SELECT id, nombre, apellido, email, creado_at
FROM usuarios
WHERE apellido = 'Apellido_123'
ORDER BY creado_at DESC
LIMIT 100;
```

**Observa:**
- El plan ahora debería mostrar **Index Scan** o **Bitmap Index Scan**.  
- Compara el `Execution Time` con la primera medición.

## 🔁 7. Script completo de demostración
```sql
-- Script completo: Comparación de consultas con y sin índice

DROP TABLE IF EXISTS usuarios;
CREATE TABLE usuarios (
  id bigserial PRIMARY KEY,
  nombre text,
  apellido text,
  email text,
  creado_at timestamp without time zone
);

-- Insertar datos (100 mil registros)
INSERT INTO usuarios (nombre, apellido, email, creado_at)
SELECT 'Nombre_' || (i % 1000),
       'Apellido_' || (i % 500),
       'user' || i || '@ejemplo.com',
       NOW() - (i % 365) * INTERVAL '1 day'
FROM generate_series(1, 100000) AS s(i);

VACUUM ANALYZE usuarios;

-- Medición antes del índice
EXPLAIN ANALYZE
SELECT id, nombre, apellido, email, creado_at
FROM usuarios
WHERE apellido = 'Apellido_123'
ORDER BY creado_at DESC
LIMIT 100;

-- Crear índice compuesto
CREATE INDEX CONCURRENTLY idx_usuarios_apellido_creado
ON usuarios(apellido, creado_at DESC);

VACUUM ANALYZE usuarios;

-- Medición después del índice
EXPLAIN ANALYZE
SELECT id, nombre, apellido, email, creado_at
FROM usuarios
WHERE apellido = 'Apellido_123'
ORDER BY creado_at DESC
LIMIT 100;
```
