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
- [🧠 Manual técnico (desarrolladores)](docs/ManualTecnico.md) *(próximamente)*
- [👥 Manual de usuario (uso del sistema)](docs/ManualUsuario.md) *(próximamente)*
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

| Login                         | Dashboard                      | Registrar Venta                |
|------------------------------|--------------------------------|--------------------------------|
| ![Login](assets/login.png)   | ![Dashboard](assets/dashboard.png) | ![Registrar Venta](assets/registrar-venta.png) |

---

## 📩 Contacto

Proyecto desarrollado por [Sebastián Sierra](docs/Autores.md).\
Para más información o colaboración: [sebsirra13@gmail.com](mailto\:sebsirra13@gmail.com)

---

## 📜 Licencia

Proyecto realizado como ejercicio de desarrollo y consolidación de habilidades en el diseño de sistemas de información empresariales.\
Se prohíbe su uso con fines comerciales sin autorización expresa.
