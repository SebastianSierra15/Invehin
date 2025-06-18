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
%>

<!DOCTYPE html>
<html  lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Perfil - INVEHIN</title>

        <link rel="icon" type="image/x-icon" href="<%= request.getContextPath()%>/favicon.ico">

        <!-- Importar fuente desde Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        fontFamily: {
                            sans: ['Poppins', 'sans-serif']
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

    <body class="bg-invehin-background font-sans flex flex-col overflow-x-hidden">
        <%@ include file="/components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col flex-1 px-4 py-6 md:p-8 ml-20 sm:ml-64 transition-all duration-300 gap-4 sm:gap-10">
            <h1 class="text-invehin-primary font-bold text-3xl text-center">Perfil de Usuario</h1>

            <div class="mx-auto max-w-4xl bg-invehin-accentLight border-2 border-black rounded-2xl shadow-lg p-6 sm:p-8">
                <form id="formActualizarDatos" class="flex flex-col sm:p-4 flex-1 gap-2 sm:gap-4">
                    <div class="grid sm:grid-cols-2 gap-2 sm:gap-x-6 sm:gap-y-4">
                        <input type="hidden" name="idUsuario" value="<%= sesion.idUsuario%>">
                        <input type="hidden" name="idPersona" value="<%= sesion.idPersona%>">

                        <div>
                            <label for="editarCorreo" class="text-black font-semibold block mb-1">Correo</label>
                            <input id="editarCorreo" type="email" name="correo" value="<%= sesion.getCorreoUsuario()%>" readonly
                                   class="w-full border border-black/50 rounded-md px-3 py-2 bg-invehin-accentLighter text-gray-500 cursor-not-allowed">
                        </div>

                        <div>
                            <label for="editarRol" class="text-black font-semibold block mb-1">Rol</label>
                            <input id="editarRol" type="text" name="rol" value="<%= sesion.rolUsuario != null ? sesion.rolUsuario.nombreRol : ""%>" readonly
                                   class="w-full border border-black/50 rounded-md px-3 py-2 bg-invehin-accentLighter text-gray-500 cursor-not-allowed">
                        </div>

                        <div>
                            <label for="editarNombres" class="text-black font-semibold block mb-1">Nombres</label>
                            <input id="editarNombres" type="text" name="nombres" value="<%= sesion.nombresPersona%>" required
                                   class="w-full border border-black/50 rounded-md px-3 py-2 bg-white">
                        </div>

                        <div>
                            <label for="editarApellidos" class="text-black font-semibold block mb-1">Apellidos</label>
                            <input id="editarApellidos" type="text" name="apellidos" value="<%= sesion.apellidosPersona%>" required
                                   class="w-full border border-black/50 rounded-md px-3 py-2 bg-white">
                        </div>

                        <div>
                            <label for="editarIdentificacion" class="text-black font-semibold block mb-1">Número de identificación</label>
                            <input id="editarIdentificacion" type="text" name="identificacion" value="<%= sesion.numeroidentificacionPersona%>" readonly
                                   class="w-full border border-black/50 rounded-md px-3 py-2 bg-invehin-accentLighter text-gray-500 cursor-not-allowed">
                        </div>

                        <div>
                            <label for="editarTelefono" class="text-black font-semibold block mb-1">Teléfono</label>
                            <input id="editarTelefono" type="text" name="telefono" value="<%= sesion.telefonoPersona%>"
                                   class="w-full border border-black/50 rounded-md px-3 py-2 bg-white">
                        </div>

                        <div>
                            <label for="editarGenero" class="text-black font-semibold block mb-1">Género</label>
                            <select id="editarGenero" name="genero"
                                    class="w-full border border-black/50 rounded-md px-3 py-2  bg-white">
                                <option value="true" <%= sesion.generoPersona ? "selected" : ""%>>Masculino</option>
                                <option value="false" <%= !sesion.generoPersona ? "selected" : ""%>>Femenino</option>
                            </select>
                        </div>
                    </div>

                    <div class="flex flex-col sm:flex-row justify-center sm:justify-between mt-8 gap-2">
                        <button id="cambiar-contrasenia-btn" type="button" onclick="abrirModalContrasenia()"
                                class="bg-gray-400 px-8 py-2 font-semibold rounded-lg hover:bg-gray-500 transition-all shadow-md">
                            Cambiar Contraseña
                        </button>
                        <button type="submit" onclick="abrirModalConfirmarDatos()"
                                class="bg-invehin-primary text-white px-8 py-2 font-semibold rounded-lg hover:bg-invehin-primaryLight transition-all shadow-md">
                            Guardar Cambios
                        </button>
                    </div>
                </form>
            </div>
        </main>

        <%@ include file="/components/footer.jsp" %>

        <!-- Modal Cambiar Contraseña -->
        <div id="modalContrasenia" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-sm max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Cambiar Contraseña</h2>
                    <button onclick="cerrarModalContrasenia()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formCambiarContrasenia" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <div class="flex flex-col gap-2 sm:gap-x-6 sm:gap-y-4">
                        <input type="hidden" id="contraseniaUsuarioId" type="number" value="<%= sesion.idUsuario%>" />

                        <div class="gap-1">
                            <label for="contraseniaActual" class="block font-semibold text-black">Contraseña actual</label>
                            <input id="contraseniaActual" type="password" name="correo" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" required />
                        </div>

                        <div class="gap-1">
                            <label for="contraseniaNueva" class="block font-semibold text-black">Contraseña nueva</label>
                            <input id="contraseniaNueva" type="password" name="correo" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" required />
                        </div>

                        <div class="gap-1">
                            <label for="contraseniaConfirmar" class="block font-semibold text-black">Confirmar contraseña nueva</label>
                            <input id="contraseniaConfirmar" type="password" name="correo" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" required />
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalContrasenia()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnCambiarContrasenia" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal Confirmación Actualizar Datos -->
        <div id="modalConfirmarDatos" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar cambios</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas modificar los campos?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarDatos" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarDatos" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal Confirmación de Contraseña -->
        <div id="modalConfirmarContrasenia" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar cambio</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas cambiar la contraseña?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarContrasenia" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarContrasenia" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>
    </body>

    <script>
        let datosUsuario = null;
        let datosContraseniaUsuario = null;

        document.getElementById("cancelarConfirmarDatos").addEventListener("click", function () {
            document.getElementById("modalConfirmarDatos").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("confirmarDatos").addEventListener("click", function () {
            fetch("Perfil", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: datosUsuario.toString()
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert(data.mensaje);
                            // Redirigir al logout
                            window.location.href = "Logout";
                        } else {
                            alert("Error: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al actualizar los datos", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarDatos").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("cancelarConfirmarContrasenia").addEventListener("click", function () {
            document.getElementById("modalConfirmarContrasenia").classList.add("hidden");
        });

        document.getElementById("confirmarContrasenia").addEventListener("click", function () {
            fetch("Perfil", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(datosContraseniaUsuario)
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Contraseña actualizada correctamente.");
                            cerrarModalContrasenia();
                        } else {
                            alert("Error al actualizar: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al enviar actualización:", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarContrasenia").classList.add("hidden");
        });

        document.getElementById("formActualizarDatos").addEventListener("submit", function (e) {
            e.preventDefault();

            const formData = new FormData(this);
            datosUsuario = new URLSearchParams(formData);

            document.getElementById("modalConfirmarDatos").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        });

        document.getElementById("formCambiarContrasenia").addEventListener("submit", function (e) {
            e.preventDefault();

            const contraseniaActual = document.getElementById("contraseniaActual").value.trim();
            const contraseniaNueva = document.getElementById("contraseniaNueva").value.trim();
            const contraseniaConfirmar = document.getElementById("contraseniaConfirmar").value.trim();

            if (contraseniaNueva !== contraseniaConfirmar) {
                alert("La contraseña nueva y la confirmación no coinciden.");
                return;
            }

            if (contraseniaNueva.length < 8) {
                alert("La contraseña debe tener mínimo 8 caracteres.");
                return;
            }

            datosContraseniaUsuario = {
                idUsuario: document.getElementById("contraseniaUsuarioId").value,
                contraseniaActual: document.getElementById("contraseniaActual").value,
                contraseniaNueva: document.getElementById("contraseniaNueva").value
            };

            document.getElementById("modalConfirmarContrasenia").classList.remove("hidden");
        });

        function abrirModalConfirmarDatos() {
            document.getElementById("modalConfirmarDatos").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }

        function abrirModalContrasenia() {
            document.getElementById("modalContrasenia").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }

        function cerrarModalContrasenia() {
            document.getElementById("modalContrasenia").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }
    </script>
</html>
