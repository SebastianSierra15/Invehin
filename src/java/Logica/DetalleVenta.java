package Logica;

import Interfaces.IDetalleVenta;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class DetalleVenta implements IDetalleVenta
{

    public int idDetalleVenta;
    public int cantidadDetalleVenta;
    public int subtotalDetalleVenta;
    public String prendacodigoDetalleVenta;
    public String prendanombreDetalleVenta;
    public String prendacolorDetalleVenta;
    public String prendatallaDetalleVenta;
    public int prendaprecioDetalleVenta;
    public int prendapromocionDetalleVenta;
    public int idventaDetalleVenta;

    public DetalleVenta()
    {
    }

    public DetalleVenta(int idDetalleVenta, int cantidadDetalleVenta, int subtotalDetalleVenta, String prendacodigoDetalleVenta, String prendanombreDetalleVenta, String prendacolorDetalleVenta, String prendatallaDetalleVenta, int prendaprecioDetalleVenta, int prendapromocionDetalleVenta, int idventaDetalleVenta)
    {
        this.idDetalleVenta = idDetalleVenta;
        this.cantidadDetalleVenta = cantidadDetalleVenta;
        this.subtotalDetalleVenta = subtotalDetalleVenta;
        this.prendacodigoDetalleVenta = prendacodigoDetalleVenta;
        this.prendanombreDetalleVenta = prendanombreDetalleVenta;
        this.prendacolorDetalleVenta = prendacolorDetalleVenta;
        this.prendatallaDetalleVenta = prendatallaDetalleVenta;
        this.prendaprecioDetalleVenta = prendaprecioDetalleVenta;
        this.prendapromocionDetalleVenta = prendapromocionDetalleVenta;
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

    @Override
    public List<DetalleVenta> obtenerDetallesVentaByVenta(int idVenta)
    {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
}
