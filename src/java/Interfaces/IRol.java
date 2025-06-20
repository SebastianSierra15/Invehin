package Interfaces;

import Logica.PaginacionResultado;
import Logica.Permiso;
import Logica.Rol;
import java.util.List;

/**
 *
 * @author Sebastian Sierra
 */
public interface IRol
{

    boolean crearRol(String nombreRol, String permisosRolJson);

    boolean actualizarRol(int idRol, String nombreRol, String permisosRolJson);

    boolean eliminarRol(int idRol);

    PaginacionResultado<Rol> obtenerRoles(String searchTerm, int numPage, int pageSize);

    List<Rol> obtenerRoles();
}
