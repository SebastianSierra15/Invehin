package servlets;

import Interfaces.IPermiso;
import Interfaces.IRol;
import Logica.PaginacionResultado;
import Logica.Permiso;
import Logica.Rol;
import Logica.Usuario;
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
public class Roles extends HttpServlet
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
                .anyMatch(p -> p.idPermiso == 5);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para visualizar roles.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

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

            // Obtener roles
            IRol servicioRol = new Rol();
            PaginacionResultado<Rol> roles = servicioRol.obtenerRoles(searchTerm, numPage, pageSize);

            // Solo en la carga inicial se obtienen los datos estáticos necesarios para la vista
            if (!esAjax)
            {
                IPermiso servicioPermiso = new Permiso();
                List<Permiso> permisos = servicioPermiso.obtenerPermisos();
                request.setAttribute("permisos", permisos);
            }

            // Atributos compartidos
            request.setAttribute("roles", roles.getItems());
            request.setAttribute("totalRoles", roles.getTotal());
            request.setAttribute("numPage", numPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchTerm", searchTerm);

            response.setContentType("text/html;charset=UTF-8");
            request.getRequestDispatcher("Views/roles/roles.jsp").forward(request, response);
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
                .anyMatch(p -> p.idPermiso == 14);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para agregar roles.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        int idUsuarioAuditor = sesion.idUsuario;

        try
        {
            String nombreRol = request.getParameter("nombreRol");
            String permisosRolJson = request.getParameter("permisosRolJson");

            if (nombreRol == null || permisosRolJson == null || nombreRol.isEmpty() || permisosRolJson.isEmpty())
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            IRol servicioRol = new Rol();
            boolean exito = servicioRol.crearRol(nombreRol, permisosRolJson, idUsuarioAuditor);

            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Rol registrado correctamente." : "Error al registrar rol.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al procesar el rol.");

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
                .anyMatch(p -> p.idPermiso == 22);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para editar roles.");
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

            Object idRolRaw = body.get("idRol");
            Object nombreRolRaw = body.get("nombreRol");
            Object permisosRolJsonRaw = body.get("permisosRolJson");

            if (idRolRaw == null || nombreRolRaw == null || permisosRolJsonRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idRol = Integer.parseInt(idRolRaw.toString());
            String nombreRol = String.valueOf(nombreRolRaw);
            String permisosRolJson = (String) body.get("permisosRolJson");

            IRol servicioRol = new Rol();
            boolean exito = servicioRol.actualizarRol(idRol, nombreRol, permisosRolJson, idUsuarioAuditor);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Rol actualizado correctamente." : "Error al actualizar el rol.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al actualizar el rol.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
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
                .anyMatch(p -> p.idPermiso == 30);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para eliminar roles.");
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
            
            Object idRolRaw = body.get("idRol");
            if (idRolRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }
            
            int idRol = Integer.parseInt(idRolRaw.toString());
            
            IRol servicioRol = new Rol();
            boolean exito = servicioRol.eliminarRol(idRol, idUsuarioAuditor);
            
            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Rol eliminado correctamente." : "Error al eliminar el rol.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");
            
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al eliminar el rol.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
}
