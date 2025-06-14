package Logica;

import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class PaginacionResultado<T>
{

    private List<T> items;
    private int total;

    public PaginacionResultado()
    {
    }

    public PaginacionResultado(List<T> items, int total)
    {
        this.items = items;
        this.total = total;
    }

    public List<T> getItems()
    {
        return items;
    }

    public int getTotal()
    {
        return total;
    }
}
