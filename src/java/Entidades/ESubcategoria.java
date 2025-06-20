package Entidades;

import java.sql.CallableStatement;
import java.sql.SQLException;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class ESubcategoria
{

    public ESubcategoria()
    {
    }

    public boolean insertSubcategoria(String nombreSubcategoria, int precioSubcategoria, int idCategoria)
    {
        String sql = "{CALL insert_subcategoria(?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, nombreSubcategoria);
                cs.setInt(2, precioSubcategoria);
                cs.setInt(3, idCategoria);

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

    public boolean updateSubcategoria(int idSubcategoria, String nombreSubcategoria, int precioSubcategoria, int idCategoria)
    {
        String sql = "{CALL update_subcategoria(?, ?, ?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idSubcategoria);
                cs.setString(2, nombreSubcategoria);
                cs.setInt(3, precioSubcategoria);
                cs.setInt(4, idCategoria);

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

    public boolean cambiarEstadoSubcategoria(int idSubcategoria, boolean estadoSubcategoria)
    {
        String sql = "{CALL cambiar_estado_subcategoria(?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idSubcategoria);
                cs.setBoolean(2, estadoSubcategoria);

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
}
