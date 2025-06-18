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
        response.sendRedirect(request.getContextPath() + "/Views/login/login.jsp");
        return;
    }

    Usuario sesion = (Usuario) session.getAttribute("sesion");

    boolean tienePermiso = false;
    for (var permiso : sesion.rolUsuario.permisosRol)
    {
        if (permiso.idPermiso == 6)
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

<!DOCTYPE html>
<html  lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Registrar Venta - INVEHIN</title>

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

        <style>
            #sugerencias li {
                list-style: none;
            }
        </style>
    </head>

    <body class="bg-invehin-background font-sans flex flex-col overflow-x-hidden">
        <%@ include file="/components/sidebar.jsp" %>

        <main id="main-content" class="flex flex-col min-h-screen flex-1 px-4 pt-6 pb-0 md:p-8 md:pb-0 ml-20 sm:ml-64 transition-all duration-300 gap-4 sm:gap-10">
            <h1 class="text-invehin-primary font-bold text-3xl text-center">Registrar Venta</h1>

            <section aria-label="Buscador de prendas"   >
                <div class="max-w-1/2 relative">
                    <label for="searchInput" class="sr-only">Buscar prenda</label>

                    <div class="relative">
                        <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"></i>

                        <input id="searchInput"
                               type="search"
                               placeholder="Buscar prenda por código, categoría, subcategoría, color, talla..."
                               class="pl-10 pr-4 py-2 rounded-md shadow-md bg-white border border-gray-300 w-full outline-none"
                               />
                    </div>

                    <ul id="sugerencias"
                        class="rounded-md shadow-md bg-white absolute left-0 right-0 top-full mt-2 p-3 hidden max-h-60 overflow-y-auto border border-gray-300">
                        <!-- Los <li> se generan dinámicamente -->
                    </ul>
                </div>
            </section>

            <section aria-label="Lista de prendas seleccionadas" class="flex flex-col gap-2">
                <div class="flex justify-between items-center">
                    <button
                        onclick="limpiarTabla()"
                        class="flex items-center gap-2 bg-red-600 text-white text-sm px-4 py-2 rounded shadow hover:bg-red-500 transition"
                        >
                        <i class="fas fa-trash-alt"></i>
                        Limpiar tabla
                    </button>
                </div>

                <div class="overflow-x-auto w-full">
                    <table class="w-full text-sm text-left bg-invehin-accentLight rounded-lg border-separate border-spacing-0 overflow-hidden">
                        <caption class="sr-only">Tabla de prendas seleccionadas para venta</caption>
                        <thead class="bg-invehin-primary text-white">
                            <tr>
                                <th class="px-3 py-2 border border-white">Código</th>
                                <th class="px-3 py-2 border border-white">Prenda</th>
                                <th class="px-3 py-2 border border-white">Talla</th>
                                <th class="px-3 py-2 border border-white">Color</th>
                                <th class="px-3 py-2 border border-white">Precio</th>
                                <th class="px-3 py-2 border border-white">Cantidad</th>
                                <th class="px-3 py-2 border border-white">Sub total</th>
                                <th class="px-3 py-2 border border-white">Acción</th>
                            </tr>
                        </thead>
                        <tbody id="prendasSeleccionadas" class="bg-pink-100">
                            <!-- filas JS aquí con td.border.border-white -->
                        </tbody>
                    </table>
                </div>
            </section>

            <section id="panelCliente" class="flex flex-col gap-6 hidden">
                <div class="flex flex-col sm:flex-row items-center gap-2 sm:gap-4">
                    <div class="relative w-full">
                        <label for="clienteInput" class="sr-only">Buscar cliente</label>
                        <input id="clienteInput" type="search"
                               placeholder="Buscar cliente por nombre, apellido, documento..."
                               class="pl-10 pr-4 py-2 rounded-md shadow-md bg-white border border-gray-300 w-full outline-none"/>
                        <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"></i>

                        <ul id="sugerenciasCliente"
                            class="rounded-md shadow-md bg-white absolute left-0 right-0 top-full mt-2 p-3 hidden max-h-60 overflow-y-auto border border-gray-300 z-50">
                        </ul>
                    </div>

                    <button onclick="abrirModalCliente()" 
                            class="bg-invehin-primaryLight text-white font-medium px-4 py-2 rounded shadow hover:bg-invehin-primary transition whitespace-nowrap">
                        <i class="fas fa-user-plus mr-2"></i>Agregar Cliente
                    </button>
                </div>

                <div class="flex flex-col sm:flex-row gap-2 sm:gap-6 text-left">
                    <div>
                        <label for="montoPago" class="block mb-1 text-lg font-medium text-gray-700">Monto recibido</label>
                        <input id="montoPago" type="text" min="0"
                               class="min-w-56 px-2 py-1 border border-gray-300 rounded shadow text-xl"
                               oninput="formatearMontoYCalcularCambio(this)" />
                    </div>

                    <div>
                        <label class="block mb-1 text-lg font-medium text-gray-700">Cambio</label>
                        <div id="cambioCalculado" class="font-semibold text-3xl md:text-4xl text-gray-800">$0</div>
                    </div>
                </div>

                <div id="datosCliente" class="grid grid-cols-2 gap-4 text-base text-gray-800 hidden border p-4 rounded shadow">
                    <span id="cliId" class="hidden absolute"></span>
                    <p><strong>Nombres:</strong> <span id="cliNombres"></span></p>
                    <p><strong>Apellidos:</strong> <span id="cliApellidos"></span></p>
                    <p><strong>Documento:</strong> <span id="cliDocumento"></span></p>
                    <p><strong>Teléfono:</strong> <span id="cliTelefono"></span></p>
                    <p><strong>Género:</strong> <span id="cliGenero"></span></p>
                    <p><strong>Dirección:</strong> <span id="cliDireccion"></span></p>
                </div>
            </section>

            <section class="mt-auto flex flex-col sm:flex-row justify-between items-end gap-2 sm:gap-4 pt-4 px-6 border-t z-10 pt-2">
                <button id="btnVolver"
                        onclick="volverAlPanelPrendas()"
                        class="hidden order-2 sm:order-none text-invehin-primary border border-invehin-primary px-4 py-2 rounded shadow hover:bg-invehin-accentLight transition">
                    <i class="fas fa-arrow-left mr-2"></i> Volver
                </button>

                <div class="flex flex-col items-end ml-auto order-1 sm:order-none">
                    <div class="text-lg text-gray-700">Total a pagar:</div>
                    <div id="totalAPagarFooter" class="text-4xl font-bold text-invehin-primary">$0</div>

                    <button id="btnConfirmar"
                            disabled
                            onclick="mostrarPanelCliente()"
                            class="mt-2 bg-invehin-primary text-white font-semibold py-2 px-6 rounded shadow hover:bg-invehin-primaryLight transition disabled:opacity-50 disabled:cursor-not-allowed">
                        <i class="fas fa-cart-plus mr-2"></i> Confirmar Prendas
                    </button>
                </div>
            </section>
        </main>

        <%@ include file="/components/footer.jsp" %>
    </body>

    <script>
        let timeout = null;
        let timeoutCliente = null;
        const input = document.getElementById('searchInput');
        const lista = document.getElementById('sugerencias');
        const tablaBody = document.getElementById("prendasSeleccionadas");

        document.addEventListener("click", function (event) {
            const input = document.getElementById("searchInput");
            const lista = document.getElementById("sugerencias");

            if (!input.contains(event.target) && !lista.contains(event.target)) {
                lista.classList.add("hidden");
            }
        });

        document.addEventListener("click", function (event) {
            const input = document.getElementById("clienteInput");
            const lista = document.getElementById("sugerenciasCliente");
            if (!input.contains(event.target) && !lista.contains(event.target)) {
                lista.classList.add("hidden");
            }
        });

        input.addEventListener('input', function () {
            clearTimeout(timeout);

            const searchTerm = this.value.trim();
            if (searchTerm.length < 2) {
                lista.classList.add("hidden");
                return;
            }

            timeout = setTimeout(() => {
                fetchPrendas(searchTerm);
            }, 300);
        });

        // Se activa cuando se borra usando la X del input de tipo "search" 
        input.addEventListener('search', () => {
            lista.classList.add("hidden");
        });

        document.getElementById("clienteInput").addEventListener("input", function () {
            clearTimeout(timeoutCliente);

            const valor = this.value.trim();
            if (valor.length < 2) {
                document.getElementById("sugerenciasCliente").classList.add("hidden");
                return;
            }

            timeoutCliente = setTimeout(() => {
                fetch('${pageContext.request.contextPath}/ClientesVenta', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: new URLSearchParams({searchTerm: valor})
                })
                        .then(res => res.json())
                        .then(data => renderSugerenciasCliente(data))
                        .catch(err => console.error("Error al buscar cliente:", err));
            }, 300);
        });

        function actualizarTotal() {
            const subtotales = document.querySelectorAll(".subtotal");
            let total = 0;

            subtotales.forEach(sub => {
                const valor = sub.textContent.replace(/[^\d]/g, "");
                total += parseInt(valor, 10);
            });

            document.getElementById("totalAPagarFooter").textContent = ("$" + Intl.NumberFormat("es-CO").format(total));
        }

        function limpiarTabla() {
            tablaBody.innerHTML = "";
            actualizarTotal();
            actualizarBotonConfirmar();
        }

        function mostrarPanelCliente() {
            document.getElementById("panelCliente").classList.remove("hidden");
            document.querySelector('[aria-label="Buscador de prendas"]').classList.add("hidden");
            document.querySelector('[aria-label="Lista de prendas seleccionadas"]').classList.add("hidden");

            document.getElementById("cambioCalculado").textContent = "$0";
            document.getElementById("montoPago").value = "0";

            document.getElementById("btnVolver").classList.remove("hidden");

            const btn = document.getElementById("btnConfirmar");
            btn.innerHTML = '<i class="fas fa-check-circle mr-2"></i> Confirmar Venta';
            btn.onclick = finalizarVenta;
            btn.disabled = true;
            actualizarBotonConfirmar();
        }

        function volverAlPanelPrendas() {
            document.getElementById("panelCliente").classList.add("hidden");
            document.querySelector('[aria-label="Buscador de prendas"]').classList.remove("hidden");
            document.querySelector('[aria-label="Lista de prendas seleccionadas"]').classList.remove("hidden");

            document.getElementById("btnVolver").classList.add("hidden");

            const btn = document.getElementById("btnConfirmar");
            btn.innerHTML = '<i class="fas fa-cart-plus mr-2"></i> Confirmar Venta';
            btn.onclick = mostrarPanelCliente;

            actualizarBotonConfirmar();
        }

        function abrirModalCliente() {
            alert("Aquí debe abrir un modal para registrar cliente. (Implementación pendiente)");
        }

        function finalizarVenta() {
            const total = parseInt(document.getElementById("totalAPagarFooter").textContent.replace(/[^\d]/g, ""));
            const montoInput = document.getElementById("montoPago").value;
            const montoRecibido = parseInt(montoInput.replace(/[^\d]/g, "") || "0");

            if (montoRecibido < total) {
                alert("El monto recibido no puede ser menor al total a pagar.");
                return;
            }

            const clienteId = document.getElementById("cliId").textContent.trim();
            const metodoPagoId = 1;
            const usuarioId = <%= sesion.idUsuario%>;

            const filas = document.querySelectorAll("#prendasSeleccionadas tr");
            const detalles = [];

            filas.forEach(fila => {
                const codigo = fila.children[0].textContent.trim();
                const cantidad = parseInt(fila.querySelector("input[type='number']").value);
                detalles.push({
                    codigo_prenda: codigo,
                    cantidad: cantidad
                });
            });

            const datos = new URLSearchParams();
            datos.append("montoRecibido", montoRecibido);
            datos.append("clienteId", clienteId);
            datos.append("metodoPagoId", metodoPagoId);
            datos.append("usuarioId", usuarioId);
            datos.append("detallesVentaJson", JSON.stringify(detalles));

            fetch("${pageContext.request.contextPath}/Ventas", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: datos
            })
                    .then(res => res.json())
                    .then(data => {
                        if (data.exito) {
                            alert("Venta registrada exitosamente.");
                            window.location.href = "${pageContext.request.contextPath}/Views/ventas/registrar-venta.jsp";
                        } else {
                            alert("Error al registrar la venta: " + data.mensaje);
                        }
                    })
                    .catch(error => {
                        console.error("Error en la venta:", error);
                        alert("Ocurrió un error al procesar la venta.");
                    });
        }

        function actualizarBotonConfirmar() {
            const btn = document.getElementById("btnConfirmar");
            const enPanelCliente = !document.getElementById("panelCliente").classList.contains("hidden");

            if (enPanelCliente) {
                btn.innerHTML = '<i class="fas fa-check-circle mr-2"></i> Confirmar Venta';

                const clienteVisible = !document.getElementById("datosCliente").classList.contains("hidden");
                const montoInput = document.getElementById("montoPago").value;
                const monto = parseInt(montoInput.replace(/[^\d]/g, "") || "0");

                const total = parseInt(document.getElementById("totalAPagarFooter").textContent.replace(/[^\d]/g, ""));

                if (monto < total) {
                    btn.disabled = true;
                } else {
                    btn.disabled = !(clienteVisible && monto >= total);
                }
            } else {
                btn.innerHTML = '<i class="fas fa-cart-plus mr-2"></i> Confirmar Prendas';
                btn.disabled = tablaBody.children.length === 0;
            }
        }

        function fetchPrendas(searchTerm) {
            fetch('${pageContext.request.contextPath}/PrendasVenta', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: new URLSearchParams({searchTerm})
            })
                    .then(response => response.json())
                    .then(data => {
                        renderSugerencias(data);
                    })
                    .catch(error => {
                        console.error('Error al buscar prendas:', error);
                    });
        }

        function renderSugerencias(data) {
            lista.innerHTML = "";

            if (!data || data.length === 0) {
                lista.classList.add("hidden");
                return;
            }

            data.forEach((prenda, i) => {
                const sub = prenda.subcategoriaPrenda;
                const cat = sub?.categoriaSubcategoria;
                const talla = prenda.tallaPrenda;
                const color = prenda.colorPrenda;

                const codigo = prenda.codigoPrenda ?? '--';
                const nombreCategoria = cat?.nombreCategoria ?? '--';
                const nombreSubcategoria = sub?.nombreSubcategoria ?? '--';
                const nombreTalla = talla?.nombreTalla ?? '--';
                const nombreColor = color?.nombreColor ?? '--';
                const precio = sub?.precioSubcategoria ?? 0;
                const stock = prenda.stockPrenda ?? 0;
                const stockMinimo = prenda.stockminimoPrenda ?? 0;

                const texto = document.createTextNode(codigo + " - " +
                        nombreCategoria + " - " + nombreSubcategoria + " · Talla " +
                        nombreTalla + " · " + nombreColor + " · $" +
                        Intl.NumberFormat("es-CO").format(precio)
                        );

                const li = document.createElement("li");
                li.className = "cursor-pointer px-4 py-2 rounded-lg hover:bg-gray-50 text-sm font-medium text-gray-800";
                li.appendChild(texto);

                li.onclick = () => {
                    // Calcular cuántas unidades ya están en la tabla
                    const filas = tablaBody.querySelectorAll("tr");
                    let cantidadActual = 0;
                    for (let fila of filas) {
                        const codigoCelda = fila.children[0].textContent.trim();
                        if (codigoCelda === codigo) {
                            const inputCantidad = fila.querySelector("input[type='number']");
                            cantidadActual = parseInt(inputCantidad.value);
                            break;
                        }
                    }

                    // Validar contra stock
                    const disponibles = prenda.stockPrenda - cantidadActual;
                    if (disponibles <= prenda.stockminimoPrenda) {
                        alert("No hay suficiente stock disponible para agregar más unidades.");
                        return;
                    }

                    input.value = "";
                    lista.classList.add("hidden");

                    agregarPrendaTabla({
                        codigo,
                        nombreCategoria,
                        nombreSubcategoria,
                        nombreTalla,
                        nombreColor,
                        precio,
                        stock,
                        stockMinimo
                    });
                };

                lista.appendChild(li);
            });

            lista.classList.remove("hidden");
        }

        function actualizarSubtotal(input) {
            const fila = input.closest("tr");
            const precioTexto = fila.children[4].textContent.replace(/[^\d]/g, "");
            const precio = parseInt(precioTexto, 10);
            const cantidad = parseInt(input.value, 10) || 1;

            const stockPrenda = parseInt(input.getAttribute("data-stock"));
            const stockMinimo = parseInt(input.getAttribute("data-minimo"));

            const totalDisponible = stockPrenda - stockMinimo;

            if (cantidad > totalDisponible) {
                alert("Cantidad excede el stock disponible.");
                input.value = totalDisponible;
                return actualizarSubtotal(input);
            }

            const subtotal = precio * cantidad;
            fila.querySelector(".subtotal").textContent = ("$" + Intl.NumberFormat("es-CO").format(subtotal));

            actualizarTotal();
        }

        function formatearMontoYCalcularCambio(input) {
            let valor = input.value.replace(/[^\d]/g, "");

            if (!valor) {
                input.value = "";
                calcularCambio(0);
                return;
            }

            const numero = parseInt(valor, 10);
            input.value = "$" + Intl.NumberFormat("es-CO").format(numero);
            calcularCambio(numero);
        }

        function calcularCambio(montoRecibido = null) {
            const total = parseInt(document.getElementById("totalAPagarFooter").textContent.replace(/[^\d]/g, ""));
            let recibido = montoRecibido;

            if (recibido === null) {
                recibido = parseInt(document.getElementById("montoPago").value.replace(/[^\d]/g, "") || "0");
            }

            const cambio = Math.max(recibido - total, 0);
            document.getElementById("cambioCalculado").textContent = "$" + Intl.NumberFormat("es-CO").format(cambio);

            actualizarBotonConfirmar();
        }

        function renderSugerenciasCliente(clientes) {
            const lista = document.getElementById("sugerenciasCliente");
            lista.innerHTML = "";

            if (!clientes || clientes.length === 0) {
                lista.classList.add("hidden");
                return;
            }

            clientes.forEach(cliente => {
                const li = document.createElement("li");
                li.className = "cursor-pointer px-4 py-2 rounded-lg hover:bg-gray-50 text-sm font-medium text-gray-800";
                li.textContent = cliente.numeroidentificacionPersona + " - " + cliente.nombresPersona + " " + cliente.apellidosPersona;
                li.onclick = () => seleccionarCliente(cliente);
                lista.appendChild(li);
            });

            lista.classList.remove("hidden");
        }

        function seleccionarCliente(cliente) {
            document.getElementById("cliId").textContent = cliente.idCliente;
            document.getElementById("cliDocumento").textContent = cliente.numeroidentificacionPersona;
            document.getElementById("cliNombres").textContent = cliente.nombresPersona;
            document.getElementById("cliApellidos").textContent = cliente.apellidosPersona;
            document.getElementById("cliTelefono").textContent = cliente.telefonoPersona;
            document.getElementById("cliGenero").textContent = cliente.generoPersona === 1 ? "Masculino" : cliente.generoPersona === 0 ? "Femenino" : "Otro";
            document.getElementById("cliDireccion").textContent = cliente.direccionCliente;
            document.getElementById("datosCliente").classList.remove("hidden");

            document.getElementById("clienteInput").value = "";
            document.getElementById("sugerenciasCliente").classList.add("hidden");

            actualizarBotonConfirmar();
        }

        function agregarPrendaTabla( { codigo, nombreCategoria, nombreSubcategoria, nombreTalla, nombreColor, precio, stock, stockMinimo }) {
            // Buscar si ya existe un <tr> con ese código
            const filas = tablaBody.querySelectorAll("tr");
            for (let fila of filas) {
                const codigoCelda = fila.children[0].textContent.trim();
                if (codigoCelda === codigo) {
                    const inputCantidad = fila.querySelector("input[type='number']");
                    inputCantidad.value = parseInt(inputCantidad.value) + 1;
                    actualizarSubtotal(inputCantidad);
                    return;
                }
            }

            const tr = document.createElement("tr");

            // Celda 1: Codigo
            const td1 = document.createElement("td");
            td1.className = "px-3 py-2 border border-white";
            td1.appendChild(document.createTextNode(codigo));
            tr.appendChild(td1);

            // Celda 2: Categoría y Subcategoría
            const td2 = document.createElement("td");
            td2.className = "px-3 py-2 border border-white";
            td2.appendChild(document.createTextNode(nombreCategoria + " - " + nombreSubcategoria));
            tr.appendChild(td2);

            // Celda 3: Talla
            const td3 = document.createElement("td");
            td3.className = "px-3 py-2 border border-white";
            td3.appendChild(document.createTextNode(nombreTalla));
            tr.appendChild(td3);

            // Celda 4: Color
            const td4 = document.createElement("td");
            td4.className = "px-3 py-2 border border-white";
            td4.appendChild(document.createTextNode(nombreColor));
            tr.appendChild(td4);

            // Celda 5: Precio
            const td5 = document.createElement("td");
            td5.className = "px-3 py-2 border border-white";
            td5.appendChild(document.createTextNode("$" + Intl.NumberFormat("es-CO").format(precio)));
            tr.appendChild(td5);

            // Celda 6: Input cantidad
            const td6 = document.createElement("td");
            td6.className = "px-3 py-2 border border-white items-center text-center";
            const input = document.createElement("input");
            input.type = "number";
            input.value = "1";
            input.min = "1";
            input.className = "w-16 px-1 py-0.5 border rounded w-full";
            input.setAttribute("onchange", "actualizarSubtotal(this)");
            input.setAttribute("data-stock", stock);
            input.setAttribute("data-minimo", stockMinimo);
            td6.appendChild(input);
            tr.appendChild(td6);

            // Celda 7: Subtotal
            const td7 = document.createElement("td");
            td7.className = "px-3 py-2 border border-white subtotal";
            td7.appendChild(document.createTextNode("$" + Intl.NumberFormat("es-CO").format(precio)));
            tr.appendChild(td7);

            // Celda 8: Botón eliminar con ícono
            const td8 = document.createElement("td");
            td8.className = "px-3 py-2 border border-white text-center";
            const btn = document.createElement("button");
            btn.className = "text-red-600 hover:text-red-500";
            btn.setAttribute("aria-label", "Eliminar");
            btn.title = "Eliminar prenda";
            const icon = document.createElement("i");
            icon.className = "fas fa-trash";
            icon.setAttribute("aria-hidden", "true");
            btn.appendChild(icon);
            btn.onclick = function () {
                this.closest('tr').remove();
                actualizarTotal();
                actualizarBotonConfirmar();
            };

            td8.appendChild(btn);
            tr.appendChild(td8);

            tablaBody.appendChild(tr);

            actualizarTotal();
            actualizarBotonConfirmar();
        }
    </script>
</html>
