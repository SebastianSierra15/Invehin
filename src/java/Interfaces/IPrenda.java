package Interfaces;

import Logica.Color;
import Logica.EstadoPrenda;
import Logica.Prenda;
import Logica.Subcategoria;
import Logica.Talla;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IPrenda
{

    boolean crearPrenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, Color colorPrenda, EstadoPrenda estadoprendaPrenda, Talla tallaPrenda, Subcategoria subcategoriaPrenda);

    boolean actualizarPrenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, Color colorPrenda, EstadoPrenda estadoprendaPrenda, Talla tallaPrenda, Subcategoria subcategoriaPrenda);

    boolean eliminarPrenda(String codigoPrenda);

    Prenda obtenerPrenda(String codigoPrenda);
    
    int cantidadPrendasBajoStock();
    
    int cantidadPrendasVendidas(Timestamp fechaInicio, Timestamp fechaFin);
    
    List<Prenda> buscarPrendas(String searchTerm);
}
