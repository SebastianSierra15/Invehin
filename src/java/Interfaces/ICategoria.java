package Interfaces;

import Logica.Categoria;
import Logica.PaginacionResultado;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface ICategoria
{

    boolean crearCategoria(String nombreCategoria, int idUsuarioAuditor);

    boolean actualizarCategoria(int idCategoria, String nombreCategoria, int idUsuarioAuditor);

    boolean cambiarEstadoCategoria(int idCategoria, boolean estadoCategoria, int idUsuarioAuditor);

    PaginacionResultado<Categoria> obtenerCategorias(String searchTerm, int numPage, int pageSize);

    List<Categoria> obtenerCategorias();
    
    Map<String, Integer> valorCategorias();
}
