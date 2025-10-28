# 🧠 Tipos de Modelos de Bases de Datos: Lógico, Relacional y Físico

## 📘 Introducción

En el diseño de una base de datos, la información pasa por **diferentes niveles de representación**, desde la planeación conceptual hasta la implementación real en un sistema gestor.  
Estos niveles se conocen como **modelos de bases de datos**, y el orden correcto es el siguiente:

1. **Modelo Lógico (o Conceptual)**  
2. **Modelo Relacional**  
3. **Modelo Físico**

Cada uno cumple un propósito específico dentro del proceso de diseño, permitiendo construir bases de datos organizadas, seguras y eficientes.

---

## 🧩 1. Modelo Lógico (o Conceptual)

### 🔹 Definición
El **modelo lógico** es la **primera etapa del diseño de una base de datos**.  
Representa **qué información se almacenará** y **cómo se relacionan los datos** entre sí, sin preocuparse aún por el sistema gestor o los tipos de datos.

Se utiliza para comprender la **estructura general** de la información mediante **diagramas entidad-relación (E-R)** o **diagramas de clases**.

### 🔹 Características principales
- Representa las **entidades**, **atributos** y **relaciones**.  
- Tiene un **alto nivel de abstracción** (no depende del SGBD).  
- Sirve como **base para los siguientes modelos**.  
- Facilita la comunicación entre el analista, el diseñador y el usuario.

### 🔹 Ejemplo
Entidad: **Cliente**  
Atributos: `ID_Cliente`, `Nombre`, `Apellido`, `Correo`, `Teléfono`  
Relación: Un cliente puede realizar muchos pedidos (**1 a N**)

Representación simple:
```
CLIENTE (ID_Cliente, Nombre, Apellido, Correo, Teléfono)
PEDIDO (ID_Pedido, Fecha, Total, ID_Cliente)
```

---

## 🧮 2. Modelo Relacional

### 🔹 Definición
El **modelo relacional** es la **traducción del modelo lógico** a una estructura basada en **tablas relacionadas entre sí**.  
Cada entidad del modelo lógico se convierte en una **tabla**, y cada relación en una **clave foránea**.  

Este modelo fue propuesto por **Edgar F. Codd (1970)** y es el estándar más utilizado actualmente.

### 🔹 Características principales
- Los datos se organizan en **tablas (relaciones)** con **filas (tuplas)** y **columnas (atributos)**.  
- Usa el lenguaje **SQL (Structured Query Language)**.  
- Permite **integridad referencial** mediante claves primarias y foráneas.  
- Se mantiene independiente de los aspectos físicos del almacenamiento.

### 🔹 Ejemplo
**Tabla Cliente**
| id_cliente | nombre | apellido | correo | teléfono |
|-------------|---------|----------|--------|-----------|
| 1 | Ana | Torres | ana@gmail.com | 0999999999 |
| 2 | Juan | Pérez | juanp@gmail.com | 0988888888 |

**Tabla Pedido**
| id_pedido | fecha | total | id_cliente |
|------------|--------|--------|-------------|
| 101 | 2025-10-01 | 45.50 | 1 |
| 102 | 2025-10-05 | 30.00 | 2 |

Relación: cada **pedido** está asociado a un **cliente** mediante la clave foránea `id_cliente`.

---

## 🧱 3. Modelo Físico

### 🔹 Definición
El **modelo físico** es la **etapa final del diseño**, donde se especifica **cómo se almacenarán realmente los datos** dentro del sistema gestor de bases de datos (SGBD).  
Aquí se definen aspectos técnicos y de rendimiento.

### 🔹 Características principales
- Depende directamente del SGBD (MySQL, PostgreSQL, Oracle, etc.).  
- Define **tipos de datos**, **restricciones**, **índices** y **optimizaciones**.  
- Incluye consideraciones sobre **seguridad**, **rendimiento** y **almacenamiento**.  
- Permite implementar el diseño mediante sentencias **SQL DDL**.

### 🔹 Ejemplo (Código SQL)
```sql
CREATE TABLE Cliente (
  id_cliente SERIAL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  correo VARCHAR(100) UNIQUE,
  telefono VARCHAR(15)
);

CREATE TABLE Pedido (
  id_pedido SERIAL PRIMARY KEY,
  fecha DATE NOT NULL,
  total DECIMAL(10,2),
  id_cliente INT REFERENCES Cliente(id_cliente)
);
```

---

## 🔗 4. Secuencia correcta del diseño de base de datos

| Etapa | Modelo | Nivel de abstracción | Objetivo |
|--------|---------|----------------------|-----------|
| **1️⃣** | **Lógico (Conceptual)** | Alto | Identificar las entidades, atributos y relaciones. |
| **2️⃣** | **Relacional** | Medio | Representar los datos en tablas con claves y relaciones. |
| **3️⃣** | **Físico** | Bajo | Implementar el diseño real en un SGBD con tipos de datos y estructuras. |

---

## 🎓 Conclusiones

El proceso de diseño de una base de datos sigue una secuencia lógica y estructurada:

1. **Modelo Lógico:** define qué información se gestionará.  
2. **Modelo Relacional:** transforma esas entidades en tablas relacionadas.  
3. **Modelo Físico:** implementa el sistema con detalles técnicos.

Comprender este flujo permite diseñar bases de datos **claras, optimizadas y escalables**, garantizando una correcta gestión de la información y un mantenimiento eficiente en cualquier entorno profesional.
