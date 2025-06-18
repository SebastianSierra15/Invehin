package servlets;

import Interfaces.IProveedor;
import Logica.PaginacionResultado;
import Logica.Proveedor;
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
public class Proveedores extends HttpServlet
{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        try
        {
            // Parámetros de búsqueda y paginación
            String paramSearchTerm = request.getParameter("searchTerm");
            String paramNumPage = request.getParameter("numPage");
            String paramPageSize = request.getParameter("pageSize");

            String searchTerm = (paramSearchTerm != null) ? paramSearchTerm : "";
            int numPage = (paramNumPage != null) ? Integer.parseInt(paramNumPage) : 1;
            int pageSize = (paramPageSize != null) ? Integer.parseInt(paramPageSize) : 10;

            // Obtener proveedores
            IProveedor servicioProveedor = new Proveedor();
            PaginacionResultado<Proveedor> proveedores = servicioProveedor.obtenerProveedores(searchTerm, numPage, pageSize);

            // Atributos compartidos
            request.setAttribute("proveedores", proveedores.getItems());
            request.setAttribute("totalProveedores", proveedores.getTotal());
            request.setAttribute("numPage", numPage);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("searchTerm", searchTerm);

            response.setContentType("text/html;charset=UTF-8");
            request.getRequestDispatcher("Views/proveedores/proveedores.jsp").forward(request, response);
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
            String nombreProveedor = request.getParameter("nombre");
            String correoProveedor = request.getParameter("correo");
            String direccionProveedor = request.getParameter("direccion");
            String nombresPersona = request.getParameter("nombres");
            String apellidosPersona = request.getParameter("apellidos");
            String telefonoPersona = request.getParameter("telefono");

            if (nombreProveedor == null || correoProveedor == null || direccionProveedor == null || nombresPersona == null || apellidosPersona == null
                    || telefonoPersona == null
                    || nombreProveedor.isEmpty() || correoProveedor.isEmpty() || direccionProveedor.isEmpty() || nombresPersona.isEmpty() || apellidosPersona.isEmpty()
                    || telefonoPersona.isEmpty())
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }

            IProveedor servicioProveedor = new Proveedor();
            boolean exito = servicioProveedor.crearProveedor(nombreProveedor, correoProveedor, direccionProveedor, nombresPersona, apellidosPersona, telefonoPersona);

            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Proveedor registrado correctamente." : "Error al registrar proveedor.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");

            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al procesar el proveedor.");

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
            
            Object idProveedorRaw = body.get("idProveedor");
            Object nombreProveedorRaw = body.get("nombreProveedor");
            Object correoProveedorRaw = body.get("correoProveedor");
            Object direccionProveedorRaw = body.get("direccionProveedor");
            Object idPersonaRaw = body.get("idPersona");
            Object nombresPersonaRaw = body.get("nombresPersona");
            Object apellidosPersonaRaw = body.get("apellidosPersona");
            Object telefonoPersonaRaw = body.get("telefonoPersona");
            
            if (idProveedorRaw == null || nombreProveedorRaw == null || correoProveedorRaw == null || direccionProveedorRaw == null || idPersonaRaw == null || nombresPersonaRaw == null || apellidosPersonaRaw == null || telefonoPersonaRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }
            
            int idProveedor = Integer.parseInt(idProveedorRaw.toString());
            String nombreProveedor = String.valueOf(nombreProveedorRaw);
            String correoProveedor = String.valueOf(correoProveedorRaw);
            String direccionProveedor = String.valueOf(direccionProveedorRaw);
            int idPersona = Integer.parseInt(idPersonaRaw.toString());
            String nombresPersona = String.valueOf(nombresPersonaRaw);
            String apellidosPersona = String.valueOf(apellidosPersonaRaw);
            String telefonoPersona = String.valueOf(telefonoPersonaRaw);
            
            IProveedor servicioProveedor = new Proveedor();
            boolean exito = servicioProveedor.actualizarProveedor(idProveedor, nombreProveedor, correoProveedor, direccionProveedor, idPersona, nombresPersona, apellidosPersona, telefonoPersona);
            
            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Proveedor actualizado correctamente." : "Error al actualizar el proveedor.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");
            
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al actualizar el proveedor.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
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
            
            Object idProveedorRaw = body.get("idProveedor");
            if (idProveedorRaw == null)
            {
                throw new IllegalArgumentException("Datos incompletos.");
            }
            
            int idProveedor = Integer.parseInt(idProveedorRaw.toString());
            
            IProveedor servicioProveedor = new Proveedor();
            boolean exito = servicioProveedor.eliminarProveedor(idProveedor);
            
            response.setContentType("application/json;charset=UTF-8");
            Map<String, Object> resultado = new HashMap<>();
            resultado.put("exito", exito);
            resultado.put("mensaje", exito ? "Proveedor eliminado correctamente." : "Error al eliminar el proveedor.");
            response.getWriter().write(gson.toJson(resultado));
        } catch (Exception e)
        {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");
            
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "Ocurrió un error al eliminar el proveedor.");
            response.getWriter().write(new Gson().toJson(error));
        }
    }
}
