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
    public boolean crearCliente(String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona, String direccionCliente, int idUsuarioAuditor)
    {
        ECliente result = new ECliente();

        return result.insertCliente(nombresPersona, apellidosPersona, numeroidentificacionPersona, telefonoPersona, generoPersona, direccionCliente, idUsuarioAuditor);
    }

    @Override
    public boolean actualizarCliente(int idCliente, String direccionCliente, int idPersona, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona, int idUsuarioAuditor)
    {
        ECliente result = new ECliente();

        return result.updateCliente(idCliente, direccionCliente, idPersona, nombresPersona, apellidosPersona, numeroidentificacionPersona, telefonoPersona, generoPersona, idUsuarioAuditor);
    }

    @Override
    public boolean eliminarCliente(int idCliente, int idUsuarioAuditor)
    {
        ECliente result = new ECliente();

        return result.deleteCliente(idCliente, idUsuarioAuditor);
    }

    @Override
    public int totalClientes(Timestamp fechaInicio, Timestamp fechaFin)
    {
        ECliente result = new ECliente();
        
        return result.getTotalClientes(fechaInicio, fechaFin);
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
