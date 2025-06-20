package servlets;

import Interfaces.IRol;
import Interfaces.IUsuario;
import Logica.PaginacionResultado;
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
public class Usuarios extends HttpServlet
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

            // Obtener usuarios
            IUsuario servicioUsuario = new Usuario();
            PaginacionResultado<Usuario> usuarios = servicioUsuario.obtenerUsuarios(searchTerm, numPage, pageSize);

            if (!esAjax)
            {
                IRol servicioRol = new Rol();
                List<Rol> roles = servicioRol.obtenerRoles();
                request.setAttribute("roles", roles);
            }

            // Atributos compartidos
            request.setAttribute("usuarios", usuarios.getItems());
            request.setAttribute("totalUsuarios", usuarios.getTotal());
            request.setAttribute("numPage", numPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchTerm", searchTerm);

            response.setContentType("text/html;charset=UTF-8");
            request.getRequestDispatcher("Views/usuarios/usuarios.jsp").forward(request, response);
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
            String correoUsuario = request.getParameter("correo");
            String rolStr = request.getParameter("rol");
            String nombresPersona = request.getParameter("nombres");
            String apellidosPersona = request.getParameter("apellidos");
            String numeroidentificacionPersona = request.getParameter("identificacion");
            String telefonoPersona = request.getParameter("telefono");
            String generoStr = request.getParameter("genero");

            if (correoUsuario == null || rolStr == null || nombresPersona == null || apellidosPersona == null || numeroidentificacionPersona == null
                    || telefonoPersona == null || generoStr == null
                    || correoUsuario.isEmpty() || rolStr.isEmpty() || nombresPersona.isEmpty() || apellidosPersona.isEmpty() || numeroidentificacionPersona.isEmpty()
                    || telefonoPersona.isEmpty() || generoStr.isEmpty())
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int rolUsuario = Integer.parseInt(rolStr);
            boolean generoPersona = Boolean.parseBoolean(generoStr);

            IUsuario servicioUsuario = new Usuario();
            boolean exito = servicioUsuario.crearUsuario(correoUsuario, rolUsuario, nombresPersona, apellidosPersona, numeroidentificacionPersona, telefonoPersona, generoPersona);

            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Usuario registrado correctamente." : "Error al registrar usuario.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al procesar el usuario.");

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

            Object idUsuarioRaw = body.get("idUsuario");
            Object idRolRaw = body.get("idRol");
            Object estadoUsuarioRaw = body.get("estadoUsuario");
            Object idPerseonaRaw = body.get("idPersona");
            Object nombresPersonaRaw = body.get("nombresPersona");
            Object apellidosPersonaRaw = body.get("apellidosPersona");
            Object identificacionPersonaRaw = body.get("identificacionPersona");
            Object telefonoPersonaRaw = body.get("telefonoPersona");
            Object generoPersonaRaw = body.get("generoPersona");

            if (idUsuarioRaw == null || idRolRaw == null || estadoUsuarioRaw == null || idPerseonaRaw == null || nombresPersonaRaw == null || apellidosPersonaRaw == null || identificacionPersonaRaw == null || telefonoPersonaRaw == null || generoPersonaRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idUsuario = Integer.parseInt(idUsuarioRaw.toString());
            int idRol = Integer.parseInt(idRolRaw.toString());
            boolean estadoUsuario = "true".equals(String.valueOf(estadoUsuarioRaw));
            int idPerseona = Integer.parseInt(idPerseonaRaw.toString());
            String nombresPersona = String.valueOf(nombresPersonaRaw);
            String apellidosPersona = String.valueOf(apellidosPersonaRaw);
            String identificacionPersona = String.valueOf(identificacionPersonaRaw);
            String telefonoPersona = String.valueOf(telefonoPersonaRaw);
            boolean generoPersona = "true".equals(String.valueOf(generoPersonaRaw));

            IUsuario servicioUsuario = new Usuario();
            boolean exito = servicioUsuario.actualizarUsuario(idUsuario, idRol, estadoUsuario, idPerseona, nombresPersona, apellidosPersona, identificacionPersona, telefonoPersona, generoPersona);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Usuario actualizado correctamente." : "Error al actualizar el usuario.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al actualizar el usuario.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
}
