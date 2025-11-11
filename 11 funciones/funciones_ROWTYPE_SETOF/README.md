# 🧩 Uso de `%ROWTYPE` y `SETOF` en funciones de PostgreSQL

## 🎯 Objetivo
Explicar cómo devolver resultados de una tabla en una función PL/pgSQL sin tener que listar todas las columnas manualmente, utilizando `%ROWTYPE` y `SETOF`.

---

## 🧠 Concepto

En PostgreSQL, cuando una función debe devolver filas completas de una tabla (por ejemplo, `customers`), existen varias formas de definir el tipo de retorno:

1. **RETURNS TABLE(...)**  
   Se define manualmente cada columna y su tipo de dato.
2. **RETURNS SETOF customers**  
   Se indica que la función devolverá varias filas del tipo `customers`.
3. **RETURNS SETOF customers%ROWTYPE**  
   Se usa la estructura de la tabla `customers` como plantilla para el tipo de fila.

---

## 🧩 Ejemplo práctico con `%TABLE`

```sql
CREATE OR REPLACE FUNCTION saludar3()
RETURNS TABLE (
    customer_id varchar,
    company_name varchar,
    contact_name varchar,
    contact_title varchar,
    address varchar,
    city varchar,
    region varchar,
    postal_code varchar,
    country varchar,
    phone varchar,
    fax varchar
)
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM customers;
END;
$$ LANGUAGE plpgsql;

```

### 🧪 Prueba

```sql
SELECT * FROM saludar3();
--O
SELECT saludar3();
```

✅ Resultado: Devuelve todas las filas y columnas de la tabla `customers`, igual que un `SELECT * FROM customers;`, pero dentro de una función.

---

## 🧩 Ejemplo práctico con `%ROWTYPE`

```sql
CREATE OR REPLACE FUNCTION saludar4()
RETURNS SETOF customers
AS $$
DECLARE
    fila customers%ROWTYPE;
BEGIN
    FOR fila IN SELECT * FROM customers LOOP
        RETURN NEXT fila;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;

```

### 🧪 Prueba

```sql
SELECT saludar4();
```

✅ Resultado: Devuelve todas las filas y columnas de la tabla `customers`, igual que un `SELECT * FROM customers;`, pero dentro de una función.

---

## 💡 Explicación línea por línea

- `RETURNS SETOF customers%ROWTYPE`  
  Indica que la función devolverá **un conjunto de filas** con la misma estructura (columnas y tipos) que la tabla `customers`.

- `RETURN QUERY`  
  Ejecuta la consulta interna (`SELECT * FROM customers`) y devuelve su resultado.

- `LANGUAGE plpgsql`  
  Especifica que la función está escrita en el lenguaje procedural de PostgreSQL.

---

## 🔍 Diferencias clave

| Forma | Ejemplo | Ventaja |
|--------|----------|----------|
| `RETURNS TABLE(...)` | Define cada columna manualmente | Mayor control, útil para personalizar el retorno |
| `RETURNS SETOF customers` | Usa directamente el tipo de la tabla | Limpio y legible |
| `RETURNS SETOF customers%ROWTYPE` | Usa la estructura de la tabla | Ideal cuando no existe un tipo de tabla explícito |

---

## 🧭 Recomendación

En la mayoría de los casos, usar:

```sql
RETURNS SETOF customers
```

es la forma más clara y práctica, ya que PostgreSQL entiende que el tipo `customers` representa la estructura completa de esa tabla.

---

## 🏁 Conclusión

El uso de `%ROWTYPE` y `SETOF` permite crear funciones **más simples, reutilizables y mantenibles**, evitando definir manualmente cada columna.  
Estas herramientas son fundamentales para trabajar con funciones que retornan consultas completas o subconjuntos de datos en PostgreSQL.
