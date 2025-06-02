package Logica;

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
    public boolean crearRol(String nombreRol, boolean estadoRol, List<Permiso> permisosRol)
    {
        return true;
    }

    @Override
    public boolean actualizarRol(int idRol, String nombreRol, boolean estadoRol, List<Permiso> permisosRol)
    {
        return true;
    }

    @Override
    public boolean agregarPermiso(int idRol, Permiso permiso)
    {
        return true;
    }

    @Override
    public boolean quitarPermiso(int IdRol, Permiso permiso)
    {
        return true;
    }

    @Override
    public boolean eliminarRol(int idRol)
    {
        return true;
    }

    @Override
    public Rol obtenerRol(int idRol)
    {
        Rol entidad = new Rol();

        return entidad;
    }
}
