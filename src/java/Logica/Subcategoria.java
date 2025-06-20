package Logica;

import Entidades.ESubcategoria;
import Interfaces.ISubcategoria;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Subcategoria implements ISubcategoria
{

    public int idSubcategoria;
    public String nombreSubcategoria;
    public int precioSubcategoria;
    public String imagenSubcategoria;
    public boolean estadoSubcategoria;
    public Categoria categoriaSubcategoria;

    public Subcategoria()
    {
    }

    public Subcategoria(int idSubcategoria, String nombreSubcategoria, int precioSubcategoria, String imagenSubcategoria, boolean estadoSubcategoria, Categoria categoriaSubcategoria)
    {
        this.idSubcategoria = idSubcategoria;
        this.nombreSubcategoria = nombreSubcategoria;
        this.precioSubcategoria = precioSubcategoria;
        this.imagenSubcategoria = imagenSubcategoria;
        this.estadoSubcategoria = estadoSubcategoria;
        this.categoriaSubcategoria = categoriaSubcategoria;
    }

    @Override
    public boolean crearSubcategoria(String nombreSubcategoria, int precioSubcategoria, int idCategoria)
    {
        ESubcategoria result = new ESubcategoria();

        return result.insertSubcategoria(nombreSubcategoria, precioSubcategoria, idCategoria);
    }

    @Override
    public boolean actualizarSubcategoria(int idSubcategoria, String nombreSubcategoria, int precioSubcategoria, int idCategoria)
    {
        ESubcategoria result = new ESubcategoria();

        return result.updateSubcategoria(idSubcategoria, nombreSubcategoria, precioSubcategoria, idCategoria);
    }

    @Override
    public boolean cambiarEstadoSubcategoria(int idSubcategoria, boolean estadoSubcategoria)
    {
        ESubcategoria result = new ESubcategoria();

        return result.cambiarEstadoSubcategoria(idSubcategoria, estadoSubcategoria);
    }
}
