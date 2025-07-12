<%-- 
    Document   : roles
    Created on : 18/06/2025, 11:48:52 a. m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Logica.Usuario"%>
<%@page import="Logica.Rol"%>
<%@page import="Logica.Permiso"%>
<%@page import="java.util.List"%>
<%@ page import="com.google.gson.Gson" %>

<%
    if (session.getAttribute("sesion") == null)
    {
        response.sendRedirect(request.getContextPath() + "/Views/login/login.jsp");
        return;
    }

    Usuario sesion = (Usuario) session.getAttribute("sesion");

    boolean puedeVerRoles = false;
    boolean puedeAgregarRol = false;
    boolean puedeEditarRol = false;
    boolean puedeEliminarRol = false;

    for (var permiso : sesion.rolUsuario.permisosRol)
    {
        switch (permiso.idPermiso)
        {
            case 5:
                puedeVerRoles = true;
                break;
            case 14:
                puedeAgregarRol = true;
                break;
            case 22:
                puedeEditarRol = true;
                break;
            case 30:
                puedeEliminarRol = true;
                break;
        }
    }

    if (!puedeVerRoles)
    {
        response.sendRedirect(request.getContextPath() + "/Views/sin-permiso.jsp");
        return;
    }
%>

<%
    Gson gson = new Gson();

    // Recibir resultado de paginación
    List<Rol> roles = (List<Rol>) request.getAttribute("roles");
    int totalRoles = (int) request.getAttribute("totalRoles");

    // Recibir paginación actual
    int numPage = (request.getAttribute("numPage") != null) ? (Integer) request.getAttribute("numPage") : 1;
    int pageSize = (request.getAttribute("pageSize") != null) ? (Integer) request.getAttribute("pageSize") : 10;

    // Para paginación
    int totalPaginas = (int) Math.ceil((double) totalRoles / pageSize);
    int maxPaginas = 8;
    int inicio = Math.max(1, numPage - maxPaginas / 2);
    int fin = Math.min(totalPaginas, inicio + maxPaginas - 1);
    inicio = Math.max(1, fin - maxPaginas + 1);

    // Datos estáticos
    List<Permiso> permisos = (List<Permiso>) request.getAttribute("permisos");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Roles - INVEHIN</title>

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

    <body class="bg-invehin-background font-sans flex flex-col overflow-x-hidden" data-totalroles="<%= totalRoles%>">
        <%@ include file="/components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col min-h-screen flex-1 px-4 py-6 md:p-8 ml-20 sm:ml-64 transition-all duration-300 gap-2">
            <h1 class="text-invehin-primary font-bold text-3xl text-center mb-10">Gestión de Roles</h1>

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
                        <button onclick="<%= puedeAgregarRol ? "abrirModalAgregar()" : "alert('No tienes permiso para agregar roles.')"%>"
                                class="bg-invehin-primary text-white font-medium px-4 py-1 rounded shadow hover:bg-invehin-primaryLight transition whitespace-nowrap">
                            <i class="fas fa-plus mr-2"></i>Agregar Rol
                        </button>
                    </div>
                </div>

                <div class="w-full flex flex-col sm:flex-row justify-between items-center gap-2 sm:gap-4 w-auto">
                    <%
                        int desde = (int) ((numPage - 1) * pageSize + 1);
                        int hasta = Math.min(numPage * pageSize, totalRoles);
                    %>
                    <div id="resumenRoles" class="text-dark text-sm w-full">
                        Mostrando <%= totalRoles > 0 ? desde : 0%> a <%= hasta%> de <%= totalRoles%> roles
                    </div>

                    <div class="relative w-full">
                        <input id="searchInput" type="search" placeholder="Buscar rol..." class="w-full pl-10 pr-4 py-1 rounded-md shadow-md bg-white border border-gray-300 outline-none" />
                        <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
                    </div>
                </div>
            </section>

            <!-- Tabla -->
            <div class="overflow-x-auto w-full">
                <table class="w-full text-sm text-left bg-invehin-accentLight rounded-lg border-separate border-spacing-0 overflow-hidden">
                    <caption class="sr-only">Tabla de roles</caption>
                    <thead class="bg-invehin-primary text-white">
                        <tr>
                            <th class="px-3 py-2 border border-white">ID</th>
                            <th class="px-3 py-2 border border-white">Nombre</th>
                            <th class="px-3 py-2 border border-white">Permisos Asignados</th>
                            <th class="px-3 py-2 border border-white text-center">Editar</th>
                            <th class="px-3 py-2 border border-white text-center">Eliminar</th>
                        </tr>
                    </thead>

                    <tbody id="rolesFiltrados" class="bg-pink-100">
                        <%
                            if (roles != null && !roles.isEmpty())
                            {
                                for (Rol rol : roles)
                                {
                        %>
                        <tr>
                            <td class="px-3 py-2 border border-white"><%= rol.idRol%></td>
                            <td class="px-3 py-2 border border-white"><%= rol.nombreRol%></td>
                            <td class="px-3 py-2 border border-white"><%= rol.permisosRol.stream().map(p -> p.nombrePermiso).collect(java.util.stream.Collectors.joining(", "))%> </td>
                            <td class="px-3 py-2 border border-white text-center">
                                <% if (puedeEditarRol)
                                    {%>
                                <!-- botón normal -->
                                <button title="Editar rol" class="text-blue-600 hover:text-blue-500 transition editar-rol-btn"
                                        data-id="<%= rol.idRol%>"
                                        data-nombre="<%= rol.nombreRol%>"
                                        data-permisos='<%= gson.toJson(rol.permisosRol)%>'>
                                    <i class="fas fa-edit"></i>
                                </button>
                                <% } else
                                { %>
                                <!-- botón deshabilitado con alerta -->
                                <button title="Sin permiso" onclick="alert('No tienes permiso para editar roles.')" class="text-blue-300 cursor-not-allowed" disabled>
                                    <i class="fas fa-edit"></i>
                                </button>
                                <% }%>
                            </td>
                            <td title="Eliminar rol" class="px-3 py-2 border border-white text-center">
                                <% if (puedeEliminarRol)
                                    {%>
                                <!-- botón normal -->
                                <button class="text-red-600 hover:text-red-500 transition eliminar-rol-btn"
                                        data-id="<%= rol.idRol%>">
                                    <i class="fas fa-trash"></i>
                                </button>
                                <% } else
                                { %>
                                <!-- botón deshabilitado con alerta -->
                                <button title="Sin permiso" onclick="alert('No tienes permiso para eliminar roles.')" class="text-red-300 cursor-not-allowed" disabled>
                                    <i class="fas fa-trash"></i>
                                </button>
                                <% } %>
                            </td>
                        </tr>
                        <%
                            }
                        } else
                        {
                        %>
                        <tr>
                            <td colspan="8" class="text-center text-gray-500 py-3">No se encontraron roles.</td>
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

        <!-- Modal agregar rol -->
        <div id="modalAgregarRol" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Agregar Rol</h2>
                    <button onclick="cerrarModalAgregar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formAgregarRol" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <div class="flex flex-col gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="agregarNombre" class="block font-semibold text-black">Nombre</label>
                            <input id="agregarNombre" name="nombre" type="text" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Nombre del rol" required />
                        </div>

                        <div class="mb-4">
                            <label class="block font-semibold text-black mb-1">Permisos</label>
                            <div class="grid grid-cols-2 gap-2 max-h-48 overflow-y-auto border border-gray-300 p-2 rounded">
                                <% if (permisos != null && !permisos.isEmpty())
                                    { %>
                                <% for (Permiso permiso : permisos)
                                    {%>
                                <label class="flex items-center space-x-2">
                                    <input type="checkbox" name="permisos" value="<%= permiso.idPermiso%>" class="permiso-checkbox-agregar" />
                                    <span><%= permiso.nombrePermiso%></span>
                                </label>
                                <% } %>
                                <% }%>
                            </div>
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalAgregar()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnAgregarRol" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Agregar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal confirmación agregar rol -->
        <div id="modalConfirmarAgregar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar registro</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas agregar el rol?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarAgregar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarAgregarRol" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal edición de rol -->
        <div id="modalEditarRol" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Editar Rol</h2>

                    <button onclick="cerrarModalEditar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <form id="formEditarRol" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <input type="hidden" id="editarRolId" type="number" />

                    <div class="flex flex-col gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="editarNombre" class="block font-semibold text-black">Nombre</label>
                            <input id="editarNombre" name="nombre" type="text" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Nombre del rol" required />
                        </div>

                        <div class="mb-4">
                            <label class="block font-semibold text-black mb-1">Permisos</label>
                            <div class="grid grid-cols-2 gap-2 max-h-48 overflow-y-auto border border-gray-300 p-2 rounded">
                                <% if (permisos != null && !permisos.isEmpty())
                                    { %>
                                <% for (Permiso permiso : permisos)
                                    {%>
                                <label class="flex items-center space-x-2">
                                    <input type="checkbox" name="permisos" value="<%= permiso.idPermiso%>" class="permiso-checkbox-editar" />
                                    <span><%= permiso.nombrePermiso%></span>
                                </label>
                                <% } %>
                                <% }%>
                            </div>
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalEditar()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnGuardarRol" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal confirmación editar rol -->
        <div id="modalConfirmarEditar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar edición</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas editar el rol?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEditar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEditarRol" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal confirmación eliminar rol -->
        <div id="modalConfirmarEliminar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar eliminación</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas eliminar el rol?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEliminar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEliminarRol" class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 text-sm">Eliminar</button>
                </div>
            </div>
        </div>
    </body>

    <script>
        let currentPage = <%= numPage%>;
        let pageSize = <%= pageSize%>;
        let totalRoles = <%= totalRoles%>;
        let searchTimeout = null;
        let datosRolesEditado = null;
        let datosRolNuevo = null;

        document.addEventListener("DOMContentLoaded", () => {
            cargarRoles();

            document.getElementById("searchInput").addEventListener("input", () => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    currentPage = 1;
                    cargarRoles();
                }, 300);
            });

            document.getElementById("pageSizeSelect").addEventListener("change", (e) => {
                pageSize = parseInt(e.target.value);
                currentPage = 1;
                cargarRoles();
            });
        });

        document.addEventListener("click", function (e) {
            if (e.target.closest(".editar-rol-btn")) {
                const btn = e.target.closest(".editar-rol-btn");

                document.getElementById("editarRolId").value = btn.dataset.id;
                document.getElementById("editarNombre").value = btn.dataset.nombre;

                // Limpiar todos los checkboxes primero
                document.querySelectorAll(".permiso-checkbox-editar").forEach(cb => cb.checked = false);

                // Marcar los permisos existentes
                const permisos = JSON.parse(btn.dataset.permisos);
                permisos.forEach(p => {
                    const checkbox = document.querySelector('.permiso-checkbox-editar[value="' + p.idPermiso + '"]');
                    if (checkbox)
                        checkbox.checked = true;
                });

                document.getElementById("modalEditarRol").classList.remove("hidden");
                document.body.classList.add("overflow-hidden");
            } else if (e.target.closest(".eliminar-rol-btn")) {
                const btn = e.target.closest(".eliminar-rol-btn");
                const id = btn.dataset.id;

                document.getElementById("confirmarEliminarRol").dataset.id = id;
                document.getElementById("modalConfirmarEliminar").classList.remove("hidden");
                document.body.classList.add("overflow-hidden");
            }
        });

        document.getElementById("cancelarConfirmarAgregar").addEventListener("click", function () {
            document.getElementById("modalConfirmarAgregar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("confirmarAgregarRol").addEventListener("click", function () {
            fetch("Roles", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: datosRolNuevo.toString()
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert(data.mensaje);
                            cerrarModalAgregar();
                            cargarRoles();
                        } else {
                            alert("Error: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al registrar rol", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarAgregar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("cancelarConfirmarEditar").addEventListener("click", function () {
            document.getElementById("modalConfirmarEditar").classList.add("hidden");
        });

        document.getElementById("confirmarEditarRol").addEventListener("click", function () {
            fetch("Roles", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(datosRolEditado)
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Rol actualizado correctamente.");
                            cerrarModalEditar();
                            cargarRoles();
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

        document.getElementById("cancelarConfirmarEliminar").addEventListener("click", function () {
            document.getElementById("modalConfirmarEliminar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("confirmarEliminarRol").addEventListener("click", function () {
            const id = this.dataset.id;

            fetch("Roles", {
                method: "DELETE",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({idRol: id})
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Rol eliminado correctamente.");
                            cargarRoles();
                        } else {
                            alert("Error al eliminar: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al eliminar rol", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarEliminar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("formAgregarRol").addEventListener("submit", function (e) {
            e.preventDefault();

            const nombre = document.getElementById("agregarNombre").value;
            const checkboxes = document.querySelectorAll(".permiso-checkbox-agregar:checked");

            if (checkboxes.length === 0) {
                alert("Debes seleccionar al menos un permiso.");
                return;
            }

            const permisosSeleccionados = [];

            checkboxes.forEach(cb => {
                permisosSeleccionados.push({id: parseInt(cb.value)});
            });

            datosRolNuevo = new URLSearchParams();
            datosRolNuevo.append("nombreRol", nombre);
            datosRolNuevo.append("permisosRolJson", JSON.stringify(permisosSeleccionados));

            document.getElementById("modalConfirmarAgregar").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        });

        document.getElementById("formEditarRol").addEventListener("submit", function (e) {
            e.preventDefault();

            const checkboxes = document.querySelectorAll(".permiso-checkbox-editar:checked");
            const permisosSeleccionados = [];

            checkboxes.forEach(cb => {
                permisosSeleccionados.push({
                    id: parseInt(cb.value)
                });
            });

            datosRolEditado = {
                idRol: document.getElementById("editarRolId").value,
                nombreRol: document.getElementById("editarNombre").value,
                permisosRolJson: JSON.stringify(permisosSeleccionados)
            };

            document.getElementById("modalConfirmarEditar").classList.remove("hidden");
        });

        function irAPagina(nuevaPagina) {
            currentPage = nuevaPagina;
            cargarRoles();
        }

        function cargarRoles() {
            const searchTerm = document.getElementById("searchInput").value.trim();

            fetch("Roles?modo=ajax&searchTerm=" + encodeURIComponent(searchTerm) + "&numPage=" + currentPage + "&pageSize=" + pageSize).then(res => res.text()).then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");

                const nuevaTabla = doc.querySelector("#rolesFiltrados");
                const resumen = doc.querySelector("#resumenRoles").textContent;
                const nuevaPaginacion = doc.querySelector("nav[aria-label='Paginación']");

                document.querySelector("#rolesFiltrados").innerHTML = nuevaTabla.innerHTML;
                document.querySelector("#resumenRoles").textContent = resumen;
                document.querySelector("nav[aria-label='Paginación']").innerHTML = nuevaPaginacion.innerHTML;

                // actualizar totalRoles si el servlet lo recalcula
                totalRoles = parseInt(doc.querySelector("body").dataset.totalroles) || totalRoles;
            }).catch(err => console.error("Error cargando roles", err));
        }

        function abrirModalAgregar() {
            document.getElementById("agregarNombre").value = "";
            document.querySelectorAll(".permiso-checkbox-agregar").forEach(cb => cb.checked = false);

            document.getElementById("modalAgregarRol").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }

        function cerrarModalAgregar() {
            document.getElementById("modalAgregarRol").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function cerrarModalEditar() {
            document.getElementById("modalEditarRol").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }
    </script>
</html>
