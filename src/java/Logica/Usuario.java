package Logica;

import Entidades.EUsuario;
import Interfaces.IUsuario;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Usuario extends Persona implements IUsuario
{

    public int idUsuario;
    private String correoUsuario;
    private String contraseniaUsuario;
    public boolean estadoUsuario;
    public Rol rol;

    public Usuario()
    {
    }

    public Usuario(int idUsuario, String correoUsuario, String contraseniaUsuario, boolean estadoUsuario)
    {
        this.idUsuario = idUsuario;
        this.correoUsuario = correoUsuario;
        this.contraseniaUsuario = contraseniaUsuario;
        this.estadoUsuario = estadoUsuario;
    }

    public Usuario(int idUsuario, String correoUsuario, String contraseniaUsuario, boolean estadoUsuario, int idPersona, String numeroIdentificacionPersona, String nombresPersona, String apellidosPersona, String telefonoPersona, boolean generoPersona, int idRol, String nombreRol, boolean estadoRol, List<Permiso> permisosRol)
    {
        super(idPersona, numeroIdentificacionPersona, nombresPersona, apellidosPersona, telefonoPersona, generoPersona);
        this.idUsuario = idUsuario;
        this.correoUsuario = correoUsuario;
        this.contraseniaUsuario = contraseniaUsuario;
        this.estadoUsuario = estadoUsuario;
        this.rol = new Rol(idRol, nombreRol, estadoRol, permisosRol);
    }

    @Override
    public Usuario iniciarSesion(String correo, String contrasenia)
    {
        EUsuario result = new EUsuario();

        return result.loginUsuario(correo, contrasenia);
    }

    @Override
    public boolean crearUsuario(Persona persona, String correoUsuario, String contraseniaUsuario, Persona personaUsuario)
    {
        return true;
    }

    @Override
    public boolean cambiarEstado(int idUsuario)
    {
        return true;
    }

    @Override
    public boolean actualizarContrasenia(int idUsuario, String contraseniaUsuario)
    {
        return true;
    }

    @Override
    public boolean eliminarUsuario(int idUsuario)
    {
        return true;
    }

    @Override
    public Usuario obtenerUsuario(int idUsuario)
    {
        Usuario entidad = new Usuario();

        return entidad;
    }
}
