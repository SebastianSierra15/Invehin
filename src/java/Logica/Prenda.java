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
    public boolean crearPrenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, int idColor, int idSubcategoria, int idTalla)
    {
        EPrenda result = new EPrenda();
        
        return result.insertPrenda(codigoPrenda, stockPrenda, stockminimoPrenda, idColor, idSubcategoria, idTalla);
    }
    
    @Override
    public boolean actualizarPrenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, int idColor, int idEstadoPrenda, int idSubcategoria, int idTalla)
    {
        EPrenda result = new EPrenda();
        
        return result.updatePrenda(codigoPrenda, stockPrenda, stockminimoPrenda, idColor, idEstadoPrenda, idSubcategoria, idTalla);
    }
    
    @Override
    public boolean eliminarPrenda(String codigoPrenda)
    {
        EPrenda result = new EPrenda();
        
        return result.deletePrenda(codigoPrenda);
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
    public PaginacionResultado<Prenda> buscarPrendas(String searchTerm, int numPage, int pageSize)
    {
        EPrenda result = new EPrenda();
        
        return result.selectPrendasPorTerminoBusqueda(searchTerm, numPage, pageSize);
    }
    
    @Override
    public List<Prenda> obtenerReportePrendas(Integer idCategoria, Integer idTalla, boolean stockBajo)
    {
        EPrenda result = new EPrenda();
        
        return result.selectReportePrendas(idCategoria, idTalla, stockBajo);
    }
    
    @Override
    public List<Prenda> buscarPrendasParaVenta(String searchTerm)
    {
        EPrenda result = new EPrenda();
        
        return result.selectPrendasForVenta(searchTerm);
    }
}
