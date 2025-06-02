package Entidades;

import Logica.Venta;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;

import java.util.Date;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class EVenta
{

    public EVenta()
    {
    }

    public boolean insertVenta()
    {
        return true;
    }

    public boolean updateVenta()
    {
        return true;
    }

    public boolean deleteVenta()
    {
        return true;
    }

    public Venta selectVentaById()
    {
        Venta entidad = new Venta();

        return entidad;
    }

    public int getTotalVentas(Timestamp fechaInicio, Timestamp fechaFin)
    {
        int total = 0;
        System.out.println("FECHA INICIO" + fechaInicio);

        String sql = "SELECT calcular_total_ventas_por_rango(?, ?) AS total_ventas";

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
                        total = rs.getInt("total_ventas");
                    }
                }
            }

            db.cerrar();
        } catch (SQLException | ClassNotFoundException e)
        {
            e.printStackTrace();
        }

        return total;
    }
}
