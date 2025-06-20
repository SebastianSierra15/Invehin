<%-- 
    Document   : sidebar
    Created on : 3/06/2025, 3:34:04 p. m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="Logica.Usuario"%>
<%@page import="Logica.Permiso"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Set<Integer> idsPermisos = new HashSet<>();
    int idUsuarioSesion = 2;
    if (session.getAttribute("sesion") != null)
    {
        idUsuarioSesion = ((Usuario) session.getAttribute("sesion")).idUsuario;
        for (Permiso p : ((Usuario) session.getAttribute("sesion")).rolUsuario.permisosRol)
        {
            idsPermisos.add(p.idPermiso);
        }
    }
%>
<%!
    public boolean tienePermiso(Set<Integer> permisos, int id)
    {
        return permisos.contains(id);
    }
%>

<style>
    .overflow-y-auto::-webkit-scrollbar {
        width: 8px;
    }

    .overflow-y-auto::-webkit-scrollbar-thumb {
        background-color: #951556;
        border-radius: 8px;
        border: 2px solid #f5dcea;
    }

    .overflow-y-auto::-webkit-scrollbar-thumb:hover {
        background-color: #c21b70;
    }

    .overflow-y-auto::-webkit-scrollbar-track {
        background-color: #f8d2e4;
        border-radius: 8px;
    }

    .sidebar.collapsed .nav-item {
        flex-direction: column;
        justify-content: center;
    }

    .sidebar.collapsed .nav-item .sidebar-text {
        display: none;
    }

    .sidebar:not(.collapsed) .nav-item {
        flex-direction: row;
        justify-content: flex-start;
    }

    .sidebar.collapsed #logo-container {
        flex-direction: column;
        align-items: center;
    }

    .sidebar.collapsed #sidebar-logo {
        width: 2.5rem;
        margin-bottom: 0.5rem;
    }

    .sidebar.collapsed .menu-button {
        margin-top: 0.5rem;
    }
</style>

