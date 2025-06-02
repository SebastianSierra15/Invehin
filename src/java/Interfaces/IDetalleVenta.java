package Interfaces;

import Logica.DetalleVenta;
import Logica.Prenda;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IDetalleVenta
{

    boolean crearDetalleVenta(int cantidadDetalleVenta, int subtotalDetalleVenta, Prenda prendasDetalleVenta, int idventaDetalleVenta);

    boolean actualizarDetalleVenta(int idDetalleVenta, int cantidadDetalleVenta, int subtotalDetalleVenta, Prenda prendasDetalleVenta, int idventaDetalleVenta);

    boolean eliminarDetalleVenta(int idDetalleVenta);

    DetalleVenta obtenerDetalleVenta(int idDetalleVenta);
}
