import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
//import '../registro.dart'; // Tu archivo real en lib/
import 'package:sistema_actividades/models/registro_model.dart';

class PdfPage extends StatelessWidget {
  final List<Registro> registros;

  const PdfPage({super.key, required this.registros});

  // Función asíncrona encargada de construir el documento PDF binario
  Future<Uint8List> _generarPdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Encabezado del reporte
                pw.Text(
                  'Reporte Oficial de Registros',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  'Materia: Programación Móvil - Proyecto Flutter',
                  style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
                ),
                pw.Divider(thickness: 2, color: PdfColors.indigo),
                pw.SizedBox(height: 20),

                // Validación: Si la lista está vacía imprimimos un aviso en el papel
                registros.isEmpty
                    ? pw.Text(
                  'No existen registros cargados en el sistema para exportar.',
                  style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
                )
                    : pw.ListView.builder(
                  itemCount: registros.length,
                  itemBuilder: (context, index) {
                    final r = registros[index];
                    return pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 12),
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey400),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            '${index + 1}. Título: ${r.titulo}',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text('Descripción: ${r.descripcion}', style: const pw.TextStyle(fontSize: 12)),
                          pw.SizedBox(height: 6),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('Responsable: ${r.responsable}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                              pw.Text('Fecha: ${r.fecha}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save(); // Devuelve el PDF listo en bytes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsualización del Reporte PDF'),
        backgroundColor: Colors.indigo.shade50,
      ),
      body: PdfPreview(
        build: (format) => _generarPdf(format),
        allowPrinting: true, // Habilita la opción de imprimir directo
        allowSharing: true,  // Habilita la opción de descargar / compartir por WhatsApp, Drive, etc.
        canChangePageFormat: false,
      ),
    );
  }
}