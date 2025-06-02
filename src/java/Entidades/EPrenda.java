package Entidades;

import Logica.Categoria;
import Logica.Color;
import Logica.EstadoPrenda;
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

    public boolean insertPrenda()
    {
        return true;
    }

    public boolean updatePrenda()
    {
        return true;
    }

    public boolean deletePrenda()
    {
        return true;
    }

    public Prenda selectPrendaById()
    {
        Prenda entidad = new Prenda();

        return entidad;
    }

    public int getPrendasBajoStock()
    {
        int cantidad = 0;
        String sql = "SELECT cantidad_prendas_bajo_stock() AS prendas_bajo_stock";

        try
        {
            DBConexion db = new DBConexion();
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

            db.cerrar();
        } catch (SQLException | ClassNotFoundException e)
        {
            e.printStackTrace();
        }

        return cantidad;
    }

    public int getPrendasVendidas(Timestamp fechaInicio, Timestamp fechaFin)
    {
        int cantidad = 0;
        System.out.println(fechaInicio);
        String sql = "SELECT cantidad_prendas_vendidas_por_rango(?, ?) AS prendas_vendidas";

        try
        {
            DBConexion db = new DBConexion();
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

            db.cerrar();
        } catch (SQLException | ClassNotFoundException e)
        {
            e.printStackTrace();
        }

        return cantidad;
    }

    public List<Prenda> selectPrendasBySearchTerm(String searchTerm)
    {
        List<Prenda> prendas = new ArrayList<>();
        String sql = "{CALL select_prendas_by_search_term(?)}";

        try
        {
            DBConexion db = new DBConexion();
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
                        Categoria categoria = new Categoria(rs.getInt("categoria_id"), rs.getString("categoria_nombre"));

                        Subcategoria subcategoria = new Subcategoria(
                                rs.getInt("subcategoria_id"),
                                rs.getString("subcategoria_nombre"),
                                (int) rs.getDouble("subcategoria_precio"),
                                rs.getInt("stock_minimo"),
                                rs.getInt("stock"),
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

            db.cerrar();
        } catch (SQLException | ClassNotFoundException e)
        {
            e.printStackTrace();
        }

        return prendas;
    }
}
