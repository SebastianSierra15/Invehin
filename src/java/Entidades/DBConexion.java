package Entidades;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class DBConexion
{

    private String driver = "com.mysql.cj.jdbc.Driver";
    private String database = "db_invehin";
    private String hostname = "localhost";
    private String port = "3307";
    private String url = "jdbc:mysql://" + hostname + ":" + port + "/" + database + "?useSSL=false";
    private String username = "root";
    private String password = "root";
    private static Connection conn = null;

    public Connection obtener()
    {
        return conn;
    }

    public Connection conectar() throws SQLException, ClassNotFoundException
    {
        if (conn == null)
        {
            try
            {
                Class.forName(driver);
                conn = DriverManager.getConnection(url, username, password);
            } catch (Exception e)
            {
                e.printStackTrace();
            }
        }
        return conn;
    }

    public void cerrar() throws SQLException
    {
        if (conn != null)
        {
            conn.close();
        }
        conn = null;
    }
}
