package Interfaces;

import Logica.PaginacionResultado;
import Logica.Venta;
import java.util.List;
import java.sql.Timestamp;
import java.util.Map;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IVenta
{

    boolean crearVenta(int montoRecibido, int clienteId, int metodoPagoId, int usuarioId, String detallesVentaJson);

    boolean actualizarVenta(int idVenta, int idClienteVenta, int idMetodopagoVenta, boolean estadoVenta);

    int totalVentas(Timestamp fechaInicio, Timestamp fechaFin);

    double promedioVentas(Timestamp fechaInicio, Timestamp fechaFin);
    
    Map<Timestamp, Integer> totalVentasPorDia(Timestamp fechaInicio, Timestamp fechaFin);

    PaginacionResultado<Venta> obtenerVentas(String searchTerm, int numPage, int pageSize);
    
    List<Venta> obtenerReporteVentas(Timestamp fechaInicio, Timestamp fechaFin);
}
