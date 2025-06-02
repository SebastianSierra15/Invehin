package Logica;

import Interfaces.IInventario;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Inventario implements IInventario
{

    public int idInventario;
    public Date fechaInventario;
    public String observacionInventario;
    public boolean estadoInventario;
    public int usuarioInventario;
    public List<DetalleInventario> detallesinventarioInventario;

    public Inventario()
    {
    }

    public Inventario(int idInventario, Date fechaInventario, String observacionInventario, boolean estadoInventario, int usuarioInventario, List<DetalleInventario> detallesinventarioInventario)
    {
        this.idInventario = idInventario;
        this.fechaInventario = fechaInventario;
        this.observacionInventario = observacionInventario;
        this.estadoInventario = estadoInventario;
        this.usuarioInventario = usuarioInventario;
        this.detallesinventarioInventario = detallesinventarioInventario;
    }

    @Override
    public boolean crearInventario(Date fechaInventario, String observacionInventario, boolean estadoInventario, int usuarioInventario, List<DetalleInventario> detallesinventarioInventario)
    {
        return true;
    }

    @Override
    public boolean actualizarInventario(int idInventario, Date fechaInventario, String observacionInventario, boolean estadoInventario, int usuarioInventario, List<DetalleInventario> detallesinventarioInventario)
    {
        return true;
    }

    @Override
    public boolean eliminarInventario(int idInventario)
    {
        return true;
    }

    @Override
    public Inventario obtenerInventario(int idInventario)
    {
        Inventario entidad = new Inventario();

        return entidad;
    }
}
