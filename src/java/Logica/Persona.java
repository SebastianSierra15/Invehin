package Logica;

import Interfaces.IPersona;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Persona implements IPersona
{

    public int idPersona;
    public String numeroidentificacionPersona;
    public String nombresPersona;
    public String apellidosPersona;
    public String telefonoPersona;
    public boolean generoPersona;

    public Persona()
    {
    }

    public Persona(int idPersona, String numeroidentificacionPersona, String nombresPersona, String apellidosPersona, String telefonoPersona, boolean generoPersona)
    {
        this.idPersona = idPersona;
        this.numeroidentificacionPersona = numeroidentificacionPersona;
        this.nombresPersona = nombresPersona;
        this.apellidosPersona = apellidosPersona;
        this.telefonoPersona = telefonoPersona;
        this.generoPersona = generoPersona;
    }

    @Override
    public boolean crearPresona(String numeroidentificacionPersona, String nombresPersona, String apellidosPersona, String telefonoPersona, boolean generoPersona)
    {
        return true;
    }

    @Override
    public boolean actualizarPresona(int idPersona, String numeroidentificacionPersona, String nombresPersona, String apellidosPersona, String telefonoPersona, boolean generoPersona)
    {
        return true;
    }

    @Override
    public boolean eliminarPresona(int idPersona)
    {
        return true;
    }

    @Override
    public Persona obtenerPresona(int idPersona)
    {
        Persona entidad = new Persona();

        return entidad;
    }
}
