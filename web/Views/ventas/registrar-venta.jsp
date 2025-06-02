<%-- 
    Document   : registrar-venta.jsp
    Created on : 22/05/2025, 9:31:16 p. m.
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
        <title>INVEHIN - Registrar Venta</title>

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

            #sugerencias li {
                list-style: none;
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
            <h1 class="text-invehin-primary font-bold text-3xl text-center mb-6">Registrar Venta</h1>

            <div class="w-full max-w-2xl mx-auto relative">
                <!-- Buscador -->
                <input id="searchInput"
                       type="search"
                       placeholder="Buscar prenda por nombre, categoría, color, talla..."
                       class="pl-6 pr-4 py-3 rounded-md shadow-md bg-white border border-gray-300 w-full outline-none"
                       />

                <!-- Lista de sugerencias -->
                <ul id="sugerencias" class="rounded-md shadow-md bg-white absolute left-0 right-0 top-full mt-2 p-3 hidden z-50 max-h-60 overflow-y-auto border border-gray-300">

                    <li id="sug-1" class="hidden grid grid-cols-10 gap-4 items-center cursor-pointer px-4 py-2 rounded-lg hover:bg-gray-50 text-sm font-medium text-gray-800"></li>
                    <li id="sug-2" class="hidden grid grid-cols-10 gap-4 items-center cursor-pointer px-4 py-2 rounded-lg hover:bg-gray-50 text-sm font-medium text-gray-800"></li>
                    <li id="sug-3" class="hidden grid grid-cols-10 gap-4 items-center cursor-pointer px-4 py-2 rounded-lg hover:bg-gray-50 text-sm font-medium text-gray-800"></li>
                    <li id="sug-4" class="hidden grid grid-cols-10 gap-4 items-center cursor-pointer px-4 py-2 rounded-lg hover:bg-gray-50 text-sm font-medium text-gray-800"></li>
                    <li id="sug-5" class="hidden grid grid-cols-10 gap-4 items-center cursor-pointer px-4 py-2 rounded-lg hover:bg-gray-50 text-sm font-medium text-gray-800"></li>
                    <li id="sug-6" class="hidden grid grid-cols-10 gap-4 items-center cursor-pointer px-4 py-2 rounded-lg hover:bg-gray-50 text-sm font-medium text-gray-800"></li>
                </ul>
            </div>


            <div class="overflow-x-auto">
                <table class="w-full border border-black text-sm text-left bg-invehin-accentLight">
                    <thead class="bg-invehin-primary text-white">
                        <tr>
                            <th class="border px-3 py-2">Prenda</th>
                            <th class="border px-3 py-2">Talla</th>
                            <th class="border px-3 py-2">Color</th>
                            <th class="border px-3 py-2">Precio</th>
                            <th class="border px-3 py-2">Cantidad</th>
                            <th class="border px-3 py-2">Sub total</th>
                            <th class="border px-3 py-2">Acción</th>
                        </tr>
                    </thead>
                    <tbody id="prendasSeleccionadas">
                        <!-- Las filas se insertan dinámicamente con JavaScript -->
                    </tbody>
                </table>
            </div>

            <div class="mt-4 text-right text-xl font-semibold">
                Total: <span id="totalVenta">$0</span>
            </div>

            <div class="mt-6 text-right">
                <button
                    onclick="confirmarVenta()"
                    class="bg-invehin-primary text-white font-semibold py-2 px-6 rounded shadow hover:bg-invehin-primaryLight transition"
                    >
                    <i class="fas fa-cart-plus mr-2"></i> Confirmar Venta
                </button>
            </div>
        </main>

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
                    logoImage.src = "${pageContext.request.contextPath}/images/favicon.ico";
                    logoImage.classList.add("w-10");
                    mainContent.classList.remove("ml-64");
                    mainContent.classList.add("ml-20");
                } else {
                    logoContainer.classList.remove("flex-col");
                    logoImage.src = "${pageContext.request.contextPath}/images/logo.webp";
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

        <script>
            let timeout = null;

            document.getElementById('searchInput').addEventListener('input', function () {
                clearTimeout(timeout);

                const searchTerm = this.value.trim();
                if (searchTerm.length < 2)
                    return;

                timeout = setTimeout(() => {
                    fetchPrendas(searchTerm);
                }, 300);
            });

            function fetchPrendas(searchTerm) {
                fetch('/INVEHIN/Prendas', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: new URLSearchParams({searchTerm})
                })
                        .then(response => response.json())
                        .then(data => {
                            console.log("📦 JSON completo:", data);
                            console.log("👀 Primer objeto:", data[0]);
                            console.log("🔍 sub:", data[0]?.subcategoriaPrenda);
                            console.log("🔍 cat:", data[0]?.subcategoriaPrenda?.categoriaSubcategoria);
                            console.log("🔍 precio:", data[0]?.subcategoriaPrenda?.precioSubcategoria);

                            renderSugerencias(data);
                        })
                        .catch(error => {
                            console.error('Error al buscar prendas:', error);
                        });
            }

            function renderSugerencias(data) {
                const max = 6;
                let seMostroAlMenosUno = false;

                for (let i = 1; i <= max; i++) {
                    const li = document.getElementById(`sug-${i}`);

                    if (i <= data.length) {
                        const prenda = data[i - 1];
                        const sub = prenda.subcategoriaPrenda || {};
                        const cat = sub.categoriaSubcategoria || {};
                        const talla = prenda.tallaPrenda || {};
                        const color = prenda.colorPrenda || {};

                        const nombreCategoria = cat.nombreCategoria ?? '--';
                        const nombreSubcategoria = sub.nombreSubcategoria ?? '--';
                        const nombreTalla = talla.nombreTalla ?? '--';
                        const nombreColor = color.nombreColor ?? '--';
                        const precio = sub.precioSubcategoria ?? 0;

                        li.innerHTML = `
                <div class="col-span-10 flex flex-col pl-4 border-l-2 border-gray-300">
                    <div class="text-md font-semibold text-gray-900">${nombreCategoria} - ${nombreSubcategoria}</div>
                    <div class="text-sm text-gray-600 mt-1">${nombreTalla} · ${nombreColor} · $${Intl.NumberFormat("es-CO").format(precio)}</div>
                </div>
            `;

                        li.classList.remove("hidden");

                        li.onclick = () => {
                            agregarPrendaATabla(prenda);
                            document.getElementById("searchInput").value = "";

                            for (let j = 1; j <= max; j++) {
                                document.getElementById(`sug-${j}`).classList.add("hidden");
                            }

                            document.getElementById("sugerencias").classList.add("hidden");
                        };

                        seMostroAlMenosUno = true;
                    } else {
                        li.textContent = "";
                        li.classList.add("hidden");
                    }
                }

                if (seMostroAlMenosUno) {
                    document.getElementById("sugerencias").classList.remove("hidden");
                } else {
                    document.getElementById("sugerencias").classList.add("hidden");
                }

            }


        </script>

    </body>
</html>
