package Interfaces;

import Logica.Permiso;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IPermiso
{

    boolean crearPermiso(String nombrePermiso);

    boolean actualizarPermiso(int idPermiso, String nombrePermiso);

    boolean eliminarPermiso(int idPermiso);

    Permiso obtenerPermiso(int idPermiso);
    
    List<Permiso> obtenerPermisos();
}
