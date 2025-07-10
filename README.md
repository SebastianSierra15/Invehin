# 🏩 INVEHIN – Sistema de Gestión de Ventas e Inventario

INVEHIN es un sistema de información web desarrollado para **tiendas de ropa**, que permite gestionar usuarios, ventas, clientes, proveedores, inventario, pedidos y reportes, entre otras funcionalidades. Construido en Java utilizando Servlets, JSP y MySQL.
Este sistema se encuentra actualmente en desarrollo activo y en proceso de mejora continua.

---

## 🚀 Tecnologías utilizadas

&#x20;  &#x20;

- Java 21
- JSP & Servlets
- Apache Tomcat
- MySQL 8
- JDBC
- Apache POI & iTextPDF para reportes

---

## 📄 Documentación

- [📸 Capturas del sistema](docs/Capturas.md)
- [🧠 Manual técnico (desarrolladores)](docs/ManualTecnico.md)
- [👥 Manual de usuario (uso del sistema)](docs/ManualUsuario.md)
- [🧑 Autores y créditos](docs/Autores.md)

---

## ⚙️ Instalación rápida

### 🔧 Requisitos

- Java JDK 21
- Apache Tomcat 10 o superior
- MySQL 8
- NetBeans o IDE compatible con Ant
- Navegador moderno

### 🧪 Pasos

1. Clona este repositorio:
   ```bash
   git clone https://github.com/SebastianSierra15/Invehin.git
   ```
2. Crea la base de datos ejecutando el archivo SQL ubicado en:
   ```
   sql/DB_INVEHIN.sql
   ```
3. Ajusta tus credenciales en el archivo:
   ```
   src/java/Entidades/DBConexion.java
   ```
4. Ejecuta el proyecto en NetBeans o exporta el `.war` y despliega en Tomcat.
5. Accede al sistema desde el navegador:
   ```
   http://localhost:8080/Invehin
   ```

---

## 💥 Vistas principales

| Dashboard                         | Listado de Prendas                      | Registrar Venta                |
|------------------------------|--------------------------------|--------------------------------|
| ![Dashboard](assets/dashboard.png)   | ![Dashboard](assets/listado-prendas.png) | ![Registrar Venta](assets/registrar-venta.png) |

---

## 📩 Contacto

Proyecto desarrollado por [Sebastián Sierra](docs/Autores.md).\
Para más información o colaboración: [sebsirra13@gmail.com](mailto\:sebsirra13@gmail.com)

---

## 📜 Licencia

Este proyecto está realizado como un ejercicio de desarrollo y consolidación de habilidades en el diseño de sistemas de información empresariales.

### Términos y Condiciones

El uso de este software está permitido únicamente con fines educativos y no comerciales. El proyecto es de **código abierto**, pero se prohíbe su uso con fines comerciales sin una **autorización expresa** de los autores.

### Licencia

Este proyecto se distribuye bajo la **Licencia Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0)**.

#### Condiciones principales de la licencia CC BY-NC 4.0:

1. **Uso del código**: Puedes usar, modificar y distribuir el código **siempre que sea con fines no comerciales**.
2. **Propiedad intelectual**: El software no transfiere derechos de propiedad intelectual, y se mantiene la autoría de los desarrolladores.
3. **Distribución**: Si distribuyes el código, debes incluir un archivo de licencia que detalle los términos de la **Licencia CC BY-NC 4.0**.
4. **Marca registrada**: El uso de la marca o nombre del proyecto está prohibido sin permiso por escrito.

### Limitación de responsabilidad

El proyecto se ofrece "tal cual" y no ofrece garantías explícitas ni implícitas de ningún tipo. Los autores no se hacen responsables de ningún daño, pérdida o inconveniente resultante del uso del software.

Para más detalles sobre la licencia, consulta el archivo completo en [Creative Commons BY-NC 4.0 License](https://creativecommons.org/licenses/by-nc/4.0/) o el archivo [**`LICENSE.txt`**](LICENSE.txt) incluido en este repositorio.
