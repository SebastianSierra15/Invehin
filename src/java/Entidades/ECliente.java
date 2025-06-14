package Entidades;

import Logica.Cliente;
import Logica.Persona;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class ECliente
{

    public ECliente()
    {
    }

    public boolean insertCliente()
    {
        return true;
    }

    public boolean updateCliente()
    {
        return true;
    }

    public boolean deleteCliente()
    {
        return true;
    }

    public Cliente selectClienteById()
    {
        Cliente entidad = new Cliente();

        return entidad;
    }

    public List<Cliente> selectClientesBySearchTerm(String searchTerm)
    {
        List<Cliente> clientes = new ArrayList<>();
        String sql = "{CALL select_clientes_by_search_term(?)}";
        DBConexion db = null;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, searchTerm);

                try (ResultSet rs = cs.executeQuery())
                {
                    while (rs.next())
                    {
                        Cliente cliente = new Cliente(
                                rs.getInt("id"),
                                rs.getString("direccion"),
                                rs.getBoolean("estado"),
                                rs.getInt("persona_id"),
                                rs.getString("numero_identificacion"),
                                rs.getString("nombres"),
                                rs.getString("apellidos"),
                                rs.getString("telefono"),
                                rs.getBoolean("genero")
                        );

                        clientes.add(cliente);
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

        return clientes;
    }
}
