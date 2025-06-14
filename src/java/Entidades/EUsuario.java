package Entidades;

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

    public boolean insertUsuario()
    {
        return true;
    }

    public boolean updateUsuario()
    {
        return true;
    }

    public boolean deleteUsuario()
    {
        return true;
    }

    public Usuario selectUsuarioById()
    {
        Usuario entidad = new Usuario();

        return entidad;
    }
}
