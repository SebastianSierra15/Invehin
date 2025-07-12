package servlets;

import Interfaces.IInventario;
import Logica.Inventario;
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
public class Inventarios extends HttpServlet
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
                .anyMatch(p -> p.idPermiso == 11);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para ver inventarios.");
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

            // Obtener inventarios
            IInventario servicioInventario = new Inventario();
            PaginacionResultado<Inventario> inventarios = servicioInventario.obtenerInventarios(searchTerm, numPage, pageSize);

            // Atributos compartidos
            request.setAttribute("inventarios", inventarios.getItems());
            request.setAttribute("totalInventarios", inventarios.getTotal());
            request.setAttribute("numPage", numPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchTerm", searchTerm);

            response.setContentType("text/html;charset=UTF-8");
            request.getRequestDispatcher("Views/inventario/inventario.jsp").forward(request, response);
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
                .anyMatch(p -> p.idPermiso == 18);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para realizar inventario.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        int idUsuarioAuditor = sesion.idUsuario;
        
        try
        {
            String observacionInventario = request.getParameter("observacionInventario");
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String detallesInventarioJson = request.getParameter("detallesInventarioJson");

            IInventario servicioInventario = new Inventario();
            boolean exito = servicioInventario.crearInventario(observacionInventario, idUsuario, detallesInventarioJson, idUsuarioAuditor);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Inventario registrado correctamente." : "Error al registrar el inventario.");

            response.getWriter().write(new Gson().toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al procesar el inventario.");

            response.getWriter().write(new Gson().toJson(error));
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
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
                .anyMatch(p -> p.idPermiso == 27);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para editar inventarios.");
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

            Object idInventarioRaw = body.get("idInventario");
            Object observacionInventarioRaw = body.get("observacionInventario");
            Object estadoInventarioRaw = body.get("estadoInventario");
            Object detallesInventarioJsonRaw = body.get("detallesInventarioJson");

            if (idInventarioRaw == null || observacionInventarioRaw == null || estadoInventarioRaw == null || detallesInventarioJsonRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idInventario = Integer.parseInt(idInventarioRaw.toString());
            String observacionInventario = observacionInventarioRaw.toString();
            boolean estadoInventario = Boolean.parseBoolean(estadoInventarioRaw.toString());
            String detallesInventarioJson = detallesInventarioJsonRaw.toString();

            IInventario servicioInventario = new Inventario();
            boolean exito = servicioInventario.actualizarInventario(idInventario, observacionInventario, estadoInventario, detallesInventarioJson, idUsuarioAuditor);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Inventario actualizado correctamente." : "Error al actualizar el inventario.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al actualizar el inventario.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
}
