package Logica;

import Entidades.EEstadoPrenda;
import Interfaces.IEstadoPrenda;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class EstadoPrenda implements IEstadoPrenda
{

    public int idEstadoPrenda;
    public String nombreEstadoPrenda;

    public EstadoPrenda()
    {
    }

    public EstadoPrenda(int idEstadoPrenda, String nombreEstadoPrenda)
    {
        this.idEstadoPrenda = idEstadoPrenda;
        this.nombreEstadoPrenda = nombreEstadoPrenda;
    }

    @Override
    public boolean crearEstadoPrenda(String nombreEstadoPrenda)
    {
        return true;
    }

    @Override
    public boolean actualizarEstadoPrenda(int idEstadoPrenda, String nombreEstadoPrenda)
    {
        return true;
    }

    @Override
    public boolean eliminarEstadoPrenda(int idEstadoPrenda)
    {
        return true;
    }

    @Override
    public EstadoPrenda obtenerEstadoPrenda(int idEstadoPrenda)
    {
        EstadoPrenda entidad = new EstadoPrenda();

        return entidad;
    }

    @Override
    public List<EstadoPrenda> obtenerEstadosPrenda()
    {
        EEstadoPrenda result = new EEstadoPrenda();
        
        return result.selectEstados();
    }
}
