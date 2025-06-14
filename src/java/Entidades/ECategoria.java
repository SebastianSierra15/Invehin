package Entidades;

import Logica.Categoria;
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

    public boolean insertCategoria()
    {
        return true;
    }

    public boolean updateCategoria()
    {
        return true;
    }

    public boolean deleteCategoria()
    {
        return true;
    }

    public Categoria selectCategoriaById()
    {
        Categoria entidad = new Categoria();

        return entidad;
    }

    public List<Categoria> selectCategorias()
    {
        List<Categoria> categorias = new ArrayList<>();
        String sql = "{CALL select_categorias()}";
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
                        // Agrupar detalles por venta_id
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

                        // Asignar los detalles a cada venta
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
}
