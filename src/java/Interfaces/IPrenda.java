package Interfaces;

import Logica.PaginacionResultado;
import Logica.Prenda;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IPrenda
{

    boolean crearPrenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, int idColor, int idSubcategoria, int idTalla, int idUsuarioAuditor);

    boolean actualizarPrenda(String codigoPrenda, int stockPrenda, int stockminimoPrenda, int idColor, int idEstadoPrenda, int idSubcategoria, int idTalla, int idUsuarioAuditor);

    boolean eliminarPrenda(String codigoPrenda, int idUsuarioAuditor);

    int cantidadPrendasBajoStock();

    int cantidadPrendasVendidas(Timestamp fechaInicio, Timestamp fechaFin);
    
    List<Prenda> cantidadPrendasMasVendidas(int cantidad, Timestamp fechaInicio, Timestamp fechaFin);

    PaginacionResultado<Prenda> obtenerPrendas(String searchTerm, int numPage, int pageSize);

    List<Prenda> obtenerReportePrendas(Integer idCategoria, Integer idTalla, boolean stockBajo);

    List<Prenda> buscarPrendasParaVenta(String searchTerm);
}
