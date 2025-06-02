package Logica;

import Entidades.EVenta;
import Interfaces.IVenta;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Venta implements IVenta
{

    public int idVenta;
    public Timestamp fechaVenta;
    public int preciototalVenta;
    public int montorecibidoVenta;
    public boolean estadoVenta;
    public MetodoPago metodopagoVenta;
    public Cliente clienteVenta;
    public int usuarioVenta;
    public List<DetalleVenta> detallesventaVenta;

    public Venta()
    {
    }

    public Venta(int idVenta, Timestamp fechaVenta, int preciototalVenta, int montorecibidoVenta, boolean estadoVenta, MetodoPago metodopagoVenta, Cliente clienteVenta, int usuarioVenta, List<DetalleVenta> detallesventaVenta)
    {
        this.idVenta = idVenta;
        this.fechaVenta = fechaVenta;
        this.preciototalVenta = preciototalVenta;
        this.montorecibidoVenta = montorecibidoVenta;
        this.estadoVenta = estadoVenta;
        this.metodopagoVenta = metodopagoVenta;
        this.clienteVenta = clienteVenta;
        this.usuarioVenta = usuarioVenta;
        this.detallesventaVenta = detallesventaVenta;
    }

    @Override
    public boolean crearVenta(Timestamp fechaVenta, int montorecibidoVenta, boolean estadoVenta, MetodoPago metodopagoVenta, int clienteVenta, int usuarioVenta, List<DetalleVenta> detallesventaVenta)
    {
        return true;
    }

    @Override
    public boolean actualizarVenta(int idVenta, Timestamp fechaVenta, int montorecibidoVenta, boolean estadoVenta, MetodoPago metodopagoVenta, int clienteVenta, int usuarioVenta, List<DetalleVenta> detallesventaVenta)
    {
        return true;
    }

    @Override
    public boolean eliminarVenta(int idVenta)
    {
        return true;
    }

    @Override
    public Venta obtenerVenta(int idVenta)
    {
        Venta entidad = new Venta();

        return entidad;
    }

    @Override
    public int totalVentas(Timestamp fechaInicio, Timestamp fechaFin)
    {
        EVenta result = new EVenta();

        return result.getTotalVentas(fechaInicio, fechaFin);
    }
}
