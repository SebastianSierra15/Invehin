<%-- 
    Document   : usuarios
    Created on : 15/06/2025, 8:42:10 p. m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Logica.Usuario"%>
<%@page import="Logica.Rol"%>
<%@page import="java.util.List"%>

<%
    if (session.getAttribute("sesion") == null)
    {
        response.sendRedirect(request.getContextPath() + "/Views/login/login.jsp");
        return;
    }

    Usuario sesion = (Usuario) session.getAttribute("sesion");

    boolean puedeVerUsuarios = false;
    boolean puedeAgregarUsuario = false;
    boolean puedeEditarUsuario = false;

    for (var permiso : sesion.rolUsuario.permisosRol)
    {
        switch (permiso.idPermiso)
        {
            case 3:
                puedeVerUsuarios = true;
                break;
            case 12:
                puedeAgregarUsuario = true;
                break;
            case 20:
                puedeEditarUsuario = true;
                break;
        }
    }

    if (!puedeVerUsuarios)
    {
        response.sendRedirect(request.getContextPath() + "/Views/sin-permiso.jsp");
        return;
    }
%>

<%
    // Recibir resultado de paginación
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    int totalUsuarios = (int) request.getAttribute("totalUsuarios");

    // Recibir paginación actual
    int numPage = (request.getAttribute("numPage") != null) ? (Integer) request.getAttribute("numPage") : 1;
    int pageSize = (request.getAttribute("pageSize") != null) ? (Integer) request.getAttribute("pageSize") : 10;

    // Para paginación
    int totalPaginas = (int) Math.ceil((double) totalUsuarios / pageSize);
    int maxPaginas = 8;
    int inicio = Math.max(1, numPage - maxPaginas / 2);
    int fin = Math.min(totalPaginas, inicio + maxPaginas - 1);
    inicio = Math.max(1, fin - maxPaginas + 1);

    List<Rol> roles = (List<Rol>) request.getAttribute("roles");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Usuarios - INVEHIN</title>

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

    <body class="bg-invehin-background font-sans flex flex-col overflow-x-hidden" data-totalusuarios="<%= totalUsuarios%>">
        <%@ include file="/components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col min-h-screen flex-1 px-4 py-6 md:p-8 ml-20 sm:ml-64 transition-all duration-300 gap-2">
            <h1 class="text-invehin-primary font-bold text-3xl text-center mb-10">Listado de Usuarios</h1>

            <!-- Filtros -->
            <section class="flex flex-col justify-between gap-2">
                <div class="w-full flex flex-wrap justify-between items-center gap-2 sm:gap-4">
                    <div class="flex items-center gap-2 w-full sm:w-auto">
                        <label for="pageSizeSelect" class="text-sm text-invehin-dark font-medium whitespace-nowrap">Mostrar:</label>
                        <select id="pageSizeSelect" class="border border-gray-300 rounded px-2 py-1 shadow-sm text-sm">
                            <option value="5" <%= pageSize == 10 ? "selected" : ""%>>5</option>
                            <option value="10" <%= pageSize == 10 ? "selected" : ""%>>10</option>
                            <option value="30" <%= pageSize == 30 ? "selected" : ""%>>30</option>
                            <option value="50" <%= pageSize == 50 ? "selected" : ""%>>50</option>
                            <option value="100" <%= pageSize == 100 ? "selected" : ""%>>100</option>
                        </select>
                    </div>

                    <div class="flex flex-col sm:flex-row w-full sm:w-auto sm:justify-between gap-2 text-sm">
                        <button onclick="<%= puedeAgregarUsuario ? "abrirModalAgregar()" : "alert('No tienes permiso para agregar usuarios.')"%>"
                                class="bg-invehin-primary text-white font-medium px-4 py-1 rounded shadow hover:bg-invehin-primaryLight transition whitespace-nowrap">
                            <i class="fas fa-plus mr-2"></i>Registrar Usuario
                        </button>
                    </div>
                </div>

                <div class="w-full flex flex-col sm:flex-row justify-between items-center gap-2 sm:gap-4 w-auto">
                    <%
                        int desde = (int) ((numPage - 1) * pageSize + 1);
                        int hasta = Math.min(numPage * pageSize, totalUsuarios);
                    %>
                    <div id="resumenUsuarios" class="text-dark text-sm w-full">
                        Mostrando <%= totalUsuarios > 0 ? desde : 0%> a <%= hasta%> de <%= totalUsuarios%> usuarios
                    </div>

                    <div class="relative w-full">
                        <input id="searchInput" type="search" placeholder="Buscar usuario..." class="w-full pl-10 pr-4 py-1 rounded-md shadow-md bg-white border border-gray-300 outline-none" />
                        <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
                    </div>
                </div>
            </section>

            <!-- Tabla -->
            <div class="overflow-x-auto w-full">
                <table class="w-full text-sm text-left bg-invehin-accentLight rounded-lg border-separate border-spacing-0 overflow-hidden">
                    <caption class="sr-only">Tabla de usuarios</caption>
                    <thead class="bg-invehin-primary text-white">
                        <tr>
                            <th class="px-3 py-2 border border-white">ID</th>
                            <th class="px-3 py-2 border border-white">Correo</th>
                            <th class="px-3 py-2 border border-white">Rol</th>
                            <th class="px-3 py-2 border border-white">Identificación</th>
                            <th class="px-3 py-2 border border-white">Nombres</th>
                            <th class="px-3 py-2 border border-white">Apellidos</th>
                            <th class="px-3 py-2 border border-white">Telefono</th>
                            <th class="px-3 py-2 border border-white">Género</th>
                            <th class="px-3 py-2 border border-white">Estado</th>
                            <th class="px-3 py-2 border border-white text-center">Editar</th>
                        </tr>
                    </thead>

                    <tbody id="usuariosFiltrados" class="bg-pink-100">
                        <%
                            if (usuarios != null && !usuarios.isEmpty())
                            {
                                for (Usuario usuario : usuarios)
                                {
                        %>
                        <tr>
                            <td class="px-3 py-2 border border-white"><%= usuario.idUsuario%></td>
                            <td class="px-3 py-2 border border-white"><%= usuario.getCorreoUsuario()%></td>
                            <td class="px-3 py-2 border border-white"><%= usuario.rolUsuario.nombreRol%></td>
                            <td class="px-3 py-2 border border-white"><%= usuario.numeroidentificacionPersona%></td>
                            <td class="px-3 py-2 border border-white"><%= usuario.nombresPersona%></td>
                            <td class="px-3 py-2 border border-white"><%= usuario.apellidosPersona%></td>
                            <td class="px-3 py-2 border border-white"><%= usuario.telefonoPersona%></td>
                            <td class="px-3 py-2 border border-white"><%= (usuario.generoPersona ? "Masculino" : "Femenino")%></td>
                            <td class="px-3 py-2 border border-white"><%= (usuario.estadoUsuario ? "Activo" : "Inactivo")%></td>
                            <td class="px-3 py-2 border border-white text-center">
                                <% if (puedeEditarUsuario)
                                    {%>
                                <!-- botón normal -->
                                <button title="Editar usuario" class="text-blue-600 hover:text-blue-500 transition editar-usuario-btn"
                                        data-id="<%= usuario.idUsuario%>"
                                        data-correo="<%= usuario.getCorreoUsuario()%>"
                                        data-rol="<%= usuario.rolUsuario.idRol%>"
                                        data-estado="<%= usuario.estadoUsuario%>"
                                        data-idpersona="<%= usuario.idPersona%>"
                                        data-identificacion="<%= usuario.numeroidentificacionPersona%>"
                                        data-nombres="<%= usuario.nombresPersona%>"
                                        data-apellidos="<%= usuario.apellidosPersona%>"
                                        data-telefono="<%= usuario.telefonoPersona%>"
                                        data-genero="<%= usuario.generoPersona%>">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <% } else
                                { %>
                                <!-- botón deshabilitado con alerta -->
                                <button title="Sin permiso" onclick="alert('No tienes permiso para editar usuarios.')" class="text-blue-300 cursor-not-allowed" disabled>
                                    <i class="fas fa-edit"></i>
                                </button>
                                <% }%>
                            </td>
                        </tr>
                        <%
                            }
                        } else
                        {
                        %>
                        <tr>
                            <td colspan="8" class="text-center text-gray-500 py-3">No se encontraron usuarios.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Paginación -->
            <div class="flex justify-center mt-6">
                <nav class="flex items-center border rounded overflow-hidden text-sm select-none" aria-label="Paginación">
                    <!-- Primera página -->
                    <button class="px-3 py-1 border-r text-invehin-primary hover:bg-gray-100" onclick="irAPagina(1)" title="Primera página">
                        <i class="fas fa-angle-double-left"></i>
                    </button>

                    <!-- Anterior -->
                    <button class="px-3 py-1 border-r text-invehin-primary hover:bg-gray-100"
                            onclick="irAPagina(<%= (numPage > 1 ? numPage - 1 : 1)%>)"
                            title="Anterior">
                        <i class="fas fa-angle-left"></i>
                    </button>

                    <!-- Páginas numeradas -->
                    <% for (int i = inicio; i <= fin; i++)
                        {%>
                    <button
                        class="px-3 py-1 border-r <%= (i == numPage) ? "bg-invehin-primary text-white font-bold" : "text-invehin-primary hover:bg-gray-100"%>"
                        onclick="irAPagina(<%= i%>)">
                        <%= i%>
                    </button>
                    <% }%>

                    <!-- Siguiente -->
                    <button class="px-3 py-1 border-r text-invehin-primary hover:bg-gray-100"
                            onclick="irAPagina(<%= (numPage < totalPaginas ? numPage + 1 : totalPaginas)%>)"
                            title="Siguiente">
                        <i class="fas fa-angle-right"></i>
                    </button>

                    <!-- Última página -->
                    <button class="px-3 py-1 text-invehin-primary hover:bg-gray-100"
                            onclick="irAPagina(<%= totalPaginas%>)"
                            title="Última página">
                        <i class="fas fa-angle-double-right"></i>
                    </button>
                </nav>
            </div>
        </main>

        <%@ include file="/components/footer.jsp" %>

        <!-- Modal agregar usuario -->
        <div id="modalAgregarUsuario" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Agregar Usuario</h2>
                    <button onclick="cerrarModalAgregar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formAgregarUsuario" action="Usuarios" method="POST" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <div class="grid sm:grid-cols-2 gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="agregarCorreo" class="block font-semibold text-black">Correo electrónico</label>
                            <input id="agregarCorreo" name="correo" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="correo@email.com" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarIdentificacion" class="block font-semibold text-black">Número de identificación</label>
                            <input id="agregarIdentificacion" name="identificacion" type="number" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Número de identificación" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarNombres" class="block font-semibold text-black">Nombres</label>
                            <input id="agregarNombres" name="nombres" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Nombres" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarApellidos" class="block font-semibold text-black">Apellidos</label>
                            <input id="agregarApellidos" name="apellidos" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Apellidos" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarRol" class="block font-semibold text-black">Rol</label>
                            <select id="agregarRol" name="rol" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <% if (roles != null && !roles.isEmpty())
                                    { %>
                                <% for (Rol rol : roles)
                                    {%>
                                <option value="<%= rol.idRol%>"><%= rol.nombreRol%></option>
                                <% } %>
                                <% }%>
                            </select>
                        </div>

                        <div class="gap-1">
                            <label for="agregarTelefono" class="block font-semibold text-black">Teléfono</label>
                            <input id="agregarTelefono" name="telefono" type="text" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="+57 312 345 6789" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarGenero" class="block font-semibold text-black">Género</label>
                            <select id="agregarGenero" name="genero" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <option value="true">Masculino</option>
                                <option value="false">Femenino</option>
                            </select>
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalAgregar()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnAgregarUsuario" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Agregar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal confirmación agregar usuario -->
        <div id="modalConfirmarAgregar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar registro</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas agregar el usuario?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarAgregar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarAgregarUsuario" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal de edición de usuario -->
        <div id="modalEditarUsuario" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Editar Usuario</h2>

                    <button onclick="cerrarModalEditar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formEditarUsuario" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <input type="hidden" id="editarUsuarioId" type="number" />
                    <input type="hidden" id="editarPersonaId" type="number" />

                    <div class="grid sm:grid-cols-2 gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="editarCorreo" class="block font-semibold text-black">Correo electrónico</label>
                            <input id="editarCorreo" name="nombres" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-gray-100 text-gray-700 cursor-not-allowed" placeholder="correo@email.com" readonly/>
                        </div>

                        <div class="gap-1">
                            <label for="editarIdentificacion" class="block font-semibold text-black">Número de identificación</label>
                            <input id="editarIdentificacion" name="identificacion" type="number" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Número de identificación" required />
                        </div>

                        <div class="gap-1">
                            <label for="editarNombres" class="block font-semibold text-black">Nombres</label>
                            <input id="editarNombres" name="nombres" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Nombres" required />
                        </div>

                        <div class="gap-1">
                            <label for="editarApellidos" class="block font-semibold text-black">Apellidos</label>
                            <input id="editarApellidos" name="apellidos" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Apellidos" required />
                        </div>

                        <div class="gap-1">
                            <label for="editarRol" class="block font-semibold text-black">Rol</label>
                            <select id="editarRol" name="rol" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <% if (roles != null && !roles.isEmpty())
                                    { %>
                                <% for (Rol rol : roles)
                                    {%>
                                <option value="<%= rol.idRol%>"><%= rol.nombreRol%></option>
                                <% } %>
                                <% }%>
                            </select>
                        </div>

                        <div class="gap-1">
                            <label for="editarTelefono" class="block font-semibold text-black">Teléfono</label>
                            <input id="editarTelefono" name="telefono" type="text" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="+57 312 345 6789" required />
                        </div>

                        <div class="gap-1">
                            <label for="editarGenero" class="block font-semibold text-black">Género</label>
                            <select id="editarGenero" name="genero" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <option value="true">Masculino</option>
                                <option value="false">Femenino</option>
                            </select>
                        </div>

                        <div class="gap-1">
                            <label for="editarEstado" class="block font-semibold text-black">Estado</label>
                            <select id="editarEstado" name="estado" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <option value="true">Activo</option>
                                <option value="false">Inactivo</option>
                            </select>
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalEditar()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnGuardarUsuario" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal confirmación editar usuario -->
        <div id="modalConfirmarEditar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar edición</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas editar el usuario?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEditar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEditarUsuario" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>
    </body>

    <script>
        let currentPage = <%= numPage%>;
        let pageSize = <%= pageSize%>;
        let totalUsuarios = <%= totalUsuarios%>;
        let searchTimeout = null;
        let datosUsuarioEditado = null;
        let datosUsuarioNuevo = null;

        document.addEventListener("DOMContentLoaded", () => {
            cargarUsuarios();

            document.getElementById("searchInput").addEventListener("input", () => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    currentPage = 1;
                    cargarUsuarios();
                }, 300);
            });

            document.getElementById("pageSizeSelect").addEventListener("change", (e) => {
                pageSize = parseInt(e.target.value);
                currentPage = 1;
                cargarUsuarios();
            });
        });

        document.addEventListener("click", function (e) {
            if (e.target.closest(".editar-usuario-btn")) {
                const btn = e.target.closest(".editar-usuario-btn");

                document.getElementById("editarUsuarioId").value = btn.dataset.id;
                document.getElementById("editarCorreo").value = btn.dataset.correo;
                document.getElementById("editarRol").value = btn.dataset.rol;
                document.getElementById("editarEstado").value = btn.dataset.estado;
                document.getElementById("editarPersonaId").value = btn.dataset.idpersona;
                document.getElementById("editarIdentificacion").value = btn.dataset.identificacion;
                document.getElementById("editarNombres").value = btn.dataset.nombres;
                document.getElementById("editarApellidos").value = btn.dataset.apellidos;
                document.getElementById("editarTelefono").value = btn.dataset.telefono;
                document.getElementById("editarGenero").value = btn.dataset.genero;

                document.getElementById("modalEditarUsuario").classList.remove("hidden");
                document.body.classList.add("overflow-hidden");
            }
        });

        document.getElementById("cancelarConfirmarAgregar").addEventListener("click", function () {
            document.getElementById("modalConfirmarAgregar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("confirmarAgregarUsuario").addEventListener("click", function () {
            fetch("Usuarios", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: datosUsuarioNuevo.toString()
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert(data.mensaje);
                            cerrarModalAgregar();
                            cargarUsuarios();
                        } else {
                            alert("Error: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al registrar usuario", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarAgregar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("cancelarConfirmarEditar").addEventListener("click", function () {
            document.getElementById("modalConfirmarEditar").classList.add("hidden");
        });

        document.getElementById("confirmarEditarUsuario").addEventListener("click", function () {
            fetch("Usuarios", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(datosUsuarioEditado)
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Usuario actualizado correctamente.");
                            cerrarModalEditar();
                            cargarUsuarios();
                        } else {
                            alert("Error al actualizar: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al enviar actualización:", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarEditar").classList.add("hidden");
        });

        document.getElementById("formAgregarUsuario").addEventListener("submit", function (e) {
            e.preventDefault();

            const formData = new FormData(this);
            datosUsuarioNuevo = new URLSearchParams(formData);

            document.getElementById("modalConfirmarAgregar").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        });

        document.getElementById("formEditarUsuario").addEventListener("submit", function (e) {
            e.preventDefault();

            datosUsuarioEditado = {
                idUsuario: document.getElementById("editarUsuarioId").value,
                idRol: document.getElementById("editarRol").value,
                estadoUsuario: document.getElementById("editarEstado").value,
                idPersona: document.getElementById("editarPersonaId").value,
                nombresPersona: document.getElementById("editarNombres").value,
                apellidosPersona: document.getElementById("editarApellidos").value,
                identificacionPersona: document.getElementById("editarIdentificacion").value,
                telefonoPersona: document.getElementById("editarTelefono").value,
                generoPersona: document.getElementById("editarGenero").value
            };

            document.getElementById("modalConfirmarEditar").classList.remove("hidden");
        });

        function irAPagina(nuevaPagina) {
            currentPage = nuevaPagina;
            cargarUsuarios();
        }

        function cargarUsuarios() {
            const searchTerm = document.getElementById("searchInput").value.trim();

            fetch("Usuarios?modo=ajax&searchTerm=" + encodeURIComponent(searchTerm) + "&numPage=" + currentPage + "&pageSize=" + pageSize).then(res => res.text()).then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");

                const nuevaTabla = doc.querySelector("#usuariosFiltrados");
                const resumen = doc.querySelector("#resumenUsuarios").textContent;
                const nuevaPaginacion = doc.querySelector("nav[aria-label='Paginación']");

                document.querySelector("#usuariosFiltrados").innerHTML = nuevaTabla.innerHTML;
                document.querySelector("#resumenUsuarios").textContent = resumen;
                document.querySelector("nav[aria-label='Paginación']").innerHTML = nuevaPaginacion.innerHTML;

                // actualizar totalUsuarios si el servlet lo recalcula
                totalUsuarios = parseInt(doc.querySelector("body").dataset.totalusuarios) || totalUsuarios;
            }).catch(err => console.error("Error cargando usuarios", err));
        }

        function abrirModalAgregar() {
            document.getElementById("modalAgregarUsuario").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }

        function cerrarModalAgregar() {
            document.getElementById("modalAgregarUsuario").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function cerrarModalEditar() {
            document.getElementById("modalEditarUsuario").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }
    </script>
</html>
