package Interfaces;

import Logica.DetallePedido;
import Logica.Prenda;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IDetallePedido
{

    public boolean crearDetallePedido(int cantidadDetallePedido, int costoUnitarioDetallePedido, int subtotalDetallePedido, Prenda prendaDetallePedido, int idPedidoDetallePedido);

    public boolean actualizarDetallePedido(int idDetallePedido, int cantidadDetallePedido, int costounitarioDetallePedido, int subtotalDetallePedido, Prenda prendaDetallePedido, int idpedidoDetallePedido);

    public boolean eliminarDetallePedido(int idDetallePedido);

    public DetallePedido obtenerDetallePedido(int idDetallePedido);
}
