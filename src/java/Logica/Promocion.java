package Logica;

import Interfaces.IPromocion;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Promocion implements IPromocion
{

    public int idPromocion;
    public int porcentajePromocion;
    public Date fechainicioPromocion;
    public Date fechafinPromocion;
    public boolean estadoPromocion;
    public List<Subcategoria> subcategoriasPromocion;

    public Promocion()
    {
    }

    public Promocion(int idPromocion, int porcentajePromocion, Date fechainicioPromocion, Date fechafinPromocion, boolean estadoPromocion, List<Subcategoria> subcategoriasPromocion)
    {
        this.idPromocion = idPromocion;
        this.porcentajePromocion = porcentajePromocion;
        this.fechainicioPromocion = fechainicioPromocion;
        this.fechafinPromocion = fechafinPromocion;
        this.estadoPromocion = estadoPromocion;
        this.subcategoriasPromocion = subcategoriasPromocion;
    }

    @Override
    public boolean crearPromocion(int porcentajePromocion, Date fechainicioPromocion, Date fechafinPromocion,  List<Subcategoria> subcategoriasPromocion)
    {
        return true;
    }

    @Override
    public boolean actualizarPromocion(int idPromocion, int porcentajePromocion, Date fechainicioPromocion, Date fechafinPromocion, boolean estadoPromocion, List<Subcategoria> subcategoriasPromocion)
    {
        return true;
    }

    @Override
    public boolean eliminarPromocion(int idPromocion)
    {
        return true;
    }

    @Override
    public Promocion obtenerPromocion(int idPromocion)
    {
        Promocion entidad = new Promocion();

        return entidad;
    }
}
