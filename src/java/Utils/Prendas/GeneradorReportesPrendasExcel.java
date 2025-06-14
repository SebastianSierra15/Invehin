package Utils.Prendas;

import Logica.Prenda;
import Utils.GeneradorExcelBase;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

/**
 *
 * @author Ing. Sebastian Sierra
 */
public class GeneradorReportesPrendasExcel
{

    public static void generarPrendasExcel(List<Prenda> prendas, OutputStream out) throws IOException
    {
        Workbook workbook = GeneradorExcelBase.crearWorkbook();
        Sheet sheet = workbook.createSheet("Prendas");

        CellStyle headerStyle = GeneradorExcelBase.estiloEncabezado(workbook);
        CellStyle cellStyle = GeneradorExcelBase.estiloContenido(workbook);

        String[] columnas =
        {
             "Código", "Categoría", "Subcategoría", "Talla", "Color", "Precio", "Stock", "Stock mínimo", "Estado"
        };

        GeneradorExcelBase.crearEncabezado(sheet, columnas, headerStyle);

        int rowIdx = 1;
        for (Prenda p : prendas)
        {
            Row row = sheet.createRow(rowIdx++);
            row.createCell(0).setCellValue(p.codigoPrenda);
            row.createCell(1).setCellValue(p.subcategoriaPrenda.categoriaSubcategoria.nombreCategoria);
            row.createCell(2).setCellValue(p.subcategoriaPrenda.nombreSubcategoria);
            row.createCell(3).setCellValue(p.tallaPrenda.nombreTalla);
            row.createCell(4).setCellValue(p.colorPrenda.nombreColor);
            row.createCell(5).setCellValue(p.subcategoriaPrenda.precioSubcategoria);
            row.createCell(6).setCellValue(p.stockPrenda);
            row.createCell(7).setCellValue(p.stockminimoPrenda);
            row.createCell(8).setCellValue(p.estadoprendaPrenda.nombreEstadoPrenda);

            for (int i = 0; i < columnas.length; i++)
            {
                row.getCell(i).setCellStyle(cellStyle);
            }
        }

        GeneradorExcelBase.ajustarColumnas(sheet, columnas.length);

        workbook.write(out);
        workbook.close();
    }
}
