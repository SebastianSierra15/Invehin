package Utils.Prendas;

import Logica.Prenda;
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
public class GeneradorReportesPrendasPDF {

    public static void generarPrendasPDF(List<Prenda> prendas, OutputStream out) throws IOException, DocumentException
    {
        // Crear documento con título
        Document document = GeneradorPDFBase.crearDocumento(out, "Reporte de Prendas");

        // Crear encabezados
        String[] encabezados =
        {
            "Código", "Categoría", "Subcategoría", "Talla", "Color", "Precio", "Stock", "Stock mínimo", "Estado"
        };

        PdfPTable table = GeneradorPDFBase.crearTablaConEncabezados(encabezados);

        // Agregar los datos
        for (Prenda p : prendas)
        {
            table.addCell(GeneradorPDFBase.celda(String.valueOf(p.codigoPrenda)));
            table.addCell(GeneradorPDFBase.celda(p.subcategoriaPrenda.categoriaSubcategoria.nombreCategoria));
            table.addCell(GeneradorPDFBase.celda(p.subcategoriaPrenda.nombreSubcategoria));
            table.addCell(GeneradorPDFBase.celda(p.tallaPrenda.nombreTalla));
            table.addCell(GeneradorPDFBase.celda(p.colorPrenda.nombreColor));
            table.addCell(GeneradorPDFBase.celda("$" + String.format("%,d", p.subcategoriaPrenda.precioSubcategoria)));
            table.addCell(GeneradorPDFBase.celda(String.format("%,d", p.stockPrenda)));
            table.addCell(GeneradorPDFBase.celda(String.format("%,d", p.stockminimoPrenda)));
            table.addCell(GeneradorPDFBase.celda(p.estadoprendaPrenda.nombreEstadoPrenda));
        }

        document.add(table);
        document.close();
    }
}
