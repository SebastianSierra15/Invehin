package Interfaces;

import Logica.DetalleInventario;
import Logica.Inventario;
import Logica.Usuario;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IInventario
{

    boolean crearInventario(Date fechaInventario, String observacionInventario, boolean estadoInventario, int usuarioInventario, List<DetalleInventario> detallesinventarioInventario);

    boolean actualizarInventario(int idInventario, Date fechaInventario, String observacionInventario, boolean estadoInventario, int usuarioInventario, List<DetalleInventario> detallesinventarioInventario);

    boolean eliminarInventario(int idInventario);

    Inventario obtenerInventario(int idInventario);
}
