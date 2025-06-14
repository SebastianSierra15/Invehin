package Interfaces;

import Logica.MetodoPago;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IMetodoPago
{

    boolean crearMetodoPago(String nombreMetodoPago, boolean estadoMetodoPago);

    boolean actualizarMetodoPago(int idMetodoPago, String nombreMetodoPago, boolean estadoMetodoPago);

    boolean eliminarMetodoPago(int idMetodoPago);

    MetodoPago obtenerMetodoPago(int idMetodoPago);
    
    List<MetodoPago> obtenerMetodosPago();
}
