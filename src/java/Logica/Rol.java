package Logica;

import Entidades.ERol;
import Interfaces.IRol;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Rol implements IRol
{

    public int idRol;
    public String nombreRol;
    public boolean estadoRol;
    public List<Permiso> permisosRol;

    public Rol()
    {
    }

    public Rol(int idRol, String nombreRol, boolean estadoRol, List<Permiso> permisosRol)
    {
        this.idRol = idRol;
        this.nombreRol = nombreRol;
        this.estadoRol = estadoRol;
        this.permisosRol = permisosRol;
    }

    @Override
    public boolean crearRol(String nombreRol, String permisosRolJson, int idUsuarioAuditor)
    {
        ERol result = new ERol();
        
        return result.insertRol(nombreRol, permisosRolJson, idUsuarioAuditor);
    }

    @Override
    public boolean actualizarRol(int idRol, String nombreRol, String permisosRolJson, int idUsuarioAuditor)
    {
        ERol result = new ERol();
        
        return result.updateRol(idRol, nombreRol, permisosRolJson, idUsuarioAuditor);
    }

    @Override
    public boolean eliminarRol(int idRol, int idUsuarioAuditor)
    {
        ERol result = new ERol();
        return result.deleteRol(idRol, idUsuarioAuditor);
    }

    @Override
    public PaginacionResultado<Rol> obtenerRoles(String searchTerm, int numPage, int pageSize)
    {
        ERol result = new ERol();

        return result.selectRolesPorTerminoBusqueda(searchTerm, numPage, pageSize);
    }

    @Override
    public List<Rol> obtenerRoles()
    {
        ERol result = new ERol();

        return result.selectRolesEstaticos();
    }
}
