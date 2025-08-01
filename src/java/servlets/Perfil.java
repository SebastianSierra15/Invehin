package servlets;

import Interfaces.IUsuario;
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
public class Perfil extends HttpServlet
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

        try
        {
            String idUsuarioTerm = request.getParameter("id");

            if (idUsuarioTerm == null || idUsuarioTerm.isEmpty())
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idUsuario = Integer.parseInt(idUsuarioTerm);

            // Validar que sea el mismo usuario de la sesión
            if (idUsuario != sesion.idUsuario)
            {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
                Map<String, Object> error = new HashMap<>();
                error.put("exito", false);
                error.put("mensaje", "No puedes acceder al perfil de otro usuario.");
                response.getWriter().write(gson.toJson(error));
                return;
            }

            // Obtener usuario
            IUsuario servicioUsuario = new Usuario();
            Usuario usuario = servicioUsuario.obtenerUsuario(idUsuario);

            request.setAttribute("usuario", usuario);

            response.setContentType("text/html;charset=UTF-8");
            request.getRequestDispatcher("Views/perfil/perfil.jsp").forward(request, response);
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
                .anyMatch(p -> p.idPermiso == 37);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para modificar el perfil.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        int idUsuarioAuditor = sesion.idUsuario;

        try
        {
            String idPersonaStr = request.getParameter("idPersona");
            String nombresPersona = request.getParameter("nombres");
            String apellidosPersona = request.getParameter("apellidos");
            String numeroidentificacionPersona = request.getParameter("identificacion");
            String telefonoPersona = request.getParameter("telefono");
            String generoStr = request.getParameter("genero");

            if (idPersonaStr == null || nombresPersona == null || apellidosPersona == null || numeroidentificacionPersona == null
                    || telefonoPersona == null || generoStr == null
                    || idPersonaStr.isEmpty() || nombresPersona.isEmpty() || apellidosPersona.isEmpty() || numeroidentificacionPersona.isEmpty()
                    || telefonoPersona.isEmpty() || generoStr.isEmpty())
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idPersona = Integer.parseInt(idPersonaStr);
            boolean generoPersona = Boolean.parseBoolean(generoStr);

            IUsuario servicioUsuario = new Usuario();
            boolean exito = servicioUsuario.actualizarPerfil(idPersona, nombresPersona, apellidosPersona, numeroidentificacionPersona, telefonoPersona, generoPersona, idUsuarioAuditor);

            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Datos actualizados correctamente, vuelve a iniciar sesión para ver los cambios." : "Error al actualizar datos.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al procesar los datos.");

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
                .anyMatch(p -> p.idPermiso == 37);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para cambiar la contraseña de este perfil.");
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

            Object idUsuarioRaw = body.get("idUsuario");
            Object contraseniaActualRaw = body.get("contraseniaActual");
            Object contraseniaNuevaRaw = body.get("contraseniaNueva");

            if (idUsuarioRaw == null || contraseniaActualRaw == null || contraseniaNuevaRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idUsuario = Integer.parseInt(idUsuarioRaw.toString());
            String contraseniaActual = String.valueOf(contraseniaActualRaw);
            String contraseniaNueva = String.valueOf(contraseniaNuevaRaw);

            IUsuario servicioUsuario = new Usuario();
            boolean exito = servicioUsuario.cambiarContrasenia(idUsuario, contraseniaActual, contraseniaNueva, idUsuarioAuditor);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Contraseña actualizada exitosamente." : "Error al cambiar la contraseña.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al cambiar la contraseña.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
}
