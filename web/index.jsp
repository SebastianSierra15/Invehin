<%-- 
    Document   : index
    Created on : 21/05/2025, 11:13:48 a. m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Logica.Usuario"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<%
    if (session.getAttribute("sesion") == null)
    {
        response.sendRedirect("Views/login/login.jsp");
        return;
    }

    if (request.getAttribute("ventasDia") == null)
    {
        response.sendRedirect("EstadisticasInicio");
        return;
    }
%>

<%
    Usuario sesion = (Usuario) session.getAttribute("sesion");
%>

<%
    NumberFormat formato = NumberFormat.getInstance(new Locale("es", "CO"));
%>

<!DOCTYPE html>
<html  lang="es">
    <head>
        <meta charset="UTF-8">
        <title>INVEHIN - Dashboard</title>

        <!-- Importar fuente desde Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        fontFamily: {
                            sans: ['Poppins', 'sans-serif'],
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
    </head>

    <body class="bg-invehin-background font-sans flex">
        <aside id="sidebar" class="fixed top-0 left-0 bg-invehin-accent h-screen w-64 flex flex-col justify-between border-r-2 border-black transition-all duration-300 p-4">
            <div id="logo-container" class="flex items-center justify-between mb-4 pb-2 bg-invehin-accent border-b-2 border-black w-full sticky top-0 z-10 transition-all duration-300">
                <a href="${pageContext.request.contextPath}/" class="flex items-center justify-center">
                    <img src="${pageContext.request.contextPath}/images/logo.webp" title="Invehin" alt="Invehin Logo" class="w-32" id="sidebar-logo" />
                </a>

                <button title="Menu" class="text-black text-2xl focus:outline-none px-2 hover:text-invehin-primaryLight menu-button mt-2" id="menu-toggle">
                    <i class="fas fa-bars"></i>
                </button>
            </div>

            <div class="overflow-y-auto flex-1">
                <nav class="flex flex-col gap-2">
                    <a href="/INVEHIN/" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter">
                        <i class="fas fa-home text-xl" title="Inicio"></i>
                        <span class="sidebar-text">Inicio</span>
                    </a>

                    <a href="/INVEHIN/Vistas/Ventas/registrar-venta.jsp" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter">
                        <i class="fas fa-shopping-cart text-xl" title="Nueva Venta"></i>
                        <span class="sidebar-text">Nueva Venta</span>
                    </a>

                    <a href="/INVEHIN/Vistas/Ventas/ventas.jsp" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter">
                        <i class="fas fa-chart-bar text-xl" title="Ventas"></i>
                        <span class="sidebar-text">Ventas</span>
                    </a>

                    <a href="/INVEHIN/Vistas/Prendas/prendas.jsp" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter">
                        <i class="fas fa-tshirt text-xl" title="Prendas"></i>
                        <span class="sidebar-text">Prendas</span>
                    </a>

                    <a href="/INVEHIN/Vistas/Clientes/clientes.jsp" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter">
                        <i class="fas fa-users text-xl" title="Clientes"></i>
                        <span class="sidebar-text">Clientes</span>
                    </a>

                    <a href="/INVEHIN/Vistas/Pedidos/pedidos.jsp" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter">
                        <i class="fas fa-box text-xl" title="Pedidos"></i>
                        <span class="sidebar-text">Pedidos</span>
                    </a>

                    <a href="/INVEHIN/Vistas/Inventario/inventario.jsp" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter">
                        <i class="fas fa-warehouse text-xl" title="Inventario"></i>
                        <span class="sidebar-text">Inventario</span>
                    </a>

                    <a href="/INVEHIN/Vistas/Promociones/promociones.jsp" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter">
                        <i class="fas fa-tags text-xl" title="Promociones"></i>
                        <span class="sidebar-text">Promociones</span>
                    </a>

                    <a href="/INVEHIN/Vistas/Categorias/categorias.jsp" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter">
                        <i class="fas fa-clipboard-list text-xl" title="Categorias"></i>
                        <span class="sidebar-text">Categorias</span>
                    </a>

                    <a href="/INVEHIN/Vistas/Configuracion/configuracion.jsp" name="nav-item" class="flex items-center gap-2 text-black font-semibold px-4 py-2 rounded border-2 border-black bg-invehin-backgroundAlt hover:bg-invehin-primaryLighter">
                        <i class="fas fa-cogs text-xl" title="Configuración"></i>
                        <span class="sidebar-text">Configuración</span>
                    </a>
                </nav>
            </div>

            <div class="sticky bottom-0 w-full border-t-2 border-black mt-2 pt-4">
                <div class="flex flex-col gap-2">
                    <a href="/Vistas/Perfil/perfil.jsp" name="nav-item" class="flex items-center gap-4 text-black font-semibold px-4 py-2 rounded hover:bg-invehin-backgroundAlt">
                        <i class="fas fa-user" title="Perfil"></i>
                        <span class="sidebar-text">Sebastián Sierra</span>
                    </a>

                    <a href="/INVEHIN/Vistas/Login/login.jsp" name="nav-item" class="flex items-center gap-4 text-black font-semibold px-4 py-2 rounded bg-invehin-primary text-white hover:bg-invehin-primaryLight transition-colors">
                        <i class="fas fa-sign-out-alt" title="Cerrar sesión"></i>
                        <span class="sidebar-text">Cerrar sesión</span>
                    </a>
                </div>
            </div>
        </aside>

        <main id="main-content" class="w-full p-8 ml-64 transition-all duration-300">
            <div class="items-center justify-center text-center mx-auto mb-4">
                <h1 class="text-invehin-primary font-bold text-3xl md:text-4xl mb-4  md:mb-12">Bienvenido, <%=sesion.nombresPersona%></h1>

                <span id="fechaActual" class="text-center text-invehin-primaryLight font-bold"></span>
            </div>

            <div class="flex justify-center mb-10">
                <a href="${pageContext.request.contextPath}/Views/ventas/registrar-venta.jsp"
                   class="bg-invehin-primary text-white text-lg md:text-xl font-semibold px-6 py-2 rounded shadow hover:bg-invehin-primaryLight flex items-center gap-2 inline-block max-w-xs">
                    <i class="fas fa-shopping-cart"></i>
                    Nueva Venta
                </a>
            </div>

            <section class="max-h-full grid grid-cols-1 md:grid-rows-2  md:grid-cols-2 gap-6 mb-6 justify-center items-center">
                <a href="/INVEHIN/Vistas/Ventas/ventas.jsp" title="Ver ventas" class="bg-white rounded-xl shadow px-4 py-1 border-2 border-black flex flex-col justify-center items-center text-center hover:scale-105 transform transition duration-300 ease-in-out">
                    <i class="fas fa-sack-dollar text-invehin-primaryLight text-2xl"></i>
                    <h2 class="text-invehin-primaryLight font-semibold text-xl">Ventas del día</h2>
                    <p class="text-black text-2xl md:text-3xl font-bold">
                        $<%= formato.format(request.getAttribute("ventasDia") != null ? request.getAttribute("ventasDia") : 0)%>
                    </p>
                    <p class="text-gray-700 text-xs font-semibold">Total vendido hoy</p>
                </a>

                <a href="/INVEHIN/Vistas/Ventas/ventas.jsp" title="Ver ventas" class="bg-white rounded-xl shadow px-4 py-1 border-2 border-black flex flex-col justify-center items-center text-center hover:scale-105 transform transition duration-300 ease-in-out">
                    <i class="fas fa-bag-shopping text-invehin-primaryLight text-2xl"></i>
                    <h2 class="text-invehin-primaryLight font-semibold text-xl">Cant. vendida hoy</h2>
                    <p class="text-black text-2xl md:text-3xl font-bold">
                        <%= formato.format(request.getAttribute("prendasVendidasDia") != null ? request.getAttribute("prendasVendidasDia") : 0)%>
                    </p>
                    <p class="text-gray-700 text-xs font-semibold">Total prendas vendidas hoy</p>
                </a>

                <a href="/INVEHIN/Vistas/Pedidos/pedidos.jsp" title="Hacer pedido" class="bg-white rounded-xl shadow px-4 py-1 border-2 border-black flex flex-col justify-center items-center text-center hover:scale-105 transform transition duration-300 ease-in-out">
                    <i class="fas fa-bell text-invehin-primaryLight text-2xl"></i>
                    <h2 class="text-invehin-primaryLight font-semibold text-xl">Stock bajo</h2>
                    <p class="text-black text-2xl md:text-3xl font-bold">
                        <%= formato.format(request.getAttribute("prendasBajoStock") != null ? request.getAttribute("prendasBajoStock") : 0)%>
                    </p>
                    <p class="text-gray-700 text-xs font-semibold">Por debajo del mínimo</p>
                </a>

                <a href="/INVEHIN/Vistas/Ventas/ventas.jsp" title="Ver ventas" class="bg-white rounded-xl shadow px-4 py-1 border-2 border-black flex flex-col justify-center items-center text-center hover:scale-105 transform transition duration-300 ease-in-out">
                    <i class="fas fa-chart-simple text-invehin-primaryLight text-2xl"></i>
                    <h2 class="text-invehin-primaryLight font-semibold text-xl">Ventas del mes</h2>
                    <p class="text-black text-2xl md:text-3xl font-bold">
                        $<%= formato.format(request.getAttribute("ventasMes") != null ? request.getAttribute("ventasMes") : 0)%>
                    </p>
                    <p class="text-gray-700 text-xs font-semibold">Acumulado del mes</p>
                </a>
            </section>
        </main>

        <script>
            const meses = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"];
            const fecha = new Date();
            const dia = fecha.getDate();
            const mes = meses[fecha.getMonth()];
            const anio = fecha.getFullYear();
            document.getElementById("fechaActual").textContent = `${dia} ${mes} ${anio}`;
        </script>

        <script>
            const toggleButton = document.getElementById("menu-toggle");
            const sidebar = document.getElementById("sidebar");
            const mainContent = document.getElementById("main-content");

            toggleButton.addEventListener("click", () => {
                sidebar.classList.toggle("collapsed");
                sidebar.classList.toggle("w-64");
                sidebar.classList.toggle("w-20");
                sidebar.classList.toggle("px-2");

                const links = sidebar.querySelectorAll("nav a span, .sidebar-text");
                links.forEach(link => link.classList.toggle("hidden"));

                const logoContainer = document.getElementById("logo-container");
                const logoImage = document.getElementById("sidebar-logo");
                if (sidebar.classList.contains("collapsed")) {
                    logoContainer.classList.add("flex-col");
                    logoImage.src = "images/favicon.ico";
                    logoImage.classList.add("w-10");
                    mainContent.classList.remove("ml-64");
                    mainContent.classList.add("ml-20");
                } else {
                    logoContainer.classList.remove("flex-col");
                    logoImage.src = "images/logo.webp";
                    logoImage.classList.remove("w-10");
                    mainContent.classList.remove("ml-20");
                    mainContent.classList.add("ml-64");
                }

                const navItems = sidebar.querySelectorAll('[name="nav-item"]');
                navItems.forEach(item => {
                    if (sidebar.classList.contains("collapsed")) {
                        item.classList.add("justify-center");
                    } else {
                        item.classList.remove("justify-center");
                    }
                });
            });
        </script>
    </body>
</html>
