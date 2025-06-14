package Logica;

import Entidades.ECategoria;
import Interfaces.ICategoria;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Categoria implements ICategoria
{

    public int idCategoria;
    public String nombreCategoria;
    public List<Subcategoria> subcategoriasCategoria;

    public Categoria()
    {
    }

    public Categoria(int idCategoria, String nombreCategoria, List<Subcategoria> subcategoriasCategoria)
    {
        this.idCategoria = idCategoria;
        this.nombreCategoria = nombreCategoria;
        this.subcategoriasCategoria = subcategoriasCategoria;
    }

    @Override
    public boolean crearCategoria(String nombreCategoria)
    {
        return true;
    }

    @Override
    public boolean actualizarCategoria(int idCategoria, String nombreCategoria)
    {
        return true;
    }

    @Override
    public boolean eliminarCategoria(int idCategoria)
    {
        return true;
    }

    @Override
    public Categoria obtenerCategoria(int Categoria)
    {
        Categoria entidad = new Categoria();

        return entidad;
    }

    @Override
    public List<Categoria> obtenerCategorias()
    {
        ECategoria result = new ECategoria();
        
        return result.selectCategorias();
    }
}
