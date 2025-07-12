package servlets;

import Interfaces.ICategoria;
import Logica.Categoria;
import Logica.PaginacionResultado;
import Logica.Usuario;
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
public class Categorias extends HttpServlet
{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        Gson gson = new Gson();

        Usuario sesion = (Usuario) request.getSession().getAttribute("sesion");

        // Validar sesión nula por seguridad
        if (sesion == null)
        {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Sesión no válida.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        boolean tienePermiso = sesion.rolUsuario.permisosRol.stream()
                .anyMatch(p -> p.idPermiso == 1);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para visualizar las categorías.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try
        {
            // Parámetros de búsqueda y paginación
            String paramSearchTerm = request.getParameter("searchTerm");
            String paramNumPage = request.getParameter("numPage");
            String paramPageSize = request.getParameter("pageSize");

            String searchTerm = (paramSearchTerm != null) ? paramSearchTerm : "";
            int numPage = (paramNumPage != null) ? Integer.parseInt(paramNumPage) : 1;
            int pageSize = (paramPageSize != null) ? Integer.parseInt(paramPageSize) : 10;

            // Obtener categorias
            ICategoria servicioCategoria = new Categoria();
            PaginacionResultado<Categoria> categorias = servicioCategoria.obtenerCategorias(searchTerm, numPage, pageSize);

            // Atributos compartidos
            request.setAttribute("categorias", categorias.getItems());
            request.setAttribute("totalCategorias", categorias.getTotal());
            request.setAttribute("numPage", numPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchTerm", searchTerm);

            response.setContentType("text/html;charset=UTF-8");
            request.getRequestDispatcher("Views/categorias/categorias.jsp").forward(request, response);
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

        Usuario sesion = (Usuario) request.getSession().getAttribute("sesion");

        // Validar sesión nula por seguridad
        if (sesion == null)
        {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Sesión no válida.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        boolean tienePermiso = sesion.rolUsuario.permisosRol.stream()
                .anyMatch(p -> p.idPermiso == 2);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para agregar categorías.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        int idUsuarioAuditor = sesion.idUsuario;

        try
        {
            String nombreCategoria = request.getParameter("nombre");

            if (nombreCategoria == null || nombreCategoria.isEmpty())
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            ICategoria servicioCategoria = new Categoria();
            boolean exito = servicioCategoria.crearCategoria(nombreCategoria, idUsuarioAuditor);

            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Categoría registrada correctamente." : "Error al registrar categoría.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al procesar la categoría.");

            response.getWriter().write(new Gson().toJson(error));
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        // Parsear JSON recibido
        Gson gson = new Gson();

        Usuario sesion = (Usuario) request.getSession().getAttribute("sesion");

        // Validar sesión nula por seguridad
        if (sesion == null)
        {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Sesión no válida.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        boolean tienePermiso = sesion.rolUsuario.permisosRol.stream()
                .anyMatch(p -> p.idPermiso == 19);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para editar categorías.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        int idUsuarioAuditor = sesion.idUsuario;

        try
        {
            // Leer datos del cuerpo de la solicitud
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null)
            {
                sb.append(linea);
            }

            Map<String, Object> body = gson.fromJson(sb.toString(), Map.class);

            Object idCategoriaRaw = body.get("idCategoria");
            Object nombreCategoriaRaw = body.get("nombreCategoria");

            if (idCategoriaRaw == null || nombreCategoriaRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idCategoria = Integer.parseInt(idCategoriaRaw.toString());
            String nombreCategoria = String.valueOf(nombreCategoriaRaw);

            ICategoria servicioCategoria = new Categoria();
            boolean exito = servicioCategoria.actualizarCategoria(idCategoria, nombreCategoria, idUsuarioAuditor);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Categoría actualizada correctamente." : "Error al actualizar la categoría.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al actualizar la categoría.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        // Parsear JSON recibido
        Gson gson = new Gson();

        Usuario sesion = (Usuario) request.getSession().getAttribute("sesion");

        // Validar sesión nula por seguridad
        if (sesion == null)
        {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Sesión no válida.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        boolean tienePermiso = sesion.rolUsuario.permisosRol.stream()
                .anyMatch(p -> p.idPermiso == 28);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para cambiar el estado de las categorías.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        int idUsuarioAuditor = sesion.idUsuario;

        try
        {
            // Leer datos del cuerpo de la solicitud
            StringBuilder sb = new StringBuilder();
            String linea;
            while ((linea = request.getReader().readLine()) != null)
            {
                sb.append(linea);
            }

            Map<String, Object> body = gson.fromJson(sb.toString(), Map.class);

            Object idCategoriaRaw = body.get("idCategoria");
            Object estadoCategoriaRaw = body.get("estadoCategoria");
            if (idCategoriaRaw == null || estadoCategoriaRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idCategoria = Integer.parseInt(idCategoriaRaw.toString());
            boolean estadoCategoria = Boolean.parseBoolean(estadoCategoriaRaw.toString());

            ICategoria servicioCategoria = new Categoria();
            boolean exito = servicioCategoria.cambiarEstadoCategoria(idCategoria, !estadoCategoria, idUsuarioAuditor);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Estado de categoría modificado correctamente." : "Error al cambiar estado de la categoría.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al cambiar el estado de la categoría.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
}
