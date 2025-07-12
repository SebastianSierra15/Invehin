package Entidades;

import Logica.PaginacionResultado;
import Logica.Permiso;
import Logica.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class EUsuario
{

    public EUsuario()
    {
    }

    public Usuario loginUsuario(String correo, String contrasenia)
    {
        Usuario usuario = null;
        String sql = "{ CALL login(?, ?) }";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, correo);
                cs.setString(2, contrasenia);

                boolean resultado = cs.execute();

                int id = 0;
                String email = null;
                String pass = null;
                boolean estado = false;
                int personaId = 0;
                String numeroIdentificacion = null;
                String nombres = null;
                String apellidos = null;
                String telefono = null;
                boolean genero = true;
                int rolId = 0;
                String rolNombre = null;
                boolean rolEstado = false;

                List<Permiso> permisos = new ArrayList<>();

                if (resultado)
                {
                    try (ResultSet rs = cs.getResultSet())
                    {
                        if (rs.next())
                        {
                            id = rs.getInt("id");
                            email = rs.getString("correo");
                            pass = rs.getString("contrasenia");
                            estado = rs.getBoolean("estado");
                            personaId = rs.getInt("persona_id");
                            numeroIdentificacion = rs.getString("numero_identificacion");
                            nombres = rs.getString("nombres");
                            apellidos = rs.getString("apellidos");
                            telefono = rs.getString("telefono");
                            genero = rs.getBoolean("genero");
                            rolId = rs.getInt("rol_id");
                            rolNombre = rs.getString("rol_nombre");
                            rolEstado = rs.getBoolean("rol_estado");
                        }
                    }
                }

                if (cs.getMoreResults())
                {
                    try (ResultSet rsPermisos = cs.getResultSet())
                    {
                        while (rsPermisos.next())
                        {
                            permisos.add(new Permiso(rsPermisos.getInt("id"), rsPermisos.getString("nombre")));
                        }
                    }
                }

                if (email != null)
                {
                    usuario = new Usuario(id, email, pass, estado, personaId,
                            numeroIdentificacion, nombres, apellidos, telefono,
                            genero, rolId, rolNombre, rolEstado, permisos);
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

        return usuario;
    }

    public boolean insertUsuario(String correoUsuario, int idRol, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona, int idUsuarioAuditor)
    {
        String sqlSetAuditor = "SET @id_usuario_auditoria = ?";
        String sql = "{CALL insert_usuario(?, ?, ?, ?, ?, ?, ?)}";
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
                cs.setString(1, correoUsuario);
                cs.setInt(2, idRol);
                cs.setString(3, nombresPersona);
                cs.setString(4, apellidosPersona);
                cs.setString(5, numeroidentificacionPersona);
                cs.setString(6, telefonoPersona);
                cs.setBoolean(7, generoPersona);

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

    public boolean updateUsuario(int idUsuario, int idRol, boolean estadoUsuario, int idPersona, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona, int idUsuarioAuditor)
    {
        String sqlSetAuditor = "SET @id_usuario_auditoria = ?";
        String sql = "{CALL update_usuario(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
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
                cs.setInt(1, idUsuario);
                cs.setInt(2, idRol);
                cs.setBoolean(3, estadoUsuario);
                cs.setInt(4, idPersona);
                cs.setString(5, nombresPersona);
                cs.setString(6, apellidosPersona);
                cs.setString(7, numeroidentificacionPersona);
                cs.setString(8, telefonoPersona);
                cs.setBoolean(9, generoPersona);

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

    public boolean updatePerfil(int idPersona, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona, int idUsuarioAuditor)
    {
        String sqlSetAuditor = "SET @id_usuario_auditoria = ?";
        String sql = "{CALL update_persona(?, ?, ?, ?, ?, ?)}";
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
                cs.setInt(1, idPersona);
                cs.setString(2, nombresPersona);
                cs.setString(3, apellidosPersona);
                cs.setString(4, numeroidentificacionPersona);
                cs.setString(5, telefonoPersona);
                cs.setBoolean(6, generoPersona);

                cs.execute();
                exito = true;
            }
        } catch (SQLException | ClassNotFoundException e)
        {
            e.printStackTrace();
            exito = false;
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

    public boolean cambiarContrasenia(int idUsuario, String contraseniaActual, String contraseniaNueva, int idUsuarioAuditor)
    {
        String sqlSetAuditor = "SET @id_usuario_auditoria = ?";
        String sql = "{CALL cambiar_contrasenia(?, ?, ?)}";
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
                cs.setInt(1, idUsuario);
                cs.setString(2, contraseniaActual);
                cs.setString(3, contraseniaNueva);

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

    public Usuario selectUsuarioById(int idUsuario)
    {
        Usuario usuario = null;
        String sql = "{CALL select_usuario_by_id(?)}";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idUsuario);

                try (ResultSet rs = cs.executeQuery())
                {
                    while (rs.next())
                    {
                        usuario = new Usuario(
                                rs.getInt("id"),
                                rs.getString("correo"),
                                rs.getString("contrasenia"),
                                rs.getBoolean("estado"),
                                rs.getInt("persona_id"),
                                rs.getString("numero_identificacion"),
                                rs.getString("nombres"),
                                rs.getString("apellidos"),
                                rs.getString("telefono"),
                                rs.getBoolean("genero"),
                                rs.getInt("rol_id"),
                                rs.getString("rol_nombre"),
                                rs.getBoolean("rol_estado"),
                                new ArrayList<>()
                        );
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

        return usuario;
    }

    public PaginacionResultado<Usuario> selectUsuariosPorTerminoBusqueda(String searchTerm, int numPage, int pageSize)
    {
        List<Usuario> usuarios = new ArrayList<>();
        int total = 0;
        String sql = "{CALL select_usuarios(?, ?, ?)}";
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
                            Usuario usuario = new Usuario(
                                    rs.getInt("id"),
                                    rs.getString("correo"),
                                    "",
                                    rs.getBoolean("estado"),
                                    rs.getInt("persona_id"),
                                    rs.getString("numero_identificacion"),
                                    rs.getString("nombres"),
                                    rs.getString("apellidos"),
                                    rs.getString("telefono"),
                                    rs.getBoolean("genero"),
                                    rs.getInt("rol_id"),
                                    rs.getString("rol_nombre"),
                                    rs.getBoolean("rol_estado"),
                                    new ArrayList<>()
                            );

                            usuarios.add(usuario);
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

        return new PaginacionResultado<>(usuarios, total);
    }
}
