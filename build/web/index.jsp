<%-- 
    Document   : index
    Created on : 21/05/2025, 11:13:48 a. m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page import="java.util.Map"%>
<%@page import="Logica.Prenda"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
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

    <body class="bg-invehin-background font-sans flex flex-col overflow-x-hidden">
        <%@ include file="components/sidebar.jsp" %>

        <main id="main-content" class="flex min-h-screen flex-col flex-1 px-4 pt-6 md:p-8 md:pb-0 ml-20 sm:ml-64 transition-all duration-300 gap-4 sm:gap-6">
            <div class="flex flex-col md:flex-row justify-between items-center gap-2 md:gap-4">
                <div class="flex flex-col items-center gap-1 text-center md:text-left">
                    <h1 class="text-invehin-primary font-bold text-2xl md:text-3xl">Bienvenido, <%= sesion.nombresPersona%></h1>
                    <span id="fechaHoraActual" class="text-invehin-primaryLight text-sm font-semibold"></span>
                </div>

                <a href="${pageContext.request.contextPath}/Views/ventas/registrar-venta.jsp"
                   class="bg-invehin-primary text-white text-sm md:text-base font-semibold px-4 py-2 rounded shadow hover:bg-invehin-primaryLight flex items-center gap-2">
                    <i class="fas fa-shopping-cart"></i>
                    Nueva Venta
                </a>
            </div>

            <section class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4">
                <!-- Ventas del día -->
                <a href="/INVEHIN/Ventas" class="bg-white rounded-lg shadow-md px-2 py-3 border border-gray-300 flex flex-col items-center text-center hover:scale-105 transition-transform">
                    <i class="fas fa-sack-dollar text-invehin-primaryLight sm:text-lg mb-1"></i>
                    <h2 class="text-invehin-primaryLight text-xs sm:text-sm font-semibold">Ventas del día</h2>
                    <p class="text-black sm:text-lg font-bold">$<%= formato.format(request.getAttribute("ventasDia"))%></p>
                </a>

                <!-- Prendas vendidas hoy -->
                <a href="/INVEHIN/Ventas" class="bg-white rounded-lg shadow-md px-2 py-3 border border-gray-300 flex flex-col items-center text-center hover:scale-105 transition-transform">
                    <i class="fas fa-bag-shopping text-invehin-primaryLight sm:text-lg mb-1"></i>
                    <h2 class="text-invehin-primaryLight text-xs sm:text-sm font-semibold">Prendas vendidas</h2>
                    <p class="text-black sm:text-lg font-bold"><%= formato.format(request.getAttribute("prendasVendidasDia"))%></p>
                </a>

                <!-- Stock bajo -->
                <a href="/INVEHIN/Pedidos" class="bg-white rounded-lg shadow-md px-2 py-3 border border-gray-300 flex flex-col items-center text-center hover:scale-105 transition-transform">
                    <i class="fas fa-bell text-invehin-primaryLight sm:text-lg mb-1"></i>
                    <h2 class="text-invehin-primaryLight text-xs sm:text-sm font-semibold">Stock bajo</h2>
                    <p class="text-black sm:text-lg font-bold"><%= formato.format(request.getAttribute("prendasBajoStock"))%></p>
                </a>

                <!-- Ventas del mes -->
                <a href="/INVEHIN/Ventas" class="bg-white rounded-lg shadow-md px-2 py-3 border border-gray-300 flex flex-col items-center text-center hover:scale-105 transition-transform">
                    <i class="fas fa-chart-simple text-invehin-primaryLight sm:text-lg mb-1"></i>
                    <h2 class="text-invehin-primaryLight text-xs sm:text-sm font-semibold">Ventas del mes</h2>
                    <p class="text-black sm:text-lg font-bold">$<%= formato.format(request.getAttribute("ventasMes"))%></p>
                </a>

                <!-- Promedio ventas diarias -->
                <a href="/INVEHIN/Ventas" class="bg-white rounded-lg shadow-md px-2 py-3 border border-gray-300 flex flex-col items-center text-center hover:scale-105 transition-transform">
                    <i class="fas fa-chart-line text-invehin-primaryLight sm:text-lg mb-1"></i>
                    <h2 class="text-invehin-primaryLight text-xs sm:text-sm font-semibold">Prom. diario</h2>
                    <p class="text-black sm:text-lg font-bold">$<%= formato.format(request.getAttribute("promedioVentas"))%></p>
                </a>

                <!-- Clientes nuevos -->
                <a href="/INVEHIN/Clientes" class="bg-white rounded-lg shadow-md px-2 py-3 border border-gray-300 flex flex-col items-center text-center hover:scale-105 transition-transform">
                    <i class="fas fa-user-plus text-invehin-primaryLight sm:text-lg mb-1"></i>
                    <h2 class="text-invehin-primaryLight text-xs sm:text-sm font-semibold">Clientes nuevos</h2>
                    <p class="text-black sm:text-lg font-bold"><%= formato.format(request.getAttribute("clientesMes"))%></p>
                </a>
            </section>

            <section class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                <!-- Gráfico: Top 5 prendas más vendidas del mes -->
                <div class="order-none sm:order-1 lg:order-none bg-white rounded-lg shadow-md p-4 border border-gray-300 flex flex-col h-full">
                    <h3 id="tituloPrendas" class="text-invehin-primary font-semibold text-lg text-center mb-2">Prendas más vendidas del mes actual</h3>
                    <div class="relative h-[240px]">
                        <canvas id="chartTopPrendas" class="w-ful h-full"></canvas>
                    </div>
                </div>

                <!-- Gráfico: Ventas por día del mes -->
                <div class="order-none sm:order-3 lg:order-none sm:col-span-2 lg:col-span-1 bg-white rounded-lg shadow-md p-4 border border-gray-300 flex flex-col h-full">
                    <h3 id="tituloVentas" class="text-invehin-primary font-semibold text-lg text-center mb-2">Ventas por día del mes actual</h3>
                    <div class="relative h-[240px]">
                        <canvas id="chartVentasDia" class="w-full h-full"></canvas>
                    </div>
                </div>

                <!-- Gráfico: Valor total por categoría -->
                <div class="order-none sm:order-2 lg:order-none bg-white rounded-lg shadow-md p-4 border border-gray-300 flex flex-col h-full">
                    <h3 class="text-invehin-primary font-semibold text-lg text-center mb-2">Valor en inventario por categoría</h3>
                    <div class="relative h-[240px]">
                        <canvas id="chartValorCategorias" class="w-full h-full"></canvas>
                    </div>
                </div>
            </section>
        </main>

        <%@ include file="components/footer.jsp" %>
    </body>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
            setInterval(actualizarFechaHora, 1000);
            actualizarFechaHora(); // inicial

            function actualizarFechaHora() {
                const ahora = new Date();
                const opciones = {weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'};
                const fecha = ahora.toLocaleDateString('es-CO', opciones);
                const hora = ahora.toLocaleTimeString('es-CO');
                document.getElementById('fechaHoraActual').textContent = fecha + " - " + hora;
            }

            // Obtener el mes actual
            const meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
            const mesActual = meses[new Date().getMonth()];

            // Actualizar los títulos con el nombre del mes
            document.getElementById('tituloPrendas').textContent = "Prendas más vendidas " + mesActual;
            document.getElementById('tituloVentas').textContent = "Ventas por día del mes " + mesActual;

            const ctx = document.getElementById('chartTopPrendas').getContext('2d');
            const ctxVentasDia = document.getElementById('chartVentasDia').getContext('2d');
            const ctxValorCategorias = document.getElementById('chartValorCategorias').getContext('2d');

            const labels = [
        <%
            List<Prenda> prendas = (List<Prenda>) request.getAttribute("prendasMasVendidasMes");
            for (int i = 0; i < prendas.size(); i++)
            {
                Prenda p = prendas.get(i);
                out.print("\"" + p.codigoPrenda + "\"");

                if (i < prendas.size() - 1)
                {
                    out.print(", ");
                }
            }
        %>
            ];

            const nombresCompletos = [
        <%
            for (int i = 0; i < prendas.size(); i++)
            {
                Prenda p = prendas.get(i);
                String nombre = p.subcategoriaPrenda.categoriaSubcategoria.nombreCategoria + " "
                        + p.subcategoriaPrenda.nombreSubcategoria + " - Talla "
                        + p.tallaPrenda.nombreTalla + " ∙ " + p.colorPrenda.nombreColor;
                out.print("\"" + nombre + "\"");
                if (i < prendas.size() - 1)
                {
                    out.print(", ");
                }
            }
        %>
            ];

            const data = [
        <%
            for (int i = 0; i < prendas.size(); i++)
            {
                out.print(prendas.get(i).stockPrenda);

                if (i < prendas.size() - 1)
                {
                    out.print(", ");
                }
            }
        %>
            ];

            const labelsVentasDia = [
        <%
            int diasMes = java.time.LocalDate.now().lengthOfMonth();
            for (int i = 1; i <= diasMes; i++)
            {
                out.print("\"" + i + "\"");
                if (i < diasMes)
                {
                    out.print(", ");
                }
            }
        %>
            ];

            const dataVentasDia = [
        <%
            java.util.Map<java.sql.Timestamp, Integer> ventasPorDia
                    = (java.util.Map<java.sql.Timestamp, Integer>) request.getAttribute("totalVentasPorDia");
            java.time.LocalDate inicio = java.time.LocalDate.now().withDayOfMonth(1);
            for (int i = 1; i <= diasMes; i++)
            {
                java.time.LocalDate dia = inicio.withDayOfMonth(i);
                java.sql.Timestamp ts = java.sql.Timestamp.valueOf(dia.atStartOfDay());
                int valor = ventasPorDia.getOrDefault(ts, 0);
                out.print(valor);
                if (i < diasMes)
                {
                    out.print(", ");
                }
            }
        %>
            ];

            const labelsCategorias = [
        <%
            Map<String, Integer> valorCategorias = (Map<String, Integer>) request.getAttribute("valorCategorias");
            int i = 0;
            for (String nombre : valorCategorias.keySet())
            {
                out.print("\"" + nombre + "\"");
                if (i < valorCategorias.size() - 1)
                {
                    out.print(", ");
                }
                i++;
            }
        %>
            ];

            const dataCategorias = [
        <%
            i = 0;
            for (Integer valor : valorCategorias.values())
            {
                out.print(valor);
                if (i < valorCategorias.size() - 1)
                {
                    out.print(", ");
                }
                i++;
            }
        %>
            ];

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Prendas vendidas',
                            data: data,
                            backgroundColor: 'rgba(149, 21, 86, 0.6)',
                            borderColor: '#951556',
                            borderWidth: 1
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    devicePixelRatio: 2,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1,
                                callback: function (value) {
                                    return Number.isInteger(value) ? value : '';
                                }
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: true,
                            position: 'bottom',
                            labels: {
                                boxWidth: 12,
                                boxHeight: 12,
                                color: '#951556',
                                font: {
                                    size: 12
                                }
                            }
                        },
                        tooltip: {
                            callbacks: {
                                title: function (tooltipItems) {
                                    const index = tooltipItems[0].dataIndex;
                                    return nombresCompletos[index];
                                },
                                label: function (tooltipItem) {
                                    return 'Cantidad: ' + tooltipItem.raw;
                                }
                            }
                        }
                    }
                }
            });

            new Chart(ctxVentasDia, {
                type: 'line',
                data: {
                    labels: labelsVentasDia,
                    datasets: [{
                            label: 'Ventas ($)',
                            data: dataVentasDia,
                            fill: false,
                            borderColor: '#951556',
                            tension: 0.2,
                            pointBackgroundColor: '#c21b70'
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    devicePixelRatio: 2,
                    scales: {
                        y: {beginAtZero: true}
                    },
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                color: '#951556'
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function (tooltipItem) {
                                    // Formatear el valor con puntos de mil
                                    const valor = tooltipItem.raw;
                                    const valorFormateado = valor.toLocaleString('es-CO');
                                    return (tooltipItem.label + ": $" + valorFormateado);
                                }
                            }
                        }
                    }
                }
            });

            new Chart(ctxValorCategorias, {
                type: 'doughnut',
                data: {
                    labels: labelsCategorias,
                    datasets: [{
                            label: 'Valor ($)',
                            data: dataCategorias,
                            backgroundColor: [
                                '#951556', '#c21b70', '#e387a3', '#f5dcea', '#dd8eba', '#b26891'
                            ],
                            borderColor: '#fff',
                            borderWidth: 1
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                color: '#951556',
                                boxWidth: 12
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function (tooltipItem) {
                                    // Formatear el valor con puntos de mil
                                    const valor = tooltipItem.raw;
                                    const valorFormateado = valor.toLocaleString('es-CO');
                                    return (tooltipItem.label + ": $" + valorFormateado);
                                }
                            }
                        }
                    }
                }
            });
    </script>
</html>
