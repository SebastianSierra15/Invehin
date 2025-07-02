package Interfaces;

import Logica.PaginacionResultado;
import Logica.Proveedor;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IProveedor
{

    public boolean crearProveedor(String nombreProveedor, String correoProveedor, String direccionProveedor, String nombresPersona, String apellidosPersona, String telefonoPersona);

    public boolean actualizarProveedor(int idProveedor, String nombreProveedor, String correoProveedor, String direccionProveedor, int idPersona, String nombresPersona, String apellidosPersona, String telefonoPersona);

    public boolean eliminarProveedor(int idProveedor);

    public Proveedor obtenerProveedor(int idProveedor);

    PaginacionResultado<Proveedor> obtenerProveedores(String searchTerm, int numPage, int pageSize);
    
    List<Proveedor> obtenerProveedores();
}
