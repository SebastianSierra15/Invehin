package Utils.Pedidos;

import Logica.Pedido;
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
public class GeneradorReportesPedidosExcel
{

    public static void generarPedidosExcel(List<Pedido> pedidos, OutputStream out) throws IOException
    {
        Workbook workbook = GeneradorExcelBase.crearWorkbook();
        Sheet sheet = workbook.createSheet("Pedidos");

        CellStyle headerStyle = GeneradorExcelBase.estiloEncabezado(workbook);
        CellStyle cellStyle = GeneradorExcelBase.estiloContenido(workbook);

        String[] columnas =
        {
             "Id", "Fecha", "Proveedor", "Precio Total", "Cantidad Prendas", "Estado"
        };

        GeneradorExcelBase.crearEncabezado(sheet, columnas, headerStyle);

        int rowIdx = 1;
        for (Pedido p : pedidos)
        {
            Row row = sheet.createRow(rowIdx++);
            row.createCell(0).setCellValue(p.idPedido);
            row.createCell(1).setCellValue(p.fechaPedido);
            row.createCell(2).setCellValue(p.proveedorPedido.nombreProveedor);
            row.createCell(3).setCellValue(p.preciototalPedido);
            row.createCell(4).setCellValue(p.cantidadPedido);
            row.createCell(5).setCellValue(p.estadoPedido ? "Entregado" : "Pendiente");

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
