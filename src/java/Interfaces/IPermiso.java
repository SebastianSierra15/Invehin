package Interfaces;

import Logica.Permiso;

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
}
