package Utils.Pedidos;

import Logica.Pedido;
import Utils.GeneradorPDFBase;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.PdfPTable;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class GeneradorReportesPedidosPDF
{

    public static void generarPedidosPDF(List<Pedido> pedidos, OutputStream out) throws IOException, DocumentException
    {
        // Crear documento con título
        Document document = GeneradorPDFBase.crearDocumento(out, "Reporte de Pedidos");

        // Crear encabezados
        String[] encabezados =
        {
            "Id", "Fecha", "Proveedor", "Precio Total", "Cantidad Prendas", "Estado"
        };

        PdfPTable table = GeneradorPDFBase.crearTablaConEncabezados(encabezados);

        // Agregar los datos
        for (Pedido p : pedidos)
        {
            table.addCell(GeneradorPDFBase.celda(String.format("%,d", p.idPedido)));
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            table.addCell(GeneradorPDFBase.celda(sdf.format(p.fechaPedido)));
            table.addCell(GeneradorPDFBase.celda(p.proveedorPedido.nombreProveedor));
            table.addCell(GeneradorPDFBase.celda("$" + String.format("%,d", p.preciototalPedido)));
            table.addCell(GeneradorPDFBase.celda(String.format("%,d", p.cantidadPedido)));
            table.addCell(GeneradorPDFBase.celda(p.estadoPedido ? "Entregado" : "Pendiente"));
        }

        document.add(table);
        document.close();
    }
}
