<%-- 
    Document   : prendas
    Created on : 22/05/2025, 12:09:15 a. m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Logica.Prenda"%>
<%@page import="Logica.Categoria"%>
<%@page import="Logica.Talla"%>
<%@page import="Logica.EstadoPrenda"%>
<%@page import="Logica.Color"%>
<%@page import="Logica.Usuario"%>
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

<%
    // Recibir resultado de paginación
    List<Prenda> prendas = (List<Prenda>) request.getAttribute("prendas");
    int totalPrendas = (int) request.getAttribute("totalPrendas");

    // Recibir paginación actual
    int numPage = (request.getAttribute("numPage") != null) ? (Integer) request.getAttribute("numPage") : 1;
    int pageSize = (request.getAttribute("pageSize") != null) ? (Integer) request.getAttribute("pageSize") : 10;

    // Para paginación
    int totalPaginas = (int) Math.ceil((double) totalPrendas / pageSize);
    int maxPaginas = 8;
    int inicio = Math.max(1, numPage - maxPaginas / 2);
    int fin = Math.min(totalPaginas, inicio + maxPaginas - 1);
    inicio = Math.max(1, fin - maxPaginas + 1);

    // Datos estáticos
    List<Color> colores = (List<Color>) request.getAttribute("colores");
    List<EstadoPrenda> estados = (List<EstadoPrenda>) request.getAttribute("estados");
    List<Talla> tallas = (List<Talla>) request.getAttribute("tallas");
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
%>

