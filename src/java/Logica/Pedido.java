package Logica;

import Interfaces.IPedido;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Pedido implements IPedido
{

    public int idPedido;
    public Date fechaPedido;
    public int preciototalPedido;
    public boolean estadoPedido;
    public List<DetallePedido> detallespedidoPedido;
    public Proveedor proveedorPedido;

    public Pedido()
    {
    }

    public Pedido(int idPedido, Date fechaPedido, int preciototalPedido, boolean estadoPedido, List detallespedidoPedido, Proveedor proveedorPedido)
    {
        this.idPedido = idPedido;
        this.fechaPedido = fechaPedido;
        this.preciototalPedido = preciototalPedido;
        this.estadoPedido = estadoPedido;
        this.detallespedidoPedido = detallespedidoPedido;
        this.proveedorPedido = proveedorPedido;
    }

    @Override
    public boolean crearPedido(Date fechaPedido, boolean estadoPedido, List detallespedidoPedido, Proveedor proveedorPedido)
    {
        return true;
    }

    @Override
    public boolean actualizarPedido(int idPedido, Date fechaPedido, boolean estadoPedido, List detallespedidoPedido, Proveedor proveedorPedido)
    {
        return true;
    }

    @Override
    public boolean eliminaredido(int idPedido)
    {
        return true;
    }

    @Override
    public Pedido obtenerPedido(int idPedido)
    {
        Pedido entidad = new Pedido();

        return entidad;
    }
}
