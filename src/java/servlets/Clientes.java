package servlets;

import Interfaces.ICliente;
import Logica.Cliente;
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
public class Clientes extends HttpServlet
{

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
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
