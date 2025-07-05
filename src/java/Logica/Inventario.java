package Logica;

import Entidades.EInventario;
import Interfaces.IInventario;
import java.sql.Timestamp;
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
    public int idusuarioInventario;
    public String nombreusuarioInventario;
    public List<DetalleInventario> detallesinventarioInventario;

    public Inventario()
    {
    }

    public Inventario(int idInventario, Date fechaInventario, String observacionInventario, boolean estadoInventario, int idusuarioInventario, String nombreusuarioInventario, List<DetalleInventario> detallesinventarioInventario)
    {
        this.idInventario = idInventario;
        this.fechaInventario = fechaInventario;
        this.observacionInventario = observacionInventario;
        this.estadoInventario = estadoInventario;
        this.idusuarioInventario = idusuarioInventario;
        this.nombreusuarioInventario = nombreusuarioInventario;
        this.detallesinventarioInventario = detallesinventarioInventario;
    }

    @Override
    public boolean crearInventario(String observacionInventario, int idUsuario, String detallesInventarioJson)
    {
        EInventario result = new EInventario();
        
        return result.insertInventario(observacionInventario, idUsuario, detallesInventarioJson);
    }

    @Override
    public boolean actualizarInventario(int idInventario, String observacionInventario, boolean estadoInventario, String detallesInventarioJson)
    {
        EInventario result = new EInventario();
        
        return result.updateInventario(idInventario, observacionInventario, estadoInventario, detallesInventarioJson);
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

    @Override
    public PaginacionResultado<Inventario> obtenerInventarios(String searchTerm, int numPage, int pageSize)
    {
        EInventario result = new EInventario();
        
        return result.selectInventariosPorTerminoBusqueda(searchTerm, numPage, pageSize);
    }

    @Override
    public List<Inventario> obtenerReporteInventarios(Timestamp fechaInicio, Timestamp fechaFin, Boolean estadoInventario)
    {
        EInventario result = new EInventario();
        
        return result.selectReporteInventarios(fechaInicio, fechaFin, estadoInventario);
    }
}
