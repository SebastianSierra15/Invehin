package Interfaces;

import Logica.PaginacionResultado;
import Logica.Rol;
import java.util.List;

/**
 *
 * @author Sebastian Sierra
 */
public interface IRol
{

    boolean crearRol(String nombreRol, String permisosRolJson, int idUsuarioAuditor);

    boolean actualizarRol(int idRol, String nombreRol, String permisosRolJson, int idUsuarioAuditor);

    boolean eliminarRol(int idRol, int idUsuarioAuditor);

    PaginacionResultado<Rol> obtenerRoles(String searchTerm, int numPage, int pageSize);

    List<Rol> obtenerRoles();
}
