<%-- 
    Document   : categorias
    Created on : 19/06/2025, 9:26:22 p. m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Logica.Usuario"%>
<%@page import="Logica.Categoria"%>
<%@page import="Logica.Subcategoria"%>
<%@page import="java.util.List"%>
<%@ page import="com.google.gson.Gson" %>

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
        if (permiso.idPermiso == 1)
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
    Gson gson = new Gson();

    // Recibir resultado de paginación
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
    int totalCategorias = (int) request.getAttribute("totalCategorias");

    // Recibir paginación actual
    int numPage = (request.getAttribute("numPage") != null) ? (Integer) request.getAttribute("numPage") : 1;
    int pageSize = (request.getAttribute("pageSize") != null) ? (Integer) request.getAttribute("pageSize") : 10;

    // Para paginación
    int totalPaginas = (int) Math.ceil((double) totalCategorias / pageSize);
    int maxPaginas = 8;
    int inicio = Math.max(1, numPage - maxPaginas / 2);
    int fin = Math.min(totalPaginas, inicio + maxPaginas - 1);
    inicio = Math.max(1, fin - maxPaginas + 1);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Categorías - INVEHIN</title>

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

    <body class="bg-invehin-background font-sans flex flex-col overflow-x-hidden" data-totalcategorias="<%= totalCategorias%>">
        <%@ include file="/components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col min-h-screen flex-1 px-4 py-6 md:p-8 ml-20 sm:ml-64 transition-all duration-300 gap-2">
            <h1 class="text-invehin-primary font-bold text-3xl text-center mb-10">Gestión de Categorías</h1>

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
                        <button onclick="abrirModalAgregarCategoria()" class="bg-invehin-primary text-white font-medium px-4 py-1 rounded shadow hover:bg-invehin-primaryLight transition whitespace-nowrap">
                            <i class="fas fa-plus mr-2"></i>Agregar Categoría
                        </button>
                    </div>
                </div>

                <div class="w-full flex flex-col sm:flex-row justify-between items-center gap-2 sm:gap-4 w-auto">
                    <%
                        int desde = (int) ((numPage - 1) * pageSize + 1);
                        int hasta = Math.min(numPage * pageSize, totalCategorias);
                    %>
                    <div id="resumenCategorias" class="text-dark text-sm w-full">
                        Mostrando <%= totalCategorias > 0 ? desde : 0%> a <%= hasta%> de <%= totalCategorias%> categorías
                    </div>

                    <div class="relative w-full">
                        <input id="searchInput" type="search" placeholder="Buscar categoría..." class="w-full pl-10 pr-4 py-1 rounded-md shadow-md bg-white border border-gray-300 outline-none" />
                        <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none"></i>
                    </div>
                </div>
            </section>

            <!-- Tabla de Categorías -->
            <div class="overflow-x-auto w-full">
                <table class="w-full text-sm text-left bg-invehin-accentLight rounded-lg border-separate border-spacing-0 overflow-hidden">
                    <caption class="sr-only">Tabla de categorias</caption>
                    <thead class="bg-invehin-primary text-white">
                        <tr>
                            <th class="px-3 py-2 border border-white">ID</th>
                            <th class="px-3 py-2 border border-white">Nombre</th>
                            <th class="px-3 py-2 border border-white">Subcategorías</th>
                            <th class="px-3 py-2 border border-white text-center">Estado</th>
                            <th class="px-3 py-2 border border-white text-center">Editar</th>
                        </tr>
                    </thead>

                    <tbody id="categoriasFiltradas" class="bg-pink-100">
                        <% if (categorias != null && !categorias.isEmpty())
                            {
                                for (Categoria categoria : categorias)
                                {
                        %>
                        <tr>
                            <td class="px-3 py-2 border border-white"><%= categoria.idCategoria%></td>
                            <td class="px-3 py-2 border border-white"><%= categoria.nombreCategoria%></td>
                            <td class="px-3 py-2 border border-white">
                                <% if (categoria.subcategoriasCategoria != null && !categoria.subcategoriasCategoria.isEmpty())
                                    {
                                        for (Subcategoria sub : categoria.subcategoriasCategoria)
                                        {%>
                                <div class="flex justify-between items-center bg-white border p-1 mb-1 rounded">
                                    <span><%= sub.nombreSubcategoria%> - $<%= String.format("%,d", sub.precioSubcategoria)%></span>

                                    <div class="flex gap-1">
                                        <button title="Cambiar estado" class="cambiar-estado-subcategoria-btn"
                                                data-id="<%= sub.idSubcategoria%>"
                                                data-estado="<%= sub.estadoSubcategoria%>">
                                            <i class="fas fa-circle <%= sub.estadoSubcategoria ? "text-green-500 hover:text-green-400" : "text-red-500 hover:text-red-400"%>"></i>
                                        </button>

                                        <button title="Editar" class="text-blue-600 hover:text-blue-400 editar-subcategoria-btn"
                                                data-id="<%= sub.idSubcategoria%>"
                                                data-idcategoria="<%= categoria.idCategoria%>"
                                                data-nombrecategoria="<%= categoria.nombreCategoria%>"
                                                data-nombre="<%= sub.nombreSubcategoria%>"
                                                data-precio="<%= sub.precioSubcategoria%>">
                                            <i class="fas fa-pencil-alt"></i>
                                        </button>
                                    </div>
                                </div>
                                <% }
                                } else
                                { %>
                                <span class="text-gray-400">Sin subcategorías</span>
                                <% }%>
                                <button class="text-sm mt-1 text-green-600 hover:underline agregar-subcategoria-btn" data-id="<%= categoria.idCategoria%>" data-nombre="<%= categoria.nombreCategoria%>">
                                    <i class="fas fa-plus-circle mr-1"></i>Agregar Subcategoría
                                </button>
                            </td>

                            <td title="Cambiar estado" class="px-3 py-2 border border-white text-center align-middle">
                                <button type="button"
                                        class="cambiar-estado-categoria-btn group flex items-center gap-1 justify-center w-full cursor-pointer"
                                        data-id="<%= categoria.idCategoria%>"
                                        data-estado="<%= categoria.estadoCategoria%>">

                                    <i class="fas fa-circle text-xl 
                                       <%= categoria.estadoCategoria ? "text-green-500 group-hover:text-green-400" : "text-red-500 group-hover:text-red-400"%>"></i>

                                    <span class="text-sm font-semibold 
                                          <%= categoria.estadoCategoria ? "text-green-600 group-hover:text-green-500" : "text-red-600 group-hover:text-red-500"%>">
                                        <%= categoria.estadoCategoria ? "Activo" : "Inactivo"%>
                                    </span>
                                </button>
                            </td>
                            <td class="px-3 py-2 border border-white text-center">
                                <button title="Editar categoría" class="text-blue-600 hover:text-blue-500 transition editar-categoria-btn"
                                        data-id="<%= categoria.idCategoria%>"
                                        data-nombre="<%= categoria.nombreCategoria%>"
                                        data-subcategorias='<%= gson.toJson(categoria.subcategoriasCategoria)%>'>
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
                            <td colspan="8" class="text-center text-gray-500 py-3">No se encontraron categorías.</td>
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

        <!-- Modal agregar subcategoria -->
        <div id="modalAgregarSubcategoria" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Agregar subcategoría</h2>
                    <button onclick="cerrarModalAgregarSubcategoria()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formAgregarSubcategoria" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <div class="flex flex-col gap-2 sm:gap-x-6 sm:gap-y-4">
                        <input type="hidden" id="agregarSubcategoriaCategoriaId" name="categoria" type="number" />

                        <div class="gap-1">
                            <label for="agregarNombreSubcategoriaCategoria" class="block font-semibold text-black">Categoría</label>
                            <input id="agregarNombreSubcategoriaCategoria" name="nombreCategoria" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-gray-100 text-gray-700 cursor-not-allowed" readonly />
                        </div>

                        <div class="gap-1">
                            <label for="agregarNombreSubcategoria" class="block font-semibold text-black">Nombre</label>
                            <input id="agregarNombreSubcategoria" name="nombre" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Nombre de la subcategoría" required />
                        </div>

                        <div class="gap-1">
                            <label for="agregarPrecioSubcategoria" class="block font-semibold text-black">Precio</label>
                            <input id="agregarPrecioSubcategoria" name="precio" type="number" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="$10.000" required />
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalAgregarSubcategoria()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnAgregarSubcategoria" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Agregar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal confirmación agregar Subcategoria -->
        <div id="modalConfirmarAgregarSubcategoria" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar registro</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas agregar la subcategoría?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarAgregarSubcategoria" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarAgregarSubcategoria" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal edición de subcategoria -->
        <div id="modalEditarSubcategoria" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Editar Subcategoría</h2>

                    <button onclick="cerrarModalEditarSubcategoria()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <form id="formEditarSubcategoria" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <input type="hidden" id="editarSubcategoriaId" type="number" />
                    <input type="hidden" id="editarSubcategoriaCategoriaId" name="categoria" type="number" />

                    <div class="flex flex-col gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="editarNombreSubcategoriaCategoria" class="block font-semibold text-black">Categoría</label>
                            <input id="editarNombreSubcategoriaCategoria" name="nombreCategoria" type="text" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm bg-gray-100 text-gray-700 cursor-not-allowed" readonly/>
                        </div>

                        <div class="gap-1">
                            <label for="editarNombreSubcategoria" class="block font-semibold text-black">Nombre</label>
                            <input id="editarNombreSubcategoria" name="nombre" type="text" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Nombre de la subcategoría" required />
                        </div>

                        <div class="gap-1">
                            <label for="editarPrecioSubcategoria" class="block font-semibold text-black">Precio</label>
                            <input id="editarPrecioSubcategoria" name="precio" type="number" min="0" step="1" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="$ 10.000" required />
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalEditarSubcategoria()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnGuardarSubcategoria" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal confirmación editar subcategoria -->
        <div id="modalConfirmarEditarSubcategoria" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar edición</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas editar la subcategoría?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEditarSubcategoria" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEditarSubcategoria" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal confirmación cambio estado subcategoria -->
        <div id="modalConfirmarEstadoSubcategoria" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar cambio de estado</h2>
                <p class="mb-6 text-sm text-gray-700"/>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEstadoSubcategoria" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEstadoSubcategoria" class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal agregar categoria -->
        <div id="modalAgregarCategoria" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Agregar categoría</h2>
                    <button onclick="cerrarModalAgregarCategoria()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Contenido -->
                <form id="formAgregarCategoria" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <div class="flex flex-col gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="agregarNombreCategoria" class="block font-semibold text-black">Nombre</label>
                            <input id="agregarNombreCategoria" name="nombre" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Nombre de la categoría" required />
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalAgregarCategoria()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnAgregarCategoria" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Agregar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal confirmación agregar categoria -->
        <div id="modalConfirmarAgregarCategoria" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar registro</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas agregar la categoría?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarAgregarCategoria" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarAgregarCategoria" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal edición de categoria -->
        <div id="modalEditarCategoria" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg sm:w-full sm:max-w-xl w-11/12 max-h-[90vh] flex flex-col relative overflow-hidden">
                <!-- Header -->
                <div class="bg-invehin-primary text-white px-4 py-3 flex items-center justify-between ">
                    <h2 class="text-lg font-bold">Editar Categoría</h2>

                    <button onclick="cerrarModalEditarCategoria()" class="text-gray-200 hover:text-gray-100 text-lg">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <form id="formEditarCategoria" class="flex flex-col overflow-y-auto px-4 py-4 flex-1 gap-2 sm:gap-4">
                    <input type="hidden" id="editarCategoriaId" type="number" />

                    <div class="flex flex-col gap-2 sm:gap-x-6 sm:gap-y-4">
                        <div class="gap-1">
                            <label for="editarNombreCategoria" class="block font-semibold text-black">Nombre</label>
                            <input id="editarNombreCategoria" name="nombre" type="text" class="block w-full px-2 border border-black/50 rounded-md shadow-sm" placeholder="Nombre de la categoría" required />
                        </div>
                    </div>

                    <div class="flex justify-end gap-2 pt-3 border-t border-gray-400 mx-[-1rem] px-4 mt-1">
                        <button type="button" onclick="cerrarModalEditarCategoria()" class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400 text-sm">Cancelar</button>
                        <button type="submit" id="btnGuardarCategoria" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal confirmación editar categoria -->
        <div id="modalConfirmarEditarCategoria" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar edición</h2>
                <p class="mb-6 text-sm text-gray-700">¿Estás seguro de que deseas editar la categoría?</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEditarCategoria" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEditarCategoria" class="px-4 py-2 bg-invehin-primary text-white rounded hover:bg-invehin-primaryLight text-sm">Confirmar</button>
                </div>
            </div>
        </div>

        <!-- Modal confirmación cambio estado categoria -->
        <div id="modalConfirmarEstadoCategoria" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center">
            <div class="bg-white border border-black rounded-lg shadow-lg max-w-md w-11/12 p-6 text-center">
                <h2 class="text-invehin-primary text-lg font-bold mb-4">Confirmar cambio de estado</h2>
                <p class="mb-6 text-sm text-gray-700"><strong>¿Estás seguro de que deseas cambiar el estado de esta categoría?</strong><br/>
                    Si la desactivas, sus subcategorías también quedarán inactivas, y las prendas asociadas a ellas no estarán disponibles para registrar nuevas ventas. 
                    Esta acción no elimina los datos y puede revertirse en cualquier momento.</p>
                <div class="flex justify-center gap-4">
                    <button id="cancelarConfirmarEstadoCategoria" class="px-4 py-2 bg-gray-300 text-black rounded hover:bg-gray-400 text-sm">Cancelar</button>
                    <button id="confirmarEstadoCategoria" class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 text-sm">Confirmar</button>
                </div>
            </div>
        </div>
    </body>

    <script>
        let currentPage = <%= numPage%>;
        let pageSize = <%= pageSize%>;
        let totalCategorias = <%= totalCategorias%>;
        let searchTimeout = null;
        let datosCategoriaEditada = null;
        let datosCategoriaNueva = null;
        let datosSubcategoriaEditada = null;
        let datosSubcategoriaNueva = null;

        document.addEventListener("DOMContentLoaded", () => {
            cargarCategorias();
            document.getElementById("searchInput").addEventListener("input", () => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    currentPage = 1;
                    cargarCategorias();
                }, 300);
            });
            document.getElementById("pageSizeSelect").addEventListener("change", (e) => {
                pageSize = parseInt(e.target.value);
                currentPage = 1;
                cargarCategorias();
            });
        });

        document.addEventListener("click", function (e) {
            if (e.target.closest(".agregar-subcategoria-btn")) {
                const btn = e.target.closest(".agregar-subcategoria-btn");
                document.getElementById("agregarSubcategoriaCategoriaId").value = btn.dataset.id;
                document.getElementById("agregarNombreSubcategoriaCategoria").value = btn.dataset.nombre;

                document.getElementById("modalAgregarSubcategoria").classList.remove("hidden");
                document.body.classList.add("overflow-hidden");

            } else if (e.target.closest(".editar-subcategoria-btn")) {
                const btn = e.target.closest(".editar-subcategoria-btn");

                document.getElementById("editarSubcategoriaId").value = btn.dataset.id;
                document.getElementById("editarSubcategoriaCategoriaId").value = btn.dataset.idcategoria;
                document.getElementById("editarNombreSubcategoriaCategoria").value = btn.dataset.nombrecategoria;
                document.getElementById("editarNombreSubcategoria").value = btn.dataset.nombre;
                document.getElementById("editarPrecioSubcategoria").value = btn.dataset.precio;

                document.getElementById("modalEditarSubcategoria").classList.remove("hidden");
                document.body.classList.add("overflow-hidden");

            } else if (e.target.closest(".cambiar-estado-subcategoria-btn")) {
                const btn = e.target.closest(".cambiar-estado-subcategoria-btn");
                const id = btn.dataset.id;
                const estado = btn.dataset.estado;

                const modal = document.getElementById("modalConfirmarEstadoSubcategoria");
                const confirmarBtn = document.getElementById("confirmarEstadoSubcategoria");
                const mensaje = modal.querySelector("p");

                confirmarBtn.dataset.id = id;
                confirmarBtn.dataset.estado = estado;

                if (estado === "true") {
                    mensaje.innerHTML = `<strong>¿Estás seguro de que deseas desactivar esta subcategoría?</strong><br/>
                    Las prendas asociadas no estarán disponibles para registrar nuevas ventas. Esta acción no elimina los datos y puede revertirse.`;

                    confirmarBtn.className = "px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 text-sm";
                    confirmarBtn.textContent = "Desactivar";
                } else {
                    mensaje.innerHTML = `<strong>¿Deseas activar esta subcategoría?</strong><br/>
                    Las prendas asociadas volverán a estar disponibles para registrar ventas.`;

                    confirmarBtn.className = "px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700 text-sm";
                    confirmarBtn.textContent = "Activar";
                }

                modal.classList.remove("hidden");
                document.body.classList.add("overflow-hidden");

            } else if (e.target.closest(".editar-categoria-btn")) {
                const btn = e.target.closest(".editar-categoria-btn");

                document.getElementById("editarCategoriaId").value = btn.dataset.id;
                document.getElementById("editarNombreCategoria").value = btn.dataset.nombre;

                document.getElementById("modalEditarCategoria").classList.remove("hidden");
                document.body.classList.add("overflow-hidden");

            } else if (e.target.closest(".cambiar-estado-categoria-btn")) {
                const btn = e.target.closest(".cambiar-estado-categoria-btn");
                const id = btn.dataset.id;
                const estado = btn.dataset.estado;

                const modal = document.getElementById("modalConfirmarEstadoCategoria");
                const confirmarBtn = document.getElementById("confirmarEstadoCategoria");
                const mensaje = modal.querySelector("p");

                confirmarBtn.dataset.id = id;
                confirmarBtn.dataset.estado = estado;

                if (estado === "true") {
                    mensaje.innerHTML = `<strong>¿Estás seguro de que deseas desactivar esta subcategoría?</strong><br/>
                    Las subcategorías asociadas también quedarán inactivas y las prendas relacionadas no estarán disponibles para registrar nuevas ventas. 
                    Esta acción no elimina los datos y puede revertirse.`;

                    confirmarBtn.className = "px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 text-sm";
                    confirmarBtn.textContent = "Desactivar";
                } else {
                    mensaje.innerHTML = `<strong>¿Deseas activar esta subcategoría?</strong><br/>
                    Sus subcategorías y prendas asociadas volverán a estar disponibles para registrar ventas.`;

                    confirmarBtn.className = "px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700 text-sm";
                    confirmarBtn.textContent = "Activar";
                }

                modal.classList.remove("hidden");
                document.body.classList.add("overflow-hidden");
            }
        });

        document.getElementById("cancelarConfirmarAgregarSubcategoria").addEventListener("click", function () {
            document.getElementById("modalConfirmarAgregarSubcategoria").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("confirmarAgregarSubcategoria").addEventListener("click", function () {
            fetch("Subcategorias", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: datosSubcategoriaNueva.toString()
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert(data.mensaje);
                            cerrarModalAgregarSubcategoria();
                            cargarCategorias();
                        } else {
                            alert("Error: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al registrar subcategoria", error);
                        alert("Ocurrió un error inesperado.");
                    });
            document.getElementById("modalConfirmarAgregarSubcategoria").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("cancelarConfirmarEditarSubcategoria").addEventListener("click", function () {
            document.getElementById("modalConfirmarEditarSubcategoria").classList.add("hidden");
        });

        document.getElementById("confirmarEditarSubcategoria").addEventListener("click", function () {
            fetch("Subcategorias", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(datosSubcategoriaEditada)
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Subcategoría actualizada correctamente.");
                            cerrarModalEditarSubcategoria();
                            cargarCategorias();
                        } else {
                            alert("Error al actualizar: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al enviar actualización:", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarEditarSubcategoria").classList.add("hidden");
        });

        document.getElementById("cancelarConfirmarEstadoSubcategoria").addEventListener("click", function () {
            document.getElementById("modalConfirmarEstadoSubcategoria").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("confirmarEstadoSubcategoria").addEventListener("click", function () {
            const id = this.dataset.id;
            const estado = this.dataset.estado;

            fetch("Subcategorias", {
                method: "DELETE",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({idSubcategoria: id, estadoSubcategoria: estado})
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Cambio de estado de subcategoría exitoso.");
                            cargarCategorias();
                        } else {
                            alert("Error al cambiar el estado " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al cambiar estado de la subcategoría", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarEstadoSubcategoria").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("cancelarConfirmarAgregarCategoria").addEventListener("click", function () {
            document.getElementById("modalConfirmarAgregarCategoria").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("confirmarAgregarCategoria").addEventListener("click", function () {
            fetch("Categorias", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: datosCategoriaNueva.toString()
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert(data.mensaje);
                            cerrarModalAgregarCategoria();
                            cargarCategorias();
                        } else {
                            alert("Error: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al registrar categoria", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarAgregarCategoria").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("cancelarConfirmarEditarCategoria").addEventListener("click", function () {
            document.getElementById("modalConfirmarEditarCategoria").classList.add("hidden");
        });

        document.getElementById("confirmarEditarCategoria").addEventListener("click", function () {
            fetch("Categorias", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(datosCategoriaEditada)
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Categoría actualizada correctamente.");
                            cerrarModalEditarCategoria();
                            cargarCategorias();
                        } else {
                            alert("Error al actualizar: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al enviar actualización:", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarEditarCategoria").classList.add("hidden");
        });

        document.getElementById("cancelarConfirmarEstadoCategoria").addEventListener("click", function () {
            document.getElementById("modalConfirmarEstadoCategoria").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("confirmarEstadoCategoria").addEventListener("click", function () {
            const id = this.dataset.id;
            const estado = this.dataset.estado;

            fetch("Categorias", {
                method: "DELETE",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({idCategoria: id, estadoCategoria: estado})
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Cambio de estado de categoría exitosamente.");
                            cargarCategorias();
                        } else {
                            alert("Error al cambiar estado " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error al cambiar estado de la categoría", error);
                        alert("Ocurrió un error inesperado.");
                    });

            document.getElementById("modalConfirmarEstadoCategoria").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        });

        document.getElementById("formAgregarSubcategoria").addEventListener("submit", function (e) {
            e.preventDefault();
            const formData = new FormData(this);
            datosSubcategoriaNueva = new URLSearchParams(formData);

            document.getElementById("modalConfirmarAgregarSubcategoria").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        });

        document.getElementById("formEditarSubcategoria").addEventListener("submit", function (e) {
            e.preventDefault();

            datosSubcategoriaEditada = {
                idSubcategoria: document.getElementById("editarSubcategoriaId").value,
                nombreSubcategoria: document.getElementById("editarNombreSubcategoria").value,
                precioSubcategoria: document.getElementById("editarPrecioSubcategoria").value,
                idCategoria: document.getElementById("editarSubcategoriaCategoriaId").value
            };

            document.getElementById("modalConfirmarEditarSubcategoria").classList.remove("hidden");
        });

        document.getElementById("formAgregarCategoria").addEventListener("submit", function (e) {
            e.preventDefault();
            const formData = new FormData(this);
            datosCategoriaNueva = new URLSearchParams(formData);

            document.getElementById("modalConfirmarAgregarCategoria").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        });

        document.getElementById("formEditarCategoria").addEventListener("submit", function (e) {
            e.preventDefault();

            datosCategoriaEditada = {
                idCategoria: document.getElementById("editarCategoriaId").value,
                nombreCategoria: document.getElementById("editarNombreCategoria").value
            };

            document.getElementById("modalConfirmarEditarCategoria").classList.remove("hidden");
        });

        function irAPagina(nuevaPagina) {
            currentPage = nuevaPagina;
            cargarCategorias();
        }

        function cargarCategorias() {
            const searchTerm = document.getElementById("searchInput").value.trim();
            fetch("Categorias?searchTerm=" + encodeURIComponent(searchTerm) + "&numPage=" + currentPage + "&pageSize=" + pageSize).then(res => res.text()).then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, "text/html");
                const nuevaTabla = doc.querySelector("#categoriasFiltradas");
                const resumen = doc.querySelector("#resumenCategorias").textContent;
                const nuevaPaginacion = doc.querySelector("nav[aria-label='Paginación']");
                document.querySelector("#categoriasFiltradas").innerHTML = nuevaTabla.innerHTML;
                document.querySelector("#resumenCategorias").textContent = resumen;
                document.querySelector("nav[aria-label='Paginación']").innerHTML = nuevaPaginacion.innerHTML;
                // actualizar totalCategorias si el servlet lo recalcula
                totalCategorias = parseInt(doc.querySelector("body").dataset.totalcategorias) || totalCategorias;
            }).catch(err => console.error("Error cargando categorias", err));
        }

        function cerrarModalAgregarSubcategoria() {
            document.getElementById("modalAgregarSubcategoria").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function cerrarModalEditarSubcategoria() {
            document.getElementById("modalEditarSubcategoria").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function abrirModalAgregarCategoria() {
            document.getElementById("agregarNombreCategoria").value = "";

            document.getElementById("modalAgregarCategoria").classList.remove("hidden");
            document.body.classList.add("overflow-hidden");
        }

        function cerrarModalAgregarCategoria() {
            document.getElementById("modalAgregarCategoria").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }

        function cerrarModalEditarCategoria() {
            document.getElementById("modalEditarCategoria").classList.add("hidden");
            document.body.classList.remove("overflow-hidden");
        }
    </script>
</html>
