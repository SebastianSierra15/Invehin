package Logica;

import Interfaces.IDetalleVenta;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class DetalleVenta implements IDetalleVenta
{

    public int idDetalleVenta;
    public int cantidadDetalleVenta;
    public int subtotalDetalleVenta;
    public Prenda prendasDetalleVenta;
    public int idventaDetalleVenta;

    public DetalleVenta()
    {
    }

    public DetalleVenta(int idDetalleVenta, int cantidadDetalleVenta, int subtotalDetalleVenta, Prenda prendasDetalleVenta, int idventaDetalleVenta)
    {
        this.idDetalleVenta = idDetalleVenta;
        this.cantidadDetalleVenta = cantidadDetalleVenta;
        this.subtotalDetalleVenta = subtotalDetalleVenta;
        this.prendasDetalleVenta = prendasDetalleVenta;
        this.idventaDetalleVenta = idventaDetalleVenta;
    }

    @Override
    public boolean crearDetalleVenta(int cantidadDetalleVenta, int subtotalDetalleVenta, Prenda prendasDetalleVenta, int idventaDetalleVenta)
    {
        return true;
    }

    @Override
    public boolean actualizarDetalleVenta(int idDetalleVenta, int cantidadDetalleVenta, int subtotalDetalleVenta, Prenda prendasDetalleVenta, int idventaDetalleVenta)
    {
        return true;
    }

    @Override
    public boolean eliminarDetalleVenta(int idDetalleVenta)
    {
        return true;
    }

    @Override
    public DetalleVenta obtenerDetalleVenta(int idDetalleVenta)
    {
        DetalleVenta entidad = new DetalleVenta();

        return entidad;
    }
}
