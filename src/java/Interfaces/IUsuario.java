package Interfaces;

import Logica.PaginacionResultado;
import Logica.Persona;
import Logica.Usuario;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IUsuario
{

    Usuario iniciarSesion(String correo, String contrasenia);

    boolean crearUsuario(String correoUsuario, int idRol, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona, int idUsuarioAuditor);

    boolean actualizarUsuario(int idUsuario, int idRol, boolean estadoUsuario, int idPersona, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona, int idUsuarioAuditor);

    boolean actualizarPerfil(int idPersona, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona, int idUsuarioAuditor);

    boolean cambiarContrasenia(int idUsuario, String contraseniaActual, String contraseniaNueva, int idUsuarioAuditor);

    Usuario obtenerUsuario(int idUsuario);

    PaginacionResultado<Usuario> obtenerUsuarios(String searchTerm, int numPage, int pageSize);
}
