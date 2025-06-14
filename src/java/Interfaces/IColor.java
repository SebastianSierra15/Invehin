package Interfaces;

import Logica.Color;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IColor
{

    boolean crearColor(String nombreColor);

    boolean actualizarColor(int idColor, String nombreColor);

    boolean eliminarColor(int idColor);

    Color obtenerColor(int idColor);

    List<Color> obtenerColores();
}
