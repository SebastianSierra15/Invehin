package Entidades;

import Logica.Permiso;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class EPermiso
{

    public EPermiso()
    {
    }

    public boolean insertPermiso()
    {
        return true;
    }

    public boolean updatePermiso()
    {
        return true;
    }

    public boolean deletePermiso()
    {
        return true;
    }

    public Permiso selectPermisoById()
    {
        Permiso entidad = new Permiso();

        return entidad;
    }

    public List<Permiso> selectPermisos()
    {
        List<Permiso> permisos = new ArrayList<>();
        String sql = "{CALL select_permisos()}";
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
                            Permiso permiso = new Permiso(
                                    rs.getInt("id"),
                                    rs.getString("nombre")
                            );

                            permisos.add(permiso);
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

        return permisos;
    }
}
