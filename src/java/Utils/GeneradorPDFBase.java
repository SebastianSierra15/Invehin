package Utils;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.OutputStream;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class GeneradorPDFBase
{

    public static Document crearDocumento(OutputStream out, String titulo) throws DocumentException
    {
        Document document = new Document(PageSize.A4.rotate());
        PdfWriter.getInstance(document, out);
        document.open();

        Font tituloFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, new BaseColor(149, 21, 86));
        Paragraph tituloParrafo = new Paragraph(titulo, tituloFont);
        tituloParrafo.setAlignment(Element.ALIGN_CENTER);
        tituloParrafo.setSpacingAfter(15f);

        document.add(tituloParrafo);
        return document;
    }

    public static PdfPTable crearTablaConEncabezados(String[] headers)
    {
        PdfPTable table = new PdfPTable(headers.length);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);

        Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.WHITE);
        BaseColor headerBg = new BaseColor(149, 21, 86);

        for (String header : headers)
        {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(headerBg);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setPadding(8f);
            table.addCell(cell);
        }

        return table;
    }

    public static PdfPCell celda(String texto)
    {
        Font bodyFont = new Font(Font.FontFamily.HELVETICA, 11);
        PdfPCell cell = new PdfPCell(new Phrase(texto, bodyFont));
        cell.setPadding(6f);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        return cell;
    }
}
