package servlets;

import Interfaces.IInventario;
import Logica.Inventario;
import Utils.Inventarios.GeneradorReportesInventariosExcel;
import Utils.Inventarios.GeneradorReportesInventariosPDF;
import com.itextpdf.text.DocumentException;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class ReporteInventarios extends HttpServlet
{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException
    {
        String formato = request.getParameter("formato");
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFin = request.getParameter("fechaFin");
        String estadoInventarioStr = request.getParameter("estado");

        LocalDate inicioDate = LocalDate.parse(fechaInicio);
        LocalDate finDate = LocalDate.parse(fechaFin);

        Timestamp inicio = Timestamp.valueOf(inicioDate.atStartOfDay());
        Timestamp fin = Timestamp.valueOf(finDate.atTime(23, 59, 59));

        Boolean estadoInventario = (estadoInventarioStr != null && !estadoInventarioStr.isEmpty())
                ? Boolean.parseBoolean(estadoInventarioStr)
                : null;

        IInventario servicioInventario = new Inventario();
        List<Inventario> inventarios = servicioInventario.obtenerReporteInventarios(inicio, fin, estadoInventario);

        if ("pdf".equals(formato))
        {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=reporte_inventarios.pdf");
            try
            {
                GeneradorReportesInventariosPDF.generarInventariosPDF(inventarios, response.getOutputStream());
            } catch (DocumentException ex)
            {
                Logger.getLogger(ReporteInventarios.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else
        {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=reporte_inventarios.xlsx");

            try
            {
                GeneradorReportesInventariosExcel.generarInventariosExcel(inventarios, response.getOutputStream());
            } catch (IOException ex)
            {
                Logger.getLogger(ReporteInventarios.class.getName()).log(Level.SEVERE, null, ex);
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al generar Excel");
            }
        }
    }
}
