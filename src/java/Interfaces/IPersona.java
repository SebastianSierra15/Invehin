package Interfaces;

import Logica.Persona;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IPersona
{

    boolean crearPresona(String numeroidentificacionPersona, String nombresPersona, String apellidosPersona, String telefonoPersona, boolean generoPersona);

    boolean actualizarPresona(int idPersona, String numeroidentificacionPersona, String nombresPersona, String apellidosPersona, String telefonoPersona, boolean generoPersona);

    boolean eliminarPresona(int idPersona);

    Persona obtenerPresona(int idPersona);
}
