package Utils;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class GeneradorExcelBase
{

    public static Workbook crearWorkbook()
    {
        return new XSSFWorkbook();
    }

    public static CellStyle estiloEncabezado(Workbook workbook)
    {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.WHITE.getIndex());
        font.setFontHeightInPoints((short) 12);
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.DARK_RED.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        return style;
    }

    public static CellStyle estiloContenido(Workbook workbook)
    {
        CellStyle style = workbook.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        return style;
    }

    public static void crearEncabezado(Sheet sheet, String[] columnas, CellStyle style)
    {
        Row header = sheet.createRow(0);
        for (int i = 0; i < columnas.length; i++)
        {
            Cell cell = header.createCell(i);
            cell.setCellValue(columnas[i]);
            cell.setCellStyle(style);
        }
    }

    public static void ajustarColumnas(Sheet sheet, int numColumnas)
    {
        for (int i = 0; i < numColumnas; i++)
        {
            sheet.autoSizeColumn(i);
        }
    }
}
