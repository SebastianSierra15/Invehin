package Interfaces;

import Logica.Promocion;
import Logica.Subcategoria;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IPromocion
{

    public boolean crearPromocion(int porcentajePromocion, Date fechainicioPromocion, Date fechafinPromocion, List<Subcategoria> subcategoriasPromocion);

    public boolean actualizarPromocion(int idPromocion, int porcentajePromocion, Date fechainicioPromocion, Date fechafinPromocion, boolean estadoPromocion, List<Subcategoria> subcategoriasPromocion);

    public boolean eliminarPromocion(int idPromocion);

    public Promocion obtenerPromocion(int idPromocion);
}
