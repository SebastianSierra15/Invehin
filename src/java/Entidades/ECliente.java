package Entidades;

import Logica.Cliente;
import Logica.PaginacionResultado;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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

    public boolean insertCliente(String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona, String direccionCliente)
    {
        String sql = "{CALL insert_cliente(?, ?, ?, ?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, nombresPersona);
                cs.setString(2, apellidosPersona);
                cs.setString(3, numeroidentificacionPersona);
                cs.setString(4, telefonoPersona);
                cs.setBoolean(5, generoPersona);
                cs.setString(6, direccionCliente);

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

    public boolean updateCliente(int idCliente, String direccionCliente, int idPersona, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona)
    {
        String sql = "{CALL update_cliente(?, ?, ?, ?, ?, ?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idCliente);
                cs.setString(2, direccionCliente);
                cs.setInt(3, idPersona);
                cs.setString(4, nombresPersona);
                cs.setString(5, apellidosPersona);
                cs.setString(6, numeroidentificacionPersona);
                cs.setString(7, telefonoPersona);
                cs.setBoolean(8, generoPersona);

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

    public boolean deleteCliente(int idCliente)
    {
        String sql = "{CALL desactivar_cliente(?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idCliente);

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

    public PaginacionResultado<Cliente> selectClientesPorTerminoBusqueda(String searchTerm, int numPage, int pageSize)
    {
        List<Cliente> clientes = new ArrayList<>();
        int total = 0;
        String sql = "{CALL select_clientes(?, ?, ?)}";
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
                            Cliente cliente = new Cliente(
                                    rs.getInt("id"),
                                    rs.getTimestamp("fecha_registro"),
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

        return new PaginacionResultado<>(clientes, total);
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
                                rs.getTimestamp("fecha_registro"),
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
