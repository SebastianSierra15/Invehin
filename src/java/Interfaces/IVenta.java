package Interfaces;

import Logica.DetalleVenta;
import Logica.MetodoPago;
import Logica.Venta;
import java.util.List;
import java.sql.Timestamp;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IVenta
{

    boolean crearVenta(Timestamp fechaVenta, int montorecibidoVenta, boolean estadoVenta, MetodoPago metodopagoVenta, int clienteVenta, int usuarioVenta, List<DetalleVenta> detallesventaVenta);

    boolean actualizarVenta(int idVenta, Timestamp fechaVenta, int montorecibidoVenta, boolean estadoVenta, MetodoPago metodopagoVenta, int clienteVenta, int usuarioVenta, List<DetalleVenta> detallesventaVenta);

    boolean eliminarVenta(int idVenta);

    Venta obtenerVenta(int idVenta);

    int totalVentas(Timestamp fechaInicio, Timestamp fechaFin);
}
