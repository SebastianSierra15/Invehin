package Logica;

import Interfaces.IDetalleInventario;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class DetalleInventario implements IDetalleInventario
{

    public int idDetalleInventario;
    public int cantidadregistradaDetalleInventario;
    public int cantidadsistemaDetalleInventario;
    public String observacionDetalleInventario;
    public String prendacodigoDetalleInventario;
    public String prendanombreDetalleInventario;
    public int idinventarioDetalleInventario;

    public DetalleInventario()
    {
    }

    public DetalleInventario(int idDetalleInventario, int cantidadregistradaDetalleInventario, int cantidadsistemaDetalleInventario, String observacionDetalleInventario, String prendacodigoDetalleInventario, String prendanombreDetalleInventario, int idinventarioDetalleInventario)
    {
        this.idDetalleInventario = idDetalleInventario;
        this.cantidadregistradaDetalleInventario = cantidadregistradaDetalleInventario;
        this.cantidadsistemaDetalleInventario = cantidadsistemaDetalleInventario;
        this.observacionDetalleInventario = observacionDetalleInventario;
        this.prendacodigoDetalleInventario = prendacodigoDetalleInventario;
        this.prendanombreDetalleInventario = prendanombreDetalleInventario;
        this.idinventarioDetalleInventario = idinventarioDetalleInventario;
    }

    @Override
    public boolean crearDetalleInventario(int cantidadregistradaDetalleInventario, int cantidadsistemaDetalleInventario, String observacionDetalleInventario, Prenda prendaDetalleInventario, int idinventarioDetalleInventario)
    {
        return true;
    }

    @Override
    public boolean actualizarDetalleInventario(int idDetalleInventario, int cantidadregistradaDetalleInventario, int cantidadsistemaDetalleInventario, String observacionDetalleInventario, Prenda prendaDetalleInventario, int idinventarioDetalleInventario)
    {
        return true;
    }

    @Override
    public boolean eliminarDetalleInventario(int idDetalleInventario)
    {
        return true;
    }

    @Override
    public DetalleInventario obtenerDetalleInventario(int idDetalleInventario)
    {
        DetalleInventario entidad = new DetalleInventario();

        return entidad;
    }
}
