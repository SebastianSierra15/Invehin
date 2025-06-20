package servlets;

import Interfaces.ISubcategoria;
import Logica.Subcategoria;
import com.google.gson.Gson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Subcategorias extends HttpServlet
{

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        response.setContentType("application/json;charset=UTF-8");
        Gson gson = new Gson();

        try
        {
            String nombreSubcategoria = request.getParameter("nombre");
            String precioSubcategoriaStr = request.getParameter("precio");
            String idCategoriaStr = request.getParameter("categoria");

            if (nombreSubcategoria == null || precioSubcategoriaStr == null || idCategoriaStr == null
                    || nombreSubcategoria.isEmpty() || precioSubcategoriaStr.isEmpty() || idCategoriaStr.isEmpty())
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int precioSubcategoria = Integer.parseInt(precioSubcategoriaStr);
            int idCategoria = Integer.parseInt(idCategoriaStr);

            ISubcategoria servicioSubcategoria = new Subcategoria();
            boolean exito = servicioSubcategoria.crearSubcategoria(nombreSubcategoria, precioSubcategoria, idCategoria);

            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Subcategoría registrada correctamente." : "Error al registrar subcategoría.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al procesar la subcategoría.");

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

            Object idSubcategoriaRaw = body.get("idSubcategoria");
            Object nombreSubcategoriaRaw = body.get("nombreSubcategoria");
            Object precioSubcategoriaRaw = body.get("precioSubcategoria");
            Object idCategoriaRaw = body.get("idCategoria");

            if (idSubcategoriaRaw == null || nombreSubcategoriaRaw == null || precioSubcategoriaRaw == null || idCategoriaRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idSubcategoria = Integer.parseInt(idSubcategoriaRaw.toString());
            String nombreSubcategoria = String.valueOf(nombreSubcategoriaRaw);
            int precioSubcategoria = Integer.parseInt(precioSubcategoriaRaw.toString());
            int idCategoria = Integer.parseInt(idCategoriaRaw.toString());

            ISubcategoria servicioSubcategoria = new Subcategoria();
            boolean exito = servicioSubcategoria.actualizarSubcategoria(idSubcategoria, nombreSubcategoria, precioSubcategoria, idCategoria);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Subcategoría actualizada correctamente." : "Error al actualizar la subcategoría.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al actualizar la subcategoría.");
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

            Object idSubcategoriaRaw = body.get("idSubcategoria");
            Object estadoSubcategoriaRaw = body.get("estadoSubcategoria");
            if (idSubcategoriaRaw == null || estadoSubcategoriaRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idSubcategoria = Integer.parseInt(idSubcategoriaRaw.toString());
            boolean estadoSubcategoria = Boolean.parseBoolean(estadoSubcategoriaRaw.toString());

            ISubcategoria servicioSubcategoria = new Subcategoria();
            boolean exito = servicioSubcategoria.cambiarEstadoSubcategoria(idSubcategoria, !estadoSubcategoria);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Subcategoría eliminada correctamente." : "Error al eliminar la subcategoría.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al eliminar la subcategoría.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
}
