package Interfaces;

import Logica.Categoria;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface ICategoria
{

    boolean crearCategoria(String nombreCategoria);

    boolean actualizarCategoria(int idCategoria, String nombreCategoria);

    boolean eliminarCategoria(int idCategoria);

    Categoria obtenerCategoria(int Categoria);
    
    List<Categoria> obtenerCategorias();
}
