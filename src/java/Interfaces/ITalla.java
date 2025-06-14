package Interfaces;

import Logica.Talla;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface ITalla
{

    boolean crearTalla(String nombreTalla);

    boolean actualizarTalla(int idTalla, String nombreTalla);

    boolean eliminarTalla(int idTalla);

    Talla obtenerTalla(int idTalla);
    
    List<Talla> obtenerTallas();
}
