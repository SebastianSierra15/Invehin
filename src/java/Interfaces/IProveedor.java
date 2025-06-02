package Interfaces;

import Logica.Persona;
import Logica.Proveedor;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IProveedor
{

    public boolean crearProveedor(Persona persona, String nombreProveedor, String direccionProveedor, String correoProveedor, boolean estadoProveedor);

    public boolean actualizarProveedor(int idProveedor, Persona persona, String nombreProveedor, String direccionProveedor, String correoProveedor, boolean estadoProveedor);

    public boolean eliminarProveedor(int idProveedor);

    public Proveedor obtenerProveedor(int idProveedor);
}
