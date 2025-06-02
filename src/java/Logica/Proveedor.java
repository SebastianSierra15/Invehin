package Logica;

import Interfaces.IProveedor;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Proveedor extends Persona implements IProveedor
{

    public int indProveedor;
    public String nombreProveedor;
    protected String direccionProveedor;
    protected String correoProveedor;
    public boolean estadoProveedor;

    public Proveedor()
    {
    }

    public Proveedor(int indProveedor, String nombreProveedor, String direccionProveedor, String correoProveedor, boolean estadoProveedor)
    {
        this.indProveedor = indProveedor;
        this.nombreProveedor = nombreProveedor;
        this.direccionProveedor = direccionProveedor;
        this.correoProveedor = correoProveedor;
        this.estadoProveedor = estadoProveedor;
    }

    public Proveedor(int indProveedor, String nombreProveedor, String direccionProveedor, String correoProveedor, boolean estadoProveedor, int idPersona, String numeroIdentificacionPersona, String nombresPersona, String apellidosPersona, String telefonoPersona, boolean generoPersona)
    {
        super(idPersona, numeroIdentificacionPersona, nombresPersona, apellidosPersona, telefonoPersona, generoPersona);
        this.indProveedor = indProveedor;
        this.nombreProveedor = nombreProveedor;
        this.direccionProveedor = direccionProveedor;
        this.correoProveedor = correoProveedor;
        this.estadoProveedor = estadoProveedor;
    }

    @Override
    public boolean crearProveedor(Persona persona, String nombreProveedor, String direccionProveedor, String correoProveedor, boolean estadoProveedor)
    {
        return true;
    }

    @Override
    public boolean actualizarProveedor(int idProveedor, Persona persona, String nombreProveedor, String direccionProveedor, String correoProveedor, boolean estadoProveedor)
    {
        return true;
    }

    @Override
    public boolean eliminarProveedor(int idProveedor)
    {
        return true;
    }

    @Override
    public Proveedor obtenerProveedor(int idProveedor)
    {
        Proveedor entidad = new Proveedor();

        return entidad;
    }
}
