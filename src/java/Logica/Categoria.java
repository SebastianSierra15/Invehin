package Logica;

import Entidades.ECategoria;
import Interfaces.ICategoria;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Categoria implements ICategoria
{

    public int idCategoria;
    public String nombreCategoria;
    public boolean estadoCategoria;
    public List<Subcategoria> subcategoriasCategoria;

    public Categoria()
    {
    }

    public Categoria(int idCategoria, String nombreCategoria, boolean estadoCategoria, List<Subcategoria> subcategoriasCategoria)
    {
        this.idCategoria = idCategoria;
        this.nombreCategoria = nombreCategoria;
        this.estadoCategoria = estadoCategoria;
        this.subcategoriasCategoria = subcategoriasCategoria;
    }

    @Override
    public boolean crearCategoria(String nombreCategoria,  int idUsuarioAuditor)
    {
        ECategoria result = new ECategoria();

        return result.insertCategoria(nombreCategoria, idUsuarioAuditor);
    }

    @Override
    public boolean actualizarCategoria(int idCategoria, String nombreCategoria,  int idUsuarioAuditor)
    {
        ECategoria result = new ECategoria();

        return result.updateCategoria(idCategoria, nombreCategoria, idUsuarioAuditor);
    }

    @Override
    public boolean cambiarEstadoCategoria(int idCategoria, boolean estadoCategoria,  int idUsuarioAuditor)
    {
        ECategoria result = new ECategoria();

        return result.cambiarEstadoCategoria(idCategoria, estadoCategoria, idUsuarioAuditor);
    }

    @Override
    public PaginacionResultado<Categoria> obtenerCategorias(String searchTerm, int numPage, int pageSize)
    {
        ECategoria result = new ECategoria();

        return result.selectCategoriasPorTerminoBusqueda(searchTerm, numPage, pageSize);
    }

    @Override
    public List<Categoria> obtenerCategorias()
    {
        ECategoria result = new ECategoria();

        return result.selectCategorias();
    }

    @Override
    public Map<String, Integer> valorCategorias()
    {
        ECategoria result = new ECategoria();
        
        return result.getValorCategorias();
    }
}
