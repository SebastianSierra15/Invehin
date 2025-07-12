package Entidades;

import Logica.DetallePedido;
import Logica.PaginacionResultado;
import Logica.Pedido;
import Logica.Proveedor;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class EPedido
{

    public EPedido()
    {
    }

    public boolean insertPedido(Timestamp fechaPedido, boolean estadoPedido, int idProveedor, String detallesPedidoJson, int idUsuarioAuditor)
    {
        String sqlSetAuditor = "SET @id_usuario_auditoria = ?";
        String sql = "{CALL insert_pedido(?, ?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            // 1. Establecer el ID de usuario auditor en la sesión de MySQL
            try (PreparedStatement ps = db.obtener().prepareStatement(sqlSetAuditor))
            {
                ps.setInt(1, idUsuarioAuditor);
                ps.execute();
            }

            // 2. Ejecutar el procedimiento almacenado
            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setTimestamp(1, fechaPedido);
                cs.setInt(2, idProveedor);
                cs.setBoolean(3, estadoPedido);
                cs.setString(4, detallesPedidoJson);

                cs.execute();
                exito = true;
            }
        } catch (SQLException | ClassNotFoundException e)
        {
            e.printStackTrace();
        } finally
        {
            if (db != null)
            {
                try
                {
                    db.cerrar();
                } catch (SQLException e)
                {
                    e.printStackTrace();
                }
            }
        }

        return exito;
    }

    public boolean updatePedido(int idPedido, Timestamp fechaPedido, boolean estadoPedido, int idProveedor, String detallesPedidoJson, int idUsuarioAuditor)
    {
        String sqlSetAuditor = "SET @id_usuario_auditoria = ?";
        String sql = "{CALL update_pedido(?, ?, ?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            // 1. Establecer el ID de usuario auditor en la sesión de MySQL
            try (PreparedStatement ps = db.obtener().prepareStatement(sqlSetAuditor))
            {
                ps.setInt(1, idUsuarioAuditor);
                ps.execute();
            }

            // 2. Ejecutar el procedimiento almacenado
            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idPedido);
                cs.setTimestamp(2, fechaPedido);
                cs.setBoolean(3, estadoPedido);
                cs.setInt(4, idProveedor);
                cs.setString(5, detallesPedidoJson);

                cs.execute();
                exito = true;
            }
        } catch (SQLException | ClassNotFoundException e)
        {
            e.printStackTrace();
        } finally
        {
            if (db != null)
            {
                try
                {
                    db.cerrar();
                } catch (SQLException e)
                {
                    e.printStackTrace();
                }
            }
        }

        return exito;
    }

    public boolean deletePedido()
    {
        return true;
    }

    public Pedido selectPedidoById()
    {
        Pedido entidad = new Pedido();

        return entidad;
    }

    public PaginacionResultado<Pedido> selectPedidosPorTerminoBusqueda(String searchTerm, int numPage, int pageSize)
    {
        List<Pedido> pedidos = new ArrayList<>();
        int total = 0;
        String sql = "{CALL select_pedidos(?, ?, ?)}";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, searchTerm);
                cs.setInt(2, numPage);
                cs.setInt(3, pageSize);

                boolean hasResults = cs.execute();

                if (hasResults)
                {
                    try (ResultSet rs = cs.getResultSet())
                    {
                        while (rs.next())
                        {
                            Proveedor proveedor = new Proveedor(
                                    rs.getInt("proveedor_id"),
                                    rs.getString("proveedor_nombre"),
                                    "",
                                    "",
                                    true
                            );

                            Pedido pedido = new Pedido(
                                    rs.getInt("id"),
                                    rs.getTimestamp("fecha"),
                                    rs.getInt("precio_total"),
                                    rs.getInt("cantidad"),
                                    rs.getBoolean("estado"),
                                    new ArrayList<>(),
                                    proveedor
                            );

                            pedidos.add(pedido);
                        }
                    }
                }

                if (cs.getMoreResults())
                {
                    try (ResultSet rs2 = cs.getResultSet())
                    {
                        if (rs2.next())
                        {
                            total = rs2.getInt("total_entries");
                        }
                    }
                }

                if (cs.getMoreResults())
                {
                    try (ResultSet rs3 = cs.getResultSet())
                    {
                        // Agrupar detalles por pedido_id
                        Map<Integer, List<DetallePedido>> detallesMap = new HashMap<>();

                        while (rs3.next())
                        {
                            int pedidoId = rs3.getInt("pedido_id");

                            DetallePedido detalle = new DetallePedido(
                                    rs3.getInt("id"),
                                    rs3.getInt("cantidad"),
                                    rs3.getInt("costo_unitario"),
                                    rs3.getInt("subtotal"),
                                    rs3.getString("prenda_codigo"),
                                    rs3.getString("prenda_nombre"),
                                    rs3.getString("prenda_color"),
                                    rs3.getString("prenda_talla"),
                                    rs3.getInt("prenda_precio"),
                                    pedidoId
                            );

                            detallesMap.computeIfAbsent(pedidoId, k -> new ArrayList<>()).add(detalle);
                        }

                        // Asignar los detalles a cada pedido
                        for (Pedido pedido : pedidos)
                        {
                            List<DetallePedido> detalles = detallesMap.getOrDefault(pedido.idPedido, new ArrayList<>());
                            pedido.detallespedidoPedido = detalles;
                        }
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e)
        {
            e.printStackTrace();
        } finally
        {
            if (db != null)
            {
                try
                {
                    db.cerrar();
                } catch (SQLException e)
                {
                    e.printStackTrace();
                }
            }
        }

        return new PaginacionResultado<>(pedidos, total);
    }

    public List<Pedido> selectReportePedidos(Timestamp fechaInicio, Timestamp fechaFin, Integer idProveedor, Boolean estadoPedido)
    {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "{CALL reporte_pedidos(?, ?, ?, ?)}";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setTimestamp(1, fechaInicio);
                cs.setTimestamp(2, fechaFin);

                // idProveedor puede ser null
                if (idProveedor != null)
                {
                    cs.setInt(3, idProveedor);
                } else
                {
                    cs.setNull(3, java.sql.Types.INTEGER);
                }

                // estadoPedido puede ser null
                if (estadoPedido != null)
                {
                    cs.setBoolean(4, estadoPedido);
                } else
                {
                    cs.setNull(4, java.sql.Types.BOOLEAN);
                }

                boolean hasResults = cs.execute();

                if (hasResults)
                {
                    try (ResultSet rs = cs.getResultSet())
                    {
                        while (rs.next())
                        {
                            Proveedor proveedor = new Proveedor(
                                    rs.getInt("proveedor_id"),
                                    rs.getString("proveedor_nombre"),
                                    "",
                                    "",
                                    true
                            );

                            Pedido pedido = new Pedido(
                                    rs.getInt("id"),
                                    rs.getTimestamp("fecha"),
                                    rs.getInt("precio_total"),
                                    rs.getInt("cantidad"),
                                    rs.getBoolean("estado"),
                                    new ArrayList<>(),
                                    proveedor
                            );

                            pedidos.add(pedido);
                        }
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e)
        {
            e.printStackTrace();
        } finally
        {
            if (db != null)
            {
                try
                {
                    db.cerrar();
                } catch (SQLException e)
                {
                    e.printStackTrace();
                }
            }
        }

        return pedidos;
    }
}
