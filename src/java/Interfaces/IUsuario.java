package Interfaces;

import Logica.Persona;
import Logica.Usuario;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IUsuario
{

    Usuario iniciarSesion(String correo, String contrasenia);

    boolean crearUsuario(Persona persona, String correoUsuario, String contraseniaUsuario, Persona personaUsuario);

    boolean cambiarEstado(int idUsuario);

    boolean actualizarContrasenia(int idUsuario, String contraseniaUsuario);

    boolean eliminarUsuario(int idUsuario);

    Usuario obtenerUsuario(int idUsuario);
}
