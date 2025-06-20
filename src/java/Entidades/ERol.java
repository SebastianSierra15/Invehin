package Entidades;

import Logica.PaginacionResultado;
import Logica.Permiso;
import Logica.Rol;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class ERol
{

    public ERol()
    {
    }

    public boolean insertRol(String nombreRol, String permisosRolJson)
    {
        String sql = "{CALL insert_rol(?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, nombreRol);
                cs.setString(2, permisosRolJson);

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

    public boolean updateRol(int idRol, String nombreRol, String permisosRolJson)
    {
        String sql = "{CALL update_rol(?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idRol);
                cs.setString(2, nombreRol);
                cs.setString(3, permisosRolJson);

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

    public boolean deleteRol(int idRol)
    {
        String sql = "{CALL delete_rol(?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idRol);

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

    public Rol selectRolById()
    {
        Rol entidad = new Rol();

        return entidad;
    }

    public PaginacionResultado<Rol> selectRolesPorTerminoBusqueda(String searchTerm, int numPage, int pageSize)
    {
        List<Rol> roles = new ArrayList<>();
        int total = 0;
        String sql = "{CALL select_roles(?, ?, ?)}";
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
                        // Agrupar permisos por rol_id
                        Map<Integer, List<Permiso>> permisosMap = new HashMap<>();

                        while (rs3.next())
                        {
                            int rolId = rs3.getInt("rol_id");

                            Permiso permiso = new Permiso(
                                    rs3.getInt("permiso_id"),
                                    rs3.getString("permiso_nombre")
                            );

                            permisosMap.computeIfAbsent(rolId, k -> new ArrayList<>()).add(permiso);
                        }

                        // Asignar los permisos a cada rol
                        for (Rol rol : roles)
                        {
                            List<Permiso> permisos = permisosMap.getOrDefault(rol.idRol, new ArrayList<>());
                            rol.permisosRol = permisos;
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

        return new PaginacionResultado<>(roles, total);
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