<aside id="sidebar" class="fixed z-40 top-0 left-0 bg-invehin-accent h-screen w-64 flex flex-col justify-between border-r-2 border-black transition-all duration-300 p-4">
    <div id="logo-container" class="flex items-center justify-between mb-4 pb-2 bg-invehin-accent border-b-2 border-black w-full sticky top-0 z-10 transition-all duration-300">
        <a href="${pageContext.request.contextPath}/" class="flex items-center justify-center">
            <img src="${pageContext.request.contextPath}/images/logo.webp" title="Invehin" alt="Invehin Logo" class="w-32" id="sidebar-logo" />
        </a>

        <button id="menu-toggle" title="Menu" class="text-black text-2xl focus:outline-none px-2 hover:text-invehin-primaryLight menu-button mt-2">
            <i class="fas fa-bars"></i>
        </button>
    </div>

    <div class="overflow-y-auto flex-1">
        <nav class="flex flex-col gap-2">
            <a href="${pageContext.request.contextPath}/" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter
               <%= request.getRequestURI().endsWith("/") ? "bg-invehin-primaryLighter" : ""%>">
                <i class="fas fa-home text-xl" title="Inicio"></i>
                <span class="sidebar-text">Dashboard</span>
            </a>

            <% if (tienePermiso(idsPermisos, 6))
                {%>
            <a href="${pageContext.request.contextPath}/Views/ventas/registrar-venta.jsp" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter
               <%= request.getRequestURI().endsWith("/Views/ventas/registrar-venta.jsp") ? "bg-invehin-primaryLighter" : ""%>">
                <i class="fas fa-shopping-cart text-xl" title="Nueva Venta"></i>
                <span class="sidebar-text">Nueva Venta</span>
            </a>
            <% }%>

            <% if (tienePermiso(idsPermisos, 7))
                {%>
            <a href="${pageContext.request.contextPath}/Ventas" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter
               <%= request.getRequestURI().endsWith("/Views/ventas/ventas.jsp") ? "bg-invehin-primaryLighter" : ""%>">
                <i class="fas fa-chart-bar text-xl" title="Ventas"></i>
                <span class="sidebar-text">Ventas</span>
            </a>
            <% }%>

            <% if (tienePermiso(idsPermisos, 8))
                {%>
            <a href="${pageContext.request.contextPath}/Prendas" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter
               <%= request.getRequestURI().endsWith("/Views/prendas/prendas.jsp") ? "bg-invehin-primaryLighter" : ""%>">
                <i class="fas fa-tshirt text-xl" title="Prendas"></i>
                <span class="sidebar-text">Prendas</span>
            </a>
            <% }%>

            <% if (tienePermiso(idsPermisos, 4))
                {%>
            <a href="${pageContext.request.contextPath}/Clientes" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter
               <%= request.getRequestURI().endsWith("/Views/clientes/clientes.jsp") ? "bg-invehin-primaryLighter" : ""%>">
                <i class="fas fa-users text-xl" title="Clientes"></i>
                <span class="sidebar-text">Clientes</span>
            </a>
            <% }%>

            <% if (tienePermiso(idsPermisos, 9))
                {%>
            <a href="${pageContext.request.contextPath}/Pedidos" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter
               <%= request.getRequestURI().endsWith("/Views/pedidos/pedidos.jsp") ? "bg-invehin-primaryLighter" : ""%>">
                <i class="fas fa-box text-xl" title="Pedidos"></i>
                <span class="sidebar-text">Pedidos</span>
            </a>
            <% }%>

            <% if (tienePermiso(idsPermisos, 11))
                {%>
            <a href="${pageContext.request.contextPath}/Inventario" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter
               <%= request.getRequestURI().endsWith("/Views/inventario/inventario.jsp") ? "bg-invehin-primaryLighter" : ""%>">
                <i class="fas fa-warehouse text-xl" title="Inventario"></i>
                <span class="sidebar-text">Inventario</span>
            </a>
            <% }%>

            <% if (tienePermiso(idsPermisos, 10))
                {%>
            <a href="${pageContext.request.contextPath}/Proveedores" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter
               <%= request.getRequestURI().endsWith("/Views/proveedores/proveedores.jsp") ? "bg-invehin-primaryLighter" : ""%>">
                <i class="fas fa-truck text-xl" title="Proveedores"></i>
                <span class="sidebar-text">Proveedores</span>
            </a>
            <% }%>

            <% if (tienePermiso(idsPermisos, 3))
                {%>
            <a href="${pageContext.request.contextPath}/Usuarios" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter
               <%= request.getRequestURI().endsWith("/Views/usuarios/usuarios.jsp") ? "bg-invehin-primaryLighter" : ""%>">
                <i class="fas fa-users-line text-xl" title="Usuarios"></i>
                <span class="sidebar-text">Usuarios</span>
            </a>
            <% }%>

            <% if (tienePermiso(idsPermisos, 1))
                {%>
            <a href="${pageContext.request.contextPath}/Categorias" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter
               <%= request.getRequestURI().endsWith("/Views/categorias/categorias.jsp") ? "bg-invehin-primaryLighter" : ""%>">
                <i class="fas fa-clipboard-list text-xl" title="Categorias"></i>
                <span class="sidebar-text">Categorias</span>
            </a>
            <% }%>

            <% if (tienePermiso(idsPermisos, 5))
                {%>
            <a href="${pageContext.request.contextPath}/Roles" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter
               <%= request.getRequestURI().endsWith("/Views/roles/roles.jsp") ? "bg-invehin-primaryLighter" : ""%>">
                <i class="fas fa-cogs text-xl" title="Roles"></i>
                <span class="sidebar-text">Roles</span>
            </a>
            <% }%>
        </nav>
    </div>

    <div class="sticky bottom-0 w-full border-t-2 border-black mt-2 pt-4">
        <div class="flex flex-col gap-2">
            <a href="<%= request.getContextPath() + "/Perfil?id=" + idUsuarioSesion%>" name="nav-item" class="flex items-center gap-4 text-black font-semibold px-4 py-2 rounded hover:bg-invehin-backgroundAlt
               <%= request.getRequestURI().endsWith("/Views/perfil/perfil.jsp") ? "bg-invehin-backgroundAlt" : ""%>">
                <i class="fas fa-user" title="Perfil"></i>
                <span class="sidebar-text">Sebastián Sierra</span>
            </a>

            <a href="${pageContext.request.contextPath}/Logout" name="nav-item" class="flex items-center gap-4 text-black font-semibold px-4 py-2 rounded bg-invehin-primary text-white hover:bg-invehin-primaryLight transition-colors">
                <i class="fas fa-sign-out-alt" title="Cerrar sesión"></i>
                <span class="sidebar-text">Cerrar sesión</span>
            </a>
        </div>
    </div>
