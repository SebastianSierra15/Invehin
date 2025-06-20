package Entidades;

import Logica.Categoria;
import Logica.Color;
import Logica.EstadoPrenda;
import Logica.PaginacionResultado;
import Logica.Prenda;
import Logica.Subcategoria;
import Logica.Talla;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class EPrenda
{

    public EPrenda()
    {
    }

    public boolean insertPrenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, int idColor, int idSubcategoria, int idTalla)
    {
        String sql = "{CALL insert_prenda(?, ?, ?, ?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, codigoPrenda);
                cs.setInt(2, stockPrenda);
                cs.setInt(3, stockminimoPrenda);
                cs.setInt(4, idColor);
                cs.setInt(5, idSubcategoria);
                cs.setInt(6, idTalla);

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

    public boolean updatePrenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, int idColor, int idEstadoPrenda, int idSubcategoria, int idTalla)
    {
        String sql = "{CALL update_prenda(?, ?, ?, ?, ?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, codigoPrenda);
                cs.setInt(2, stockPrenda);
                cs.setInt(3, stockminimoPrenda);
                cs.setInt(4, idColor);
                cs.setInt(5, idEstadoPrenda);
                cs.setInt(6, idSubcategoria);
                cs.setInt(7, idTalla);

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

    public boolean deletePrenda(String codigoPrenda)
    {
        String sql = "{CALL desactivar_prenda(?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, codigoPrenda);

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

    public int getPrendasBajoStock()
    {
        int cantidad = 0;
        String sql = "SELECT cantidad_prendas_bajo_stock() AS prendas_bajo_stock";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                boolean resultado = cs.execute();

                if (resultado)
                {
                    try (ResultSet rs = cs.getResultSet())
                    {
                        if (rs.next())
                        {
                            cantidad = rs.getInt("prendas_bajo_stock");
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

        return cantidad;
    }

    public int getPrendasVendidas(Timestamp fechaInicio, Timestamp fechaFin)
    {
        int cantidad = 0;
        System.out.println(fechaInicio);
        String sql = "SELECT cantidad_prendas_vendidas_por_rango(?, ?) AS prendas_vendidas";
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
                        cantidad = rs.getInt("prendas_vendidas");
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

        return cantidad;
    }

    public PaginacionResultado<Prenda> selectPrendasPorTerminoBusqueda(String searchTerm, int numPage, int pageSize)
    {
        List<Prenda> prendas = new ArrayList<>();
        int total = 0;
        String sql = "{CALL select_prendas(?, ?, ?)}";
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
                            Color color = new Color(
                                    rs.getInt("color_id"),
                                    rs.getString("color_nombre")
                            );

                            EstadoPrenda estado = new EstadoPrenda(
                                    rs.getInt("estadoprenda_id"),
                                    rs.getString("estadoprenda_nombre")
                            );

                            Talla talla = new Talla(
                                    rs.getInt("talla_id"),
                                    rs.getString("talla_nombre")
                            );

                            Categoria categoria = new Categoria(
                                    rs.getInt("categoria_id"),
                                    rs.getString("categoria_nombre"),
                                    true,
                                    new ArrayList<>()
                            );

                            Subcategoria subcategoria = new Subcategoria(
                                    rs.getInt("subcategoria_id"),
                                    rs.getString("subcategoria_nombre"),
                                    rs.getInt("subcategoria_precio"),
                                    rs.getString("subcategoria_imagen"),
                                    rs.getBoolean("subcategoria_estado"),
                                    categoria
                            );

                            Prenda prenda = new Prenda(
                                    rs.getString("codigo"),
                                    rs.getInt("stock"),
                                    rs.getInt("stock_minimo"),
                                    color,
                                    estado,
                                    talla,
                                    subcategoria
                            );

                            prendas.add(prenda);
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

        return new PaginacionResultado<>(prendas, total);
    }

    public List<Prenda> selectReportePrendas(Integer idCategoria, Integer idTalla, boolean stockBajo)
    {
        List<Prenda> prendas = new ArrayList<>();
        String sql = "{CALL reporte_prendas(?, ?, ?)}";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                if (idCategoria != null)
                {
                    cs.setInt(1, idCategoria);
                } else
                {
                    cs.setNull(1, java.sql.Types.INTEGER);
                }

                if (idTalla != null)
                {
                    cs.setInt(2, idTalla);
                } else
                {
                    cs.setNull(2, java.sql.Types.INTEGER);
                }

                cs.setBoolean(3, stockBajo);

                boolean hasResults = cs.execute();

                if (hasResults)
                {
                    try (ResultSet rs = cs.getResultSet())
                    {
                        while (rs.next())
                        {
                            Color color = new Color(
                                    rs.getInt("color_id"),
                                    rs.getString("color_nombre")
                            );

                            EstadoPrenda estado = new EstadoPrenda(
                                    rs.getInt("estadoprenda_id"),
                                    rs.getString("estadoprenda_nombre")
                            );

                            Talla talla = new Talla(
                                    rs.getInt("talla_id"),
                                    rs.getString("talla_nombre")
                            );

                            Categoria categoria = new Categoria(
                                    rs.getInt("categoria_id"),
                                    rs.getString("categoria_nombre"),
                                    true,
                                    new ArrayList<>()
                            );

                            Subcategoria subcategoria = new Subcategoria(
                                    rs.getInt("subcategoria_id"),
                                    rs.getString("subcategoria_nombre"),
                                    rs.getInt("subcategoria_precio"),
                                    rs.getString("subcategoria_imagen"),
                                    rs.getBoolean("subcategoria_estado"),
                                    categoria
                            );

                            Prenda prenda = new Prenda(
                                    rs.getString("codigo"),
                                    rs.getInt("stock"),
                                    rs.getInt("stock_minimo"),
                                    color,
                                    estado,
                                    talla,
                                    subcategoria
                            );

                            prendas.add(prenda);
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

        return prendas;
    }

    public List<Prenda> selectPrendasForVenta(String searchTerm)
    {
        List<Prenda> prendas = new ArrayList<>();
        String sql = "{CALL select_prendas_for_venta(?)}";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, searchTerm);

                try (ResultSet rs = cs.executeQuery())
                {
                    while (rs.next())
                    {
                        Color color = new Color(rs.getInt("color_id"), rs.getString("color_nombre"));
                        Talla talla = new Talla(rs.getInt("talla_id"), rs.getString("talla_nombre"));
                        EstadoPrenda estado = new EstadoPrenda(rs.getInt("estadoprenda_id"), rs.getString("estadoprenda_nombre"));
                        Categoria categoria = new Categoria(rs.getInt("categoria_id"), rs.getString("categoria_nombre"), rs.getBoolean("categoria_estado"), new ArrayList<>());

                        Subcategoria subcategoria = new Subcategoria(
                                rs.getInt("subcategoria_id"),
                                rs.getString("subcategoria_nombre"),
                                (int) rs.getDouble("subcategoria_precio"),
                                rs.getString("subcategoria_imagen"),
                                true,
                                categoria);

                        Prenda prenda = new Prenda(
                                rs.getString("codigo"),
                                rs.getInt("stock"),
                                rs.getInt("stock_minimo"),
                                color,
                                estado,
                                talla,
                                subcategoria
                        );

                        prendas.add(prenda);
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

        return prendas;
    }
}
