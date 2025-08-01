package Logica;

import Entidades.ETalla;
import Interfaces.ITalla;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Talla implements ITalla
{

    public int idTalla;
    public String nombreTalla;

    public Talla()
    {
    }

    public Talla(int idTalla, String nombreTalla)
    {
        this.idTalla = idTalla;
        this.nombreTalla = nombreTalla;
    }

    @Override
    public boolean crearTalla(String nombreTalla)
    {
        return true;
    }

    @Override
    public boolean actualizarTalla(int idTalla, String nombreTalla)
    {
        return true;
    }

    @Override
    public boolean eliminarTalla(int idTalla)
    {
        return true;
    }

    @Override
    public Talla obtenerTalla(int idTalla)
    {
        Talla entidad = new Talla();

        return entidad;
    }

    @Override
    public List<Talla> obtenerTallas()
    {
        ETalla result = new ETalla();

        return result.selectTallas();
    }
}
