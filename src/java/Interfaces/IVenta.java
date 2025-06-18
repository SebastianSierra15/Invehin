package Interfaces;

import Logica.PaginacionResultado;
import Logica.Venta;
import java.util.List;
import java.sql.Timestamp;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IVenta
{

    boolean crearVenta(int montoRecibido, int clienteId, int metodoPagoId, int usuarioId, String detallesVentaJson);

    boolean actualizarVenta(int idVenta, int idClienteVenta, int idMetodopagoVenta, boolean estadoVenta);

    int totalVentas(Timestamp fechaInicio, Timestamp fechaFin);

    PaginacionResultado<Venta> obtenerVentas(String searchTerm, int numPage, int pageSize);
    
    List<Venta> obtenerReporteVentas(Timestamp fechaInicio, Timestamp fechaFin);
}
