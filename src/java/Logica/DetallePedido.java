package Logica;

import Interfaces.IDetallePedido;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class DetallePedido implements IDetallePedido
{

    public int idDetallePedido;
    public int cantidadDetallePedido;
    public int costounitarioDetallePedido;
    public int subtotalDetallePedido;
    public Prenda prendaDetallePedido;
    public int idpedidoDetallePedido;

    public DetallePedido()
    {
    }

    public DetallePedido(int idDetallePedido, int cantidadDetallePedido, int costounitarioDetallePedido, int subtotalDetallePedido, Prenda prendaDetallePedido, int idpedidoDetallePedido)
    {
        this.idDetallePedido = idDetallePedido;
        this.cantidadDetallePedido = cantidadDetallePedido;
        this.costounitarioDetallePedido = costounitarioDetallePedido;
        this.subtotalDetallePedido = subtotalDetallePedido;
        this.prendaDetallePedido = prendaDetallePedido;
        this.idpedidoDetallePedido = idpedidoDetallePedido;
    }

    @Override
    public boolean crearDetallePedido(int cantidadDetallePedido, int costoUnitarioDetallePedido, int subtotalDetallePedido, Prenda prendaDetallePedido, int idPedidoDetallePedido)
    {
        return true;
    }

    @Override
    public boolean actualizarDetallePedido(int idDetallePedido, int cantidadDetallePedido, int costounitarioDetallePedido, int subtotalDetallePedido, Prenda prendaDetallePedido, int idpedidoDetallePedido)
    {
        return true;
    }

    @Override
    public boolean eliminarDetallePedido(int idDetallePedido)
    {
        return true;
    }

    @Override
    public DetallePedido obtenerDetallePedido(int idDetallePedido)
    {
        DetallePedido entidad = new DetallePedido();

        return entidad;
    }
}
