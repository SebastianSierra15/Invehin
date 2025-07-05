package Utils.Inventarios;

import Logica.Inventario;
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
public class GeneradorReportesInventariosPDF
{

    public static void generarInventariosPDF(List<Inventario> inventarios, OutputStream out) throws IOException, DocumentException
    {
        // Crear documento con título
        Document document = GeneradorPDFBase.crearDocumento(out, "Reporte de Inventarios");

        // Crear encabezados
        String[] encabezados =
        {
            "Id", "Fecha", "Observacion", "Usuario", "Estado"
        };

        PdfPTable table = GeneradorPDFBase.crearTablaConEncabezados(encabezados);

        // Agregar los datos
        for (Inventario i : inventarios)
        {
            table.addCell(GeneradorPDFBase.celda(String.format("%,d", i.idInventario)));
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            table.addCell(GeneradorPDFBase.celda(sdf.format(i.fechaInventario)));
            table.addCell(GeneradorPDFBase.celda(i.observacionInventario));
            table.addCell(GeneradorPDFBase.celda(i.nombreusuarioInventario));
            table.addCell(GeneradorPDFBase.celda(i.estadoInventario ? "Realizado" : "Por terminar"));
        }

        document.add(table);
        document.close();
    }
}
