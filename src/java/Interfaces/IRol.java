package Interfaces;

import Logica.Permiso;
import Logica.Rol;
import java.util.List;

/**
 *
 * @author Sebastian Sierra
 */
public interface IRol
{

    boolean crearRol(String nombreRol, boolean estadoRol, List<Permiso> permisosRol);

    boolean actualizarRol(int idRol, String nombreRol, boolean estadoRol, List<Permiso> permisosRol);

    boolean agregarPermiso(int idRol, Permiso permiso);

    boolean quitarPermiso(int IdRol, Permiso permiso);

    boolean eliminarRol(int idRol);

    Rol obtenerRol(int idRol);

    List<Rol> obtenerRolesEstaticos();
}
