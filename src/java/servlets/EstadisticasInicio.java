package servlets;

import Interfaces.IPrenda;
import Interfaces.IVenta;
import Logica.Prenda;
import Logica.Venta;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class EstadisticasInicio extends HttpServlet
{

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String message = null;

        try
        {
            LocalDate hoy = LocalDate.now();
            LocalDate primerDiaMes = hoy.withDayOfMonth(1);
            LocalDate ultimoDiaMes = hoy.withDayOfMonth(hoy.lengthOfMonth());

            // Para hoy (inicio y fin del día)
            LocalDateTime inicioHoy = hoy.atStartOfDay(); // 00:00:00
            LocalDateTime finHoy = hoy.atTime(23, 59, 59); // 23:59:59

            // Para mes
            LocalDateTime inicioMes = primerDiaMes.atStartOfDay();
            LocalDateTime finMes = ultimoDiaMes.atTime(23, 59, 59);

            // Convertir a Timestamp
            Timestamp tsInicioHoy = Timestamp.valueOf(inicioHoy);
            Timestamp tsFinHoy = Timestamp.valueOf(finHoy);
            Timestamp tsInicioMes = Timestamp.valueOf(inicioMes);
            Timestamp tsFinMes = Timestamp.valueOf(finMes);

            IPrenda servicioPrenda = new Prenda();
            IVenta servicioVenta = new Venta();

            int cantidadPrendasVendidas = servicioPrenda.cantidadPrendasVendidas(tsInicioHoy, tsFinHoy);
            int cantidadPrendasBajoStock = servicioPrenda.cantidadPrendasBajoStock();
            int totalVentasDia = servicioVenta.totalVentas(tsInicioHoy, tsFinHoy);
            int totalVentasMes = servicioVenta.totalVentas(tsInicioMes, tsFinMes);

            request.setAttribute("ventasDia", totalVentasDia);
            request.setAttribute("ventasMes", totalVentasMes);
            request.setAttribute("prendasVendidasDia", cantidadPrendasVendidas);
            request.setAttribute("prendasBajoStock", cantidadPrendasBajoStock);

            request.getRequestDispatcher("/").forward(request, response);
        } catch (IllegalArgumentException e)
        {
            message = "Datos no encontrados.";
            request.setAttribute("message", message);
            request.getRequestDispatcher("/").forward(request, response);
        }
    }
}
