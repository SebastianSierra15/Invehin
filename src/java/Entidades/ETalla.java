package Entidades;

import Logica.Talla;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class ETalla {

    public ETalla() {
    }

    public boolean insertTalla() {
        return true;
    }

    public boolean updateTalla() {
        return true;
    }

    public boolean deleteTalla() {
        return true;
    }

    public Talla selectTallaById() {
        Talla entidad = new Talla();

        return entidad;
    }
    
    public List<Talla> selectTallas()
    {
        List<Talla> tallas = new ArrayList<>();
        String sql = "{CALL select_tallas()}";
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
                            Talla talla = new Talla(
                                    rs.getInt("id"),
                                    rs.getString("nombre")
                            );
                            
                            tallas.add(talla);
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

        return tallas;
    }
}
