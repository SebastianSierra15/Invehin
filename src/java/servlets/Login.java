package servlets;

import Interfaces.IUsuario;
import Logica.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Login extends HttpServlet
{

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String correo = request.getParameter("correo");
        String contrasenia = request.getParameter("contrasenia");
        String message = null;

        if (correo == null || correo.trim().isEmpty() || contrasenia == null || contrasenia.trim().isEmpty())
        {
            response.sendRedirect(request.getContextPath() + "/Views/login/login.jsp");
            return;
        }

        try
        {
            IUsuario servicio = new Usuario();
            Usuario session = servicio.iniciarSesion(correo, contrasenia);

            if (session != null && session.estadoUsuario)
            {
                request.getSession().setAttribute("sesion", session);
                response.sendRedirect(request.getContextPath() + "/");
            } else
            {
                message = "Correo electrónico o contraseña no válidos.";
                request.setAttribute("message", message);
                request.getRequestDispatcher("/Views/login/login.jsp").forward(request, response);
            }

        } catch (IllegalArgumentException e)
        {
            message = "Usuario o contraseña incorrectos.";
            request.setAttribute("message", message);
            request.getRequestDispatcher("/Views/login/login.jsp").forward(request, response);
        }
    }
}
