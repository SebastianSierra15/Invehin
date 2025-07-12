package Logica;

import Entidades.EPedido;
import Interfaces.IPedido;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Pedido implements IPedido
{

    public int idPedido;
    public Timestamp fechaPedido;
    public int preciototalPedido;
    public int cantidadPedido;
    public boolean estadoPedido;
    public List<DetallePedido> detallespedidoPedido;
    public Proveedor proveedorPedido;

    public Pedido()
    {
    }

    public Pedido(int idPedido, Timestamp fechaPedido, int preciototalPedido, int cantidadPedido, boolean estadoPedido, List detallespedidoPedido, Proveedor proveedorPedido)
    {
        this.idPedido = idPedido;
        this.fechaPedido = fechaPedido;
        this.preciototalPedido = preciototalPedido;
        this.cantidadPedido = cantidadPedido;
        this.estadoPedido = estadoPedido;
        this.detallespedidoPedido = detallespedidoPedido;
        this.proveedorPedido = proveedorPedido;
    }

    @Override
    public boolean crearPedido(Timestamp fechaPedido, boolean estadoPedido, int idProveedor, String detallesPedidoJson, int idUsuarioAuditor)
    {
        EPedido result = new EPedido();
        
        return result.insertPedido(fechaPedido, estadoPedido, idProveedor, detallesPedidoJson, idUsuarioAuditor);
    }

    @Override
    public boolean actualizarPedido(int idPedido, Timestamp fechaPedido, boolean estadoPedido, int idProveedor, String detallesPedidoJson, int idUsuarioAuditor)
    {
        EPedido result = new EPedido();
        
        return result.updatePedido(idPedido, fechaPedido, estadoPedido, idProveedor, detallesPedidoJson, idUsuarioAuditor);
    }

    @Override
    public boolean eliminaredido(int idPedido, int idUsuarioAuditor)
    {
        return true;
    }

    @Override
    public Pedido obtenerPedido(int idPedido)
    {
        Pedido entidad = new Pedido();

        return entidad;
    }

    @Override
    public PaginacionResultado<Pedido> obtenerPedidos(String searchTerm, int numPage, int pageSize)
    {
        EPedido result = new EPedido();
        
        return result.selectPedidosPorTerminoBusqueda(searchTerm, numPage, pageSize);
    }

    @Override
    public List<Pedido> obtenerReportePedidos(Timestamp fechaInicio, Timestamp fechaFin, Integer idProveedor, Boolean estadoPedido)
    {
        EPedido result = new EPedido();
        
        return result.selectReportePedidos(fechaInicio, fechaFin, idProveedor, estadoPedido);
    }
}
