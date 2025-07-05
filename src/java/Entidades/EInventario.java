package Entidades;

import Logica.DetalleInventario;
import Logica.Inventario;
import Logica.PaginacionResultado;
import java.sql.CallableStatement;
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
public class EInventario
{
    
    public EInventario()
    {
    }
    
    
    public boolean insertInventario(String observacionInventario, int idUsuario, String detallesInventarioJson)
    {
        String sql = "{CALL insert_inventario(?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, observacionInventario);
                cs.setInt(2, idUsuario);
                cs.setString(3, detallesInventarioJson);

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
    
    public boolean updateInventario(int idInventario, String observacionInventario, boolean estadoInventario, String detallesInventarioJson)
    {
        String sql = "{CALL update_inventario(?, ?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idInventario);
                cs.setString(2, observacionInventario);
                cs.setBoolean(3, estadoInventario);
                cs.setString(4, detallesInventarioJson);

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

    public boolean deleteInventario()
    {
        return true;
    }
    
    public Inventario selectInventarioById()
    {
        Inventario entidad = new Inventario();
        
        return entidad;
    }
    
    public PaginacionResultado<Inventario> selectInventariosPorTerminoBusqueda(String searchTerm, int numPage, int pageSize)
    {
        List<Inventario> inventarios = new ArrayList<>();
        int total = 0;
        String sql = "{CALL select_inventarios(?, ?, ?)}";
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
                            Inventario inventario = new Inventario(
                                    rs.getInt("id"),
                                    rs.getTimestamp("fecha"),
                                    rs.getString("observacion"),
                                    rs.getBoolean("estado"),
                                    rs.getInt("usuario_id"),
                                    rs.getString("usuario_nombre"),
                                    new ArrayList<>()
                            );
                            
                            inventarios.add(inventario);
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
                        // Agrupar detalles por inventario_id
                        Map<Integer, List<DetalleInventario>> detallesMap = new HashMap<>();
                        
                        while (rs3.next())
                        {
                            int inventarioId = rs3.getInt("inventario_id");
                            
                            DetalleInventario detalle = new DetalleInventario(
                                    rs3.getInt("id"),
                                    rs3.getInt("cantidad_registrada"),
                                    rs3.getInt("cantidad_sistema"),
                                    rs3.getString("observacion"),
                                    rs3.getString("prenda_codigo"),
                                    rs3.getString("prenda_nombre"),
                                    inventarioId
                            );
                            
                            detallesMap.computeIfAbsent(inventarioId, k -> new ArrayList<>()).add(detalle);
                        }

                        // Asignar los detalles a cada inventario
                        for (Inventario inventario : inventarios)
                        {
                            List<DetalleInventario> detalles = detallesMap.getOrDefault(inventario.idInventario, new ArrayList<>());
                            inventario.detallesinventarioInventario = detalles;
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
        
        return new PaginacionResultado<>(inventarios, total);
    }
    
    public List<Inventario> selectReporteInventarios(Timestamp fechaInicio, Timestamp fechaFin, Boolean estadoInventario)
    {
        List<Inventario> inventarios = new ArrayList<>();
        String sql = "{CALL reporte_inventarios(?, ?, ?)}";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setTimestamp(1, fechaInicio);
                cs.setTimestamp(2, fechaFin);

                // estadoInventario puede ser null
                if (estadoInventario != null)
                {
                    cs.setBoolean(3, estadoInventario);
                } else
                {
                    cs.setNull(3, java.sql.Types.BOOLEAN);
                }

                boolean hasResults = cs.execute();

                if (hasResults)
                {
                    try (ResultSet rs = cs.getResultSet())
                    {
                        while (rs.next())
                        {
                            Inventario inventario = new Inventario(
                                    rs.getInt("id"),
                                    rs.getTimestamp("fecha"),
                                    rs.getString("observacion"),
                                    rs.getBoolean("estado"),
                                    rs.getInt("usuario_id"),
                                    rs.getString("usuario_nombre"),
                                    new ArrayList<>()
                            );
                            
                            inventarios.add(inventario);
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

        return inventarios;
    }
}
