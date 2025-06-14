package Entidades;

import Logica.EstadoPrenda;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class EEstadoPrenda
{

    public EEstadoPrenda()
    {
    }

    public boolean insertEstadoPrenda()
    {
        return true;
    }

    public boolean updateEstadoPrenda()
    {
        return true;
    }

    public boolean deleteEstadoPrenda()
    {
        return true;
    }

    public EstadoPrenda selectEstadoPrendaById()
    {
        EstadoPrenda entidad = new EstadoPrenda();

        return entidad;
    }

    public List<EstadoPrenda> selectEstados()
    {
        List<EstadoPrenda> estados = new ArrayList<>();
        String sql = "{CALL select_estadosprenda()}";
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
                            EstadoPrenda estado = new EstadoPrenda(
                                    rs.getInt("id"),
                                    rs.getString("nombre")
                            );

                            estados.add(estado);
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

        return estados;
    }
}
