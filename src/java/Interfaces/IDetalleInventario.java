package Interfaces;

import Logica.DetalleInventario;
import Logica.Prenda;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public interface IDetalleInventario
{

    boolean crearDetalleInventario(int cantidadregistradaDetalleInventario, int cantidadsistemaDetalleInventario, String observacionDetalleInventario, Prenda prendaDetalleInventario, int idinventarioDetalleInventario);

    boolean actualizarDetalleInventario(int idDetalleInventario, int cantidadregistradaDetalleInventario, int cantidadsistemaDetalleInventario, String observacionDetalleInventario, Prenda prendaDetalleInventario, int idinventarioDetalleInventario);

    boolean eliminarDetalleInventario(int idDetalleInventario);

    DetalleInventario obtenerDetalleInventario(int idDetalleInventario);
}
