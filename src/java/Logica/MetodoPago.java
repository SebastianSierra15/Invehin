package Logica;

import Entidades.EMetodoPago;
import Interfaces.IMetodoPago;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class MetodoPago implements IMetodoPago
{

    public int idMetodoPago;
    public String nombreMetodoPago;
    public boolean estadoMetodoPago;

    public MetodoPago()
    {
    }

    public MetodoPago(int idMetodoPago, String nombreMetodoPago, boolean estadoMetodoPago)
    {
        this.idMetodoPago = idMetodoPago;
        this.nombreMetodoPago = nombreMetodoPago;
        this.estadoMetodoPago = estadoMetodoPago;
    }

    @Override
    public boolean crearMetodoPago(String nombreMetodoPago, boolean estadoMetodoPago)
    {
        return true;
    }

    @Override
    public boolean actualizarMetodoPago(int idMetodoPago, String nombreMetodoPago, boolean estadoMetodoPago)
    {
        return true;
    }

    @Override
    public boolean eliminarMetodoPago(int idMetodoPago)
    {
        return true;
    }

    @Override
    public MetodoPago obtenerMetodoPago(int idMetodoPago)
    {
        MetodoPago entidad = new MetodoPago();

        return entidad;
    }

    @Override
    public List<MetodoPago> obtenerMetodosPago()
    {
        EMetodoPago result = new EMetodoPago();

        return result.selectMetodosPago();
    }
}
