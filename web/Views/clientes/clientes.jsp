<%-- 
    Document   : clientes
    Created on : 14/06/2025, 6:40:43 p. m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Logica.Cliente"%>
<%@page import="java.util.List"%>

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
        if (permiso.idPermiso == 4)
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

<%
    // Recibir resultado de paginación
    List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
    int totalClientes = (int) request.getAttribute("totalClientes");

    // Recibir paginación actual
    int numPage = (request.getAttribute("numPage") != null) ? (Integer) request.getAttribute("numPage") : 1;
    int pageSize = (request.getAttribute("pageSize") != null) ? (Integer) request.getAttribute("pageSize") : 10;

    // Para paginación
    int totalPaginas = (int) Math.ceil((double) totalClientes / pageSize);
    int maxPaginas = 8;
    int inicio = Math.max(1, numPage - maxPaginas / 2);
    int fin = Math.min(totalPaginas, inicio + maxPaginas - 1);
    inicio = Math.max(1, fin - maxPaginas + 1);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Clientes - INVEHIN</title>

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

    <body class="bg-invehin-background font-sans flex flex-col overflow-x-hidden" data-totalclientes="<%= totalClientes%>">
        <%@ include file="/components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col min-h-screen flex-1 px-4 py-6 md:p-8 md:pb-0 ml-20 sm:ml-64 transition-all duration-300 gap-2">
            <h1 class="text-invehin-primary font-bold text-3xl text-center mb-10">Listado de Clientes</h1>

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
                        <button onclick="abrirModalAgregar()" class="bg-invehin-primary text-white font-medium px-4 py-1 rounded shadow hover:bg-invehin-primaryLight transition whitespace-nowrap">
                            <i class="fas fa-plus mr-2"></i>Registrar Cliente
                        </button>
                    </div>
                </div>

                <div class="w-full flex flex-col sm:flex-row justify-between items-center gap-2 sm:gap-4 w-auto">
                    <%
                        int desde = (int) ((numPage - 1) * pageSize + 1);
                        int hasta = Math.min(numPage * pageSize, totalClientes);
                    %>
                    <div id="resumenClientes" class="text-dark text-sm w-full">
                        Mostrando <%= totalClientes > 0 ? desde : 0%> a <%= hasta%> de <%= totalClientes%> clientes
                    </div>

                    <div class="relative w-full">
                        <input id="searchInput" type="search" placeholder="Buscar cliente..." class="w-full pl-10 pr-4 py-1 rounded-md shadow-md bg-white border border-gray-300 outline-none" />
                        <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
                    </div>
                </div>
            </section>

            <!-- Tabla -->
            <div class="overflow-x-auto w-full">
                <table class="w-full text-sm text-left bg-invehin-accentLight rounded-lg border-separate border-spacing-0 overflow-hidden">
                    <caption class="sr-only">Tabla de clientes</caption>
                    <thead class="bg-invehin-primary text-white">
                        <tr>
                            <th class="px-3 py-2 border border-white">ID</th>
                            <th class="px-3 py-2 border border-white">Identificación</th>
                            <th class="px-3 py-2 border border-white">Nombres</th>
                            <th class="px-3 py-2 border border-white">Apellidos</th>
                            <th class="px-3 py-2 border border-white">Fecha Registro</th>
                            <th class="px-3 py-2 border border-white">Telefono</th>
                            <th class="px-3 py-2 border border-white">Género</th>
                            <th class="px-3 py-2 border border-white">Dirección</th>
                            <th class="px-3 py-2 border border-white text-center">Editar</th>
                            <th class="px-3 py-2 border border-white text-center">Eliminar</th>
                        </tr>
                    </thead>

                    <tbody id="clientesFiltrados" class="bg-pink-100">
                        <%
                            if (clientes != null && !clientes.isEmpty())
                            {
                                for (Cliente cliente : clientes)
                                {
                        %>
                        <tr>
                            <td class="px-3 py-2 border border-white"><%= cliente.idCliente%></td>
                            <td class="px-3 py-2 border border-white"><%= cliente.numeroidentificacionPersona%></td>
                            <td class="px-3 py-2 border border-white"><%= cliente.nombresPersona%></td>
                            <td class="px-3 py-2 border border-white"><%= cliente.apellidosPersona%></td>
                            <td class="px-3 py-2 border border-white"><%= cliente.fecharegistroCliente%></td>
                            <td class="px-3 py-2 border border-white"><%= cliente.telefonoPersona%></td>
                            <td class="px-3 py-2 border border-white"><%= (cliente.generoPersona ? "Masculino" : "Femenino")%></td>
                            <td class="px-3 py-2 border border-white"><%= cliente.direccionCliente%></td>
                            <td class="px-3 py-2 border border-white text-center">
                                <button title="Editar cliente" class="text-blue-600 hover:text-blue-500 transition editar-cliente-btn"
                                        data-id="<%= cliente.idCliente%>"
                                        data-direccion="<%= cliente.direccionCliente%>"
                                        data-idpersona="<%= cliente.idPersona%>"
                                        data-identificacion="<%= cliente.numeroidentificacionPersona%>"
                                        data-nombres="<%= cliente.nombresPersona%>"
                                        data-apellidos="<%= cliente.apellidosPersona%>"
                                        data-telefono="<%= cliente.telefonoPersona%>"
                                        data-genero="<%= cliente.generoPersona%>">
                                    <i class="fas fa-edit"></i>
                                </button>
                            </td>
                            <td title="Eliminar cliente" class="px-3 py-2 border border-white text-center">
                                <button class="text-red-600 hover:text-red-500 transition eliminar-cliente-btn"
                                        data-id="<%= cliente.idCliente%>">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                        <%
                            }
                        } else
                        {
                        %>
                        <tr>
                            <td colspan="8" class="text-center text-gray-500 py-3">No se encontraron clientes.</td>
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

        <!-- Modal agregar cliente -->
        <div id="modalAgregarCliente" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Agregar Cliente</h2>
                    <button onclick="cerrarModalAgregar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formAgregarCliente" action="Clientes" method="POST" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <div class="grid sm:grid-cols-2 gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="agregarNombres" class="block font-semibold text-black">Nombres</label>
                            <input id="agregarNombres" name="nombres" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Nombres" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarApellidos" class="block font-semibold text-black">Apellidos</label>
                            <input id="agregarApellidos" name="apellidos" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Apellidos" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarIdentificacion" class="block font-semibold text-black">Número de identificación</label>
                            <input id="agregarIdentificacion" name="identificacion" type="number" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Número de identificación" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarTelefono" class="block font-semibold text-black">Teléfono</label>
                            <input id="agregarTelefono" name="telefono" type="text" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="+57 312 345 6789" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarDireccion" class="block font-semibold text-black">Dirección</label>
                            <input id="agregarDireccion" name="direccion" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Cra 1C bis..." required />
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
                        <button type="submit" id="btnAgregarCliente" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Agregar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal confirmación agregar cliente -->
        <div id="modalConfirmarAgregar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar registro</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas agregar el cliente?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarAgregar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarAgregarCliente" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal de edición de cliente -->
        <div id="modalEditarCliente" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Editar Cliente</h2>

                    <button onclick="cerrarModalEditar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formEditarCliente" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <input type="hidden" id="editarClienteId" type="number" />
                    <input type="hidden" id="editarPersonaId" type="number" />

                    <div class="grid sm:grid-cols-2 gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="editarNombres" class="block font-semibold text-black">Nombres</label>
                            <input id="editarNombres" name="nombres" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Nombres" required />
                        </div>

                        <div class="gap-1">
                            <label for="editarApellidos" class="block font-semibold text-black">Apellidos</label>
                            <input id="editarApellidos" name="apellidos" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Apellidos" required />
                        </div>

                        <div class="gap-1">
                            <label for="editarIdentificacion" class="block font-semibold text-black">Número de identificación</label>
                            <input id="editarIdentificacion" name="identificacion" type="number" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Número de identificación" required />
                        </div>

                        <div class="gap-1">
                            <label for="editarTelefono" class="block font-semibold text-black">Teléfono</label>
                            <input id="editarTelefono" name="telefono" type="text" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="+57 312 345 6789" required />
                        </div>

                        <div class="gap-1">
                            <label for="editarDireccion" class="block font-semibold text-black">Dirección</label>
                            <input id="editarDireccion" name="direccion" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Cra 1C bis..." required />
                        </div>

                        <div class="gap-1">
                            <label for="editarGenero" class="block font-semibold text-black">Género</label>
                            <select id="editarGenero" name="genero" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <option value="true">Masculino</option>
                                <option value="false">Femenino</option>
                            </select>
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalEditar()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnGuardarCliente" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal confirmación editar cliente -->
        <div id="modalConfirmarEditar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar edición</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas editar el cliente?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEditar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEditarCliente" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal confirmación eliminar cliente -->
        <div id="modalConfirmarEliminar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar eliminación</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas eliminar el cliente?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEliminar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEliminarCliente" class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 text-sm">Eliminar</button>
                </div>
            </div>
        </div>
    </body>

    <script>
        let currentPage = <%= numPage%>;
        let pageSize = <%= pageSize%>;
        let totalClientes = <%= totalClientes%>;
        let searchTimeout = null;
        let datosClienteEditado = null;
        let datosClienteNuevo = null;

        document.addEventListener("DOMContentLoaded", () => {
            cargarClientes();

            document.getElementById("searchInput").addEventListener("input", () => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    currentPage = 1;
                    cargarClientes();
                }, 300);
            });

            document.getElementById("pageSizeSelect").addEventListener("change", (e) => {
                pageSize = parseInt(e.target.value);
                currentPage = 1;
                cargarClientes();
            });
        });

        document.addEventListener("click", function (e) {
            if (e.target.closest(".editar-cliente-btn")) {
                const btn = e.target.closest(".editar-cliente-btn");

                document.getElementById("editarClienteId").value = btn.dataset.id;
                document.getElementById("editarDireccion").value = btn.dataset.direccion;
                document.getElementById("editarPersonaId").value = btn.dataset.idpersona;
                document.getElementById("editarIdentificacion").value = btn.dataset.identificacion;
                document.getElementById("editarNombres").value = btn.dataset.nombres;
                document.getElementById("editarApellidos").value = btn.dataset.apellidos;
                document.getElementById("editarTelefono").value = btn.dataset.telefono;
                document.getElementById("editarGenero").value = btn.dataset.genero;

                document.getElementById("modalEditarCliente").classList.remove("hidden");
                document.body.classList.add("overflow-hidden");
            }

            if (e.target.closest(".eliminar-cliente-btn")) {
                const btn = e.target.closest(".eliminar-cliente-btn");
                const id = btn.dataset.id;

                document.getElementById("confirmarEliminarCliente").dataset.id = id;
                document.getElementById("modalConfirmarEliminar").classList.remove("hidden");
                document.body.classList.add("overflow-hidden");
            }
        });

        document.getElementById("cancelarConfirmarAgregar").addEventListener("click", function () {
            document.getElementById("modalConfirmarAgregar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("confirmarAgregarCliente").addEventListener("click", function () {
            fetch("Clientes", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: datosClienteNuevo.toString()
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert(data.mensaje);
                            cerrarModalAgregar();
                            cargarClientes();
                        } else {
                            alert("Error: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al registrar cliente", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarAgregar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("cancelarConfirmarEditar").addEventListener("click", function () {
            document.getElementById("modalConfirmarEditar").classList.add("hidden");
        });

        document.getElementById("confirmarEditarCliente").addEventListener("click", function () {
            fetch("Clientes", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(datosClienteEditado)
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Cliente actualizado correctamente.");
                            cerrarModalEditar();
                            cargarClientes();
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

        document.getElementById("confirmarEliminarCliente").addEventListener("click", function () {
            const id = this.dataset.id;

            fetch("Clientes", {
                method: "DELETE",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({idCliente: id})
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Cliente eliminado correctamente.");
                            cargarClientes();
                        } else {
                            alert("Error al eliminar: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al eliminar cliente:", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarEliminar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("formAgregarCliente").addEventListener("submit", function (e) {
            e.preventDefault();

            const formData = new FormData(this);
            datosClienteNuevo = new URLSearchParams(formData);

            document.getElementById("modalConfirmarAgregar").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        });

        document.getElementById("formEditarCliente").addEventListener("submit", function (e) {
            e.preventDefault();

            datosClienteEditado = {
                idCliente: document.getElementById("editarClienteId").value,
                direccionCliente: document.getElementById("editarDireccion").value,
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
            cargarClientes();
        }

        function cargarClientes() {
            const searchTerm = document.getElementById("searchInput").value.trim();

            fetch("Clientes?searchTerm=" + encodeURIComponent(searchTerm) + "&numPage=" + currentPage + "&pageSize=" + pageSize).then(res => res.text()).then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");

                const nuevaTabla = doc.querySelector("#clientesFiltrados");
                const resumen = doc.querySelector("#resumenClientes").textContent;
                const nuevaPaginacion = doc.querySelector("nav[aria-label='Paginación']");

                document.querySelector("#clientesFiltrados").innerHTML = nuevaTabla.innerHTML;
                document.querySelector("#resumenClientes").textContent = resumen;
                document.querySelector("nav[aria-label='Paginación']").innerHTML = nuevaPaginacion.innerHTML;

                // actualizar totalClientes si el servlet lo recalcula
                totalClientes = parseInt(doc.querySelector("body").dataset.totalclientes) || totalClientes;
            }).catch(err => console.error("Error cargando clientes", err));
        }

        function abrirModalAgregar() {
            document.getElementById("modalAgregarCliente").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }

        function cerrarModalAgregar() {
            document.getElementById("modalAgregarCliente").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function cerrarModalEditar() {
            document.getElementById("modalEditarCliente").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }
    </script>
</html>
