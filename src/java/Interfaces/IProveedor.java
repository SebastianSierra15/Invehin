package Interfaces;

import Logica.PaginacionResultado;
import Logica.Persona;
import Logica.Proveedor;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IProveedor
{

    public boolean crearProveedor(String nombreProveedor, String correoProveedor, String direccionProveedor, String nombresPersona, String apellidosPersona, String telefonoPersona);

    public boolean actualizarProveedor(int idProveedor, Persona persona, String nombreProveedor, String direccionProveedor, String correoProveedor, boolean estadoProveedor);

    public boolean eliminarProveedor(int idProveedor);

    public Proveedor obtenerProveedor(int idProveedor);

    PaginacionResultado<Proveedor> obtenerProveedores(String searchTerm, int numPage, int pageSize);
}
