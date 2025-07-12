package servlets;

import Interfaces.IPedido;
import Logica.Pedido;
import Logica.Usuario;
import Utils.Pedidos.GeneradorReportesPedidosExcel;
import Utils.Pedidos.GeneradorReportesPedidosPDF;
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
public class ReportePedidos extends HttpServlet
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
                .anyMatch(p -> p.idPermiso == 34);

        if (!tienePermiso)
        {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403
            Map<String, Object> error = new HashMap<>();
            error.put("exito", false);
            error.put("mensaje", "No tienes permiso para generar reportes de pedidos.");
            response.getWriter().write(gson.toJson(error));
            return;
        }

        try
        {
            String formato = request.getParameter("formato");
            String fechaInicio = request.getParameter("fechaInicio");
            String fechaFin = request.getParameter("fechaFin");
            String idProveedorStr = request.getParameter("proveedor");
            String estadoPedidoStr = request.getParameter("estado");

            LocalDate inicioDate = LocalDate.parse(fechaInicio);
            LocalDate finDate = LocalDate.parse(fechaFin);

            Timestamp inicio = Timestamp.valueOf(inicioDate.atStartOfDay());
            Timestamp fin = Timestamp.valueOf(finDate.atTime(23, 59, 59));

            // Solo convertir si no es nulo ni vacío
            Integer idProveedor = (idProveedorStr != null && !idProveedorStr.isEmpty())
                    ? Integer.parseInt(idProveedorStr)
                    : null;

            Boolean estadoPedido = (estadoPedidoStr != null && !estadoPedidoStr.isEmpty())
                    ? Boolean.parseBoolean(estadoPedidoStr)
                    : null;

            IPedido servicioPedido = new Pedido();
            List<Pedido> pedidos = servicioPedido.obtenerReportePedidos(inicio, fin, idProveedor, estadoPedido);

            if ("pdf".equals(formato))
            {
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "inline; filename=reporte_pedidos.pdf");
                try
                {
                    GeneradorReportesPedidosPDF.generarPedidosPDF(pedidos, response.getOutputStream());
                } catch (DocumentException ex)
                {
                    Logger.getLogger(ReportePedidos.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else
            {
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", "attachment; filename=reporte_pedidos.xlsx");

                try
                {
                    GeneradorReportesPedidosExcel.generarPedidosExcel(pedidos, response.getOutputStream());
                } catch (IOException ex)
                {
                    Logger.getLogger(ReportePedidos.class.getName()).log(Level.SEVERE, null, ex);
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
