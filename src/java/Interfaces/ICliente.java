package Interfaces;

import Logica.Cliente;
import Logica.Persona;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface ICliente
{

    boolean crearCliente(Persona persona, String direccionCliente, boolean estadoCliente);

    boolean actualizarCliente(int idCliente, Persona persona, String direccionCliente, boolean estadoCliente);

    boolean eliminarCliente(int idCliente);

    Cliente obtenerCliente(int idCliente);

    List<Cliente> buscarClientes(String searchTerm);
}
