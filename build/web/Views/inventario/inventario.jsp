<%-- 
    Document   : inventario
    Created on : 4/07/2025, 2:48:23?p.?m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page import="Logica.Inventario"%>
<%@page import="Logica.Usuario"%>
<%@page import="com.google.gson.Gson" %>
<%@page import="java.util.List"%>
<%@page import="java.text.NumberFormat"%>

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
        if (permiso.idPermiso == 11)
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
    List<Inventario> inventarios = (List<Inventario>) request.getAttribute("inventarios");
    int totalInventarios = (int) request.getAttribute("totalInventarios");

    // Recibir paginación actual
    int numPage = (request.getAttribute("numPage") != null) ? (Integer) request.getAttribute("numPage") : 1;
    int pageSize = (request.getAttribute("pageSize") != null) ? (Integer) request.getAttribute("pageSize") : 10;

    // Para paginación
    int totalPaginas = (int) Math.ceil((double) totalInventarios / pageSize);
    int maxPaginas = 8;
    int inicio = Math.max(1, numPage - maxPaginas / 2);
    int fin = Math.min(totalPaginas, inicio + maxPaginas - 1);
    inicio = Math.max(1, fin - maxPaginas + 1);

    // Datos estáticos
    // List<Proveedor> proveedores = (List<Proveedor>) request.getAttribute("proveedores");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Inventario - INVEHIN</title>

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

    <body class="bg-invehin-background font-sans flex flex-col overflow-x-hidden" data-totalinventarios="<%= totalInventarios%>">
        <%@ include file="/components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col min-h-screen flex-1 px-4 pt-6 md:p-8 md:pb-0 ml-20 sm:ml-64 transition-all duration-300 gap-2">
            <h1 class="text-invehin-primary font-bold text-3xl text-center mb-10">Listado de Inventarios Realizados</h1>

            <!-- Filtros -->
            <section class="flex flex-col justify-between gap-2">
                <div class="w-full flex flex-wrap justify-between items-center gap-2 sm:gap-4">
                    <div class="flex items-center gap-2 w-full sm:w-auto">
                        <label for="pageSizeSelect" class="text-sm text-invehin-dark font-medium whitespace-nowrap">Mostrar:</label>
                        <select id="pageSizeSelect" class="border border-gray-300 rounded px-2 py-1 shadow-sm text-sm">
                            <option value="5" <%= pageSize == 5 ? "selected" : ""%>>5</option>
                            <option value="10" <%= pageSize == 10 ? "selected" : ""%>>10</option>
                            <option value="30" <%= pageSize == 30 ? "selected" : ""%>>30</option>
                            <option value="50" <%= pageSize == 50 ? "selected" : ""%>>50</option>
                            <option value="100" <%= pageSize == 100 ? "selected" : ""%>>100</option>
                        </select>
                    </div>

                    <div class="flex flex-col sm:flex-row w-full sm:w-auto sm:justify-between gap-2 text-sm">
                        <button onclick="abrirModalReporte()" class="bg-invehin-primary text-white font-medium px-4 py-1 rounded shadow hover:bg-invehin-primaryLight transition whitespace-nowrap">
                            <i class="fa-solid fa-file-lines mr-2"></i>Generar Reporte
                        </button>

                        <button onclick="abrirModalAgregar()" class="bg-invehin-primary text-white font-medium px-4 py-1 rounded shadow hover:bg-invehin-primaryLight transition whitespace-nowrap">
                            <i class="fas fa-plus mr-2"></i>Nuevo Inventario
                        </button>
                    </div>
                </div>

                <div class="w-full flex flex-col sm:flex-row justify-between items-center gap-2 sm:gap-4 w-auto">
                    <%
                        int desde = (int) ((numPage - 1) * pageSize + 1);
                        int hasta = Math.min(numPage * pageSize, totalInventarios);
                    %>
                    <div id="resumenInventarios" class="text-dark text-sm w-full">
                        Mostrando <%= totalInventarios > 0 ? desde : 0%> a <%= hasta%> de <%= totalInventarios%> inventarios
                    </div>

                    <div class="relative w-full">
                        <input id="searchInput" type="search" placeholder="Buscar inventario..." class="w-full pl-10 pr-4 py-1 rounded-md shadow-md bg-white border border-gray-300 outline-none" />
                        <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
                    </div>
                </div>
            </section>

            <!-- Tabla -->
            <div class="overflow-x-auto w-full">
                <table class="w-full text-sm text-left bg-invehin-accentLight rounded-lg border-separate border-spacing-0 overflow-hidden">
                    <caption class="sr-only">Tabla de inventarios</caption>
                    <thead class="bg-invehin-primary text-white">
                        <tr>
                            <th class="px-3 py-2 border border-white">ID</th>
                            <th class="px-3 py-2 border border-white">Fecha</th>
                            <th class="px-3 py-2 border border-white">Observación</th>
                            <th class="px-3 py-2 border border-white">Usuario</th>
                            <th class="px-3 py-2 border border-white">Estado</th>
                            <th class="px-3 py-2 border border-white text-center">Detalle</th>
                            <th class="px-3 py-2 border border-white text-center">Editar</th>
                        </tr>
                    </thead>

                    <tbody id="inventariosFiltrados" class="bg-pink-100">
                        <%
                            if (inventarios != null && !inventarios.isEmpty())
                            {
                                for (Inventario inventario : inventarios)
                                {
                                    Gson gson = new Gson();
                                    String detallesJson = gson.toJson(inventario.detallesinventarioInventario).replace("\"", "&quot;");
                        %>
                        <tr>
                            <td class="px-3 py-2 border border-white"><%= inventario.idInventario%></td>
                            <td class="px-3 py-2 border border-white"><%= inventario.fechaInventario%></td>
                            <td class="px-3 py-2 border border-white"><%= inventario.observacionInventario%></td>
                            <td class="px-3 py-2 border border-white"><%= inventario.nombreusuarioInventario%></td>
                            <td class="px-3 py-2 border border-white"><%= inventario.estadoInventario ? "Realizado" : "Por terminar"%></td>
                            <td class="px-3 py-2 border border-white text-center">
                                <button class="text-green-600 hover:text-green-500 transition ver-detalle-btn" title="Ver detalle inventario"
                                        data-detalles='<%= detallesJson%>'>
                                    <i class="fas fa-eye"></i>
                                </button>
                            </td>
                            <td class="px-3 py-2 border border-white text-center">
                                <button title="Editar inventario" class="text-blue-600 hover:text-blue-500 transition editar-inventario-btn"
                                        data-id="<%= inventario.idInventario%>"
                                        data-fecha="<%= inventario.fechaInventario%>"
                                        data-observacion="<%= inventario.observacionInventario%>"
                                        data-usuarionombre="<%= inventario.nombreusuarioInventario%>"
                                        data-estado="<%= inventario.estadoInventario%>"
                                        data-detalles="<%= detallesJson%>">
                                    <i class="fas fa-edit"></i>
                                </button>
                            </td>
                        </tr>
                        <%
                            }
                        } else
                        {
                        %>
                        <tr>
                            <td colspan="8" class="text-center text-gray-500 py-3">No se encontraron inventarios.</td>
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

        <!-- Modal de detalle inventario -->
        <div id="modalDetalleInventario" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-3xl max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Detalle Inventario</h2>

                    <button onclick="cerrarModalDetalleInventario()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <div class="overflow-x-auto w-full px-4 py-4 ">
                    <table class="w-full text-sm text-left rounded-lg border-separate border-spacing-0 overflow-hidden">
                        <thead class="bg-invehin-primary text-white">
                            <tr>
                                <th class="px-3 py-2 border border-white">Prenda</th>
                                <th class="px-3 py-2 border border-white">Cantidad Registrada</th>
                                <th class="px-3 py-2 border border-white">Cantidad en el Sistema</th>
                                <th class="px-3 py-2 border border-white">Observación</th>
                            </tr>
                        </thead>
                        <tbody id="detalleInventarioBody" class="bg-pink-50">
                            <!-- Se llenará con JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Modal nuevo inventario -->
        <div id="modalAgregarInventario" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-3xl w-11/12 sm:min-w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Nuevo Inventario</h2>

                    <button onclick="cerrarModalAgregar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formAgregarInventario" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <input type="hidden" id="agregarIdUsuario" value=<%= sesion.idUsuario%> />

                    <div class="grid sm:grid-cols-2 gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="agregarFecha" class="block font-semibold text-black">Fecha</label>
                            <input id="agregarFecha" name="fecha" type="date" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" readonly />
                        </div>

                        <div class="gap-1">
                            <label for="agregarResponsable" class="block font-semibold text-black">Responsable</label>
                            <input id="agregarResponsable" name="responsable" type="text" value="<%= sesion.nombresPersona + " " + sesion.apellidosPersona%>" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" readonly />
                        </div>

                        <div class="col-span-2 gap-1">
                            <label for="agregarObservacion" class="block font-semibold text-black">Observaciones</label>
                            <textarea id="agregarObservacion" name="observacion" rows="3"
                                      class="block w-full px-3 border border-black/50 rounded-md shadow-sm bg-white text-gray-800 resize-none"
                                      placeholder="Todo en orden" required></textarea>
                        </div>

                        <h2 class="col-span-2 text-black font-semibold">Detalles del inventario</h2>

                        <button type="button" onclick="abrirModalAgregarPrendaDesdeAgregar()" class="-mt-2 bg-green-600 text-sm text-white px-4 py-2 rounded hover:bg-green-700">
                            Registrar prenda al inventario
                        </button>

                        <div class="col-span-2 overflow-x-auto w-full">
                            <table class="w-full text-sm text-left rounded-lg border-separate border-spacing-0 overflow-hidden">
                                <thead class="bg-invehin-primary text-white">
                                    <tr>
                                        <th class="px-3 py-2 border border-white">Código</th>
                                        <th class="px-3 py-2 border border-white">Nombre</th>
                                        <th class="px-3 py-2 border border-white">Talla</th>
                                        <th class="px-3 py-2 border border-white">Color</th>
                                        <th class="px-3 py-2 border border-white">Cantidad en el Sistema</th>
                                        <th class="px-3 py-2 border border-white">Cantidad Existente</th>
                                        <th class="px-3 py-2 border border-white">Observación</th>
                                        <th class="px-3 py-2 border border-white">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="agregarDetalleInventarioBody" class="bg-pink-50">
                                    <!-- Se llenará con JavaScript -->
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalAgregar()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnGuardarInventario" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Finalizar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal de edición de inventario -->
        <div id="modalEditarInventario" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-3xl w-11/12 sm:min-w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Editar Inventario</h2>

                    <button onclick="cerrarModalEditar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formEditarInventario" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <input type="hidden" id="editarInventarioId" />

                    <div class="grid sm:grid-cols-2 gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="editarFecha" class="block font-semibold text-black">Fecha</label>
                            <input id="editarFecha" name="fecha" type="date" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" readonly />
                        </div>

                        <div class="gap-1">
                            <label for="editarResponsable" class="block font-semibold text-black">Responsable</label>
                            <input id="editarResponsable" name="responsable" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" readonly />
                        </div>

                        <div class="col-span-1 gap-1">
                            <label for="editarEstado" class="block font-semibold text-black">Estado</label>
                            <select id="editarEstado" name="estado" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <option value="true">Realizado</option>
                                <option value="false">Por terminar</option>
                            </select>
                        </div>

                        <div class="col-span-2 gap-1">
                            <label for="editarObservacion" class="block font-semibold text-black">Observaciones</label>
                            <textarea id="editarObservacion" name="observacion" rows="3"
                                      class="block w-full px-3 border border-black/50 rounded-md shadow-sm bg-white text-gray-800 resize-none"
                                      placeholder="Todo en orden" required></textarea>
                        </div>

                        <h2 class="col-span-2 text-black font-semibold">Detalles del inventario</h2>

                        <button type="button" onclick="abrirModalAgregarPrendaDesdeEditar()" class="-mt-2 bg-green-600 text-sm text-white px-4 py-2 rounded hover:bg-green-700">
                            Registrar prenda al inventario
                        </button>

                        <div class="col-span-2 overflow-x-auto w-full">
                            <table class="w-full text-sm text-left rounded-lg border-separate border-spacing-0 overflow-hidden">
                                <thead class="bg-invehin-primary text-white">
                                    <tr>
                                        <th class="px-3 py-2 border border-white">Código</th>
                                        <th class="px-3 py-2 border border-white">Nombre</th>
                                        <th class="px-3 py-2 border border-white">Talla</th>
                                        <th class="px-3 py-2 border border-white">Color</th>
                                        <th class="px-3 py-2 border border-white">Cantidad en el Sistema</th>
                                        <th class="px-3 py-2 border border-white">Cantidad Existente</th>
                                        <th class="px-3 py-2 border border-white">Observación</th>
                                        <th class="px-3 py-2 border border-white">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="editarDetalleInventarioBody" class="bg-pink-50">
                                    <!-- Se llenará con JavaScript -->
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalEditar()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnGuardarInventar" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal registrar prenda al inventario -->
        <div id="modalAgregarPrenda" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md sm:max-w-xl w-11/12 sm:w-11/12 p-6">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Agregar prenda al inventario</h2>

                <div class="max-w-1/2 relative">
                    <label for="searchInputPrenda" class="block font-semibold text-black">Buscar prenda</label>
                    <div class="relative">
                        <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"></i>
                        <input id="searchInputPrenda"
                               type="search"
                               placeholder="Buscar por código, categoría, subcategoría, color, talla..."
                               class="pl-8 pr-4 py-1 rounded-md shadow-md border border-black/50 w-full outline-none"
                               />
                    </div>

                    <ul id="sugerencias"
                        class="rounded-md shadow-md bg-white absolute left-0 right-0 top-full mt-2 p-3 hidden max-h-60 overflow-y-auto border border-gray-300">
                        <!-- Los <li> se generan dinámicamente -->
                    </ul>
                </div>

                <div id="infoPrendaSeleccionada" class="hidden mt-4">
                    <label class="block font-semibold mb-1">Prenda seleccionada</label>
                    <input id="prendaSeleccionada" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-gray-100 cursor-not-allowed" readonly />
                    <input type="hidden" id="codigoPrendaSeleccionada" />
                </div>

                <div class="grid sm:grid-cols-2 gap-2 sm:gap-4 mt-4">
                    <div class="gap-1">
                        <label for="cantidadSistemaPrenda" class="block font-semibold">Cantidad en el sistema</label>
                        <input id="cantidadSistemaPrenda" name="cantidad prenda" type="number" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-gray-100 cursor-not-allowed" placeholder="0" readonly>
                    </div>

                    <div class="gap-1">
                        <label for="cantidadExistentePrenda"  class="block font-semibold">Cantidad existente</label>
                        <input id="cantidadExistentePrenda" name="cantidad prenda" type="number" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="0" required>
                    </div>
                </div>

                <label for="observacionPrenda" class="block font-semibold mt-4 mb-1">Observación de la prenda</label>
                <textarea id="observacionPrenda" name="observacionPrenda" rows="2"
                          class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-white text-gray-800 resize-none"
                          placeholder="Observación opcional..."></textarea>

                <div class="mt-6 flex justify-end gap-2">
                    <button onclick="cerrarModalAgregarPrenda()" class="px-4 py-2 bg-gray-400 text-white rounded hover:bg-gray-500">Cancelar</button>
                    <button onclick="agregarPrendaAlInventario()" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">Agregar</button>
                </div>
            </div>
        </div>

        <!-- Modal confirmación agregar inventario -->
        <div id="modalConfirmarAgregar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar registro</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas realizar este inventario?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarAgregar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarAgregarInventario" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal confirmación editar inventario -->
        <div id="modalConfirmarEditar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar edición</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas editar este inventario?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEditar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEditarInventario" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal Generar Reporte -->
        <div id="modalReporte" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Generar Reporte</h2>

                    <button onclick="cerrarModalReporte()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form action="ReporteInventarios" method="GET" target="_blank" 
                      onsubmit="cerrarModalReporte()" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <div class="gap-1">
                        <label class="block font-semibold text-black">Fecha Inicio</label>
                        <input type="date" name="fechaInicio" required class="block w-full px-2 border border-black/50 rounded-md shadow-sm" />
                    </div>

                    <div class="gap-1">
                        <label class="block font-semibold text-black">Fecha Fin</label>
                        <input type="date" name="fechaFin" required class="block w-full px-2 border border-black/50 rounded-md shadow-sm" />
                    </div>

                    <div class="gap-1">
                        <label class="block font-semibold text-black">Estado (opcional)</label>
                        <select name="estado" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                            <option value="">Todos los estados</option>
                            <option value="true">Realizado</option>
                            <option value="false">Por terminar</option>
                        </select>
                    </div>

                    <div class="gap-1">
                        <label class="block font-semibold text-black">Formato</label>
                        <select name="formato" required class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                            <option value="pdf">PDF</option>
                            <option value="excel">Excel</option>
                        </select>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalReporte()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                    </div>
                </form>
            </div>
        </div>
    </body>

    <script>
        let currentPage = <%= numPage%>;
        let pageSize = <%= pageSize%>;
        let totalInventarios = <%= totalInventarios%>;
        let searchTimeout = null;
        let datosInventarioEditado = null;
        let datosInventarioNuevo = null;
        let timeout = null;
        let origenAgregarPrenda = null;
        const input = document.getElementById('searchInputPrenda');
        const lista = document.getElementById('sugerencias');

        document.addEventListener("DOMContentLoaded", () => {
            cargarInventarios();

            document.getElementById("searchInput").addEventListener("input", () => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    currentPage = 1;
                    cargarInventarios();
                }, 300);
            });

            document.getElementById("pageSizeSelect").addEventListener("change", (e) => {
                pageSize = parseInt(e.target.value);
                currentPage = 1;
                cargarInventarios();
            });
        });

        document.addEventListener("click", function (e) {
            if (e.target.closest(".ver-detalle-btn")) {
                const btn = e.target.closest(".ver-detalle-btn");
                const rawJson = btn.dataset.detalles;

                try {
                    const detalles = JSON.parse(rawJson.replace(/&quot;/g, '"'));
                    mostrarModalDetalle(detalles);
                } catch (err) {
                    console.error("JSON inválido:", rawJson, err);
                }

            } else if (e.target.closest(".editar-inventario-btn")) {
                const btn = e.target.closest(".editar-inventario-btn");
                const rawJson = btn.dataset.detalles;
                const id = btn.dataset.id;
                const fechaCompleta = btn.dataset.fecha;
                const fecha = fechaCompleta.split(" ")[0];
                const usuarioNombre = btn.dataset.usuarionombre;
                const observacion = btn.dataset.observacion;
                const estado = btn.dataset.estado;

                document.getElementById("editarInventarioId").value = id;
                document.getElementById("editarFecha").value = fecha;
                document.getElementById("editarResponsable").value = usuarioNombre;
                document.getElementById("editarObservacion").value = observacion;
                document.getElementById("editarEstado").value = estado;

                try {
                    const detalles = JSON.parse(rawJson.replace(/&quot;/g, '"'));
                    editarModalDetalle(detalles);
                } catch (err) {
                    console.error("JSON inválido:", rawJson, err);
                }

                document.getElementById("modalEditarInventario").classList.remove("hidden");
                document.body.classList.add("overflow-hidden");
            }
        });

        document.addEventListener("click", function (event) {
            const input = document.getElementById("searchInputPrenda");
            const lista = document.getElementById("sugerencias");

            if (!input.contains(event.target) && !lista.contains(event.target)) {
                lista.classList.add("hidden");
            }
        });

        input.addEventListener('input', function () {
            clearTimeout(timeout);

            const searchTerm = this.value.trim();
            if (searchTerm.length < 2) {
                lista.classList.add("hidden");
                return;
            }

            timeout = setTimeout(() => {
                fetchPrendas(searchTerm);
            }, 300);
        });

        document.getElementById("cancelarConfirmarAgregar").addEventListener("click", function () {
            document.getElementById("modalConfirmarAgregar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("confirmarAgregarInventario").addEventListener("click", function () {
            fetch("Inventarios", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: new URLSearchParams(datosInventarioNuevo)
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert(data.mensaje);
                            cerrarModalAgregar();
                            cargarInventarios();
                        } else {
                            alert("Error: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al registrar el inventario", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarAgregar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("cancelarConfirmarEditar").addEventListener("click", function () {
            document.getElementById("modalConfirmarEditar").classList.add("hidden");
        });

        document.getElementById("confirmarEditarInventario").addEventListener("click", function () {
            fetch("Inventarios", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(datosInventarioEditado)
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Inventario actualizado correctamente.");
                            cerrarModalEditar();
                            cargarInventarios();
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

        document.getElementById("formAgregarInventario").addEventListener("submit", function (e) {
            e.preventDefault();

            const detalles = [];
            document.querySelectorAll("#agregarDetalleInventarioBody tr").forEach((fila, index) => {
                const cantidadSistemaTexto = fila.children[4].textContent.trim();
                const cantidad_sistema = parseInt(cantidadSistemaTexto);

                const cantidadRegistradaTexto = fila.children[5].textContent.replace(/[^\d]/g, "");
                const cantidad_registrada = parseInt(cantidadRegistradaTexto);

                if (isNaN(cantidad_sistema) || isNaN(cantidad_registrada)) {
                    console.error(`Fila ${index + 1} inválida. Cantidad en el Sistema: ${cantidad_sistema}, Cantidad existente: ${cantidad_registrada}`);
                    alert(`Error: Verifica los datos de la fila ${index + 1}.`);
                    return;
                }

                detalles.push({
                    codigo_prenda: fila.children[0].textContent.trim(),
                    observacion: fila.children[6].textContent.trim(),
                    cantidad_registrada,
                    cantidad_sistema
                });
            });

            datosInventarioNuevo = {
                observacionInventario: document.getElementById("agregarObservacion").value,
                idUsuario: parseInt(document.getElementById("agregarIdUsuario").value),
                detallesInventarioJson: JSON.stringify(detalles)
            };

            if (detalles.length === 0) {
                alert("Debes agregar al menos una prenda al inventario.");
                return;
            }

            document.getElementById("modalConfirmarAgregar").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        });

        document.getElementById("formEditarInventario").addEventListener("submit", function (e) {
            e.preventDefault();

            const detalles = [];
            document.querySelectorAll("#editarDetalleInventarioBody tr").forEach((fila, index) => {
                const cantidadSistemaTexto = fila.children[4].textContent.trim();
                const cantidad_sistema = parseInt(cantidadSistemaTexto);

                const cantidadRegistradaTexto = fila.children[5].textContent.replace(/[^\d]/g, "");
                const cantidad_registrada = parseInt(cantidadRegistradaTexto);

                if (isNaN(cantidad_sistema) || isNaN(cantidad_registrada)) {
                    console.error(`Fila ${index + 1} inválida. Cantidad en el Sistema: ${cantidad_sistema}, Cantidad existente: ${cantidad_registrada}`);
                    alert(`Error: Verifica los datos de la fila ${index + 1}.`);
                    return;
                }

                detalles.push({
                    codigo_prenda: fila.children[0].textContent.trim(),
                    observacion: fila.children[6].textContent.trim(),
                    cantidad_registrada,
                    cantidad_sistema
                });
            });

            datosInventarioEditado = {
                idInventario: document.getElementById("editarInventarioId").value,
                observacionInventario: document.getElementById("editarObservacion").value,
                estadoInventario: document.getElementById("editarEstado").value === "true",
                detallesInventarioJson: JSON.stringify(detalles)
            };

            if (detalles.length === 0) {
                alert("Debes agregar al menos una prenda al inventario.");
                return;
            }

            document.getElementById("modalConfirmarEditar").classList.remove("hidden");
        });

        function irAPagina(nuevaPagina) {
            currentPage = nuevaPagina;
            cargarInventarios();
        }

        function cargarInventarios() {
            const searchTerm = document.getElementById("searchInput").value.trim();

            fetch("Inventarios?searchTerm=" + encodeURIComponent(searchTerm) + "&numPage=" + currentPage + "&pageSize=" + pageSize).then(res => res.text()).then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");
                const nuevaTabla = doc.querySelector("#inventariosFiltrados");
                const resumen = doc.querySelector("#resumenInventarios").textContent;
                const nuevaPaginacion = doc.querySelector("nav[aria-label='Paginación']");

                document.querySelector("#inventariosFiltrados").innerHTML = nuevaTabla.innerHTML;
                document.querySelector("#resumenInventarios").textContent = resumen;
                document.querySelector("nav[aria-label='Paginación']").innerHTML = nuevaPaginacion.innerHTML;

                // actualizar totalInventarios si el servlet lo recalcula
                totalInventarios = parseInt(doc.querySelector("body").dataset.totalinventarios) || totalInventarios;
            }).catch(err => console.error("Error cargando inventarios", err));
        }

        function mostrarModalDetalle(detalles) {
            const tbody = document.getElementById("detalleInventarioBody");

            tbody.innerHTML = "";
            detalles.forEach(d => {
                const tr = document.createElement("tr");
                const campos = [
                    d.prendacodigoDetalleInventario + " - " + d.prendanombreDetalleInventario,
                    d.cantidadregistradaDetalleInventario,
                    d.cantidadsistemaDetalleInventario,
                    d.observacionDetalleInventario
                ];

                campos.forEach(valor => {
                    const td = document.createElement("td");
                    td.className = "px-3 py-2 border border-white";
                    td.textContent = valor;
                    tr.appendChild(td);
                });
                tbody.appendChild(tr);
            });
            document.getElementById("modalDetalleInventario").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }
        
        function editarModalDetalle(detalles) {
            const tbody = document.getElementById("editarDetalleInventarioBody");
            tbody.innerHTML = "";

            detalles.forEach(d => {
                const tr = document.createElement("tr");

                // Separar prendaNombre: "Blusa - Manga larga - Talla S · Rojo"
                const partes = d.prendanombreDetalleInventario.split(" - ");
                const nombre = partes.length >= 2 ? partes[0] + " - " + partes[1] : d.prendanombreDetalleInventario;
                const tallaYColor = d.prendanombreDetalleInventario.split("Talla ")[1] || "";
                const [talla, color] = tallaYColor.split(" · ");

                const columnas = [
                    d.prendacodigoDetalleInventario, // Código
                    nombre.trim(), // Nombre
                    talla?.trim() ?? "--", // Talla
                    color?.trim() ?? "--", // Color
                    d.cantidadsistemaDetalleInventario, // Cantidad en el sistema
                    d.cantidadregistradaDetalleInventario, // Cantidad registrada
                    d.observacionDetalleInventario || "" // Observación
                ];

                columnas.forEach(valor => {
                    const td = document.createElement("td");
                    td.className = "px-3 py-2 border border-white";
                    td.textContent = valor;
                    tr.appendChild(td);
                });

                const accionesTd = document.createElement("td");
                accionesTd.className = "px-3 py-2 border border-white text-center";

                const btnEliminar = document.createElement("button");
                btnEliminar.type = "button";
                btnEliminar.className = "text-red-600 hover:text-red-500 eliminar-detalle-btn";
                btnEliminar.title = "Remover prenda";
                btnEliminar.innerHTML = '<i class="fas fa-trash"></i>';
                btnEliminar.addEventListener("click", () => {
                    tr.remove();
                });

                accionesTd.appendChild(btnEliminar);
                tr.appendChild(accionesTd);

                tbody.appendChild(tr);
            });
        }

        function cerrarModalDetalleInventario() {
            document.getElementById("modalDetalleInventario").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function abrirModalAgregarPrenda() {
            document.getElementById('modalAgregarPrenda').classList.remove('hidden');
            document.getElementById('searchInputPrenda').value = '';
            document.getElementById('sugerencias').innerHTML = '';
            document.getElementById('sugerencias').classList.add('hidden');
        }

        function cerrarModalAgregarPrenda() {
            document.getElementById('modalAgregarPrenda').classList.add('hidden');
            document.getElementById("infoPrendaSeleccionada").classList.add("hidden");
            document.getElementById("prendaSeleccionada").value = "";
            document.getElementById("codigoPrendaSeleccionada").value = "";
            document.getElementById("cantidadSistemaPrenda").value = "";
            document.getElementById("cantidadExistentePrenda").value = "";
            document.getElementById("observacionPrenda").value = "";
            document.getElementById("searchInputPrenda").value = "";
            document.getElementById("sugerencias").innerHTML = "";
            document.getElementById("sugerencias").classList.add("hidden");
            origenAgregarPrenda = null;
        }

        function fetchPrendas(searchTerm) {
            fetch('${pageContext.request.contextPath}/PrendasVenta', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: new URLSearchParams({searchTerm})
            })
                    .then(response => response.json())
                    .then(data => {
                        renderSugerencias(data);
                    })
                    .catch(error => {
                        console.error('Error al buscar prendas:', error);
                    });
        }

        function renderSugerencias(data) {
            const tablaBody = document.getElementById("editarDetalleInventarioBody");
            lista.innerHTML = "";

            if (!data || data.length === 0) {
                lista.classList.add("hidden");
                return;
            }

            data.forEach((prenda, i) => {
                const sub = prenda.subcategoriaPrenda;
                const cat = sub?.categoriaSubcategoria;
                const talla = prenda.tallaPrenda;
                const color = prenda.colorPrenda;
                const codigo = prenda.codigoPrenda ?? '--';
                const nombreCategoria = cat?.nombreCategoria ?? '--';
                const nombreSubcategoria = sub?.nombreSubcategoria ?? '--';
                const nombreTalla = talla?.nombreTalla ?? '--';
                const nombreColor = color?.nombreColor ?? '--';
                const cantidad = prenda.stockPrenda;

                const texto = document.createTextNode(codigo + " - " +
                        nombreCategoria + " - " + nombreSubcategoria + " · Talla " +
                        nombreTalla + " · " + nombreColor
                        );

                const li = document.createElement("li");
                li.className = "cursor-pointer px-4 py-2 rounded-lg hover:bg-gray-50 text-sm font-medium text-gray-800";
                li.appendChild(texto);

                li.onclick = () => {
                    const infoSeleccionada = codigo + " - " + nombreCategoria + " - " + nombreSubcategoria + " · Talla " + nombreTalla + " · " + nombreColor;

                    document.getElementById("prendaSeleccionada").value = infoSeleccionada;
                    document.getElementById("codigoPrendaSeleccionada").value = codigo;
                    document.getElementById("cantidadSistemaPrenda").value = cantidad;
                    document.getElementById("infoPrendaSeleccionada").classList.remove("hidden");

                    input.value = "";
                    lista.classList.add("hidden");
                };

                lista.appendChild(li);
            });

            lista.classList.remove("hidden");
        }

        function agregarPrendaTabla( { codigo, nombreCategoria, nombreSubcategoria, nombreTalla, nombreColor, cantidadSistema, cantidadExistente, observacion }, tablaBody) {
            // Buscar si ya existe un <tr> con ese código
            const filas = tablaBody.querySelectorAll("tr");

            for (let fila of filas) {
                const codigoCelda = fila.children[0].textContent.trim();
                if (codigoCelda === codigo) {
                    const celdaCantidad = fila.children[4];
                    let cantidadActual = parseInt(celdaCantidad.textContent.trim());
                    cantidadActual += 1;
                    celdaCantidad.textContent = cantidadActual;

                    return;
                }
            }

            const tr = document.createElement("tr");

            // Celda 1: Codigo
            const td1 = document.createElement("td");
            td1.className = "px-3 py-2 border border-white";
            td1.appendChild(document.createTextNode(codigo));
            tr.appendChild(td1);

            // Celda 2: Categoría y Subcategoría
            const td2 = document.createElement("td");
            td2.className = "px-3 py-2 border border-white";
            td2.appendChild(document.createTextNode(nombreCategoria + " - " + nombreSubcategoria));
            tr.appendChild(td2);

            // Celda 3: Talla
            const td3 = document.createElement("td");
            td3.className = "px-3 py-2 border border-white";
            td3.appendChild(document.createTextNode(nombreTalla));
            tr.appendChild(td3);

            // Celda 4: Color
            const td4 = document.createElement("td");
            td4.className = "px-3 py-2 border border-white";
            td4.appendChild(document.createTextNode(nombreColor));
            tr.appendChild(td4);

            // Celda 5: Cantidad Sistema
            const td5 = document.createElement("td");
            td5.className = "px-3 py-2 border border-white";
            td5.appendChild(document.createTextNode(cantidadSistema));
            tr.appendChild(td5);

            // Celda 6: Cantidad Existente
            const td6 = document.createElement("td");
            td6.className = "px-3 py-2 border border-white";
            td6.appendChild(document.createTextNode(cantidadExistente));
            tr.appendChild(td6);

            // Celda 7: Observación
            const td7 = document.createElement("td");
            td7.className = "px-3 py-2 border border-white";
            td7.appendChild(document.createTextNode(observacion));
            tr.appendChild(td7);

            // Celda 8: Botón eliminar con ícono
            const td8 = document.createElement("td");
            td8.className = "px-3 py-2 border border-white text-center";

            const btn = document.createElement("button");
            btn.className = "text-red-600 hover:text-red-500";
            btn.setAttribute("aria-label", "Eliminar");
            btn.title = "Remover prenda";

            const icon = document.createElement("i");
            icon.className = "fas fa-trash";
            icon.setAttribute("aria-hidden", "true");
            btn.appendChild(icon);
            btn.onclick = function () {
                this.closest('tr').remove();
            };

            td8.appendChild(btn);
            tr.appendChild(td8);

            tablaBody.appendChild(tr);
        }

        function agregarPrendaAlInventario() {
            let tablaBody = null;

            if (origenAgregarPrenda === "editar") {
                tablaBody = document.getElementById("editarDetalleInventarioBody");
            } else if (origenAgregarPrenda === "agregar") {
                tablaBody = document.getElementById("agregarDetalleInventarioBody");
            } else {
                alert("No se pudo determinar a qué tabla agregar la prenda.");
                return;
            }
            
            const codigo = document.getElementById("codigoPrendaSeleccionada")?.value;
            const info = document.getElementById("prendaSeleccionada")?.value;

            if (!codigo || !info) {
                alert("Debes seleccionar una prenda primero.");
                return;
            }

            const cantidadSistema = parseInt(document.getElementById("cantidadSistemaPrenda").value);
            const cantidadExistente = parseInt(document.getElementById("cantidadExistentePrenda").value);
            const observacion = document.getElementById("observacionPrenda").value.trim();

            if (isNaN(cantidadSistema) || isNaN(cantidadExistente)) {
                alert("Cantidad existente debe ser válida.");
                return;
            }

            const nombreCategoria = info.split(" - ")[1]?.split(" · ")[0] || "--";
            const nombreSubcategoria = info.split(" - ")[2]?.split(" · ")[0] || "--";
            const nombreTalla = info.split("Talla ")[1]?.split(" · ")[0] || "--";
            const nombreColor = info.split(" · ")[2] || "--";

            // Agregar a la tabla
            agregarPrendaTabla({
                codigo,
                nombreCategoria,
                nombreSubcategoria,
                nombreTalla,
                nombreColor,
                cantidadSistema,
                cantidadExistente,
                observacion
            }, tablaBody);

            cerrarModalAgregarPrenda();
        }

        function abrirModalAgregarPrendaDesdeAgregar() {
            origenAgregarPrenda = "agregar";
            abrirModalAgregarPrenda();
        }

        function abrirModalAgregarPrendaDesdeEditar() {
            origenAgregarPrenda = "editar";
            abrirModalAgregarPrenda();
        }

        function abrirModalAgregar() {
            const hoy = new Date().toISOString().split("T")[0];
            const inputFecha = document.getElementById("agregarFecha");
            inputFecha.min = hoy;
            if (!inputFecha.value) {
                inputFecha.value = hoy;
            }

            document.getElementById("modalAgregarInventario").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }

        function cerrarModalAgregar() {
            document.getElementById("modalAgregarInventario").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function cerrarModalEditar() {
            document.getElementById("modalEditarInventario").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function abrirModalReporte() {
            document.getElementById("modalReporte").classList.remove("hidden");
        }

        function cerrarModalReporte() {
            document.getElementById("modalReporte").classList.add("hidden");
        }
    </script>
</html>
