package Interfaces;

import Logica.PaginacionResultado;
import Logica.Pedido;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IPedido
{

    public boolean crearPedido(Timestamp fechaPedido, boolean estadoPedido, int idProveedor, String detallesPedidoJson, int idUsuarioAuditor);

    public boolean actualizarPedido(int idPedido, Timestamp fechaPedido, boolean estadoPedido, int idProveedor, String detallesPedidoJson, int idUsuarioAuditor);

    public boolean eliminaredido(int idPedido, int idUsuarioAuditor);

    public Pedido obtenerPedido(int idPedido);

    PaginacionResultado<Pedido> obtenerPedidos(String searchTerm, int numPage, int pageSize);

    List<Pedido> obtenerReportePedidos(Timestamp fechaInicio, Timestamp fechaFin, Integer idProveedor, Boolean estadoPedido);
}
