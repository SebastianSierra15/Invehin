package servlets;

import Interfaces.IPrenda;
import Logica.Prenda;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

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
