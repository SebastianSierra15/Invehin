package Utils.Inventarios;

import Logica.Inventario;
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
public class GeneradorReportesInventariosExcel
{

    public static void generarInventariosExcel(List<Inventario> inventarios, OutputStream out) throws IOException
    {
        Workbook workbook = GeneradorExcelBase.crearWorkbook();
        Sheet sheet = workbook.createSheet("Inventarios");

        CellStyle headerStyle = GeneradorExcelBase.estiloEncabezado(workbook);
        CellStyle cellStyle = GeneradorExcelBase.estiloContenido(workbook);

        String[] columnas =
        {
             "Id", "Fecha", "Observacion", "Usuario", "Estado"
        };

        GeneradorExcelBase.crearEncabezado(sheet, columnas, headerStyle);

        int rowIdx = 1;
        for (Inventario i : inventarios)
        {
            Row row = sheet.createRow(rowIdx++);
            row.createCell(0).setCellValue(i.idInventario);
            row.createCell(1).setCellValue(i.fechaInventario);
            row.createCell(2).setCellValue(i.observacionInventario);
            row.createCell(3).setCellValue(i.nombreusuarioInventario);
            row.createCell(4).setCellValue(i.estadoInventario ? "Realizado" : "Por terminar");

            for (int j = 0; j < columnas.length; j++)
            {
                row.getCell(j).setCellStyle(cellStyle);
            }
        }

        GeneradorExcelBase.ajustarColumnas(sheet, columnas.length);

        workbook.write(out);
        workbook.close();
    }
}
