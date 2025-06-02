package Logica;

import Entidades.EPrenda;
import Interfaces.IPrenda;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class Prenda implements IPrenda
{
    
    public String codigoPrenda;
    public int stockPrenda;
    public int stockminimoPrenda;
    public Color colorPrenda;
    public EstadoPrenda estadoprendaPrenda;
    public Talla tallaPrenda;
    public Subcategoria subcategoriaPrenda;
    
    public Prenda()
    {
    }
    
    public Prenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, Color colorPrenda, EstadoPrenda estadoprendaPrenda, Talla tallaPrenda, Subcategoria subcategoriaPrenda)
    {
        this.codigoPrenda = codigoPrenda;
        this.stockPrenda = stockPrenda;
        this.stockminimoPrenda = stockminimoPrenda;
        this.colorPrenda = colorPrenda;
        this.estadoprendaPrenda = estadoprendaPrenda;
        this.tallaPrenda = tallaPrenda;
        this.subcategoriaPrenda = subcategoriaPrenda;
    }
    
    @Override
    public boolean crearPrenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, Color colorPrenda, EstadoPrenda estadoprendaPrenda, Talla tallaPrenda, Subcategoria subcategoriaPrenda)
    {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    @Override
    public boolean actualizarPrenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, Color colorPrenda, EstadoPrenda estadoprendaPrenda, Talla tallaPrenda, Subcategoria subcategoriaPrenda)
    {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    @Override
    public boolean eliminarPrenda(String codigoPrenda)
    {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    @Override
    public Prenda obtenerPrenda(String codigoPrenda)
    {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    @Override
    public int cantidadPrendasBajoStock()
    {
        EPrenda result = new EPrenda();
        
        return result.getPrendasBajoStock();
    }
    
    @Override
    public int cantidadPrendasVendidas(Timestamp fechaInicio, Timestamp fechaFin)
    {
        EPrenda result = new EPrenda();
        
        return result.getPrendasVendidas(fechaInicio, fechaFin);
    }
    
    @Override
    public List<Prenda> buscarPrendas(String searchTerm)
    {
        EPrenda result = new EPrenda();
        
        return result.selectPrendasBySearchTerm(searchTerm);
    }
}
