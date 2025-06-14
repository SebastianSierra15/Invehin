package Logica;

import Entidades.EColor;
import Interfaces.IColor;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Color implements IColor
{

    public int idColor;
    public String nombreColor;

    public Color()
    {
    }

    public Color(int idColor, String nombreColor)
    {
        this.idColor = idColor;
        this.nombreColor = nombreColor;
    }

    @Override
    public boolean crearColor(String nombreColor)
    {
        return true;
    }

    @Override
    public boolean actualizarColor(int idColor, String nombreColor)
    {
        return true;
    }

    @Override
    public boolean eliminarColor(int idColor)
    {
        return true;
    }

    @Override
    public Color obtenerColor(int idColor)
    {
        Color entidad = new Color();

        return entidad;
    }

    @Override
    public List<Color> obtenerColores()
    {
        EColor result = new EColor();

        return result.selectColores();
    }

}
