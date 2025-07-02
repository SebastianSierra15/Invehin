package servlets;

import Interfaces.IPedido;
import Interfaces.IProveedor;
import Logica.PaginacionResultado;
import Logica.Pedido;
import Logica.Proveedor;
import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Pedidos extends HttpServlet
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

            // Obtener pedidos
            IPedido servicioPedido = new Pedido();
            PaginacionResultado<Pedido> pedidos = servicioPedido.obtenerPedidos(searchTerm, numPage, pageSize);

            // Solo en la carga inicial se obtienen los datos estáticos necesarios para la vista
            if (!esAjax)
            {
                IProveedor servicioProveedor = new Proveedor();
                List<Proveedor> proveedores = servicioProveedor.obtenerProveedores();
                request.setAttribute("proveedores", proveedores);
            }

            // Atributos compartidos
            request.setAttribute("pedidos", pedidos.getItems());
            request.setAttribute("totalPedidos", pedidos.getTotal());
            request.setAttribute("numPage", numPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchTerm", searchTerm);

            response.setContentType("text/html;charset=UTF-8");
            request.getRequestDispatcher("Views/pedidos/pedidos.jsp").forward(request, response);
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
            String fechaPedidoStr = request.getParameter("fechaPedido");
            Timestamp fechaPedido = Timestamp.valueOf(fechaPedidoStr + " 00:00:00");
            int idProveedor = Integer.parseInt(request.getParameter("idProveedor"));
            boolean estadoPedido = Boolean.parseBoolean(request.getParameter("estadoPedido"));
            String detallesPedidoJson = request.getParameter("detallesPedidoJson");

            IPedido servicioPedido = new Pedido();
            boolean exito = servicioPedido.crearPedido(fechaPedido, estadoPedido, idProveedor, detallesPedidoJson);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Pedido registrado correctamente." : "Error al registrar el pedido.");

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

            Object idPedidoRaw = body.get("idPedido");
            Object fechaPedidoRaw = body.get("fechaPedido");
            Object idProveedorRaw = body.get("idProveedor");
            Object estadoPedidoRaw = body.get("estadoPedido");
            Object detallesPedidoJsonRaw = body.get("detallesPedidoJson");

            if (idPedidoRaw == null || fechaPedidoRaw == null || estadoPedidoRaw == null || idProveedorRaw == null || detallesPedidoJsonRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idPedido = ((Double) idPedidoRaw).intValue();
            String fechaPedidoStr = ((String) fechaPedidoRaw);
            Timestamp fechaPedido = Timestamp.valueOf(fechaPedidoStr + " 00:00:00");
            int idProveedor = ((Double) idProveedorRaw).intValue();
            boolean estadoPedido = ((Boolean) estadoPedidoRaw);
            String detallesPedidoJson = (String) detallesPedidoJsonRaw;

            IPedido servicioPedido = new Pedido();
            boolean exito = servicioPedido.actualizarPedido(idPedido, fechaPedido, estadoPedido, idProveedor, detallesPedidoJson);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Pedido actualizado correctamente." : "Error al actualizar el pedido.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al actualizar el pedido.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
}
