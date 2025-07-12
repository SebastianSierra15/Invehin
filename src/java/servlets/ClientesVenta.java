package servlets;

import Interfaces.ICliente;
import Logica.Cliente;
import Logica.Usuario;
import com.google.gson.Gson;
import jakarta.servlet.RequestDispatcher;
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
public class ClientesVenta extends HttpServlet
{

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
                .anyMatch(p -> p.idPermiso == 6 || p.idPermiso == 23);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para buscar clientes.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try
        {
            String searchTerm = request.getParameter("searchTerm");

            ICliente servicioCliente = new Cliente();
            List<Cliente> resultados = servicioCliente.buscarClientes(searchTerm);

            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith))
            {
                // Es una petición AJAX → retornar JSON
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(convertirClientesAJson(resultados));
            } else
            {
                // Petición normal → reenviar a la vista
                request.setAttribute("clientes", resultados);
                RequestDispatcher dispatcher = request.getRequestDispatcher("Views/clientes/clientes.jsp");
                dispatcher.forward(request, response);
            }

        } catch (Exception e)
        {
            e.printStackTrace();
            request.setAttribute("error", "Ocurrió un error al buscar los clientes.");
            request.getRequestDispatcher("Views/clientes/clientes.jsp").forward(request, response);
        }
    }

    private String convertirClientesAJson(List<Cliente> prendas)
    {
        com.google.gson.Gson gson = new com.google.gson.Gson();
        return gson.toJson(prendas);
    }
}
