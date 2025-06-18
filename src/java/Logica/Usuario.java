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
    public Rol rolUsuario;

    public Usuario()
    {
    }

    public String getCorreoUsuario()
    {
        return this.correoUsuario;
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
        this.rolUsuario = new Rol(idRol, nombreRol, estadoRol, permisosRol);
    }

    @Override
    public Usuario iniciarSesion(String correo, String contrasenia)
    {
        EUsuario result = new EUsuario();

        return result.loginUsuario(correo, contrasenia);
    }

    @Override
    public boolean crearUsuario(String correoUsuario, int idRol, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona)
    {
        EUsuario result = new EUsuario();

        return result.insertUsuario(correoUsuario, idRol, nombresPersona, apellidosPersona, numeroidentificacionPersona, telefonoPersona, generoPersona);
    }

    @Override
    public boolean actualizarUsuario(int idUsuario, int idRol, boolean estadoUsuario, int idPersona, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona)
    {
        EUsuario result = new EUsuario();

        return result.updateUsuario(idUsuario, idRol, estadoUsuario, idPersona, nombresPersona, apellidosPersona, numeroidentificacionPersona, telefonoPersona, generoPersona);
    }

    @Override
    public boolean actualizarPerfil(int idPersona, String nombresPersona, String apellidosPersona, String numeroidentificacionPersona, String telefonoPersona, boolean generoPersona)
    {
        EUsuario result = new EUsuario();

        return result.updatePerfil(idPersona, nombresPersona, apellidosPersona, numeroidentificacionPersona, telefonoPersona, generoPersona);
    }

    @Override
    public boolean cambiarContrasenia(int idUsuario, String contraseniaActual, String contraseniaNueva)
    {
        EUsuario result = new EUsuario();

        return result.cambiarContrasenia(idUsuario, contraseniaActual, contraseniaNueva);
    }

    @Override
    public Usuario obtenerUsuario(int idUsuario)
    {
        EUsuario result = new EUsuario();

        return result.selectUsuarioById(idUsuario);
    }

    @Override
    public PaginacionResultado<Usuario> obtenerUsuarios(String searchTerm, int numPage, int pageSize)
    {
        EUsuario result = new EUsuario();

        return result.selectUsuariosPorTerminoBusqueda(searchTerm, numPage, pageSize);
    }
}
