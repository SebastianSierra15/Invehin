package Entidades;

import Logica.Color;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class EColor {

    public EColor() {
    }

    public boolean insertColor() {
        return true;
    }

    public boolean updateColor() {
        return true;
    }

    public boolean deleteColor() {
        return true;
    }

    public Color selectColorById() {
        Color entidad = new Color();

        return entidad;
    }

     public List<Color> selectColores()
    {
        List<Color> colores = new ArrayList<>();
        String sql = "{CALL select_colores()}";
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
                            Color color = new Color(
                                    rs.getInt("id"),
                                    rs.getString("nombre")
                            );
                            
                            colores.add(color);
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

        return colores;
    }
}
