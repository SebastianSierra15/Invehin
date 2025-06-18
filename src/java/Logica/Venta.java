package Logica;

import Entidades.EVenta;
import Interfaces.IVenta;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Venta implements IVenta
{

    public int idVenta;
    public Timestamp fechaVenta;
    public int cantidadVenta;
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

    public Venta(int idVenta, Timestamp fechaVenta, int cantidadVenta, int preciototalVenta, int montorecibidoVenta, boolean estadoVenta, MetodoPago metodopagoVenta, Cliente clienteVenta, int usuarioVenta, List<DetalleVenta> detallesventaVenta)
    {
        this.idVenta = idVenta;
        this.fechaVenta = fechaVenta;
        this.cantidadVenta = cantidadVenta;
        this.preciototalVenta = preciototalVenta;
        this.montorecibidoVenta = montorecibidoVenta;
        this.estadoVenta = estadoVenta;
        this.metodopagoVenta = metodopagoVenta;
        this.clienteVenta = clienteVenta;
        this.usuarioVenta = usuarioVenta;
        this.detallesventaVenta = detallesventaVenta;
    }

    @Override
    public boolean crearVenta(int montoRecibido, int clienteId, int metodoPagoId, int usuarioId, String detallesVentaJson)
    {
        EVenta result = new EVenta();

        return result.insertVenta(montoRecibido, clienteId, metodoPagoId, usuarioId, detallesVentaJson);
    }

    @Override
    public boolean actualizarVenta(int idVenta, int idClienteVenta, int idMetodopagoVenta, boolean estadoVenta)
    {
        EVenta result = new EVenta();

        return result.updateVenta(idVenta, idClienteVenta, idMetodopagoVenta, estadoVenta);
    }

    @Override
    public int totalVentas(Timestamp fechaInicio, Timestamp fechaFin)
    {
        EVenta result = new EVenta();

        return result.getTotalVentas(fechaInicio, fechaFin);
    }

    @Override
    public PaginacionResultado<Venta> obtenerVentas(String searchTerm, int numPage, int pageSize)
    {
        EVenta result = new EVenta();

        return result.selectVentasPorTerminoBusqueda(searchTerm, numPage, pageSize);
    }

    @Override
    public List<Venta> obtenerReporteVentas(Timestamp fechaInicio, Timestamp fechaFin)
    {
        EVenta result = new EVenta();

        return result.selectReporteVentas(fechaInicio, fechaFin);
    }
}
