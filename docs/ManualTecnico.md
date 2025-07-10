
# 🧠 Manual Técnico – INVEHIN

## 🛠️ Requisitos del Proyecto

Este proyecto está construido usando las siguientes tecnologías:

- **Java 21** para el desarrollo backend.
- **JSP & Servlets** para la arquitectura web.
- **Apache Tomcat** como servidor web.
- **MySQL 8** para la base de datos.
- **JDBC** para la conexión entre el backend y la base de datos.
- **Apache POI & iTextPDF** para la generación de reportes en formato Excel y PDF.

## 📂 Estructura del Proyecto

El proyecto está organizado en las siguientes carpetas:

- **`src/`**: Contiene todo el código fuente de Java.
    - **`Entidades/`**: Clases que representan las entidades del sistema.
    - **`Interfaces/`**: Interfaces que definen los contratos del sistema.
    - **`Logica/`**: Clases de la lógica del negocio.
    - **`servlets/`**: Contiene los servlets para manejar las peticiones HTTP.
    - **`Utils/`**: Clases auxiliares y utilidades.
- **`sql/`**: Contiene los scripts SQL para la creación de la base de datos y sus procedimientos.
- **`web/`**: Archivos JSP y otros recursos para la interfaz de usuario.

## 💻 Instalación

1. Clona el repositorio:

   ```bash
   git clone https://github.com/SebastianSierra15/Invehin.git
   ```

2. Crea la base de datos ejecutando el script SQL ubicado en:

   ```
   sql/DB_INVEHIN.sql
   ```

3. Ajusta las credenciales de la base de datos en el archivo:

   ```
   src/java/Entidades/DBConexion.java
   ```

4. Ejecuta el proyecto en NetBeans o despliega el archivo `.war` en Apache Tomcat.

## 🚀 Contribuciones

Si deseas contribuir al proyecto, por favor sigue estos pasos:

1. Realiza un fork del proyecto.
2. Crea una rama con tu funcionalidad o corrección de errores.
3. Realiza un pull request explicando los cambios realizados.

## 🧑‍💻 Clases Importantes

Algunas clases clave del sistema incluyen:

- **`ECategoria.java`**: Representa las categorías de productos.
- **`ECliente.java`**: Representa a los clientes.
- **`EVenta.java`**: Representa las ventas realizadas en el sistema.

Para más detalles, revisa el código en el repositorio.

## 📊 Generación de Reportes

Este sistema utiliza **Apache POI** y **iTextPDF** para la generación de reportes en formato **Excel** y **PDF**, lo cual se gestiona en las clases dentro del paquete `Utils/GeneradorReportes`.

---

Si tienes alguna pregunta sobre cómo contribuir o sobre el código, no dudes en ponerte en contacto con el equipo de desarrollo.
