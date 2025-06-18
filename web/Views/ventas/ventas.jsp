<%-- 
    Document   : ventas
    Created on : 6/06/2025, 11:00:33 a. m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Logica.MetodoPago"%>
<%@page import="Logica.Venta"%>
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
        if (permiso.idPermiso == 7)
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
    List<Venta> ventas = (List<Venta>) request.getAttribute("ventas");
    int totalVentas = (int) request.getAttribute("totalVentas");

    // Recibir paginación actual
    int numPage = (request.getAttribute("numPage") != null) ? (Integer) request.getAttribute("numPage") : 1;
    int pageSize = (request.getAttribute("pageSize") != null) ? (Integer) request.getAttribute("pageSize") : 10;

    // Para paginación
    int totalPaginas = (int) Math.ceil((double) totalVentas / pageSize);
    int maxPaginas = 8;
    int inicio = Math.max(1, numPage - maxPaginas / 2);
    int fin = Math.min(totalPaginas, inicio + maxPaginas - 1);
    inicio = Math.max(1, fin - maxPaginas + 1);

    // Datos estáticos
    List<MetodoPago> metodos = (List<MetodoPago>) request.getAttribute("metodosPago");
%>

<!DOCTYPE html>
<html  lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Ventas - INVEHIN</title>

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

    <body class="bg-invehin-background font-sans flex flex-col overflow-x-hidden" data-totalventas="<%= totalVentas%>">
        <%@ include file="/components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col min-h-screen flex-1 px-4 pt-6 md:p-8 md:pb-0 ml-20 sm:ml-64 transition-all duration-300 gap-2">
            <h1 class="text-invehin-primary font-bold text-3xl text-center mb-10">Listado de Ventas</h1>

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

                        <button onclick="window.location.href = 'Views/ventas/registrar-venta.jsp'" class="bg-invehin-primary text-white font-medium px-4 py-1 rounded shadow hover:bg-invehin-primaryLight transition whitespace-nowrap">
                            <i class="fas fa-plus mr-2"></i>Registrar Venta
                        </button>
                    </div>
                </div>

                <div class="w-full flex flex-col sm:flex-row justify-between items-center gap-2 sm:gap-4 w-auto">
                    <%
                        int desde = (int) ((numPage - 1) * pageSize + 1);
                        int hasta = Math.min(numPage * pageSize, totalVentas);
                    %>
                    <div id="resumenVentas" class="text-dark text-sm w-full">
                        Mostrando <%= totalVentas > 0 ? desde : 0%> a <%= hasta%> de <%= totalVentas%> ventas
                    </div>

                    <div class="relative w-full">
                        <input id="searchInput" type="search" placeholder="Buscar venta..." class="w-full pl-10 pr-4 py-1 rounded-md shadow-md bg-white border border-gray-300 outline-none" />
                        <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
                    </div>
                </div>
            </section>

            <!-- Tabla -->
            <div class="overflow-x-auto w-full">
                <table class="w-full text-sm text-left bg-invehin-accentLight rounded-lg border-separate border-spacing-0 overflow-hidden">
                    <caption class="sr-only">Tabla de ventas</caption>
                    <thead class="bg-invehin-primary text-white">
                        <tr>
                            <th class="px-3 py-2 border border-white">ID</th>
                            <th class="px-3 py-2 border border-white">Fecha</th>
                            <th class="px-3 py-2 border border-white">Cliente</th>
                            <th class="px-3 py-2 border border-white">Usuario</th>
                            <th class="px-3 py-2 border border-white">Método Pago</th>
                            <th class="px-3 py-2 border border-white">Cantidad</th>
                            <th class="px-3 py-2 border border-white">Total</th>
                            <th class="px-3 py-2 border border-white">Recibido</th>
                            <th class="px-3 py-2 border border-white">Estado</th>
                            <th class="px-3 py-2 border border-white text-center">Detalle</th>
                            <th class="px-3 py-2 border border-white text-center">Editar</th>
                        </tr>
                    </thead>

                    <tbody id="ventasFiltradas" class="bg-pink-100">
                        <%
                            if (ventas != null && !ventas.isEmpty())
                            {
                                for (Venta venta : ventas)
                                {
                                    String cliente = venta.clienteVenta.nombresPersona + " " + venta.clienteVenta.apellidosPersona;
                                    String clienteFull = venta.clienteVenta.numeroidentificacionPersona + " - " + cliente;
                                    Gson gson = new Gson();
                                    String detallesJson = gson.toJson(venta.detallesventaVenta).replace("\"", "&quot;");
                        %>
                        <tr>
                            <td class="px-3 py-2 border border-white"><%= venta.idVenta%></td>
                            <td class="px-3 py-2 border border-white"><%= venta.fechaVenta%></td>
                            <td class="px-3 py-2 border border-white"><%= cliente%></td>
                            <td class="px-3 py-2 border border-white"><%= venta.usuarioVenta%></td>
                            <td class="px-3 py-2 border border-white"><%= venta.metodopagoVenta.nombreMetodoPago%></td>
                            <td class="px-3 py-2 border border-white"><%= venta.cantidadVenta%></td>
                            <td class="px-3 py-2 border border-white">$<%= String.format("%,d", venta.preciototalVenta)%></td>
                            <td class="px-3 py-2 border border-white">$<%= String.format("%,d", venta.montorecibidoVenta)%></td>
                            <td class="px-3 py-2 border border-white"><%= venta.estadoVenta ? "Activo" : "Inactivo"%></td>
                            <td class="px-3 py-2 border border-white text-center">
                                <button class="text-green-600 hover:text-green-500 transition ver-detalle-btn" title="Ver detalle venta"
                                        data-detalles='<%= detallesJson%>'>
                                    <i class="fas fa-eye"></i>
                                </button>
                            </td>
                            <td class="px-3 py-2 border border-white text-center">
                                <button title="Editar venta" class="text-blue-600 hover:text-blue-500 transition editar-venta-btn"
                                        data-id="<%= venta.idVenta%>"
                                        data-clienteid="<%= venta.clienteVenta.idCliente%>"
                                        data-cliente="<%= clienteFull%>"
                                        data-metodo="<%= venta.metodopagoVenta.idMetodoPago%>"
                                        data-estado="<%= venta.estadoVenta%>">
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
                            <td colspan="8" class="text-center text-gray-500 py-3">No se encontraron ventas.</td>
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

        <!-- Modal de detalle venta -->
        <div id="modalDetalleVenta" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-3xl max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Detalle Venta</h2>

                    <button onclick="cerrarModalDetalleVenta()" class="text-gray-200 hover:text-gray-100 text-lg">
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
                                <th class="px-3 py-2 border border-white">Precio</th>
                                <th class="px-3 py-2 border border-white">Cantidad</th>
                                <th class="px-3 py-2 border border-white">Subtotal</th>
                            </tr>
                        </thead>
                        <tbody id="detalleVentaBody" class="bg-pink-50">
                            <!-- Se llenará con JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Modal de edición de venta -->
        <div id="modalEditarVenta" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Editar Venta</h2>

                    <button onclick="cerrarModalEditar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formEditarVenta" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <input type="hidden" id="editarVentaId" />

                    <div class="gap-1 relative">
                        <label for="editarClienteInput" class="block font-semibold text-black">Cliente</label>

                        <div class="relative">
                            <i class="fas fa-search absolute left-1 sm:left-3 top-1/2 -translate-y-1/2 text-gray-400"></i>

                            <input type="search"
                                   id="editarClienteInput"
                                   placeholder="Buscar cliente por nombre, apellido, documento..."
                                   class="block w-full pl-6  sm:pl-10 pr-2 sm:pr-4 py-1 border border-black/50 rounded-md shadow-sm" />
                        </div>

                        <ul id="editarSugerenciasCliente"
                            class="rounded-md shadow-md bg-white absolute left-0 right-0 top-full mt-2 p-3 hidden max-h-60 overflow-y-auto border border-gray-300 z-50 text-sm">
                        </ul>

                        <input type="hidden" id="editarClienteId" name="clienteId" />
                    </div>

                    <div class="gap-1">
                        <label for="editarMetodoPago" class="block font-semibold text-black">Método de Pago</label>
                        <select id="editarMetodoPago" name="metodoPago" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                            <option value="">Seleccione un método</option>
                            <% if (metodos != null && !metodos.isEmpty())
                                { %>
                            <% for (MetodoPago metodo : metodos)
                                {%>
                            <option value="<%= metodo.idMetodoPago%>"><%= metodo.nombreMetodoPago%></option>
                            <% } %>
                            <% }%>
                        </select>

                        <input type="hidden" id="editarMetodoPagoId" name="metodoPagoId" />
                    </div>

                    <div class="gap-1">
                        <label for="editarEstadoVenta" class="block font-semibold text-black">Estado</label>
                        <select id="editarEstadoVenta" name="estado" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                            <option value="true">Activo</option>
                            <option value="false">Inactivo</option>
                        </select>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalEditar()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnGuardarVenta" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal Confirmación Editar Venta -->
        <div id="modalConfirmarEditar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar edición</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas editar esta venta?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEditar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEditarVenta" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
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
                <form action="ReporteVentas" method="GET" target="_blank" 
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
        let totalVentas = <%= totalVentas%>;
        let searchTimeout = null;
        let datosVentaEditada = null;
        let timeoutEditarCliente = null;

        document.addEventListener("DOMContentLoaded", () => {
            cargarVentas();

            // Actualizar hidden del método de pago al cambiarlo manualmente
            document.getElementById("editarMetodoPago").addEventListener("change", function () {
                document.getElementById("editarMetodoPagoId").value = this.value;
            });

            document.getElementById("searchInput").addEventListener("input", () => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    currentPage = 1;
                    cargarVentas();
                }, 300);
            });

            document.getElementById("pageSizeSelect").addEventListener("change", (e) => {
                pageSize = parseInt(e.target.value);
                currentPage = 1;
                cargarVentas();
            });

            const fechaInicioInput = document.querySelector('input[name="fechaInicio"]');
            const fechaFinInput = document.querySelector('input[name="fechaFin"]');

            const hoy = new Date().toISOString().split("T")[0];
            fechaInicioInput.min = "2020-01-01";
            fechaInicioInput.max = hoy;

            fechaFinInput.disabled = true;

            fechaInicioInput.addEventListener("change", () => {
                const inicio = fechaInicioInput.value;

                if (inicio) {
                    fechaFinInput.disabled = false;
                    fechaFinInput.min = inicio;
                    fechaFinInput.max = hoy;
                    fechaFinInput.value = inicio;
                } else {
                    fechaFinInput.disabled = true;
                    fechaFinInput.value = "";
                }
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
            } else if (e.target.closest(".editar-venta-btn")) {
                const btn = e.target.closest(".editar-venta-btn");

                const id = btn.dataset.id;
                const clienteId = btn.dataset.clienteid;
                const cliente = btn.dataset.cliente;
                const metodo = btn.dataset.metodo;
                const estado = btn.dataset.estado === "true";

                document.getElementById("editarVentaId").value = id;
                document.getElementById("editarClienteInput").value = cliente;
                document.getElementById("editarClienteId").value = clienteId;
                document.getElementById("editarMetodoPago").value = metodo;
                document.getElementById("editarMetodoPagoId").value = metodo;
                document.getElementById("editarEstadoVenta").value = estado;

                document.getElementById("modalEditarVenta").classList.remove("hidden");
                document.body.classList.add("overflow-hidden");
            }
        });

        document.addEventListener("click", function (event) {
            const input = document.getElementById("editarClienteInput");
            const lista = document.getElementById("editarSugerenciasCliente");
            if (!input.contains(event.target) && !lista.contains(event.target)) {
                lista.classList.add("hidden");
            }
        });

        document.getElementById("cancelarConfirmarEditar").addEventListener("click", function () {
            document.getElementById("modalConfirmarEditar").classList.add("hidden");
        });

        document.getElementById("confirmarEditarVenta").addEventListener("click", function () {
            fetch("Ventas", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(datosVentaEditada)
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Venta actualizada correctamente.");
                            cerrarModalEditar();
                            cargarVentas();
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

        document.getElementById("editarClienteInput").addEventListener("input", function () {
            clearTimeout(timeoutEditarCliente);
            const valor = this.value.trim();

            if (valor.length < 2) {
                document.getElementById("editarSugerenciasCliente").classList.add("hidden");
                return;
            }

            timeoutEditarCliente = setTimeout(() => {
                fetch("Clientes", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: new URLSearchParams({searchTerm: valor})
                })
                        .then(res => res.json())
                        .then(data => renderEditarSugerenciasCliente(data))
                        .catch(err => console.error("Error al buscar cliente (editar):", err));
            }, 300);
        });

        document.getElementById("formEditarVenta").addEventListener("submit", function (e) {
            e.preventDefault();

            datosVentaEditada = {
                idVenta: parseInt(document.getElementById("editarVentaId").value),
                clienteId: parseInt(document.getElementById("editarClienteId").value),
                metodoPagoId: parseInt(document.getElementById("editarMetodoPagoId").value),
                estado: document.getElementById("editarEstadoVenta").value === "true"
            };

            document.getElementById("modalConfirmarEditar").classList.remove("hidden");
        });

        function irAPagina(nuevaPagina) {
            currentPage = nuevaPagina;
            cargarVentas();
        }

        function mostrarModalDetalle(detalles) {
            const tbody = document.getElementById("detalleVentaBody");
            tbody.innerHTML = "";

            detalles.forEach(d => {
                const tr = document.createElement("tr");

                const campos = [
                    d.prendacodigoDetalleVenta,
                    d.prendanombreDetalleVenta,
                    d.prendacolorDetalleVenta,
                    d.prendatallaDetalleVenta,
                    "$" + Intl.NumberFormat("es-CO").format(d.prendaprecioDetalleVenta),
                    d.cantidadDetalleVenta,
                    "$" + Intl.NumberFormat("es-CO").format(d.subtotalDetalleVenta)
                ];

                campos.forEach(valor => {
                    const td = document.createElement("td");
                    td.className = "px-3 py-2 border border-white";
                    td.textContent = valor;
                    tr.appendChild(td);
                });

                tbody.appendChild(tr);
            });

            document.getElementById("modalDetalleVenta").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }

        function renderEditarSugerenciasCliente(clientes) {
            const lista = document.getElementById("editarSugerenciasCliente");
            lista.innerHTML = "";

            if (!clientes || clientes.length === 0) {
                lista.classList.add("hidden");
                return;
            }

            clientes.forEach(cliente => {
                const li = document.createElement("li");
                li.className = "cursor-pointer px-4 py-2 rounded-lg hover:bg-gray-100 text-sm font-medium text-gray-800";
                li.textContent = cliente.numeroidentificacionPersona + " - " + cliente.nombresPersona + " " + cliente.apellidosPersona;
                li.onclick = () => seleccionarEditarCliente(cliente);
                lista.appendChild(li);
            });

            lista.classList.remove("hidden");
        }

        function seleccionarEditarCliente(cliente) {
            document.getElementById("editarClienteId").value = cliente.idCliente;
            document.getElementById("editarClienteInput").value = cliente.numeroidentificacionPersona + " - " + cliente.nombresPersona + " " + cliente.apellidosPersona;
            document.getElementById("editarSugerenciasCliente").classList.add("hidden");
        }

        function cargarVentas() {
            const searchTerm = document.getElementById("searchInput").value.trim();

            fetch("Ventas?modo=ajax&searchTerm=" + encodeURIComponent(searchTerm) + "&numPage=" + currentPage + "&pageSize=" + pageSize).then(res => res.text()).then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");

                const nuevaTabla = doc.querySelector("#ventasFiltradas");
                const resumen = doc.querySelector("#resumenVentas").textContent;
                const nuevaPaginacion = doc.querySelector("nav[aria-label='Paginación']");

                document.querySelector("#ventasFiltradas").innerHTML = nuevaTabla.innerHTML;
                document.querySelector("#resumenVentas").textContent = resumen;
                document.querySelector("nav[aria-label='Paginación']").innerHTML = nuevaPaginacion.innerHTML;

                // actualizar totalVentas si el servlet lo recalcula
                totalVentas = parseInt(doc.querySelector("body").dataset.totalventas) || totalVentas;
            }).catch(err => console.error("Error cargando ventas:", err));
        }

        function cerrarModalDetalleVenta() {
            document.getElementById("modalDetalleVenta").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function cerrarModalEditar() {
            document.getElementById("modalEditarVenta").classList.add("hidden");
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
