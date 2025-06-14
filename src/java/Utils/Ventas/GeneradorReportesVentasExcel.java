package Utils.Ventas;

import Logica.Venta;
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
public class GeneradorReportesVentasExcel
{

    public static void generarVentasExcel(List<Venta> ventas, OutputStream out) throws IOException
    {
        Workbook workbook = GeneradorExcelBase.crearWorkbook();
        Sheet sheet = workbook.createSheet("Ventas");

        CellStyle headerStyle = GeneradorExcelBase.estiloEncabezado(workbook);
        CellStyle cellStyle = GeneradorExcelBase.estiloContenido(workbook);

        String[] columnas =
        {
            "ID", "Fecha", "Cliente", "Método Pago", "Cantidad", "Total", "Recibido", "Estado"
        };

        GeneradorExcelBase.crearEncabezado(sheet, columnas, headerStyle);

        int rowIdx = 1;
        for (Venta v : ventas)
        {
            Row row = sheet.createRow(rowIdx++);
            row.createCell(0).setCellValue(v.idVenta);
            row.createCell(1).setCellValue(v.fechaVenta.toString());
            row.createCell(2).setCellValue(v.clienteVenta.nombresPersona + " " + v.clienteVenta.apellidosPersona);
            row.createCell(3).setCellValue(v.metodopagoVenta.nombreMetodoPago);
            row.createCell(4).setCellValue(v.cantidadVenta);
            row.createCell(5).setCellValue(v.preciototalVenta);
            row.createCell(6).setCellValue(v.montorecibidoVenta);
            row.createCell(7).setCellValue(v.estadoVenta ? "Activo" : "Inactivo");

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
