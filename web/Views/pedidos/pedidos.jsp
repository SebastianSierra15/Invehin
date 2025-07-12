<%-- 
    Document   : pedidos
    Created on : 20/06/2025, 6:12:57?p.?m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page import="Logica.Proveedor"%>
<%@page import="Logica.Pedido"%>
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

    boolean puedeVerPedidos = false;
    boolean puedeAgregarPedido = false;
    boolean puedeEditarPedido = false;
    boolean puedeGenerarReporte = false;

    for (var permiso : sesion.rolUsuario.permisosRol)
    {
        switch (permiso.idPermiso)
        {
            case 9:
                puedeVerPedidos = true;
                break;
            case 16:
                puedeAgregarPedido = true;
                break;
            case 25:
                puedeEditarPedido = true;
                break;
            case 34:
                puedeGenerarReporte = true;
                break;
        }
    }

    if (!puedeVerPedidos)
    {
        response.sendRedirect(request.getContextPath() + "/Views/sin-permiso.jsp");
        return;
    }
%>

<%
    // Recibir resultado de paginación
    List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
    int totalPedidos = (int) request.getAttribute("totalPedidos");

    // Recibir paginación actual
    int numPage = (request.getAttribute("numPage") != null) ? (Integer) request.getAttribute("numPage") : 1;
    int pageSize = (request.getAttribute("pageSize") != null) ? (Integer) request.getAttribute("pageSize") : 10;

    // Para paginación
    int totalPaginas = (int) Math.ceil((double) totalPedidos / pageSize);
    int maxPaginas = 8;
    int inicio = Math.max(1, numPage - maxPaginas / 2);
    int fin = Math.min(totalPaginas, inicio + maxPaginas - 1);
    inicio = Math.max(1, fin - maxPaginas + 1);

    // Datos estáticos
    List<Proveedor> proveedores = (List<Proveedor>) request.getAttribute("proveedores");
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Pedidos - INVEHIN</title>

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

    <body class="bg-invehin-background font-sans flex flex-col overflow-x-hidden" data-totalpedidos="<%= totalPedidos%>">
        <%@ include file="/components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col min-h-screen flex-1 px-4 pt-6 md:p-8 md:pb-0 ml-20 sm:ml-64 transition-all duration-300 gap-2">
            <h1 class="text-invehin-primary font-bold text-3xl text-center mb-10">Listado de Pedidos</h1>

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
                        <button onclick="<%= puedeGenerarReporte ? "abrirModalReporte()" : "alert('No tienes permiso para generar reportes.')"%>"
                                class="bg-invehin-primary text-white font-medium px-4 py-1 rounded shadow hover:bg-invehin-primaryLight transition whitespace-nowrap">
                            <i class="fa-solid fa-file-lines mr-2"></i>Generar Reporte
                        </button>

                        <button onclick="<%= puedeAgregarPedido ? "abrirModalAgregar()" : "alert('No tienes permiso para agregar pedidos.')"%>"
                                class="bg-invehin-primary text-white font-medium px-4 py-1 rounded shadow hover:bg-invehin-primaryLight transition whitespace-nowrap">
                            <i class="fas fa-plus mr-2"></i>Registrar Pedido
                        </button>
                    </div>
                </div>

                <div class="w-full flex flex-col sm:flex-row justify-between items-center gap-2 sm:gap-4 w-auto">
                    <%
                        int desde = (int) ((numPage - 1) * pageSize + 1);
                        int hasta = Math.min(numPage * pageSize, totalPedidos);
                    %>
                    <div id="resumenPedidos" class="text-dark text-sm w-full">
                        Mostrando <%= totalPedidos > 0 ? desde : 0%> a <%= hasta%> de <%= totalPedidos%> pedidos
                    </div>

                    <div class="relative w-full">
                        <input id="searchInput" type="search" placeholder="Buscar pedido..." class="w-full pl-10 pr-4 py-1 rounded-md shadow-md bg-white border border-gray-300 outline-none" />
                        <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
                    </div>
                </div>
            </section>

            <!-- Tabla -->
            <div class="overflow-x-auto w-full">
                <table class="w-full text-sm text-left bg-invehin-accentLight rounded-lg border-separate border-spacing-0 overflow-hidden">
                    <caption class="sr-only">Tabla de pedidos</caption>
                    <thead class="bg-invehin-primary text-white">
                        <tr>
                            <th class="px-3 py-2 border border-white">ID</th>
                            <th class="px-3 py-2 border border-white">Fecha</th>
                            <th class="px-3 py-2 border border-white">Proveedor</th>
                            <th class="px-3 py-2 border border-white">Cantidad</th>
                            <th class="px-3 py-2 border border-white">Precio total</th>
                            <th class="px-3 py-2 border border-white">Estado</th>
                            <th class="px-3 py-2 border border-white text-center">Detalle</th>
                            <th class="px-3 py-2 border border-white text-center">Editar</th>
                        </tr>
                    </thead>

                    <tbody id="pedidosFiltrados" class="bg-pink-100">
                        <%
                            if (pedidos != null && !pedidos.isEmpty())
                            {
                                for (Pedido pedido : pedidos)
                                {
                                    Gson gson = new Gson();
                                    String detallesJson = gson.toJson(pedido.detallespedidoPedido).replace("\"", "&quot;");
                        %>
                        <tr>
                            <td class="px-3 py-2 border border-white"><%= pedido.idPedido%></td>
                            <td class="px-3 py-2 border border-white"><%= pedido.fechaPedido%></td>
                            <td class="px-3 py-2 border border-white"><%= pedido.proveedorPedido.nombreProveedor%></td>
                            <td class="px-3 py-2 border border-white"><%= pedido.cantidadPedido%></td>
                            <td class="px-3 py-2 border border-white">$<%= String.format("%,d", pedido.preciototalPedido)%></td>
                            <td class="px-3 py-2 border border-white"><%= pedido.estadoPedido ? "Entregado" : "Sin entregar"%></td>
                            <td class="px-3 py-2 border border-white text-center">
                                <button class="text-green-600 hover:text-green-500 transition ver-detalle-btn" title="Ver detalle pedido"
                                        data-detalles='<%= detallesJson%>'>
                                    <i class="fas fa-eye"></i>
                                </button>
                            </td>
                            <td class="px-3 py-2 border border-white text-center">
                                <% if (puedeEditarPedido)
                                    {%>
                                <!-- botón normal -->
                                <button title="Editar pedido" class="text-blue-600 hover:text-blue-500 transition editar-pedido-btn"
                                        data-id="<%= pedido.idPedido%>"
                                        data-fecha="<%= pedido.fechaPedido%>"
                                        data-proveedor="<%= pedido.proveedorPedido.idProveedor%>"
                                        data-cantidad="<%= pedido.cantidadPedido%>"
                                        data-precio="<%= pedido.preciototalPedido%>"
                                        data-estado="<%= pedido.estadoPedido%>"
                                        data-detalles="<%= detallesJson%>">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <% } else
                                    { %>
                                <!-- botón deshabilitado con alerta -->
                                <button title="Sin permiso" onclick="alert('No tienes permiso para editar prendas.')" class="text-blue-300 cursor-not-allowed" disabled>
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
                            <td colspan="8" class="text-center text-gray-500 py-3">No se encontraron pedidos.</td>
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

        <!-- Modal de detalle pedido -->
        <div id="modalDetallePedido" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-3xl max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Detalle Pedido</h2>

                    <button onclick="cerrarModalDetallePedido()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <div class="overflow-x-auto w-full px-4 py-4 ">
                    <table class="w-full text-sm text-left rounded-lg border-separate border-spacing-0 overflow-hidden">
                        <thead class="bg-invehin-primary text-white">
                            <tr>
                                <th class="px-3 py-2 border border-white">Código</th>
                                <th class="px-3 py-2 border border-white">Nombre</th>
                                <th class="px-3 py-2 border border-white">Color</th>
                                <th class="px-3 py-2 border border-white">Talla</th>
                                <th class="px-3 py-2 border border-white">Cantidad</th>
                                <th class="px-3 py-2 border border-white">Costo unitario</th>
                                <th class="px-3 py-2 border border-white">Subtotal</th>
                                <th class="px-3 py-2 border border-white">Precio Actual</th>
                            </tr>
                        </thead>
                        <tbody id="detallePedidoBody" class="bg-pink-50">
                            <!-- Se llenará con JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Modal agregar pedido -->
        <div id="modalAgregarPedido" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-3xl w-11/12 sm:min-w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Agregar Pedido</h2>

                    <button onclick="cerrarModalAgregar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formAgregarPedido" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <input type="hidden" id="agregarPedidoId" />

                    <div class="grid sm:grid-cols-2 gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="agregarFecha" class="block font-semibold text-black">Fecha</label>
                            <input id="agregarFecha" name="fecha" type="date" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarProveedor" class="block font-semibold text-black">Proveedor</label>
                            <select id="agregarProveedor" name="proveedor" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <% if (proveedores != null && !proveedores.isEmpty())
                                    { %>
                                <% for (Proveedor proveedor : proveedores)
                                    {%>
                                <option value="<%= proveedor.idProveedor%>"><%= proveedor.nombreProveedor%></option>
                                <% } %>
                                <% }%>
                            </select>

                            <input type="hidden" id="agregarProveedorId" name="proveedorId" />
                        </div>

                        <div class="gap-1">
                            <label for="agregarCantidad" class="block font-semibold text-black">Cantidad</label>
                            <input id="agregarCantidad" name="cantidad" type="number" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-gray-100 text-gray-700 cursor-not-allowed" readonly />
                        </div>

                        <div class="gap-1">
                            <label for="agregarPrecio" class="block font-semibold text-black">Precio total</label>
                            <input id="agregarPrecio" name="precio total" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-gray-100 text-gray-700 cursor-not-allowed" readonly />
                        </div>

                        <div class="gap-1">
                            <label for="agregarEstado" class="block font-semibold text-black">Estado</label>
                            <select id="agregarEstado" name="estado" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <option value="true">Entregado</option>
                                <option value="false">Sin entregar</option>
                            </select>
                        </div>

                        <h2 class="col-span-2 text-black font-semibold">Detalles del pedido</h2>

                        <button type="button" onclick="abrirModalAgregarPrendaDesdeAgregar()" class="-mt-2 bg-green-600 text-sm text-white px-4 py-2 rounded hover:bg-green-700">
                            Agregar prenda al pedido
                        </button>

                        <div class="col-span-2 overflow-x-auto w-full">
                            <table class="w-full text-sm text-left rounded-lg border-separate border-spacing-0 overflow-hidden">
                                <thead class="bg-invehin-primary text-white">
                                    <tr>
                                        <th class="px-3 py-2 border border-white">Código</th>
                                        <th class="px-3 py-2 border border-white">Nombre</th>
                                        <th class="px-3 py-2 border border-white">Color</th>
                                        <th class="px-3 py-2 border border-white">Talla</th>
                                        <th class="px-3 py-2 border border-white">Cantidad</th>
                                        <th class="px-3 py-2 border border-white">Costo unitario</th>
                                        <th class="px-3 py-2 border border-white">Subtotal</th>
                                        <th class="px-3 py-2 border border-white">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="agregarDetallePedidoBody" class="bg-pink-50">
                                    <!-- Se llenará con JavaScript -->
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalAgregar()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnGuardarPedido" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal de edición de pedido -->
        <div id="modalEditarPedido" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-3xl w-11/12 sm:min-w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Editar Pedido</h2>

                    <button onclick="cerrarModalEditar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formEditarPedido" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <input type="hidden" id="editarPedidoId" />

                    <div class="grid sm:grid-cols-2 gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="editarFecha" class="block font-semibold text-black">Fecha</label>
                            <input id="editarFecha" name="fecha" type="date" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" required />
                        </div>

                        <div class="gap-1">
                            <label for="editarProveedor" class="block font-semibold text-black">Proveedor</label>
                            <select id="editarProveedor" name="proveedor" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <% if (proveedores != null && !proveedores.isEmpty())
                                    { %>
                                <% for (Proveedor proveedor : proveedores)
                                    {%>
                                <option value="<%= proveedor.idProveedor%>"><%= proveedor.nombreProveedor%></option>
                                <% } %>
                                <% }%>
                            </select>

                            <input type="hidden" id="editarProveedorId" name="proveedorId" />
                        </div>

                        <div class="gap-1">
                            <label for="editarCantidad" class="block font-semibold text-black">Cantidad</label>
                            <input id="editarCantidad" name="cantidad" type="number" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-gray-100 text-gray-700 cursor-not-allowed" readonly />
                        </div>

                        <div class="gap-1">
                            <label for="editarPrecio" class="block font-semibold text-black">Precio total</label>
                            <input id="editarPrecio" name="precio total" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-gray-100 text-gray-700 cursor-not-allowed" readonly />
                        </div>

                        <div class="gap-1">
                            <label for="editarEstado" class="block font-semibold text-black">Estado</label>
                            <select id="editarEstado" name="estado" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <option value="true">Entregado</option>
                                <option value="false">Sin entregar</option>
                            </select>
                        </div>

                        <h2 class="col-span-2 text-black font-semibold">Detalles del pedido</h2>

                        <button type="button" onclick="abrirModalAgregarPrendaDesdeEditar()" class="-mt-2 bg-green-600 text-sm text-white px-4 py-2 rounded hover:bg-green-700">
                            Agregar prenda al pedido
                        </button>

                        <div class="col-span-2 overflow-x-auto w-full">
                            <table class="w-full text-sm text-left rounded-lg border-separate border-spacing-0 overflow-hidden">
                                <thead class="bg-invehin-primary text-white">
                                    <tr>
                                        <th class="px-3 py-2 border border-white">Código</th>
                                        <th class="px-3 py-2 border border-white">Nombre</th>
                                        <th class="px-3 py-2 border border-white">Color</th>
                                        <th class="px-3 py-2 border border-white">Talla</th>
                                        <th class="px-3 py-2 border border-white">Cantidad</th>
                                        <th class="px-3 py-2 border border-white">Costo unitario</th>
                                        <th class="px-3 py-2 border border-white">Subtotal</th>
                                        <th class="px-3 py-2 border border-white">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="editarDetallePedidoBody" class="bg-pink-50">
                                    <!-- Se llenará con JavaScript -->
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalEditar()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnGuardarPedido" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal agregar prenda -->
        <div id="modalAgregarPrenda" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md sm:max-w-xl w-11/12 sm:w-11/12 p-6">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Agregar prenda al pedido</h2>

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

                <label class="block font-semibold mt-4 mb-1">Cantidad</label>
                <input id="cantidadPrenda" name="cantidad prenda" type="number" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" required>

                <label class="block font-semibold mt-4 mb-1">Costo unitario ($)</label>
                <input id="costoUnitarioPrenda" name="costo unitario prenda" type="number" min="0" step="0.01" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" required>

                <div class="mt-6 flex justify-end gap-2">
                    <button onclick="cerrarModalAgregarPrenda()" class="px-4 py-2 bg-gray-400 text-white rounded hover:bg-gray-500">Cancelar</button>
                    <button onclick="agregarPrendaAlPedido()" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">Agregar</button>
                </div>
            </div>
        </div>

        <!-- Modal confirmación agregar pedido -->
        <div id="modalConfirmarAgregar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar registro</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas agregar este pedido?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarAgregar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarAgregarPedido" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal confirmación editar pedido -->
        <div id="modalConfirmarEditar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar edición</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas editar este pedido?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEditar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEditarPedido" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
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
                <form action="ReportePedidos" method="GET" target="_blank" 
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
                        <label class="block font-semibold text-black">Proveedor (opcional)</label>
                        <select name="proveedor" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                            <option value="">Todos los proveedores</option>
                            <% if (proveedores != null && !proveedores.isEmpty())
                                { %>
                            <% for (Proveedor proveedor : proveedores)
                                {%>
                            <option value="<%= proveedor.idProveedor%>"><%= proveedor.nombreProveedor%></option>
                            <% } %>
                            <% }%>
                        </select>
                    </div>

                    <div class="gap-1">
                        <label class="block font-semibold text-black">Estado (opcional)</label>
                        <select name="estado" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                            <option value="">Todos los estados</option>
                            <option value="true">Entregado</option>
                            <option value="false">Sin entregar</option>
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
        let totalPedidos = <%= totalPedidos%>;
        let searchTimeout = null;
        let datosPedidoEditado = null;
        let datosPedidoNuevo = null;
        let timeout = null;
        let origenAgregarPrenda = null;
        const input = document.getElementById('searchInputPrenda');
        const lista = document.getElementById('sugerencias');

        document.addEventListener("DOMContentLoaded", () => {
            cargarPedidos();
            document.getElementById("searchInput").addEventListener("input", () => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    currentPage = 1;
                    cargarPedidos();
                }, 300);
            });

            document.getElementById("pageSizeSelect").addEventListener("change", (e) => {
                pageSize = parseInt(e.target.value);
                currentPage = 1;
                cargarPedidos();
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

            } else if (e.target.closest(".editar-pedido-btn")) {
                const btn = e.target.closest(".editar-pedido-btn");
                const rawJson = btn.dataset.detalles;
                const id = btn.dataset.id;
                const fechaCompleta = btn.dataset.fecha;
                const fecha = fechaCompleta.split(" ")[0];
                const proveedorId = btn.dataset.proveedor;
                const cantidad = btn.dataset.cantidad;
                const precio = btn.dataset.precio;
                const estado = btn.dataset.estado;
                document.getElementById("editarFecha").value = fecha;
                document.getElementById("editarPedidoId").value = id;
                document.getElementById("editarProveedor").value = proveedorId;
                document.getElementById("editarCantidad").value = cantidad;
                document.getElementById("editarPrecio").value = "$" + Intl.NumberFormat("es-CO").format(precio);
                document.getElementById("editarEstado").value = estado;
                try {
                    const detalles = JSON.parse(rawJson.replace(/&quot;/g, '"'));
                    editarModalDetalle(detalles);
                } catch (err) {
                    console.error("JSON inválido:", rawJson, err);
                }

                document.getElementById("modalEditarPedido").classList.remove("hidden");
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

        document.getElementById("confirmarAgregarPedido").addEventListener("click", function () {
            fetch("Pedidos", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: new URLSearchParams(datosPedidoNuevo)
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert(data.mensaje);
                            cerrarModalAgregar();
                            cargarPedidos();
                        } else {
                            alert("Error: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al registrar el pedido", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarAgregar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("cancelarConfirmarEditar").addEventListener("click", function () {
            document.getElementById("modalConfirmarEditar").classList.add("hidden");
        });

        document.getElementById("confirmarEditarPedido").addEventListener("click", function () {
            fetch("Pedidos", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(datosPedidoEditado)
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Pedido actualizado correctamente.");
                            cerrarModalEditar();
                            cargarPedidos();
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

        document.getElementById("formAgregarPedido").addEventListener("submit", function (e) {
            e.preventDefault();

            const detalles = [];
            document.querySelectorAll("#agregarDetallePedidoBody tr").forEach((fila, index) => {
                const cantidadTexto = fila.children[4].textContent.trim();
                const cantidad = parseInt(cantidadTexto);

                const costoTexto = fila.children[5].textContent.replace(/[^\d]/g, "");
                const costo_unitario = parseInt(costoTexto);

                if (isNaN(cantidad) || isNaN(costo_unitario)) {
                    console.error(`Fila ${index + 1} inválida. Cantidad: ${cantidadTexto}, Costo: ${costoTexto}`);
                    alert(`Error: Verifica los datos de la fila ${index + 1}.`);
                    return;
                }

                detalles.push({
                    codigo_prenda: fila.children[0].textContent.trim(),
                    cantidad,
                    costo_unitario
                });
            });

            datosPedidoNuevo = {
                fechaPedido: document.getElementById("agregarFecha").value,
                idProveedor: parseInt(document.getElementById("agregarProveedor").value),
                estadoPedido: document.getElementById("agregarEstado").value === "true",
                detallesPedidoJson: JSON.stringify(detalles)
            };

            if (detalles.length === 0) {
                alert("Debes agregar al menos una prenda al pedido.");
                return;
            }

            document.getElementById("modalConfirmarAgregar").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        });

        document.getElementById("formEditarPedido").addEventListener("submit", function (e) {
            e.preventDefault();

            const detalles = [];
            document.querySelectorAll("#editarDetallePedidoBody tr").forEach((fila, index) => {
                const cantidadTexto = fila.children[4].textContent.trim();
                const cantidad = parseInt(cantidadTexto);

                const costoTexto = fila.children[5].textContent.replace(/[^\d]/g, "");
                const costo_unitario = parseInt(costoTexto);

                if (isNaN(cantidad) || isNaN(costo_unitario)) {
                    console.error(`Fila ${index + 1} inválida. Cantidad: ${cantidadTexto}, Costo: ${costoTexto}`);
                    alert(`Error: Verifica los datos de la fila ${index + 1}.`);
                    return;
                }

                detalles.push({
                    codigo_prenda: fila.children[0].textContent.trim(),
                    cantidad,
                    costo_unitario
                });
            });

            datosPedidoEditado = {
                idPedido: parseInt(document.getElementById("editarPedidoId").value),
                fechaPedido: document.getElementById("editarFecha").value,
                idProveedor: parseInt(document.getElementById("editarProveedor").value),
                estadoPedido: document.getElementById("editarEstado").value === "true",
                detallesPedidoJson: JSON.stringify(detalles)
            };

            if (detalles.length === 0) {
                alert("Debes agregar al menos una prenda al pedido.");
                return;
            }

            document.getElementById("modalConfirmarEditar").classList.remove("hidden");
        });

        function irAPagina(nuevaPagina) {
            currentPage = nuevaPagina;
            cargarPedidos();
        }

        function cargarPedidos() {
            const searchTerm = document.getElementById("searchInput").value.trim();
            fetch("Pedidos?modo=ajax&searchTerm=" + encodeURIComponent(searchTerm) + "&numPage=" + currentPage + "&pageSize=" + pageSize).then(res => res.text()).then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");
                const nuevaTabla = doc.querySelector("#pedidosFiltrados");
                const resumen = doc.querySelector("#resumenPedidos").textContent;
                const nuevaPaginacion = doc.querySelector("nav[aria-label='Paginación']");
                document.querySelector("#pedidosFiltrados").innerHTML = nuevaTabla.innerHTML;
                document.querySelector("#resumenPedidos").textContent = resumen;
                document.querySelector("nav[aria-label='Paginación']").innerHTML = nuevaPaginacion.innerHTML;
                // actualizar totalPedidos si el servlet lo recalcula
                totalPedidos = parseInt(doc.querySelector("body").dataset.totalpedidos) || totalPedidos;
            }).catch(err => console.error("Error cargando pedidos", err));
        }

        function mostrarModalDetalle(detalles) {
            const tbody = document.getElementById("detallePedidoBody");
            tbody.innerHTML = "";
            detalles.forEach(d => {
                const tr = document.createElement("tr");
                const campos = [
                    d.prendacodigoDetallePedido,
                    d.prendanombreDetallePedido,
                    d.prendacolorDetallePedido,
                    d.prendatallaDetallePedido,
                    d.cantidadDetallePedido,
                    "$" + Intl.NumberFormat("es-CO").format(d.costounitarioDetallePedido),
                    "$" + Intl.NumberFormat("es-CO").format(d.subtotalDetallePedido),
                    "$" + Intl.NumberFormat("es-CO").format(d.prendaprecioDetallePedido)
                ];
                campos.forEach(valor => {
                    const td = document.createElement("td");
                    td.className = "px-3 py-2 border border-white";
                    td.textContent = valor;
                    tr.appendChild(td);
                });
                tbody.appendChild(tr);
            });
            document.getElementById("modalDetallePedido").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }

        function cerrarModalDetallePedido() {
            document.getElementById("modalDetallePedido").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function editarModalDetalle(detalles) {
            const tbody = document.getElementById("editarDetallePedidoBody");
            tbody.innerHTML = "";

            detalles.forEach(d => {
                const tr = document.createElement("tr");
                const campos = [
                    d.prendacodigoDetallePedido,
                    d.prendanombreDetallePedido,
                    d.prendacolorDetallePedido,
                    d.prendatallaDetallePedido,
                    d.cantidadDetallePedido,
                    "$" + Intl.NumberFormat("es-CO").format(d.costounitarioDetallePedido),
                    "$" + Intl.NumberFormat("es-CO").format(d.subtotalDetallePedido)
                ];

                campos.forEach(valor => {
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
                    actualizarTotalesPedido();
                });

                accionesTd.appendChild(btnEliminar);
                tr.appendChild(accionesTd);
                tbody.appendChild(tr);
            });
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
            document.getElementById("cantidadPrenda").value = "";
            document.getElementById("costoUnitarioPrenda").value = "";
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
            const tablaBody = document.getElementById("editarDetallePedidoBody");
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
                const precio = sub?.prendaSubcategoria ?? '--';

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
                    document.getElementById("infoPrendaSeleccionada").classList.remove("hidden");

                    input.value = "";
                    lista.classList.add("hidden");
                };

                lista.appendChild(li);
            });

            lista.classList.remove("hidden");
        }

        function agregarPrendaTabla( { codigo, nombreCategoria, nombreSubcategoria, nombreTalla, nombreColor, cantidad, costoUnitario, subtotal }, tablaBody) {
            // Buscar si ya existe un <tr> con ese código
            const filas = tablaBody.querySelectorAll("tr");
            for (let fila of filas) {
                const codigoCelda = fila.children[0].textContent.trim();
                if (codigoCelda === codigo) {
                    const celdaCantidad = fila.children[4];
                    let cantidadActual = parseInt(celdaCantidad.textContent.trim());
                    cantidadActual += 1;
                    celdaCantidad.textContent = cantidadActual;

                    // Recalcular el subtotal en la celda 6
                    const celdaCosto = fila.children[5];
                    const celdaSubtotal = fila.children[6];
                    const costoTexto = celdaCosto.textContent.replace(/[^\d]/g, "");
                    const costoUnitario = parseInt(costoTexto);
                    const nuevoSubtotal = cantidadActual * costoUnitario;
                    celdaSubtotal.textContent = "$" + Intl.NumberFormat("es-CO").format(nuevoSubtotal);

                    // Actualizar totales generales
                    if (origenAgregarPrenda === "editar") {
                        actualizarTotalesPedido();
                    } else if (origenAgregarPrenda === "agregar") {
                        actualizarTotalesPedidoAgregar();
                    }
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

            // Celda 5: Cantidad
            const td5 = document.createElement("td");
            td5.className = "px-3 py-2 border border-white";
            td5.appendChild(document.createTextNode(cantidad));
            tr.appendChild(td5);

            // Celda 6: Costo unitario
            const td6 = document.createElement("td");
            td6.className = "px-3 py-2 border border-white";
            td6.appendChild(document.createTextNode("$" + Intl.NumberFormat("es-CO").format(costoUnitario)));
            tr.appendChild(td6);

            // Celda 7: Subtotal
            const td7 = document.createElement("td");
            td7.className = "px-3 py-2 border border-white";
            td7.appendChild(document.createTextNode("$" + Intl.NumberFormat("es-CO").format(subtotal)));
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
                if (origenAgregarPrenda === "editar") {
                    actualizarTotalesPedido();
                } else if (origenAgregarPrenda === "agregar") {
                    actualizarTotalesPedidoAgregar();
                }
            };
            td8.appendChild(btn);
            tr.appendChild(td8);

            tablaBody.appendChild(tr);

            if (origenAgregarPrenda === "editar") {
                actualizarTotalesPedido();
            } else if (origenAgregarPrenda === "agregar") {
                actualizarTotalesPedidoAgregar();
        }
        }

        function agregarPrendaAlPedido() {
            let tablaBody = null;

            if (origenAgregarPrenda === "editar") {
                tablaBody = document.getElementById("editarDetallePedidoBody");
            } else if (origenAgregarPrenda === "agregar") {
                tablaBody = document.getElementById("agregarDetallePedidoBody");
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

            const cantidad = parseInt(document.getElementById("cantidadPrenda").value);
            const costoUnitario = parseFloat(document.getElementById("costoUnitarioPrenda").value);
            const subtotal = cantidad * costoUnitario;

            if (isNaN(cantidad) || isNaN(costoUnitario)) {
                alert("Cantidad y costo unitario deben ser válidos.");
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
                cantidad,
                costoUnitario,
                subtotal
            }, tablaBody);

            cerrarModalAgregarPrenda();

            if (origenAgregarPrenda === "editar") {
                actualizarTotalesPedido();
            } else if (origenAgregarPrenda === "agregar") {
                actualizarTotalesPedidoAgregar();
            }
        }

        function actualizarTotalesPedido() {
            const filas = document.querySelectorAll("#editarDetallePedidoBody tr");
            let totalCantidad = 0;
            let totalPrecio = 0;

            filas.forEach(fila => {
                const cantidad = parseInt(fila.children[4]?.textContent.trim() || "0");
                const subtotalTexto = fila.children[6]?.textContent.trim().replace(/[^\d]/g, "") || "0";
                const subtotal = parseInt(subtotalTexto);

                totalCantidad += cantidad;
                totalPrecio += subtotal;
            });

            document.getElementById("editarCantidad").value = totalCantidad;
            document.getElementById("editarPrecio").value = "$" + Intl.NumberFormat("es-CO").format(totalPrecio);
        }

        function actualizarTotalesPedidoAgregar() {
            const filas = document.querySelectorAll("#agregarDetallePedidoBody tr");
            let totalCantidad = 0;
            let totalPrecio = 0;

            filas.forEach(fila => {
                const cantidad = parseInt(fila.children[4]?.textContent.trim() || "0");
                const subtotalTexto = fila.children[6]?.textContent.trim().replace(/[^\d]/g, "") || "0";
                const subtotal = parseInt(subtotalTexto);

                totalCantidad += cantidad;
                totalPrecio += subtotal;
            });

            document.getElementById("agregarCantidad").value = totalCantidad;
            document.getElementById("agregarPrecio").value = "$" + Intl.NumberFormat("es-CO").format(totalPrecio);
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

            document.getElementById("modalAgregarPedido").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }

        function cerrarModalAgregar() {
            document.getElementById("modalAgregarPedido").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function cerrarModalEditar() {
            document.getElementById("modalEditarPedido").classList.add("hidden");
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
