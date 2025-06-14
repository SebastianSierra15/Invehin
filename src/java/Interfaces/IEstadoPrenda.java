package Interfaces;

import Logica.EstadoPrenda;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IEstadoPrenda
{

    boolean crearEstadoPrenda(String nombreEstadoPrenda);

    boolean actualizarEstadoPrenda(int idEstadoPrenda, String nombreEstadoPrenda);

    boolean eliminarEstadoPrenda(int idEstadoPrenda);

    EstadoPrenda obtenerEstadoPrenda(int idEstadoPrenda);
    
    List<EstadoPrenda> obtenerEstadosPrenda();
}
