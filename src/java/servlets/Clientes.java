package servlets;

import Interfaces.ICliente;
import Logica.Cliente;
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
public class Clientes extends HttpServlet
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
                .anyMatch(p -> p.idPermiso == 4);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para ver clientes.");
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

            // Obtener clientes
            ICliente servicioCliente = new Cliente();
            PaginacionResultado<Cliente> clientes = servicioCliente.obtenerClientes(searchTerm, numPage, pageSize);

            // Atributos compartidos
            request.setAttribute("clientes", clientes.getItems());
            request.setAttribute("totalClientes", clientes.getTotal());
            request.setAttribute("numPage", numPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchTerm", searchTerm);

            response.setContentType("text/html;charset=UTF-8");
            request.getRequestDispatcher("Views/clientes/clientes.jsp").forward(request, response);
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
                .anyMatch(p -> p.idPermiso == 13);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para agregar clientes.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        int idUsuarioAuditor = sesion.idUsuario;

        try
        {
            String nombresPersona = request.getParameter("nombres");
            String apellidosPersona = request.getParameter("apellidos");
            String numeroidentificacionPersona = request.getParameter("identificacion");
            String telefonoPersona = request.getParameter("telefono");
            String generoStr = request.getParameter("genero");
            String direccionCliente = request.getParameter("direccion");

            if (nombresPersona == null || apellidosPersona == null || numeroidentificacionPersona == null
                    || telefonoPersona == null || generoStr == null || direccionCliente == null
                    || nombresPersona.isEmpty() || apellidosPersona.isEmpty() || numeroidentificacionPersona.isEmpty()
                    || telefonoPersona.isEmpty() || generoStr.isEmpty() || direccionCliente.isEmpty())
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            boolean generoPersona = Boolean.parseBoolean(generoStr);

            ICliente servicioCliente = new Cliente();
            boolean exito = servicioCliente.crearCliente(nombresPersona, apellidosPersona, numeroidentificacionPersona, telefonoPersona, generoPersona, direccionCliente, idUsuarioAuditor);

            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Cliente registrado correctamente." : "Error al registrar cliente.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al procesar el cliente.");

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
                .anyMatch(p -> p.idPermiso == 21);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para editar clientes.");
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

            Object idClienteRaw = body.get("idCliente");
            Object direccionClienteRaw = body.get("direccionCliente");
            Object idPersonaRaw = body.get("idPersona");
            Object nombresPersonaRaw = body.get("nombresPersona");
            Object apellidosPersonaRaw = body.get("apellidosPersona");
            Object identificacionPersonaRaw = body.get("identificacionPersona");
            Object telefonoPersonaRaw = body.get("telefonoPersona");
            Object generoPersonaRaw = body.get("generoPersona");

            if (idClienteRaw == null || direccionClienteRaw == null || idPersonaRaw == null || nombresPersonaRaw == null || apellidosPersonaRaw == null || identificacionPersonaRaw == null || telefonoPersonaRaw == null || generoPersonaRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idCliente = Integer.parseInt(idClienteRaw.toString());
            String direccionCliente = String.valueOf(direccionClienteRaw);
            int idPersona = Integer.parseInt(idPersonaRaw.toString());
            String nombresPersona = String.valueOf(nombresPersonaRaw);
            String apellidosPersona = String.valueOf(apellidosPersonaRaw);
            String identificacionPersona = String.valueOf(identificacionPersonaRaw);
            String telefonoPersona = String.valueOf(telefonoPersonaRaw);
            boolean generoPersona = "true".equals(String.valueOf(generoPersonaRaw));

            ICliente servicioCliente = new Cliente();
            boolean exito = servicioCliente.actualizarCliente(idCliente, direccionCliente, idPersona, nombresPersona, apellidosPersona, identificacionPersona, telefonoPersona, generoPersona, idUsuarioAuditor);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Cliente actualizado correctamente." : "Error al actualizar el cliente.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al actualizar el cliente.");
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
                .anyMatch(p -> p.idPermiso == 29);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para eliminar clientes.");
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

            Object idClienteRaw = body.get("idCliente");
            if (idClienteRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            int idCliente = Integer.parseInt(idClienteRaw.toString());

            ICliente servicioCliente = new Cliente();
            boolean exito = servicioCliente.eliminarCliente(idCliente, idUsuarioAuditor);

            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Cliente eliminado correctamente." : "Error al eliminar el cliente.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al eliminar el cliente.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
}
