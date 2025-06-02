package Interfaces;

import Logica.Pedido;
import Logica.Proveedor;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IPedido
{

    public boolean crearPedido(Date fechaPedido, boolean estadoPedido, List detallespedidoPedido, Proveedor proveedorPedido);

    public boolean actualizarPedido(int idPedido, Date fechaPedido, boolean estadoPedido, List detallespedidoPedido, Proveedor proveedorPedido);

    public boolean eliminaredido(int idPedido);

    public Pedido obtenerPedido(int idPedido);
}
