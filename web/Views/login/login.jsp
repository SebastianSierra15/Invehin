<%-- 
    Document   : login
    Created on : 18/05/2025, 10:18:03 p. m.
    Author     : Ing. Sebastián Sierra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8" />
        <title>Login | Invehin</title>

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
    </head>

    <body class="bg-invehin-background font-sans flex justify-center items-center min-h-screen p-4">
        <div class="bg-invehin-accent p-4 sm:p-8 rounded-xl border-2 border-black w-full sm:max-w-sm flex flex-col items-center shadow-md">
            <img src="${pageContext.request.contextPath}/images/logo.webp" alt="Invehin Logo" class="mb-4 w-24 sm:w-32" />

            <h2 class="text-invehin-primary font-semibold mb-8 text-center text-lg sm:text-xl md:text-2xl">Bienvenido a invehin</h2>

            <form action="${pageContext.request.contextPath}/Login" method="post" class="w-full">
                <label for="correo" class="text-invehin-primaryLight text-sm mb-1 block font-semibold">Correo electrónico</label>
                <input id="correo" name="correo" type="email" placeholder="ingresa tu correo electrónico"
                       class="w-full border border-invehin-primaryLight rounded px-2 py-1 mb-4
                       focus:outline-none focus:ring-2 focus:ring-invehin-primaryLight bg-invehin-accentLight" required />

                <label for="contrasenia" class="text-invehin-primaryLight text-sm mb-1 block font-semibold">Contraseña</label>
                <input id="contrasenia" name="contrasenia" type="password" placeholder="ingresa tu contraseña"
                       class="w-full border border-invehin-primaryLight rounded px-2 py-1 mb-2
                       focus:outline-none focus:ring-2 focus:ring-invehin-primaryLight bg-invehin-accentLight" required />
                
                <div class="mb-10 text-xs text-left">
                    <a href="#" class="text-blue-700 underline hover:text-blue-900">¿Olvidaste tu contraseña?</a>
                </div>

                <button type="submit"
                        class="w-full bg-invehin-primary text-white py-2 rounded font-semibold hover:bg-invehin-primaryLight
                        transition-colors duration-300">
                    Iniciar Sesión
                </button>
            </form>
        </div>
    </body>
</html>
