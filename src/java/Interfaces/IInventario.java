package Interfaces;

import Logica.Inventario;
import Logica.PaginacionResultado;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IInventario
{

    boolean crearInventario(String observacionInventario, int idUsuario, String detallesInventarioJson, int idUsuarioAuditor);

    boolean actualizarInventario(int idInventario, String observacionInventario, boolean estadoInventario, String detallesInventarioJson, int idUsuarioAuditor);

    boolean eliminarInventario(int idInventario, int idUsuarioAuditor);

    Inventario obtenerInventario(int idInventario);

    PaginacionResultado<Inventario> obtenerInventarios(String searchTerm, int numPage, int pageSize);

    List<Inventario> obtenerReporteInventarios(Timestamp fechaInicio, Timestamp fechaFin, Boolean estadoInventario);
}
