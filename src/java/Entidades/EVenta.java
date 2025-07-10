package Entidades;

import Logica.Cliente;
import Logica.DetalleVenta;
import Logica.MetodoPago;
import Logica.PaginacionResultado;
import Logica.Venta;
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
public class EVenta
{

    public EVenta()
    {
    }

    public boolean insertVenta(int montoRecibido, int clienteId, int metodoPagoId, int usuarioId, String detallesVentaJson)
    {
        String sql = "{CALL insert_venta(?, ?, ?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, montoRecibido);
                cs.setInt(2, clienteId);
                cs.setInt(3, metodoPagoId);
                cs.setInt(4, usuarioId);
                cs.setString(5, detallesVentaJson);

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

    public boolean updateVenta(int idVenta, int idClienteVenta, int idMetodopagoVenta, boolean estadoVenta)
    {
        String sql = "{CALL update_venta(?, ?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idVenta);
                cs.setInt(2, idClienteVenta);
                cs.setInt(3, idMetodopagoVenta);
                cs.setBoolean(4, estadoVenta);

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

    public int getTotalVentas(Timestamp fechaInicio, Timestamp fechaFin)
    {
        int total = 0;
        System.out.println("FECHA INICIO" + fechaInicio);

        String sql = "SELECT calcular_total_ventas_por_rango(?, ?) AS total_ventas";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (PreparedStatement ps = db.obtener().prepareStatement(sql))
            {
                ps.setTimestamp(1, fechaInicio);
                ps.setTimestamp(2, fechaFin);

                try (ResultSet rs = ps.executeQuery())
                {
                    if (rs.next())
                    {
                        total = rs.getInt("total_ventas");
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

        return total;
    }

    public double getPromedioVentas(Timestamp fechaInicio, Timestamp fechaFin)
    {
        double promedio = 0;
        System.out.println("FECHA INICIO" + fechaInicio);

        String sql = "SELECT promedio_venta_por_rango(?, ?) AS promedio_ventas";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (PreparedStatement ps = db.obtener().prepareStatement(sql))
            {
                ps.setTimestamp(1, fechaInicio);
                ps.setTimestamp(2, fechaFin);

                try (ResultSet rs = ps.executeQuery())
                {
                    if (rs.next())
                    {
                        promedio = rs.getInt("promedio_ventas");
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

        return promedio;
    }

    public Map<Timestamp, Integer> getTotalVentasPorDia(Timestamp fechaInicio, Timestamp fechaFin)
    {
        Map<Timestamp, Integer> ventas = new HashMap<>();
        String sql = "{CALL get_ventas_por_dia_por_rango(?, ?)}";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setTimestamp(1, fechaInicio);
                cs.setTimestamp(2, fechaFin);

                try (ResultSet rs = cs.executeQuery())
                {
                    while (rs.next())
                    {
                        ventas.put(rs.getTimestamp("fecha"), rs.getInt("total"));
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

        return ventas;
    }

    public PaginacionResultado<Venta> selectVentasPorTerminoBusqueda(String searchTerm, int numPage, int pageSize)
    {
        List<Venta> ventas = new ArrayList<>();
        int total = 0;
        String sql = "{CALL select_ventas(?, ?, ?)}";
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
                            MetodoPago metodopago = new MetodoPago(
                                    rs.getInt("metodopago_id"),
                                    rs.getString("metodopago_nombre"),
                                    rs.getBoolean("metodopago_estado")
                            );

                            Cliente cliente = new Cliente(
                                    rs.getInt("cliente_id"),
                                    rs.getTimestamp("cliente_fecha_registro"),
                                    rs.getString("cliente_direccion"),
                                    rs.getBoolean("cliente_estado"),
                                    rs.getInt("persona_id"),
                                    rs.getString("persona_numero_identificacion"),
                                    rs.getString("persona_nombres"),
                                    rs.getString("persona_apellidos"),
                                    rs.getString("persona_telefono"),
                                    rs.getBoolean("persona_genero")
                            );

                            Venta venta = new Venta(
                                    rs.getInt("id"),
                                    rs.getTimestamp("fecha"),
                                    rs.getInt("cantidad"),
                                    rs.getInt("precio_total"),
                                    rs.getInt("monto_recibido"),
                                    rs.getBoolean("estado"),
                                    metodopago,
                                    cliente,
                                    rs.getInt("usuario_id"),
                                    new ArrayList<>()
                            );

                            ventas.add(venta);
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
                        // Agrupar detalles por venta_id
                        Map<Integer, List<DetalleVenta>> detallesMap = new HashMap<>();

                        while (rs3.next())
                        {
                            int ventaId = rs3.getInt("venta_id");

                            DetalleVenta detalle = new DetalleVenta(
                                    rs3.getInt("id"),
                                    rs3.getInt("cantidad"),
                                    rs3.getInt("subtotal"),
                                    rs3.getString("prenda_codigo"),
                                    rs3.getString("prenda_nombre"),
                                    rs3.getString("prenda_color"),
                                    rs3.getString("prenda_talla"),
                                    rs3.getInt("prenda_precio"),
                                    rs3.getInt("prenda_promocion"),
                                    ventaId
                            );

                            detallesMap.computeIfAbsent(ventaId, k -> new ArrayList<>()).add(detalle);
                        }

                        // Asignar los detalles a cada venta
                        for (Venta venta : ventas)
                        {
                            List<DetalleVenta> detalles = detallesMap.getOrDefault(venta.idVenta, new ArrayList<>());
                            venta.detallesventaVenta = detalles;
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

        return new PaginacionResultado<>(ventas, total);
    }

    public List<Venta> selectReporteVentas(Timestamp fechaInicio, Timestamp fechaFin)
    {
        List<Venta> ventas = new ArrayList<>();
        String sql = "{CALL reporte_ventas(?, ?)}";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setTimestamp(1, fechaInicio);
                cs.setTimestamp(2, fechaFin);

                boolean hasResults = cs.execute();

                if (hasResults)
                {
                    try (ResultSet rs = cs.getResultSet())
                    {
                        while (rs.next())
                        {
                            MetodoPago metodopago = new MetodoPago(
                                    rs.getInt("metodopago_id"),
                                    rs.getString("metodopago_nombre"),
                                    rs.getBoolean("metodopago_estado")
                            );

                            Cliente cliente = new Cliente(
                                    rs.getInt("cliente_id"),
                                    rs.getTimestamp("cliente_fecha_registro"),
                                    rs.getString("cliente_direccion"),
                                    rs.getBoolean("cliente_estado"),
                                    rs.getInt("persona_id"),
                                    rs.getString("persona_numero_identificacion"),
                                    rs.getString("persona_nombres"),
                                    rs.getString("persona_apellidos"),
                                    rs.getString("persona_telefono"),
                                    rs.getBoolean("persona_genero")
                            );

                            Venta venta = new Venta(
                                    rs.getInt("id"),
                                    rs.getTimestamp("fecha"),
                                    rs.getInt("cantidad"),
                                    rs.getInt("precio_total"),
                                    rs.getInt("monto_recibido"),
                                    rs.getBoolean("estado"),
                                    metodopago,
                                    cliente,
                                    rs.getInt("usuario_id"),
                                    new ArrayList<>()
                            );

                            ventas.add(venta);
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

        return ventas;
    }
}
