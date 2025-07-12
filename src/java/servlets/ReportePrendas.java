package servlets;

import Interfaces.IPrenda;
import Logica.Prenda;
import Logica.Usuario;
import Utils.Prendas.GeneradorReportesPrendasExcel;
import Utils.Prendas.GeneradorReportesPrendasPDF;
import com.google.gson.Gson;
import com.itextpdf.text.DocumentException;
import java.io.IOException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class ReportePrendas extends HttpServlet
{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException
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
                .anyMatch(p -> p.idPermiso == 35);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para generar reportes de prendas.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try
        {
            String formato = request.getParameter("formato");
            String paramIdCategoria = request.getParameter("idCategoria");
            String paramIdTalla = request.getParameter("idTalla");
            String paramStockBajo = request.getParameter("stockBajo");

            Integer idCategoria = (paramIdCategoria != null && !paramIdCategoria.isEmpty()) ? Integer.valueOf(paramIdCategoria) : null;
            Integer idTalla = (paramIdTalla != null && !paramIdTalla.isEmpty()) ? Integer.valueOf(paramIdTalla) : null;
            boolean stockBajo = (paramStockBajo != null) ? Boolean.parseBoolean(paramStockBajo) : false;

            IPrenda servicioPrenda = new Prenda();
            List<Prenda> prendas = servicioPrenda.obtenerReportePrendas(idCategoria, idTalla, stockBajo);

            if ("pdf".equals(formato))
            {
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "inline; filename=reporte_prendas.pdf");
                try
                {
                    GeneradorReportesPrendasPDF.generarPrendasPDF(prendas, response.getOutputStream());
                } catch (DocumentException ex)
                {
                    Logger.getLogger(ReportePrendas.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else
            {
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", "attachment; filename=reporte_prendas.xlsx");

                try
                {
                    GeneradorReportesPrendasExcel.generarPrendasExcel(prendas, response.getOutputStream());
                } catch (IOException ex)
                {
                    Logger.getLogger(ReportePrendas.class.getName()).log(Level.SEVERE, null, ex);
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al generar Excel");
                }
            }
        } catch (Exception e)
        {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al generar el reporte.");
        }
    }
}