</aside>

<script>
    const toggleButton = document.getElementById("menu-toggle");
    const sidebar = document.getElementById("sidebar");
    const logoContainer = document.getElementById("logo-container");
    const logoImage = document.getElementById("sidebar-logo");

    function aplicarColapsado() {
        const mainContent = document.getElementById("main-content");
        const footer = document.getElementById("footer");

        sidebar.classList.add("collapsed", "w-20", "px-2");
        sidebar.classList.remove("w-64");

        // Ocultar textos
        const links = sidebar.querySelectorAll("nav a span, .sidebar-text");
        links.forEach(link => link.classList.add("hidden"));

        // Cambiar logo
        logoContainer.classList.add("flex-col", "items-center");
        logoImage.src = `${pageContext.request.contextPath}/favicon.ico`;
        logoImage.classList.add("w-10");

        // Centrar íconos
        const navItems = sidebar.querySelectorAll('[name="nav-item"]');
        navItems.forEach(item => item.classList.add("justify-center"));

        // Ajustar contenido principal
        if (mainContent && window.innerWidth >= 640) {
            mainContent.classList.remove("sm:ml-64");
            mainContent.classList.add("ml-20");
        }

        // Ajustar contenido footer
        if (footer && window.innerWidth >= 640) {
            footer.classList.remove("sm:ml-64");
            footer.classList.add("ml-20");
        }
    }

    function quitarColapsado() {
        const mainContent = document.getElementById("main-content");
        const footer = document.getElementById("footer");

        sidebar.classList.remove("collapsed", "w-20", "px-2");
        sidebar.classList.add("w-64");

        const links = sidebar.querySelectorAll("nav a span, .sidebar-text");
        links.forEach(link => link.classList.remove("hidden"));

        logoContainer.classList.remove("flex-col", "items-center");
        logoImage.src = `${pageContext.request.contextPath}/images/logo.webp`;
        logoImage.classList.remove("w-10");

        const navItems = sidebar.querySelectorAll('[name="nav-item"]');
        navItems.forEach(item => item.classList.remove("justify-center"));

        if (mainContent && window.innerWidth >= 640) {
            mainContent.classList.remove("ml-20");
            mainContent.classList.add("sm:ml-64");
        }

        if (footer && window.innerWidth >= 640) {
            footer.classList.remove("ml-20");
            footer.classList.add("sm:ml-64");
        }
    }

    // Al cargar, si es menor a lg, colapsar
    window.addEventListener("DOMContentLoaded", () => {
        const esMenorALg = window.innerWidth < 1024;
        if (esMenorALg) {
            aplicarColapsado();
        }

        toggleButton.addEventListener("click", () => {
            const colapsado = sidebar.classList.contains("collapsed");
            if (colapsado) {
                quitarColapsado();
            } else {
                aplicarColapsado();
            }
        });
    });
</script>
