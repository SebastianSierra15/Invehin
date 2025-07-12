package Entidades;

import Logica.Proveedor;
import Logica.PaginacionResultado;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class EProveedor
{

    public EProveedor()
    {
    }

    public boolean insertProveedor(String nombreProveedor, String correoProveedor, String direccionProveedor, String nombresPersona, String apellidosPersona, String telefonoPersona, int idUsuarioAuditor)
    {
        String sqlSetAuditor = "SET @id_usuario_auditoria = ?";
        String sql = "{CALL insert_proveedor(?, ?, ?, ?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            // 1. Establecer el ID de usuario auditor en la sesión de MySQL
            try (PreparedStatement ps = db.obtener().prepareStatement(sqlSetAuditor))
            {
                ps.setInt(1, idUsuarioAuditor);
                ps.execute();
            }

            // 2. Ejecutar el procedimiento almacenado
            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, nombreProveedor);
                cs.setString(2, correoProveedor);
                cs.setString(3, direccionProveedor);
                cs.setString(4, nombresPersona);
                cs.setString(5, apellidosPersona);
                cs.setString(6, telefonoPersona);

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

    public boolean updateProveedor(int idProveedor, String nombreProveedor, String correoProveedor, String direccionProveedor, int idPersona, String nombresPersona, String apellidosPersona, String telefonoPersona, int idUsuarioAuditor)
    {
        String sqlSetAuditor = "SET @id_usuario_auditoria = ?";
        String sql = "{CALL update_proveedor(?, ?, ?, ?, ?, ?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            // 1. Establecer el ID de usuario auditor en la sesión de MySQL
            try (PreparedStatement ps = db.obtener().prepareStatement(sqlSetAuditor))
            {
                ps.setInt(1, idUsuarioAuditor);
                ps.execute();
            }

            // 2. Ejecutar el procedimiento almacenado
            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idProveedor);
                cs.setString(2, nombreProveedor);
                cs.setString(3, correoProveedor);
                cs.setString(4, direccionProveedor);
                cs.setInt(5, idPersona);
                cs.setString(6, nombresPersona);
                cs.setString(7, apellidosPersona);
                cs.setString(8, telefonoPersona);

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

    public boolean deleteProveedor(int idProveedor, int idUsuarioAuditor)
    {
        String sqlSetAuditor = "SET @id_usuario_auditoria = ?";
        String sql = "{CALL desactivar_proveedor(?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            // 1. Establecer el ID de usuario auditor en la sesión de MySQL
            try (PreparedStatement ps = db.obtener().prepareStatement(sqlSetAuditor))
            {
                ps.setInt(1, idUsuarioAuditor);
                ps.execute();
            }

            // 2. Ejecutar el procedimiento almacenado
            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idProveedor);

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

    public Proveedor selectProveedorById()
    {
        Proveedor entidad = new Proveedor();

        return entidad;
    }

    public PaginacionResultado<Proveedor> selectProveedoresPorTerminoBusqueda(String searchTerm, int numPage, int pageSize)
    {
        List<Proveedor> proveedores = new ArrayList<>();
        int total = 0;
        String sql = "{CALL select_proveedores(?, ?, ?)}";
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
                            Proveedor proveedor = new Proveedor(
                                    rs.getInt("id"),
                                    rs.getString("nombre"),
                                    rs.getString("direccion"),
                                    rs.getString("correo"),
                                    rs.getBoolean("estado"),
                                    rs.getInt("persona_id"),
                                    "",
                                    rs.getString("persona_nombres"),
                                    rs.getString("persona_apellidos"),
                                    rs.getString("persona_telefono"),
                                    false
                            );

                            proveedores.add(proveedor);
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

        return new PaginacionResultado<>(proveedores, total);
    }

    public List<Proveedor> selectProveedoresEstaticos()
    {
        List<Proveedor> proveedores = new ArrayList<>();
        String sql = "{CALL select_proveedores_estaticos()}";
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
                            Proveedor proveedor = new Proveedor(
                                    rs.getInt("id"),
                                    rs.getString("nombre"),
                                    "",
                                    "",
                                    true
                            );

                            proveedores.add(proveedor);
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

        return proveedores;
    }
}
