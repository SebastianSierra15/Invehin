<%-- 
    Document   : perfil
    Created on : 3/06/2025, 3:25:17 p. m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Logica.Usuario"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<%
    if (session.getAttribute("sesion") == null)
    {
        response.sendRedirect(request.getContextPath() + "/Views/login/login.jsp");
        return;
    }

    Usuario sesion = (Usuario) session.getAttribute("sesion");

    boolean tienePermiso = false;
    for (var permiso : sesion.rolUsuario.permisosRol)
    {
        if (permiso.idPermiso == 8)
        {
            tienePermiso = true;
            break;
        }
    }

    if (!tienePermiso)
    {
        response.sendRedirect(request.getContextPath() + "/Views/sin-permiso.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html  lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Perfil - INVEHIN</title>

        <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/favicon.ico">
        
        <!-- Importar fuente desde Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        fontFamily: {
                            sans: ['Poppins', 'sans-serif'],
                        },
                        colors: {
                            invehin: {
                                primary: "#951556",
                                primaryDark: "#5e0e33",
                                primaryLight: "#c21b70",
                                primaryLighter: "#e387a3",

                                accent: "#e9b5d2",
                                accentDark: "#c792ae",
                                accentLight: "#f5dcea",
                                accentLighter: "#fdebf4",

                                background: "#fafbf7",
                                backgroundDark: "#d4d6cf",
                                backgroundLight: "#ffffff",
                                backgroundLighter: "#fefefb",

                                backgroundAlt: "#dd8eba",
                                backgroundAltDark: "#b26891",
                                backgroundAltLight: "#f0b9d4",
                                backgroundAltLighter: "#f8d2e4"
                            }
                        }
                    }
                }
            };
        </script>

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    </head>

    <body class="bg-invehin-background font-sans flex">
        <%@ include file="/components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col w-full max-w-full overflow-x-hidden  px-4 py-6 md:p-8 ml-20 sm:ml-64 transition-all duration-300 gap-4 sm:gap-10">
            <h1 class="text-invehin-primary font-bold text-3xl text-center">Perfil de Usuario</h1>

            <form action="${pageContext.request.contextPath}/ActualizarPerfil" method="post" class="max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-x-10 gap-y-6">

                <input type="hidden" name="idUsuario" value="<%= sesion.idUsuario%>">
                <input type="hidden" name="idPersona" value="<%= sesion.idPersona%>">

                <div>
                    <label class="text-invehin-primary font-semibold">Nombres</label>
                    <input type="text" name="nombres" value="<%= sesion.nombresPersona%>" required class="w-full border-b border-gray-300 focus:outline-none py-2 bg-transparent">
                </div>

                <div>
                    <label class="text-invehin-primary font-semibold">Apellidos</label>
                    <input type="text" name="apellidos" value="<%= sesion.apellidosPersona%>" required class="w-full border-b border-gray-300 focus:outline-none py-2 bg-transparent">
                </div>

                <div>
                    <label class="text-invehin-primary font-semibold">Correo</label>
                    <input type="email" name="correo" value="<%= sesion.getCorreoUsuario()%>" readonly class="w-full border-b border-gray-300 py-2 bg-transparent text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label class="text-invehin-primary font-semibold">Rol</label>
                    <input type="text" name="rol" value="<%= sesion.rol != null ? sesion.rol.nombreRol : ""%>" readonly class="w-full border-b border-gray-300 py-2 bg-transparent text-gray-500 cursor-not-allowed">
                </div>

                <div>
                    <label class="text-invehin-primary font-semibold">Teléfono</label>
                    <input type="text" name="telefono" value="<%= sesion.telefonoPersona%>" class="w-full border-b border-gray-300 focus:outline-none py-2 bg-transparent">
                </div>

                <div>
                    <label class="text-invehin-primary font-semibold">Género</label>
                    <select name="genero" class="w-full border-b border-gray-300 focus:outline-none py-2 bg-transparent">
                        <option value="true" <%= sesion.generoPersona ? "selected" : ""%>>Masculino</option>
                        <option value="false" <%= !sesion.generoPersona ? "selected" : ""%>>Femenino</option>
                    </select>
                </div>

                <div class="col-span-2 text-center mt-8">
                    <button type="submit" class="bg-invehin-primary text-white px-8 py-2 font-semibold rounded hover:bg-invehin-primaryLight transition">
                        Guardar Cambios
                    </button>
                </div>
            </form>
        </main>
    </body>
</html>
