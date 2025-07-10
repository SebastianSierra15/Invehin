package servlets;

import Interfaces.ICategoria;
import Interfaces.ICliente;
import Interfaces.IPrenda;
import Interfaces.IVenta;
import Logica.Categoria;
import Logica.Cliente;
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
import java.util.List;
import java.util.Map;

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

            int top = 5;
            
            IPrenda servicioPrenda = new Prenda();
            IVenta servicioVenta = new Venta();
            ICliente servicioCliente = new Cliente();
            ICategoria servicioCategoria = new Categoria();

            int cantidadPrendasVendidas = servicioPrenda.cantidadPrendasVendidas(tsInicioHoy, tsFinHoy);
            int cantidadPrendasBajoStock = servicioPrenda.cantidadPrendasBajoStock();
            List<Prenda> prendasMasVendidasMes = servicioPrenda.cantidadPrendasMasVendidas(top, tsInicioMes, tsFinMes);
            int totalVentasDia = servicioVenta.totalVentas(tsInicioHoy, tsFinHoy);
            int totalVentasMes = servicioVenta.totalVentas(tsInicioMes, tsFinMes);
            double promedioVentasMes = servicioVenta.promedioVentas(tsInicioMes, tsFinMes);
            Map<Timestamp, Integer> totalVentasPorDia = servicioVenta.totalVentasPorDia(tsInicioMes, tsFinMes);
            int cantidadClientesMes = servicioCliente.totalClientes(tsInicioMes, tsFinMes);
            Map<String, Integer> valorCategorias = servicioCategoria.valorCategorias();

            request.setAttribute("ventasDia", totalVentasDia);
            request.setAttribute("ventasMes", totalVentasMes);
            request.setAttribute("prendasVendidasDia", cantidadPrendasVendidas);
            request.setAttribute("prendasBajoStock", cantidadPrendasBajoStock);
            request.setAttribute("promedioVentas", promedioVentasMes);
            request.setAttribute("totalVentasPorDia", totalVentasPorDia);
            request.setAttribute("clientesMes", cantidadClientesMes);
            request.setAttribute("prendasMasVendidasMes", prendasMasVendidasMes);
            request.setAttribute("valorCategorias", valorCategorias);

            request.getRequestDispatcher("/").forward(request, response);
        } catch (IllegalArgumentException e)
        {
            message = "Datos no encontrados.";
            request.setAttribute("message", message);
            request.getRequestDispatcher("/").forward(request, response);
        }
    }
}
