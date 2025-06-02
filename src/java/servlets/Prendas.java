package servlets;

import Interfaces.IPrenda;
import Logica.Prenda;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import com.google.gson.Gson;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Prendas extends HttpServlet
{

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        
        String searchTerm = request.getParameter("searchTerm");

        IPrenda servicioPrenda = new Prenda();
        List<Prenda> resultados = servicioPrenda.buscarPrendas(searchTerm);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Gson gson = new Gson();
        String json = gson.toJson(resultados);

        try (PrintWriter out = response.getWriter())
        {
            out.print(json);
        }
    }
}
