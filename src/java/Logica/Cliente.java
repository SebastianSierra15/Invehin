package Logica;

import Entidades.ECliente;
import Interfaces.ICliente;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Cliente extends Persona implements ICliente
{

    public int idCliente;
    public Timestamp fecharegistroCliente;
    public String direccionCliente;
    public boolean estadoCliente;

    public Cliente()
    {
    }

    public Cliente(int idCliente, Timestamp fecharegistroCliente, String direccionCliente, boolean estadoCliente)
    {
        this.idCliente = idCliente;
        this.fecharegistroCliente = fecharegistroCliente;
        this.direccionCliente = direccionCliente;
        this.estadoCliente = estadoCliente;
    }

    public Cliente(int idCliente, Timestamp fecharegistroCliente, String direccionCliente, boolean estadoCliente, int idPersona, String numeroidentificacionPersona, String nombresPersona, String apellidosPersona, String telefonoPersona, boolean generoPersona)
    {
        super(idPersona, numeroidentificacionPersona, nombresPersona, apellidosPersona, telefonoPersona, generoPersona);
        this.idCliente = idCliente;
        this.fecharegistroCliente = fecharegistroCliente;
        this.direccionCliente = direccionCliente;
        this.estadoCliente = estadoCliente;
    }

    @Override
    public boolean crearCliente(String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona, String direccionCliente)
    {
        ECliente result = new ECliente();

        return result.insertCliente(nombresPersona, apellidosPersona, numeroidentificacionPersona, telefonoPersona, generoPersona, direccionCliente);
    }

    @Override
    public boolean actualizarCliente(int idCliente, String direccionCliente, int idPersona, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona)
    {
        ECliente result = new ECliente();

        return result.updateCliente(idCliente, direccionCliente, idPersona, nombresPersona, apellidosPersona, numeroidentificacionPersona, telefonoPersona, generoPersona);
    }

    @Override
    public boolean eliminarCliente(int idCliente)
    {
        ECliente result = new ECliente();

        return result.deleteCliente(idCliente);
    }

    @Override
    public PaginacionResultado<Cliente> obtenerClientes(String searchTerm, int numPage, int pageSize)
    {
        ECliente result = new ECliente();

        return result.selectClientesPorTerminoBusqueda(searchTerm, numPage, pageSize);
    }

    @Override
    public List<Cliente> buscarClientes(String searchTerm)
    {
        ECliente result = new ECliente();

        return result.selectClientesBySearchTerm(searchTerm);
    }
}
