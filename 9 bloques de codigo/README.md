# 📚 Guía Completa de Bloques de Código en PostgreSQL

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16+-blue.svg)
![PLpgSQL](https://img.shields.io/badge/PL%252FpgSQL-Advanced-green.svg)

## 📋 Tabla de Contenidos
- 🎯 Introducción
- 🚀 Bloques Anónimos
- 📦 Declaración de Variables
- 🎮 Estructuras de Control
- ⚠️ Manejo de Excepciones
- 🗃️ Consultas SQL en Bloques
- 📑 Cursores
- 💳 Transacciones
- ⚡ Ejemplos Avanzados
- 🏆 Mejores Prácticas
- 🔍 Depuración
- 📥 Descarga y Uso
- 📋 Requisitos

---

## 🎯 Introducción
### ¿Qué son los Bloques de Código? 🤔
Los bloques de código en PostgreSQL son estructuras PL/pgSQL que permiten ejecutar lógica procedural directamente en la base de datos. Existen dos tipos:

- 📝 **Bloques Anónimos:** Se ejecutan una vez y no se almacenan
- 💾 **Funciones/Procedimientos:** Se almacenan en la base de datos para reutilización

---

## 🚀 Bloques Anónimos
### Sintaxis Básica 📝
```sql
DO $$
[DECLARE
    declaraciones_de_variables]
BEGIN
    -- código ejecutable
    [EXCEPTION
        -- manejo de excepciones]
END $$;
```

### Ejemplos Prácticos 🛠️
```sql
-- 👋 Bloque simple
DO $$
BEGIN
    RAISE NOTICE '¡Hola, mundo desde PostgreSQL! 🌍';
END $$;

-- 🔢 Bloque con variables
DO $$
DECLARE
    contador INTEGER := 0;
    mensaje TEXT := 'Valor del contador: %';
BEGIN
    contador := contador + 1;
    RAISE NOTICE mensaje, contador;  -- ⚠️ ESTO DA ERROR
END $$;
```
---
# ✅ Soluciones Correctas: Bloques DO en PostgreSQL

## Opción 1: 🎯 String directo
```sql
DO $$
DECLARE
    contador INTEGER := 0;
BEGIN
    contador := contador + 1;
    RAISE NOTICE 'Valor del contador: %', contador;
END $$;
```

## Opción 2: 🔧 Concatenar variables
```sql
DO $$
DECLARE
    contador INTEGER := 0;
    mensaje TEXT;
BEGIN
    contador := contador + 1;
    mensaje := 'Valor del contador: ' || contador;
    RAISE NOTICE '%', mensaje;
END $$;
```

## Opción 3: 🛠️ Usar FORMAT()
```sql
DO $$
DECLARE
    contador INTEGER := 0;
    mensaje TEXT := 'Valor del contador: %';
    mensaje_final TEXT;
BEGIN
    contador := contador + 1;
    mensaje_final := FORMAT(mensaje, contador);
    RAISE NOTICE '%', mensaje_final;
END $$;
```

## Opción 4: ⚡ La más eficiente
```sql
DO $$
DECLARE
    contador INTEGER := 0;
BEGIN
    contador := contador + 1;
    RAISE NOTICE 'Valor del contador: %', contador;
END $$;
```

---

## 📦 Declaración de Variables
### Tipos de Datos Disponibles 🎨
```sql
DO $$
DECLARE
    -- 🔢 Números
    entero INTEGER := 100;
    decimal NUMERIC(10,2) := 999.99;

    -- 📝 Texto
    nombre VARCHAR(50) := 'Juan Pérez';
    descripcion TEXT;

    -- 📅 Fechas
    fecha_hoy DATE := CURRENT_DATE;
    fecha_completa TIMESTAMP := NOW();

    -- ✅ Booleanos
    es_activo BOOLEAN := TRUE;

    -- 🎯 Constantes
    PI CONSTANT NUMERIC := 3.14159;
BEGIN
    RAISE NOTICE 'Entero: %, Decimal: %, Nombre: %', 
        entero, decimal, nombre;
    RAISE NOTICE 'Fecha: %, Activo: %', fecha_hoy, es_activo;
END $$;
```

### Asignación de Valores 💰
```sql
DO $$
DECLARE
    total INTEGER;
    promedio NUMERIC;
BEGIN
    -- Asignación directa
    total := 150;

    -- Asignación desde consulta
    SELECT COUNT(*) INTO total FROM usuarios;

    -- Asignación con cálculo
    promedio := total / 10.0;

    RAISE NOTICE '📊 Total: %, Promedio: %', total, promedio;
END $$;
```

---

## 🎮 Estructuras de Control
### Condicional IF/ELSE 🔀
```sql
DO $$
DECLARE
    edad INTEGER := 25;
    categoria VARCHAR(20);
BEGIN
    IF edad < 18 THEN
        categoria := '👶 Menor';
    ELSIF edad BETWEEN 18 AND 65 THEN
        categoria := '👨‍💼 Adulto';
    ELSE
        categoria := '👴 Jubilado';
    END IF;

    RAISE NOTICE 'Categoría: %', categoria;
END $$;
```

### Condicional CASE 🎲
```sql
DO $$
DECLARE
    nota INTEGER := 85;
    calificacion VARCHAR(10);
BEGIN
    CASE 
        WHEN nota >= 90 THEN calificacion := '🎉 Excelente';
        WHEN nota >= 80 THEN calificacion := '👍 Muy Bueno';
        WHEN nota >= 70 THEN calificacion := '✅ Bueno';
        ELSE calificacion := '📝 Regular';
    END CASE;

    RAISE NOTICE 'Nota: %, Calificación: %', nota, calificacion;
END $$;
```

### Bucles 🔄

#### LOOP Básico
```sql
DO $$
DECLARE
    i INTEGER := 1;
    suma INTEGER := 0;
BEGIN
    LOOP
        suma := suma + i;
        i := i + 1;
        EXIT WHEN i > 5;
    END LOOP;

    RAISE NOTICE 'Suma: %', suma;
END $$;
```

#### Bucle WHILE
```sql
DO $$
DECLARE
    contador INTEGER := 1;
    resultado TEXT := '';
BEGIN
    WHILE contador <= 5 LOOP
        resultado := resultado || contador || ' ';
        contador := contador + 1;
    END LOOP;

    RAISE NOTICE 'Números: %', resultado;
END $$;
```

#### Bucle FOR
```sql
DO $$
DECLARE
    i INTEGER;
    cadena TEXT := '';
BEGIN
    FOR i IN 1..5 LOOP
        cadena := cadena || 'Número: ' || i || ', ';
    END LOOP;

    RAISE NOTICE 'Secuencia: %', cadena;
END $$;
```

---

## ⚠️ Manejo de Excepciones
### Bloque TRY-CATCH 🛡️
```sql
DO $$
DECLARE
    divisor INTEGER := 0;
    resultado NUMERIC;
BEGIN
    BEGIN
        resultado := 100 / divisor;
        RAISE NOTICE 'Resultado: %', resultado;
    EXCEPTION
        WHEN division_by_zero THEN
            RAISE NOTICE '❌ Error: División por cero no permitida';
            resultado := NULL;
        WHEN OTHERS THEN
            RAISE NOTICE '🚨 Error inesperado: %', SQLERRM;
    END;

    RAISE NOTICE 'Resultado final: %', resultado;
END $$;
```

### Excepciones Específicas 🎯
```sql
DO $$
DECLARE
    id_inexistente INTEGER := 99999;
    nombre_usuario VARCHAR;
BEGIN
    BEGIN
        SELECT nombre INTO nombre_usuario 
        FROM usuarios WHERE id = id_inexistente;

    EXCEPTION
        WHEN no_data_found THEN
            RAISE NOTICE '📭 Excepción: No se encontraron datos';
        WHEN too_many_rows THEN
            RAISE NOTICE '📦 Excepción: Demasiadas filas retornadas';
        WHEN unique_violation THEN
            RAISE NOTICE '🔑 Excepción: Violación de unicidad';
        WHEN foreign_key_violation THEN
            RAISE NOTICE '🔗 Excepción: Violación de clave foránea';
    END;
END $$;
```

---

## 🗃️ Consultas SQL en Bloques
### Consultas SELECT INTO 📥
```sql
DO $$
DECLARE
    total_usuarios INTEGER;
    usuario_nombre VARCHAR;
    usuario_fecha_registro DATE;
BEGIN
    -- Contar registros
    SELECT COUNT(*) INTO total_usuarios FROM usuarios;

    -- Obtener un registro específico
    SELECT nombre, fecha_registro INTO usuario_nombre, usuario_fecha_registro
    FROM usuarios WHERE id = 1;

    RAISE NOTICE '👥 Total usuarios: %', total_usuarios;
    RAISE NOTICE '👤 Usuario: %, Fecha: %', usuario_nombre, usuario_fecha_registro;
END $$;
```

### Operaciones DML ✏️
```sql
DO $$
DECLARE
    nuevo_id INTEGER;
    filas_afectadas INTEGER;
BEGIN
    -- INSERT con RETURNING
    INSERT INTO usuarios (nombre, email) 
    VALUES ('María García', 'maria@email.com')
    RETURNING id INTO nuevo_id;

    RAISE NOTICE '✅ Nuevo usuario creado con ID: %', nuevo_id;

    -- UPDATE
    UPDATE usuarios SET activo = FALSE 
    WHERE fecha_registro < '2020-01-01';
    GET DIAGNOSTICS filas_afectadas = ROW_COUNT;

    RAISE NOTICE '🔴 Usuarios desactivados: %', filas_afectadas;

    -- DELETE
    DELETE FROM usuarios_log WHERE fecha < CURRENT_DATE - INTERVAL '1 year';
    GET DIAGNOSTICS filas_afectadas = ROW_COUNT;

    RAISE NOTICE '🗑️ Registros antiguos eliminados: %', filas_afectadas;
END $$;
```

---

## 📑 Cursores
### Cursor Explícito 📖
```sql
DO $$
DECLARE
    usuario_record RECORD;
    usuario_cursor CURSOR FOR 
        SELECT id, nombre, email FROM usuarios WHERE activo = TRUE;
BEGIN
    OPEN usuario_cursor;

    LOOP
        FETCH usuario_cursor INTO usuario_record;
        EXIT WHEN NOT FOUND;

        RAISE NOTICE '🆔 ID: %, Nombre: %, Email: %', 
            usuario_record.id, usuario_record.nombre, usuario_record.email;
    END LOOP;

    CLOSE usuario_cursor;
END $$;
```

### Cursor con FOR 🔄
```sql
DO $$
DECLARE
    contador INTEGER := 0;
BEGIN
    FOR usuario IN 
        SELECT id, nombre FROM usuarios ORDER BY nombre LIMIT 5
    LOOP
        contador := contador + 1;
        RAISE NOTICE '👤 Usuario %: % (%)', contador, usuario.nombre, usuario.id;
    END LOOP;

    RAISE NOTICE '📊 Total usuarios mostrados: %', contador;
END $$;
```

---

## 💳 Transacciones
### Control Manual de Transacciones 🎛️
```sql
DO $$
DECLARE
    saldo_actual NUMERIC;
BEGIN
    BEGIN
        -- Verificar saldo
        SELECT saldo INTO saldo_actual FROM cuentas WHERE id = 1;

        IF saldo_actual >= 100 THEN
            -- Realizar transferencia
            UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;
            UPDATE cuentas SET saldo = saldo + 100 WHERE id = 2;

            -- Registrar transacción
            INSERT INTO transacciones (origen, destino, monto, fecha)
            VALUES (1, 2, 100, NOW());

            RAISE NOTICE '✅ Transferencia realizada exitosamente';
        ELSE
            RAISE EXCEPTION '❌ Saldo insuficiente';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '🚨 Error en transacción: %', SQLERRM;
    END;
END $$;
```

---

## ⚡ Ejemplos Avanzados
### Procesamiento por Lotes 📦
```sql
DO $$
DECLARE
    lote_size INTEGER := 100;
    offset_val INTEGER := 0;
    total_records INTEGER;
    processed INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO total_records FROM usuarios;

    RAISE NOTICE '🔄 Procesando % registros en lotes de %', total_records, lote_size;

    WHILE offset_val < total_records LOOP
        UPDATE usuarios 
        SET ultima_revision = NOW() 
        WHERE id IN (
            SELECT id FROM usuarios 
            ORDER BY id 
            LIMIT lote_size OFFSET offset_val
        );

        GET DIAGNOSTICS processed = ROW_COUNT;
        offset_val := offset_val + lote_size;

        RAISE NOTICE '📋 Procesados % registros, offset: %', processed, offset_val;

        -- Pequeña pausa para no sobrecargar el sistema
        PERFORM pg_sleep(0.1);
    END LOOP;

    RAISE NOTICE '🎉 Procesamiento por lotes completado';
END $$;
```

### Validación de Datos Compleja 🔍
```sql
DO $$
DECLARE
    usuario_id INTEGER := 1;
    usuario_email VARCHAR;
    es_valido BOOLEAN := TRUE;
    mensajes TEXT[] := '{}';
BEGIN
    SELECT email INTO usuario_email FROM usuarios WHERE id = usuario_id;

    IF usuario_email IS NULL THEN
        es_valido := FALSE;
        mensajes := array_append(mensajes, '❌ Usuario no encontrado');
    ELSE
        -- Validar formato de email
        IF usuario_email !~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$' THEN
            es_valido := FALSE;
            mensajes := array_append(mensajes, '📧 Formato de email inválido');
        END IF;

        -- Validar duplicados
        IF EXISTS (
            SELECT 1 FROM usuarios 
            WHERE email = usuario_email AND id != usuario_id
        ) THEN
            es_valido := FALSE;
            mensajes := array_append(mensajes, '🔑 Email ya existe en otro usuario');
        END IF;
    END IF;

    -- Mostrar resultados
    IF es_valido THEN
        RAISE NOTICE '✅ VALIDACIÓN EXITOSA: Email % es válido', usuario_email;
    ELSE
        RAISE NOTICE '❌ VALIDACIÓN FALLIDA: %', array_to_string(mensajes, ', ');
    END IF;
END $$;
```

---

## 🏆 Mejores Prácticas
### Optimización de Rendimiento ⚡
```sql
DO $$
DECLARE
    inicio TIMESTAMP;
    fin TIMESTAMP;
    duracion INTERVAL;
BEGIN
    inicio := clock_timestamp();

    -- Código a medir
    PERFORM pg_sleep(0.5);

    fin := clock_timestamp();
    duracion := fin - inicio;

    RAISE NOTICE '⏱️ Duración de ejecución: %', duracion;
END $$;
```

### Manejo Eficiente de Memória 💾
```sql
DO $$
DECLARE
    -- Usar tipos de datos apropiados
    id_small SMALLINT;
    nombre_corto VARCHAR(50);
    texto_grande TEXT;

    -- Arrays eficientes
    numeros INTEGER[] := ARRAY[1,2,3,4,5];
BEGIN
    -- Evitar SELECT * en bucles
    FOR i IN 1..array_length(numeros, 1) LOOP
        RAISE NOTICE '🔢 Procesando número: %', numeros[i];
    END LOOP;

    -- Usar EXISTS en lugar de COUNT(*)
    IF EXISTS(SELECT 1 FROM usuarios WHERE activo = TRUE) THEN
        RAISE NOTICE '✅ Hay usuarios activos';
    END IF;
END $$;
```

---

## 🔍 Depuración
### Técnicas de Logging 📝
```sql
DO $$
DECLARE
    debug BOOLEAN := TRUE;
    paso_actual VARCHAR;
    valor_actual INTEGER;
BEGIN
    paso_actual := 'Inicialización';
    IF debug THEN RAISE NOTICE '🔍 Paso: %', paso_actual; END IF;

    valor_actual := 10;
    IF debug THEN RAISE NOTICE '📊 Valor actual: %', valor_actual; END IF;

    paso_actual := 'Procesamiento';
    IF debug THEN RAISE NOTICE '🔍 Paso: %', paso_actual; END IF;

    valor_actual := valor_actual * 2;
    IF debug THEN RAISE NOTICE '📈 Nuevo valor: %', valor_actual; END IF;

    -- Diferentes niveles de logging
    RAISE LOG '📋 Este es un mensaje de log';
    RAISE INFO 'ℹ️ Información general';
    RAISE NOTICE '💡 Notificación importante';
    RAISE WARNING '⚠️ Advertencia';
END $$;
```

---

## 📥 Descarga y Uso
Para usar esta guía:

- 📥 Guarda este archivo como `README.md`
- 🐘 Conéctate a tu base de datos PostgreSQL
- ▶️ Copia y ejecuta los ejemplos que necesites
- 🔄 Modifica según tus necesidades específicas

---

## 📋 Requisitos
- PostgreSQL 11 o superior
- Lenguaje PL/pgSQL habilitado
- Permisos de ejecución en la base de datos

---

🎉 ¡Feliz Codificación!
¿Tienes preguntas? ¡Los bloques de código en PostgreSQL son poderosos y esta guía te ayudará a dominarlos! 🚀

📚 Documentación creada para desarrolladores PostgreSQL - ¡Comparte el conocimiento! 💫
