<%-- 
    Document   : sin-permiso
    Created on : 12/06/2025, 1:50:48 p. m.
    Author     : jhoan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>No autorizado - INVEHIN</title>

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
        <%@ include file="/components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col min-h-screen w-full max-w-full items-center justify-center overflow-x-hidden px-4 py-6 md:p-8 ml-20 sm:ml-64 transition-all duration-300 gap-2">
            <div class="bg-invehin-backgroundAltLight p-8 rounded-2xl shadow-lg max-w-md w-full text-center">
                <div class="text-6xl text-invehin-primary mb-4">
                    <i class="fas fa-ban"></i>
                </div>
                
                <h1 class="text-2xl font-bold mb-2">Acceso Denegado</h1>
                
                <p class="text-invehin-primaryDark mb-6">No estás autorizado para acceder a esta página.</p>
                
                <a href="<%= request.getContextPath()%>/" 
                   class="inline-block bg-invehin-primary text-white px-6 py-2 rounded-lg hover:bg-invehin-primaryLight transition">
                    Volver al inicio
                </a>
            </div>
        </main>
    </body>
</html>
