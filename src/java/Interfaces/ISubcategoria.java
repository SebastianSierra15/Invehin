package Interfaces;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface ISubcategoria
{

    boolean crearSubcategoria(String nombreSubcategoria, int precioSubcategoria, int idCategoria);

    boolean actualizarSubcategoria(int idSubcategoria, String nombreSubcategoria, int precioSubcategoria, int idCategoria);

    boolean cambiarEstadoSubcategoria(int idSubcategoria, boolean estadoSubcategoria);
}
