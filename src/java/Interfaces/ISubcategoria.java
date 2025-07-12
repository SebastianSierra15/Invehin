package Interfaces;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface ISubcategoria
{

    boolean crearSubcategoria(String nombreSubcategoria, int precioSubcategoria, int idCategoria, int idUsuarioAuditor);

    boolean actualizarSubcategoria(int idSubcategoria, String nombreSubcategoria, int precioSubcategoria, int idCategoria, int idUsuarioAuditor);

    boolean cambiarEstadoSubcategoria(int idSubcategoria, boolean estadoSubcategoria, int idUsuarioAuditor);
}
