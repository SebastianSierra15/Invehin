package Entidades;

import Logica.MetodoPago;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class EMetodoPago
{

    public EMetodoPago()
    {
    }

    public boolean insertMetodoPago()
    {
        return true;
    }

    public boolean updateMetodoPago()
    {
        return true;
    }

    public boolean deleteMetodoPago()
    {
        return true;
    }

    public MetodoPago selectMetodoPagoById()
    {
        MetodoPago entidad = new MetodoPago();

        return entidad;
    }

    public List<MetodoPago> selectMetodosPago()
    {
        List<MetodoPago> metodos = new ArrayList<>();
        String sql = "{CALL select_metodospago()}";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                boolean hasResults = cs.execute();

                if (hasResults)
                {
                    try (ResultSet rs = cs.getResultSet())
                    {
                        while (rs.next())
                        {
                            MetodoPago metodo = new MetodoPago(
                                    rs.getInt("id"),
                                    rs.getString("nombre"),
                                    rs.getBoolean("estado")
                            );
                            metodos.add(metodo);
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

        return metodos;
    }
}
