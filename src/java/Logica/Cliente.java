package Logica;

import Interfaces.ICliente;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Cliente extends Persona implements ICliente
{

    public int idCliente;
    protected String direccionCliente;
    public boolean estadoCliente;

    public Cliente()
    {
    }

    public Cliente(int idCliente, String direccionCliente, boolean estadoCliente)
    {
        this.idCliente = idCliente;
        this.direccionCliente = direccionCliente;
        this.estadoCliente = estadoCliente;
    }

    public Cliente(int idCliente, String direccionCliente, boolean estadoCliente, int idPersona, String numeroIdentificacionPersona, String nombresPersona, String apellidosPersona, String telefonoPersona, boolean generoPersona)
    {
        super(idPersona, numeroIdentificacionPersona, nombresPersona, apellidosPersona, telefonoPersona, generoPersona);
        this.idCliente = idCliente;
        this.direccionCliente = direccionCliente;
        this.estadoCliente = estadoCliente;
    }

    @Override
    public boolean crearCliente(Persona persona, String direccionCliente, boolean estadoCliente)
    {
        return true;
    }

    @Override
    public boolean actualizarCliente(int idCliente, Persona persona, String direccionCliente, boolean estadoCliente)
    {
        return true;
    }

    @Override
    public boolean eliminarCliente(int idCliente)
    {
        return true;
    }

    @Override
    public Cliente obtenerCliente(int idCliente)
    {
        Cliente entidad = new Cliente();

        return entidad;
    }

}
