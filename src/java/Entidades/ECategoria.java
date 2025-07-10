package Entidades;

import Logica.Categoria;
import Logica.PaginacionResultado;
import Logica.Subcategoria;
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
public class ECategoria
{

    public ECategoria()
    {
    }

    public boolean insertCategoria(String nombreCategoria)
    {
        String sql = "{CALL insert_categoria(?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setString(1, nombreCategoria);

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

    public boolean updateCategoria(int idCategoria, String nombreCategoria)
    {
        String sql = "{CALL update_categoria(?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idCategoria);
                cs.setString(2, nombreCategoria);

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

    public boolean cambiarEstadoCategoria(int idCategoria, boolean estadoCategoria)
    {
        String sql = "{CALL cambiar_estado_categoria(?, ?)}";
        DBConexion db = null;
        boolean exito = false;

        try
        {
            db = new DBConexion();
            db.conectar();

            try (CallableStatement cs = db.obtener().prepareCall(sql))
            {
                cs.setInt(1, idCategoria);
                cs.setBoolean(2, estadoCategoria);

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

    public PaginacionResultado<Categoria> selectCategoriasPorTerminoBusqueda(String searchTerm, int numPage, int pageSize)
    {
        List<Categoria> categorias = new ArrayList<>();
        int total = 0;
        String sql = "{CALL select_categorias(?, ?, ?)}";
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
                            Categoria categoria = new Categoria(
                                    rs.getInt("id"),
                                    rs.getString("nombre"),
                                    rs.getBoolean("estado"),
                                    new ArrayList<>()
                            );

                            categorias.add(categoria);
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
                        // Agrupar subcategorias por categoria_id
                        Map<Integer, List<Subcategoria>> subcategoriasMap = new HashMap<>();

                        while (rs3.next())
                        {
                            int categoriaId = rs3.getInt("categoria_id");

                            Subcategoria subcategoria = new Subcategoria(
                                    rs3.getInt("id"),
                                    rs3.getString("nombre"),
                                    rs3.getInt("precio"),
                                    rs3.getString("imagen"),
                                    rs3.getBoolean("estado"),
                                    new Categoria()
                            );

                            subcategoriasMap.computeIfAbsent(categoriaId, k -> new ArrayList<>()).add(subcategoria);
                        }

                        // Asignar las subcategorias a cada categoria
                        for (Categoria categoria : categorias)
                        {
                            List<Subcategoria> subcategorias = subcategoriasMap.getOrDefault(categoria.idCategoria, new ArrayList<>());
                            categoria.subcategoriasCategoria = subcategorias;
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

        return new PaginacionResultado<>(categorias, total);
    }

    public List<Categoria> selectCategorias()
    {
        List<Categoria> categorias = new ArrayList<>();
        String sql = "{CALL select_categorias_estaticas()}";
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
                            Categoria categoria = new Categoria(
                                    rs.getInt("id"),
                                    rs.getString("nombre"),
                                    rs.getBoolean("estado"),
                                    new ArrayList<>()
                            );

                            categorias.add(categoria);
                        }
                    }
                }

                if (cs.getMoreResults())
                {
                    try (ResultSet rs2 = cs.getResultSet())
                    {
                        // Agrupar subcategorias por categoria_id
                        Map<Integer, List<Subcategoria>> subcategoriasMap = new HashMap<>();

                        while (rs2.next())
                        {
                            int categoriaId = rs2.getInt("categoria_id");

                            Subcategoria subcategoria = new Subcategoria(
                                    rs2.getInt("subcategoria_id"),
                                    rs2.getString("subcategoria_nombre"),
                                    rs2.getInt("subcategoria_precio"),
                                    rs2.getString("subcategoria_imagen"),
                                    rs2.getBoolean("subcategoria_estado"),
                                    new Categoria()
                            );

                            subcategoriasMap.computeIfAbsent(categoriaId, k -> new ArrayList<>()).add(subcategoria);
                        }

                        // Asignar las subcategorias a cada categoria
                        for (Categoria categoria : categorias)
                        {
                            List<Subcategoria> subcategorias = subcategoriasMap.getOrDefault(categoria.idCategoria, new ArrayList<>());
                            categoria.subcategoriasCategoria = subcategorias;
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

        return categorias;
    }

    public Map<String, Integer> getValorCategorias()
    {
        Map<String, Integer> categorias = new HashMap<>();
        String sql = "{CALL get_valor_prendas_por_categoria()}";
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
                            categorias.put(rs.getString("nombre"), rs.getInt("total"));
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

        return categorias;
    }
}
