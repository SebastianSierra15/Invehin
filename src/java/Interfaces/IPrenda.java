package Interfaces;

import Logica.Color;
import Logica.EstadoPrenda;
import Logica.PaginacionResultado;
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

    boolean crearPrenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, int idColor, int idSubcategoria, int idTalla);

    boolean actualizarPrenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, int idColor, int idEstadoPrenda, int idSubcategoria, int idTalla);

    boolean eliminarPrenda(String codigoPrenda);

    int cantidadPrendasBajoStock();

    int cantidadPrendasVendidas(Timestamp fechaInicio, Timestamp fechaFin);

    PaginacionResultado<Prenda> buscarPrendas(String searchTerm, int numPage, int pageSize);

    List<Prenda> obtenerReportePrendas(Integer idCategoria, Integer idTalla, boolean stockBajo);

    List<Prenda> buscarPrendasParaVenta(String searchTerm);
}