<!DOCTYPE html>
<html  lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Prendas - INVEHIN</title>

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

    <body class="bg-invehin-background font-sans flex flex-col overflow-x-hidden" data-totalprendas="<%= totalPrendas%>">
        <%@ include file="/components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col min-h-screen flex-1 px-4 py-6 md:p-8 ml-20 sm:ml-64 transition-all duration-300 gap-2">
            <h1 class="text-invehin-primary font-bold text-3xl text-center mb-10">Listado de Prendas</h1>

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
                        <button onclick="abrirModalReporte()" class="bg-invehin-primary text-white font-medium px-4 py-1 rounded shadow hover:bg-invehin-primaryLight transition whitespace-nowrap">
                            <i class="fa-solid fa-file-lines mr-2"></i>Generar Reporte
                        </button>

                        <button onclick="abrirModalAgregar()" class="bg-invehin-primary text-white font-medium px-4 py-1 rounded shadow hover:bg-invehin-primaryLight transition whitespace-nowrap">
                            <i class="fas fa-plus mr-2"></i>Agregar Prenda
                        </button>
                    </div>
                </div>

                <div class="w-full flex flex-col sm:flex-row justify-between items-center gap-2 sm:gap-4 w-auto">
                    <%
                        int desde = (int) ((numPage - 1) * pageSize + 1);
                        int hasta = Math.min(numPage * pageSize, totalPrendas);
                    %>
                    <div id="resumenPrendas" class="text-dark text-sm w-full">
                        Mostrando <%= totalPrendas > 0 ? desde : 0%> a <%= hasta%> de <%= totalPrendas%> prendas
                    </div>

                    <div class="relative w-full">
                        <input id="searchInput" type="search" placeholder="Buscar prenda..." class="w-full pl-10 pr-4 py-1 rounded-md shadow-md bg-white border border-gray-300 outline-none" />
                        <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
                    </div>
                </div>
            </section>

            <!-- Tabla -->
            <div class="overflow-x-auto w-full">
                <table class="w-full text-sm text-left bg-invehin-accentLight rounded-lg border-separate border-spacing-0 overflow-hidden">
                    <caption class="sr-only">Tabla de prendas</caption>
                    <thead class="bg-invehin-primary text-white">
                        <tr>
                            <th class="px-3 py-2 border border-white">Código</th>
                            <th class="px-3 py-2 border border-white">Categoria</th>
                            <th class="px-3 py-2 border border-white">Subcategoria</th>
                            <th class="px-3 py-2 border border-white">Talla</th>
                            <th class="px-3 py-2 border border-white">Color</th>
                            <th class="px-3 py-2 border border-white">Precio</th>
                            <th class="px-3 py-2 border border-white">Stock</th>
                            <th class="px-3 py-2 border border-white">Stock Mínimo</th>
                            <th class="px-3 py-2 border border-white">Estado</th>
                            <th class="px-3 py-2 border border-white text-center">Editar</th>
                            <th class="px-3 py-2 border border-white text-center">Eliminar</th>
                        </tr>
                    </thead>

                    <tbody id="prendasFiltradas" class="bg-pink-100">
                        <%
                            if (prendas != null && !prendas.isEmpty())
                            {
                                for (Prenda prenda : prendas)
                                {
                        %>
                        <tr>
                            <td class="px-3 py-2 border border-white"><%= prenda.codigoPrenda%></td>
                            <td class="px-3 py-2 border border-white"><%= prenda.subcategoriaPrenda.categoriaSubcategoria.nombreCategoria%></td>
                            <td class="px-3 py-2 border border-white"><%= prenda.subcategoriaPrenda.nombreSubcategoria%></td>
                            <td class="px-3 py-2 border border-white"><%= prenda.tallaPrenda.nombreTalla%></td>
                            <td class="px-3 py-2 border border-white"><%= prenda.colorPrenda.nombreColor%></td>
                            <td class="px-3 py-2 border border-white">$<%= String.format("%,d", prenda.subcategoriaPrenda.precioSubcategoria)%></td>
                            <td class="px-3 py-2 border border-white"><%= prenda.stockPrenda%></td>
                            <td class="px-3 py-2 border border-white"><%= prenda.stockminimoPrenda%></td>
                            <td class="px-3 py-2 border border-white"><%= prenda.estadoprendaPrenda.nombreEstadoPrenda%></td>
                            <td class="px-3 py-2 border border-white text-center">
                                <button title="Editar prenda" class="text-blue-600 hover:text-blue-500 transition editar-prenda-btn"
                                        data-id="<%= prenda.codigoPrenda%>"
                                        data-estado="<%= prenda.estadoprendaPrenda.idEstadoPrenda%>"
                                        data-categoria="<%= prenda.subcategoriaPrenda.categoriaSubcategoria.idCategoria%>"
                                        data-subcategoria="<%= prenda.subcategoriaPrenda.idSubcategoria%>"
                                        data-precio="<%= prenda.subcategoriaPrenda.precioSubcategoria%>"
                                        data-talla="<%= prenda.tallaPrenda.idTalla%>"
                                        data-color="<%= prenda.colorPrenda.idColor%>"
                                        data-stock="<%= prenda.stockPrenda%>"
                                        data-stockminimo="<%= prenda.stockminimoPrenda%>">
                                    <i class="fas fa-edit"></i>
                                </button>
                            </td>
                            <td title="Eliminar prenda" class="px-3 py-2 border border-white text-center">
                                <button class="text-red-600 hover:text-red-500 transition eliminar-prenda-btn"
                                        data-id="<%= prenda.codigoPrenda%>">
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
                            <td colspan="8" class="text-center text-gray-500 py-3">No se encontraron prendas.</td>
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
        
        <!-- Modal agregar prenda -->
        <div id="modalAgregarPrenda" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Agregar Prenda</h2>
                    <button onclick="cerrarModalAgregar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formAgregarPrenda" action="Prendas" method="POST" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <div class="grid sm:grid-cols-2 gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="agregarCodigo" class="block font-semibold text-black">Código</label>
                            <input id="agregarCodigo" name="codigo" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Código de prenda" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarPrecio" class="block font-semibold text-black">Precio</label>
                            <input id="agregarPrecio" name="precio" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-gray-100 text-gray-700 cursor-not-allowed" readonly />
                        </div>

                        <div class="gap-1">
                            <label for="agregarCategoria" class="block font-semibold text-black">Categoría</label>
                            <select id="agregarCategoria" name="categoria" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <% if (categorias != null && !categorias.isEmpty())
                                    { %>
                                <% for (Categoria categoria : categorias)
                                    {%>
                                <option value="<%= categoria.idCategoria%>"><%= categoria.nombreCategoria%></option>
                                <% } %>
                                <% }%>
                            </select>
                        </div>

                        <div class="gap-1">
                            <label for="agregarSubcategoria" class="block font-semibold text-black">Subcategoría</label>
                            <select id="agregarSubcategoria" name="subcategoria" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" disabled>
                                <% if (categorias != null)
                                    {
                                        for (Categoria categoria : categorias)
                                        {
                                            for (var sub : categoria.subcategoriasCategoria)
                                            {
                                %>
                                <option value="<%= sub.idSubcategoria%>" data-categoria="<%= categoria.idCategoria%>"  data-precio="<%= sub.precioSubcategoria%>"><%= sub.nombreSubcategoria%></option>
                                <%      }
                                        }
                                    } %>
                            </select>
                            <input type="hidden" id="agregarSubcategoriaId" name="SubcategoriaId" />
                        </div>

                        <div class="gap-1">
                            <label for="agregarTalla" class="block font-semibold text-black">Talla</label>
                            <select id="agregarTalla" name="talla" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <% if (tallas != null && !tallas.isEmpty())
                                    { %>
                                <% for (Talla talla : tallas)
                                    {%>
                                <option value="<%= talla.idTalla%>"><%= talla.nombreTalla%></option>
                                <% } %>
                                <% }%>
                            </select>
                        </div>

                        <div class="gap-1">
                            <label for="agregarColor" class="block font-semibold text-black">Color</label>
                            <select id="agregarColor" name="color" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <% if (colores != null && !colores.isEmpty())
                                    { %>
                                <% for (Color color : colores)
                                    {%>
                                <option value="<%= color.idColor%>"><%= color.nombreColor%></option>
                                <% } %>
                                <% }%>
                            </select>
                        </div>

                        <div class="gap-1">
                            <label for="agregarStock" class="block font-semibold text-black">Stock inicial</label>
                            <input id="agregarStock" name="stock" type="number" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Stock inicial" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarStockMinimo" class="block font-semibold text-black">Stock mínimo</label>
                            <input id="agregarStockMinimo" name="stockMinimo" type="number" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Stock mínimo" required />
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalAgregar()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnAgregarPrenda" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Agregar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal confirmación agregar prenda -->
        <div id="modalConfirmarAgregar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar registro</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas agregar esta prenda?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarAgregar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarAgregarPrenda" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal de edición de prenda -->
        <div id="modalEditarPrenda" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Editar Prenda</h2>

                    <button onclick="cerrarModalEditar()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formEditarPrenda" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <input type="hidden" id="editarPrendaId" />

                    <div class="grid sm:grid-cols-2 gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="editarCodigo" class="block font-semibold text-black">Código</label>
                            <input id="editarCodigo"
                                   name="codigo"
                                   type="text"
                                   class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-gray-100 text-gray-700 cursor-not-allowed"
                                   readonly />
                        </div>

                        <div class="gap-1">
                            <label for="editarPrecio" class="block font-semibold text-black">Precio</label>
                            <input id="editarPrecio"
                                   name="precio"
                                   type="text"
                                   class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-gray-100 text-gray-700 cursor-not-allowed"
                                   readonly />
                        </div>

                        <div class="gap-1">
                            <label for="editarCategoria" class="block font-semibold text-black">Categoria</label>
                            <select id="editarCategoria" name="categoria" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <% if (categorias != null && !categorias.isEmpty())
                                    { %>
                                <% for (Categoria categoria : categorias)
                                    {%>
                                <option value="<%= categoria.idCategoria%>"><%= categoria.nombreCategoria%></option>
                                <% } %>
                                <% }%>
                            </select>

                            <input type="hidden" id="editarCategoria" name="categoriaId" />
                        </div>

                        <div class="gap-1">
                            <label for="editarSubcategoria" class="block font-semibold text-black">Subcategoria</label>
                            <select id="editarSubcategoria" name="subcategoria" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" disabled>
                                <% if (categorias != null)
                                    {
                                        for (Categoria categoria : categorias)
                                        {
                                            for (var sub : categoria.subcategoriasCategoria)
                                            {
                                %>
                                <option value="<%= sub.idSubcategoria%>" data-categoria="<%= categoria.idCategoria%>"  data-precio="<%= sub.precioSubcategoria%>"><%= sub.nombreSubcategoria%></option>
                                <%      }
                                        }
                                    } %>
                            </select>

                            <input type="hidden" id="editarSubcategoriaId" name="SubcategoriaId" />
                        </div>

                        <div class="gap-1">
                            <label for="editarTalla" class="block font-semibold text-black">Talla</label>
                            <select id="editarTalla" name="talla" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <% if (tallas != null && !tallas.isEmpty())
                                    { %>
                                <% for (Talla talla : tallas)
                                    {%>
                                <option value="<%= talla.idTalla%>"><%= talla.nombreTalla%></option>
                                <% } %>
                                <% }%>
                            </select>

                            <input type="hidden" id="editarTalla" name="tallaId" />
                        </div>

                        <div class="gap-1">
                            <label for="editarColor" class="block font-semibold text-black">Color</label>
                            <select id="editarColor" name="color" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <% if (colores != null && !colores.isEmpty())
                                    { %>
                                <% for (Color color : colores)
                                    {%>
                                <option value="<%= color.idColor%>"><%= color.nombreColor%></option>
                                <% } %>
                                <% }%>
                            </select>

                            <input type="hidden" id="editarColor" name="colorId" />
                        </div>

                        <div class="gap-1">
                            <label for="editarStock" class="block font-semibold text-black">Stock actual</label>
                            <input id="editarStock"
                                   name="stock"
                                   type="number"
                                   min="0"
                                   step="1"
                                   class="block w-full px-2 border border-black/50 rounded-md shadow-sm"
                                   placeholder="Ingrese el stock inicial" />

                            <input type="hidden" id="editarStock" name="stockId" />
                        </div>

                        <div class="gap-1">
                            <label for="editarStockMinimo" class="block font-semibold text-black">Stock mínimo</label>
                            <input id="editarStockMinimo"
                                   name="stockMinimo"
                                   type="number"
                                   min="0"
                                   step="1"
                                   class="block w-full px-2 border border-black/50 rounded-md shadow-sm"
                                   placeholder="Ingrese el stock mínimo" />

                            <input type="hidden" id="editarStockMinimo" name="stockMinimoId" />
                        </div>

                        <div class="gap-1">
                            <label for="editarEstado" class="block font-semibold text-black">Estado</label>
                            <select id="editarEstado" name="estado" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                                <% if (estados != null && !estados.isEmpty())
                                    {
                                        for (EstadoPrenda estado : estados)
                                        {%>
                                <option value="<%= estado.idEstadoPrenda%>"><%= estado.nombreEstadoPrenda%></option>
                                <% }
                                    } %>
                            </select>
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalEditar()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnGuardarPrenda" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal confirmación editar prenda -->
        <div id="modalConfirmarEditar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar edición</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas editar esta prenda?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEditar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEditarPrenda" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal confirmación eliminar prenda -->
        <div id="modalConfirmarEliminar" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar eliminación</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas eliminar esta prenda?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEliminar" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEliminarPrenda" class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 text-sm">Eliminar</button>
                </div>
            </div>
        </div>

        <!-- Modal generar reporte -->
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
                <form action="ReportePrendas" method="GET" target="_blank" 
                      onsubmit="cerrarModalReporte()" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">

                    <!-- Categoría -->
                    <div class="gap-1">
                        <label class="block font-semibold text-black">Categoría</label>
                        <select name="idCategoria" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                            <option value="">Todas</option>
                            <% if (categorias != null)
                                {
                                    for (Categoria cat : categorias)
                                    {%>
                            <option value="<%= cat.idCategoria%>"><%= cat.nombreCategoria%></option>
                            <%     }
                                } %>
                        </select>
                    </div>

                    <!-- Talla -->
                    <div class="gap-1">
                        <label class="block font-semibold text-black">Talla</label>
                        <select name="idTalla" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                            <option value="">Todas</option>
                            <% if (tallas != null)
                                {
                                    for (Talla talla : tallas)
                                    {%>
                            <option value="<%= talla.idTalla%>"><%= talla.nombreTalla%></option>
                            <% }
                                }%>
                        </select>
                    </div>

                    <!-- Stock bajo -->
                    <div class="gap-1">
                        <label class="block font-semibold text-black">Filtrar por stock bajo</label>
                        <select name="stockBajo" class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                            <option value="">No filtrar</option>
                            <option value="true">Sí, solo stock bajo</option>
                        </select>
                    </div>

                    <!-- Formato -->
                    <div class="gap-1">
                        <label class="block font-semibold text-black">Formato</label>
                        <select name="formato" required class="block w-full px-2 border border-black/50 rounded-md shadow-sm">
                            <option value="pdf">PDF</option>
                            <option value="excel">Excel</option>
                        </select>
                    </div>

                    <!-- Botones -->
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
        let totalPrendas = <%= totalPrendas%>;
        let searchTimeout = null;
        let datosPrendaEditada = null;
        let datosPrendaNueva = null;

        document.addEventListener("DOMContentLoaded", () => {
            cargarPrendas();

            document.getElementById("searchInput").addEventListener("input", () => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    currentPage = 1;
                    cargarPrendas();
                }, 300);
            });

            document.getElementById("pageSizeSelect").addEventListener("change", (e) => {
                pageSize = parseInt(e.target.value);
                currentPage = 1;
                cargarPrendas();
            });
        });

        document.addEventListener("click", function (e) {
            if (e.target.closest(".editar-prenda-btn")) {
                const btn = e.target.closest(".editar-prenda-btn");

                document.getElementById("editarPrendaId").value = btn.dataset.id;
                document.getElementById("editarCodigo").value = btn.dataset.id;
                document.getElementById("editarEstado").value = btn.dataset.estado;
                document.getElementById("editarCategoria").value = btn.dataset.categoria;
                document.getElementById("editarTalla").value = btn.dataset.talla;
                document.getElementById("editarColor").value = btn.dataset.color;
                document.getElementById("editarStock").value = btn.dataset.stock;
                document.getElementById("editarStockMinimo").value = btn.dataset.stockminimo;
                document.getElementById("editarPrecio").value = btn.dataset.precio;

                const catSelect = document.getElementById("editarCategoria");
                const subcatSelect = document.getElementById("editarSubcategoria");
                const subcatHidden = document.getElementById("editarSubcategoriaId");

                const categoriaId = btn.dataset.categoria;
                const subcatId = btn.dataset.subcategoria;

                catSelect.value = categoriaId;

                // Filtrar subcategorías visibles sin fetch
                subcatSelect.disabled = false;
                Array.from(subcatSelect.options).forEach(opt => {
                    const pertenece = opt.dataset.categoria === categoriaId || !opt.value;
                    opt.hidden = !pertenece;
                });

                // Seleccionar subcategoría
                subcatSelect.value = subcatId;
                subcatHidden.value = subcatId;

                document.getElementById("modalEditarPrenda").classList.remove("hidden");
                document.body.classList.add("overflow-hidden");
            }

            if (e.target.closest(".eliminar-prenda-btn")) {
                const btn = e.target.closest(".eliminar-prenda-btn");
                const codigo = btn.dataset.id;

                document.getElementById("confirmarEliminarPrenda").dataset.codigo = codigo;
                document.getElementById("modalConfirmarEliminar").classList.remove("hidden");
                document.body.classList.add("overflow-hidden");
            }
        });

        document.getElementById("cancelarConfirmarAgregar").addEventListener("click", function () {
            document.getElementById("modalConfirmarAgregar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("confirmarAgregarPrenda").addEventListener("click", function () {
            fetch("Prendas", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: datosPrendaNueva.toString()
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert(data.mensaje);
                            cerrarModalAgregar();
                            cargarPrendas();
                        } else {
                            alert("Error: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al agregar prenda:", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarAgregar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("cancelarConfirmarEditar").addEventListener("click", function () {
            document.getElementById("modalConfirmarEditar").classList.add("hidden");
        });

        document.getElementById("confirmarEditarPrenda").addEventListener("click", function () {
            fetch("Prendas", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(datosPrendaEditada)
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Prenda actualizada correctamente.");
                            cerrarModalEditar();
                            cargarPrendas();
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

        document.getElementById("confirmarEliminarPrenda").addEventListener("click", function () {
            const codigo = this.dataset.codigo;

            fetch("Prendas", {
                method: "DELETE",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({codigoPrenda: codigo})
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Prenda eliminada correctamente.");
                            cargarPrendas();
                        } else {
                            alert("Error al eliminar: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al eliminar prenda:", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarEliminar").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("agregarCategoria").addEventListener("change", function () {
            const categoriaId = this.value;
            const subcategoriaSelect = document.getElementById("agregarSubcategoria");
            const subcategoriaHidden = document.getElementById("agregarSubcategoriaId");

            subcategoriaSelect.disabled = false;
            subcategoriaHidden.value = "";

            Array.from(subcategoriaSelect.options).forEach(opt => {
                const pertenece = opt.dataset.categoria === categoriaId || !opt.value;
                opt.hidden = !pertenece;
            });

            subcategoriaSelect.selectedIndex = 0;
            document.getElementById("agregarPrecio").value = "";
        });

        document.getElementById("agregarSubcategoria").addEventListener("change", function () {
            const selectedOption = this.selectedOptions[0];
            const precio = selectedOption ? selectedOption.dataset.precio : "";
            document.getElementById("agregarSubcategoriaId").value = this.value;
            document.getElementById("agregarPrecio").value = precio ? parseInt(precio).toLocaleString() : "";
        });

        document.getElementById("editarCategoria").addEventListener("change", function () {
            const categoriaId = this.value;
            const subcategoriaSelect = document.getElementById("editarSubcategoria");
            const subcategoriaHidden = document.getElementById("editarSubcategoriaId");

            subcategoriaSelect.value = "";
            subcategoriaHidden.value = "";
            subcategoriaSelect.disabled = false;

            // Mostrar solo subcategorías que pertenecen a la categoría seleccionada
            Array.from(subcategoriaSelect.options).forEach(opt => {
                const pertenece = opt.dataset.categoria === categoriaId || !opt.value;
                opt.hidden = !pertenece;
            });

            subcategoriaSelect.selectedIndex = 0;
        });

        document.getElementById("editarSubcategoria").addEventListener("change", function () {
            const selectedOption = this.selectedOptions[0];
            const precio = selectedOption ? selectedOption.dataset.precio : "";
            document.getElementById("editarSubcategoriaId").value = this.value;
            document.getElementById("editarPrecio").value = precio ? parseInt(precio).toLocaleString() : "";
        });

        document.getElementById("formAgregarPrenda").addEventListener("submit", function (e) {
            e.preventDefault();

            const formData = new FormData(this);
            datosPrendaNueva = new URLSearchParams(formData);

            document.getElementById("modalConfirmarAgregar").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        });

        document.getElementById("formEditarPrenda").addEventListener("submit", function (e) {
            e.preventDefault();

            datosPrendaEditada = {
                codigoPrenda: document.getElementById("editarCodigo").value,
                stockPrenda: parseInt(document.getElementById("editarStock").value),
                stockminimoPrenda: parseInt(document.getElementById("editarStockMinimo").value),
                idColor: parseInt(document.getElementById("editarColor").value),
                idEstadoPrenda: parseInt(document.getElementById("editarEstado").value),
                idSubcategoria: parseInt(document.getElementById("editarSubcategoriaId").value),
                idTalla: parseInt(document.getElementById("editarTalla").value)
            };

            document.getElementById("modalConfirmarEditar").classList.remove("hidden");
        });

        function irAPagina(nuevaPagina) {
            currentPage = nuevaPagina;
            cargarPrendas();
        }

        function filtrarSubcategorias(categoriaId) {
            const subcategoriaSelect = document.getElementById("editarSubcategoria");
            const subcategoriaHidden = document.getElementById("editarSubcategoriaId");

            subcategoriaSelect.value = "";
            subcategoriaHidden.value = "";
            subcategoriaSelect.disabled = false;

            Array.from(subcategoriaSelect.options).forEach(opt => {
                const pertenece = opt.dataset.categoria === categoriaId || !opt.value;
                opt.hidden = !pertenece;
            });

            subcategoriaSelect.selectedIndex = 0;
        }

        function cargarPrendas() {
            const searchTerm = document.getElementById("searchInput").value.trim();

            fetch("Prendas?modo=ajax&searchTerm=" + encodeURIComponent(searchTerm) + "&numPage=" + currentPage + "&pageSize=" + pageSize).then(res => res.text()).then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");

                const nuevaTabla = doc.querySelector("#prendasFiltradas");
                const resumen = doc.querySelector("#resumenPrendas").textContent;
                const nuevaPaginacion = doc.querySelector("nav[aria-label='Paginación']");

                document.querySelector("#prendasFiltradas").innerHTML = nuevaTabla.innerHTML;
                document.querySelector("#resumenPrendas").textContent = resumen;
                document.querySelector("nav[aria-label='Paginación']").innerHTML = nuevaPaginacion.innerHTML;

                // actualizar totalPrendas si el servlet lo recalcula
                totalPrendas = parseInt(doc.querySelector("body").dataset.totalprendas) || totalPrendas;
            }).catch(err => console.error("Error cargando prendas:", err));
        }

        function abrirModalAgregar() {
            document.getElementById("modalAgregarPrenda").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }

        function cerrarModalAgregar() {
            document.getElementById("modalAgregarPrenda").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function cerrarModalEditar() {
            document.getElementById("modalEditarPrenda").classList.add("hidden");
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