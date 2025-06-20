package Logica;

import Entidades.EPermiso;
import Interfaces.IPermiso;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Permiso implements IPermiso
{

    public int idPermiso;
    public String nombrePermiso;

    public Permiso()
    {
    }

    public Permiso(int idPermiso, String nombrePermiso)
    {
        this.idPermiso = idPermiso;
        this.nombrePermiso = nombrePermiso;
    }

    @Override
    public boolean crearPermiso(String nombrePermiso)
    {
        return true;
    }

    @Override
    public boolean actualizarPermiso(int idPermiso, String nombrePermiso)
    {
        return true;
    }

    @Override
    public boolean eliminarPermiso(int idPermiso)
    {
        return true;
    }

    @Override
    public Permiso obtenerPermiso(int idPermiso)
    {
        Permiso entidad = new Permiso();

        return entidad;
    }

    @Override
    public List<Permiso> obtenerPermisos()
    {
        EPermiso result = new EPermiso();
        
        return result.selectPermisos();
    }
}
