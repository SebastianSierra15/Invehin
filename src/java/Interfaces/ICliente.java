package Interfaces;

import Logica.Cliente;
import Logica.PaginacionResultado;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface ICliente
{

    boolean crearCliente(String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona, String direccionCliente, int idUsuarioAuditor);

    boolean actualizarCliente(int idCliente, String direccionCliente, int idPersona, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona, int idUsuarioAuditor);

    boolean eliminarCliente(int idCliente, int idUsuarioAuditor);
    
    int totalClientes(Timestamp fechaInicio, Timestamp fechaFin);

    PaginacionResultado<Cliente> obtenerClientes(String searchTerm, int numPage, int pageSize);

    List<Cliente> buscarClientes(String searchTerm);
}
