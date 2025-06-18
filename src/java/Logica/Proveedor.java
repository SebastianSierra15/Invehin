package Logica;

import Entidades.EProveedor;
import Interfaces.IProveedor;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Proveedor extends Persona implements IProveedor
{

    public int idProveedor;
    public String nombreProveedor;
    public String direccionProveedor;
    public String correoProveedor;
    public boolean estadoProveedor;

    public Proveedor()
    {
    }

    public Proveedor(int idProveedor, String nombreProveedor, String direccionProveedor, String correoProveedor, boolean estadoProveedor)
    {
        this.idProveedor = idProveedor;
        this.nombreProveedor = nombreProveedor;
        this.direccionProveedor = direccionProveedor;
        this.correoProveedor = correoProveedor;
        this.estadoProveedor = estadoProveedor;
    }

    public Proveedor(int idProveedor, String nombreProveedor, String direccionProveedor, String correoProveedor, boolean estadoProveedor, int idPersona, String numeroIdentificacionPersona, String nombresPersona, String apellidosPersona, String telefonoPersona, boolean generoPersona)
    {
        super(idPersona, numeroIdentificacionPersona, nombresPersona, apellidosPersona, telefonoPersona, generoPersona);
        this.idProveedor = idProveedor;
        this.nombreProveedor = nombreProveedor;
        this.direccionProveedor = direccionProveedor;
        this.correoProveedor = correoProveedor;
        this.estadoProveedor = estadoProveedor;
    }

    @Override
    public boolean crearProveedor(String nombreProveedor, String correoProveedor, String direccionProveedor, String nombresPersona, String apellidosPersona, String telefonoPersona)
    {
        EProveedor result = new EProveedor();
        
        return result.insertProveedor(nombreProveedor, correoProveedor, direccionProveedor, nombresPersona, apellidosPersona, telefonoPersona);
    }

    @Override
    public boolean actualizarProveedor(int idProveedor, String nombreProveedor, String correoProveedor, String direccionProveedor, int idPersona, String nombresPersona, String apellidosPersona, String telefonoPersona)
    {
        EProveedor result = new EProveedor();
        
        return result.updateProveedor(idProveedor, nombreProveedor, correoProveedor, direccionProveedor, idPersona, nombresPersona, apellidosPersona, telefonoPersona);
    }

    @Override
    public boolean eliminarProveedor(int idProveedor)
    {
        EProveedor result = new EProveedor();
        
        return result.deleteProveedor(idProveedor);
    }

    @Override
    public Proveedor obtenerProveedor(int idProveedor)
    {
        Proveedor entidad = new Proveedor();

        return entidad;
    }

    @Override
    public PaginacionResultado<Proveedor> obtenerProveedores(String searchTerm, int numPage, int pageSize)
    {
        EProveedor result = new EProveedor();

        return result.selectProveedoresPorTerminoBusqueda(searchTerm, numPage, pageSize);
    }
}
