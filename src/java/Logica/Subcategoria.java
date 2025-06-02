package Logica;

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
    public int stockMinimoSubcategoria;
    public int stockSubcategoria;
    public String imagenSubcategoria;
    public boolean estadoSubcategoria;
    public Categoria categoriaSubcategoria;

    public Subcategoria()
    {
    }

    public Subcategoria(int idSubcategoria, String nombreSubcategoria, int precioSubcategoria, int stockMinimoSubcategoria, int stockSubcategoria, String imagenSubcategoria, boolean estadoSubcategoria, Categoria categoriaSubcategoria)
    {
        this.idSubcategoria = idSubcategoria;
        this.nombreSubcategoria = nombreSubcategoria;
        this.precioSubcategoria = precioSubcategoria;
        this.stockMinimoSubcategoria = stockMinimoSubcategoria;
        this.stockSubcategoria = stockSubcategoria;
        this.imagenSubcategoria = imagenSubcategoria;
        this.estadoSubcategoria = estadoSubcategoria;
        this.categoriaSubcategoria = categoriaSubcategoria;
    }

    @Override
    public boolean crearSubcategoria(String nombreSubcategoria, int precioSubcategoria, int stockMinimoSubcategoria, int stockSubcategoria, String imagenSubcategoria, boolean estadoSubcategoria, Categoria categoriaSubcategoria)
    {
        return true;
    }

    @Override
    public boolean actualizarSubcategoria(int idSubcategoria, String nombreSubcategoria, int precioSubcategoria, int stockMinimoSubcategoria, int stockSubcategoria, String imagenSubcategoria, boolean estadoSubcategoria, Categoria categoriaSubcategoria)
    {
        return true;
    }

    @Override
    public boolean eliminarSubcategoria(int idSubcategoria)
    {
        return true;
    }

    @Override
    public Subcategoria obtenerSubcategoria(int idSubcategoria)
    {
        Subcategoria entidad = new Subcategoria();

        return entidad;
    }
}
