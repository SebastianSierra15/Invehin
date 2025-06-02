package Logica;

import Interfaces.ICategoria;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Categoria implements ICategoria
{

    public int idCategoria;
    public String nombreCategoria;

    public Categoria()
    {
    }

    public Categoria(int idCategoria, String nombreCategoria)
    {
        this.idCategoria = idCategoria;
        this.nombreCategoria = nombreCategoria;
    }

    @Override
    public boolean crearCategoria(String nombreCategoria)
    {
        return true;
    }

    @Override
    public boolean actualizarCategoria(int idCategoria, String nombreCategoria)
    {
        return true;
    }

    @Override
    public boolean eliminarCategoria(int idCategoria)
    {
        return true;
    }

    @Override
    public Categoria obtenerCategoria(int Categoria)
    {
        Categoria entidad = new Categoria();

        return entidad;
    }
}
