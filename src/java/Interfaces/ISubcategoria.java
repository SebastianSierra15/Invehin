package Interfaces;

import Logica.Categoria;
import Logica.Subcategoria;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface ISubcategoria
{

    boolean crearSubcategoria(String nombreSubcategoria, int precioSubcategoria, int stockMinimoSubcategoria, int stockSubcategoria, String imagenSubcategoria, boolean estadoSubcategoria, Categoria categoriaSubcategoria);

    boolean actualizarSubcategoria(int idSubcategoria, String nombreSubcategoria, int precioSubcategoria, int stockMinimoSubcategoria, int stockSubcategoria, String imagenSubcategoria, boolean estadoSubcategoria, Categoria categoriaSubcategoria);

    boolean eliminarSubcategoria(int idSubcategoria);

    Subcategoria obtenerSubcategoria(int idSubcategoria);
}
