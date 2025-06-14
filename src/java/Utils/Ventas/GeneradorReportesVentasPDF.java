package Utils.Ventas;

import Logica.Venta;
import Utils.GeneradorPDFBase;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.PdfPTable;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class GeneradorReportesVentasPDF
{

    public static void generarVentasPDF(List<Venta> ventas, OutputStream out) throws IOException, DocumentException
    {
        // Crear documento con título
        Document document = GeneradorPDFBase.crearDocumento(out, "Reporte de Ventas");

        // Crear encabezados
        String[] encabezados =
        {
            "ID", "Fecha", "Cliente", "Método Pago", "Cantidad", "Total", "Recibido", "Estado"
        };

        PdfPTable table = GeneradorPDFBase.crearTablaConEncabezados(encabezados);

        // Agregar los datos
        for (Venta v : ventas)
        {
            table.addCell(GeneradorPDFBase.celda(String.valueOf(v.idVenta)));
            table.addCell(GeneradorPDFBase.celda(v.fechaVenta.toString()));
            table.addCell(GeneradorPDFBase.celda(v.clienteVenta.nombresPersona + " " + v.clienteVenta.apellidosPersona));
            table.addCell(GeneradorPDFBase.celda(v.metodopagoVenta.nombreMetodoPago));
            table.addCell(GeneradorPDFBase.celda(String.valueOf(v.cantidadVenta)));
            table.addCell(GeneradorPDFBase.celda("$" + String.format("%,d", v.preciototalVenta)));
            table.addCell(GeneradorPDFBase.celda("$" + String.format("%,d", v.montorecibidoVenta)));
            table.addCell(GeneradorPDFBase.celda(v.estadoVenta ? "Activo" : "Inactivo"));
        }

        document.add(table);
        document.close();
    }
}
