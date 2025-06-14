package servlets;

import Interfaces.IMetodoPago;
import Interfaces.IVenta;
import Logica.MetodoPago;
import Logica.PaginacionResultado;
import Logica.Venta;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Ventas extends HttpServlet
{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        try
        {
            // Detectar si es una llamada AJAX
            String modo = request.getParameter("modo");
            boolean esAjax = "ajax".equalsIgnoreCase(modo);

            // Parámetros de búsqueda y paginación
            String paramSearchTerm = request.getParameter("searchTerm");
            String paramNumPage = request.getParameter("numPage");
            String paramPageSize = request.getParameter("pageSize");

            String searchTerm = (paramSearchTerm != null) ? paramSearchTerm : "";
            int numPage = (paramNumPage != null) ? Integer.parseInt(paramNumPage) : 1;
            int pageSize = (paramPageSize != null) ? Integer.parseInt(paramPageSize) : 10;

            // Obtener ventas
            IVenta servicioVenta = new Venta();
            PaginacionResultado<Venta> ventas = servicioVenta.buscarVentas(searchTerm, numPage, pageSize);

            // Solo en la carga inicial se obtienen los datos estáticos necesarios para la vista
            if (!esAjax)
            {
                IMetodoPago servicioMetodoPago = new MetodoPago();
                List<MetodoPago> metodos = servicioMetodoPago.obtenerMetodosPago();
                request.setAttribute("metodosPago", metodos);
            }

            // Atributos compartidos
            request.setAttribute("ventas", ventas.getItems());
            request.setAttribute("totalVentas", ventas.getTotal());
            request.setAttribute("numPage", numPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchTerm", searchTerm);

            response.setContentType("text/html;charset=UTF-8");
            request.getRequestDispatcher("Views/ventas/ventas.jsp").forward(request, response);
        } catch (Exception e)
        {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        try
        {
            int montoRecibido = Integer.parseInt(request.getParameter("montoRecibido"));
            int clienteId = Integer.parseInt(request.getParameter("clienteId"));
            int metodoPagoId = Integer.parseInt(request.getParameter("metodoPagoId"));
            int usuarioId = Integer.parseInt(request.getParameter("usuarioId"));
            String detallesVentaJson = request.getParameter("detallesVentaJson");

            IVenta servicioVenta = new Venta();
            boolean exito = servicioVenta.crearVenta(montoRecibido, clienteId, metodoPagoId, usuarioId, detallesVentaJson);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Venta registrada correctamente." : "Error al registrar la venta.");

            response.getWriter().write(new Gson().toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al procesar la venta.");

            response.getWriter().write(new Gson().toJson(error));
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        try
        {
            // Leer datos del cuerpo de la solicitud
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null)
            {
                sb.append(linea);
            }

            // Parsear JSON recibido
            Gson gson = new Gson();
            Map<String, Object> body = gson.fromJson(sb.toString(), Map.class);

            Object idVentaRaw = body.get("idVenta");
            Object clienteRaw = body.get("clienteId");
            Object metodoRaw = body.get("metodoPagoId");

            if (idVentaRaw == null || clienteRaw == null || metodoRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idVenta = ((Double) idVentaRaw).intValue();
            int idClienteVenta = ((Double) clienteRaw).intValue();
            int idMetodopagoVenta = ((Double) metodoRaw).intValue();
            boolean estadoVenta = Boolean.parseBoolean(body.get("estado").toString());

            IVenta servicioVenta = new Venta();
            boolean exito = servicioVenta.actualizarVenta(idVenta, idClienteVenta, idMetodopagoVenta, estadoVenta);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Venta actualizada correctamente." : "Error al actualizar la venta.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al actualizar la venta.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
}
