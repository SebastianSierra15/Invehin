package Logica;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Persona
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
}
