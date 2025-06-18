package Entidades;

import Logica.Rol;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class ERol
{

    public ERol()
    {
    }

    public boolean insertRol()
    {
        return true;
    }

    public boolean updateRol()
    {
        return true;
    }

    public boolean deleteRol()
    {
        return true;
    }

    public Rol selectRolById()
    {
        Rol entidad = new Rol();

        return entidad;
    }

    public List<Rol> selectRolesEstaticos()
    {
        List<Rol> roles = new ArrayList<>();
        String sql = "{CALL select_roles_estaticos()}";
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
                            Rol rol = new Rol(
                                    rs.getInt("id"),
                                    rs.getString("nombre"),
                                    rs.getBoolean("estado"),
                                    new ArrayList<>()
                            );

                            roles.add(rol);
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

        return roles;
    }
}
