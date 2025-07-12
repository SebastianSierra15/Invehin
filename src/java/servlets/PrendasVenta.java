package servlets;

import Interfaces.IPrenda;
import Logica.Prenda;
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
public class PrendasVenta extends HttpServlet
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
                .anyMatch(p ->  p.idPermiso == 8 ||p.idPermiso == 6 || p.idPermiso == 23 || p.idPermiso == 16 || p.idPermiso == 25 || p.idPermiso == 18 || p.idPermiso == 27);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para ver prendas.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try
        {
            String searchTerm = request.getParameter("searchTerm");

            IPrenda servicioPrenda = new Prenda();
            List<Prenda> resultados = servicioPrenda.buscarPrendasParaVenta(searchTerm);

            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith))
            {
                // Es una petición AJAX → retornar JSON
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(convertirPrendasAJson(resultados));
            } else
            {
                // Petición normal → reenviar a la vista
                request.setAttribute("prendas", resultados);
                RequestDispatcher dispatcher = request.getRequestDispatcher("Views/ventas/registrar-venta.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
            request.setAttribute("error", "Ocurrió un error al buscar las prendas.");
            request.getRequestDispatcher("Views/ventas/registrar-venta.jsp").forward(request, response);
        }
    }

    private String convertirPrendasAJson(List<Prenda> prendas)
    {
        com.google.gson.Gson gson = new com.google.gson.Gson();
        return gson.toJson(prendas);
    }
}
