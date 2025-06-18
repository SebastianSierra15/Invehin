package servlets;

import Interfaces.ICategoria;
import Interfaces.IColor;
import Interfaces.IEstadoPrenda;
import Interfaces.IPrenda;
import Interfaces.ITalla;
import Logica.Categoria;
import Logica.Color;
import Logica.EstadoPrenda;
import Logica.PaginacionResultado;
import Logica.Prenda;
import Logica.Talla;
import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Prendas extends HttpServlet
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

            // Obtener prendas
            IPrenda servicioPrenda = new Prenda();
            PaginacionResultado<Prenda> prendas = servicioPrenda.obtenerPrendas(searchTerm, numPage, pageSize);

            // Solo en la carga inicial se obtienen los datos estáticos necesarios para la vista
            if (!esAjax)
            {
                IColor servicioColor = new Color();
                List<Color> colores = servicioColor.obtenerColores();
                request.setAttribute("colores", colores);

                IEstadoPrenda servicioEstadoPrenda = new EstadoPrenda();
                List<EstadoPrenda> estados = servicioEstadoPrenda.obtenerEstadosPrenda();
                request.setAttribute("estados", estados);

                ITalla servicioTalla = new Talla();
                List<Talla> tallas = servicioTalla.obtenerTallas();
                request.setAttribute("tallas", tallas);

                ICategoria servicioCategoria = new Categoria();
                List<Categoria> categorias = servicioCategoria.obtenerCategorias();
                request.setAttribute("categorias", categorias);
            }

            // Atributos compartidos
            request.setAttribute("prendas", prendas.getItems());
            request.setAttribute("totalPrendas", prendas.getTotal());
            request.setAttribute("numPage", numPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchTerm", searchTerm);

            response.setContentType("text/html;charset=UTF-8");
            request.getRequestDispatcher("Views/prendas/prendas.jsp").forward(request, response);
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
        response.setContentType("application/json;charset=UTF-8");
        Gson gson = new Gson();

        try
        {
            String codigoPrenda = request.getParameter("codigo");
            String stockStr = request.getParameter("stock");
            String stockMinStr = request.getParameter("stockMinimo");
            String colorStr = request.getParameter("color");
            String subcategoriaStr = request.getParameter("subcategoria");
            String tallaStr = request.getParameter("talla");

            if (codigoPrenda == null || stockStr == null || stockMinStr == null
                    || colorStr == null || subcategoriaStr == null || tallaStr == null
                    || codigoPrenda.isEmpty() || stockStr.isEmpty() || stockMinStr.isEmpty()
                    || colorStr.isEmpty() || subcategoriaStr.isEmpty() || tallaStr.isEmpty())
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int stockPrenda = Integer.parseInt(stockStr);
            int stockminimoPrenda = Integer.parseInt(stockMinStr);
            int idColor = Integer.parseInt(colorStr);
            int idSubcategoria = Integer.parseInt(subcategoriaStr);
            int idTalla = Integer.parseInt(tallaStr);

            IPrenda servicioPrenda = new Prenda();
            boolean exito = servicioPrenda.crearPrenda(codigoPrenda, stockPrenda, stockminimoPrenda, idColor, idSubcategoria, idTalla);

            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Prenda agregada correctamente." : "Error al agregar la prenda.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al procesar la prenda.");

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

            Object codigoPrendaRaw = body.get("codigoPrenda");
            Object stockPrendaRaw = body.get("stockPrenda");
            Object stockminimoPrendaRaw = body.get("stockminimoPrenda");
            Object idColorRaw = body.get("idColor");
            Object idEstadoPrendaRaw = body.get("idEstadoPrenda");
            Object idSubcategoriaRaw = body.get("idSubcategoria");
            Object idTallaRaw = body.get("idTalla");

            if (codigoPrendaRaw == null || stockPrendaRaw == null || stockminimoPrendaRaw == null || idColorRaw == null || idEstadoPrendaRaw == null || idSubcategoriaRaw == null || idTallaRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            String codigoPrenda = String.valueOf(codigoPrendaRaw);
            int stockPrenda = ((Double) stockPrendaRaw).intValue();
            int stockminimoPrenda = ((Double) stockminimoPrendaRaw).intValue();
            int idColor = ((Double) idColorRaw).intValue();
            int idEstadoPrenda = ((Double) idEstadoPrendaRaw).intValue();
            int idSubcategoria = ((Double) idSubcategoriaRaw).intValue();
            int idTalla = ((Double) idTallaRaw).intValue();

            IPrenda servicioPrenda = new Prenda();
            boolean exito = servicioPrenda.actualizarPrenda(codigoPrenda, stockPrenda, stockminimoPrenda, idColor, idEstadoPrenda, idSubcategoria, idTalla);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Prenda actualizada correctamente." : "Error al actualizar la prenda.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al actualizar la prenda.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
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

            Object codigoPrendaRaw = body.get("codigoPrenda");
            if (codigoPrendaRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            String codigoPrenda = String.valueOf(codigoPrendaRaw);

            IPrenda servicioPrenda = new Prenda();
            boolean exito = servicioPrenda.eliminarPrenda(codigoPrenda);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Prenda eliminada correctamente." : "Error al eliminar la prenda.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al eliminar la prenda.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
}
