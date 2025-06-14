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

    Usuario sesion = (Usuario) session.getAttribute("sesion");
%>

<%
    NumberFormat formato = NumberFormat.getInstance(new Locale("es", "CO"));
%>

<!DOCTYPE html>
<html  lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Dashboard - INVEHIN</title>

        <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/favicon.ico">
        
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
    </head>

    <body class="bg-invehin-background font-sans flex">
        <%@ include file="components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col w-full max-w-full overflow-x-hidden  px-4 py-6 md:p-8 ml-20 sm:ml-64 transition-all duration-300 gap-4 sm:gap-10">
            <div class="items-center justify-center text-center mx-auto">
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
    </body>
</html>
