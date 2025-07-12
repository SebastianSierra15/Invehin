package servlets;

import Interfaces.IVenta;
import Logica.Usuario;
import Logica.Venta;
import Utils.Ventas.GeneradorReportesVentasExcel;
import Utils.Ventas.GeneradorReportesVentasPDF;
import com.google.gson.Gson;
import com.itextpdf.text.DocumentException;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class ReporteVentas extends HttpServlet
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
                .anyMatch(p -> p.idPermiso == 33);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para generar reportes de ventas.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try
        {
            String formato = request.getParameter("formato");
            String fechaInicio = request.getParameter("fechaInicio");
            String fechaFin = request.getParameter("fechaFin");

            LocalDate inicioDate = LocalDate.parse(fechaInicio);
            LocalDate finDate = LocalDate.parse(fechaFin);

            Timestamp inicio = Timestamp.valueOf(inicioDate.atStartOfDay());
            Timestamp fin = Timestamp.valueOf(finDate.atTime(23, 59, 59));

            IVenta servicioVenta = new Venta();
            List<Venta> ventas = servicioVenta.obtenerReporteVentas(inicio, fin);

            if ("pdf".equals(formato))
            {
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "inline; filename=reporte_ventas.pdf");
                try
                {
                    GeneradorReportesVentasPDF.generarVentasPDF(ventas, response.getOutputStream());
                } catch (DocumentException ex)
                {
                    Logger.getLogger(ReporteVentas.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else
            {
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", "attachment; filename=reporte_ventas.xlsx");

                try
                {
                    GeneradorReportesVentasExcel.generarVentasExcel(ventas, response.getOutputStream());
                } catch (IOException ex)
                {
                    Logger.getLogger(ReporteVentas.class.getName()).log(Level.SEVERE, null, ex);
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
