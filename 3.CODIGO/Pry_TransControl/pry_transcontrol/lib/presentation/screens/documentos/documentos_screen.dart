import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../business/entities/documento.dart';

class DocumentosScreen extends ConsumerWidget {
  const DocumentosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Para demo, mostraremos documentos ficticios
    final documentosFicticios = [
      Documento(
        id: 'DOC001',
        nombre: 'Licencia Conducción',
        tipo: TipoDocumento.licencia,
        propietarioId: 'TRAN001',
        estado: EstadoDocumento.aprobado,
        fechaCarga: DateTime(2024, 1, 15),
        fechaVencimiento: DateTime(2027, 12, 31),
      ),
      Documento(
        id: 'DOC002',
        nombre: 'Certificado Técnico-Mecánico',
        tipo: TipoDocumento.tecnicomecanica,
        propietarioId: 'TRAN001',
        estado: EstadoDocumento.aprobado,
        fechaCarga: DateTime(2024, 2, 20),
        fechaVencimiento: DateTime(2025, 6, 30),
      ),
      Documento(
        id: 'DOC003',
        nombre: 'Póliza de Seguro',
        tipo: TipoDocumento.seguro,
        propietarioId: 'TRAN001',
        estado: EstadoDocumento.pendiente,
        fechaCarga: DateTime(2024, 3, 1),
        fechaVencimiento: DateTime(2025, 3, 31),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Documentos')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: documentosFicticios.length,
        itemBuilder: (context, index) {
          final documento = documentosFicticios[index];
          return _buildDocumentoCard(context, documento);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Funcionalidad de carga de documentos'),
            ),
          );
        },
        child: const Icon(Icons.upload),
      ),
    );
  }

  Widget _buildDocumentoCard(BuildContext context, Documento documento) {
    final estadoColor = _getEstadoColor(documento.estado);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: estadoColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.description, color: estadoColor),
        ),
        title: Text(documento.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${documento.tipo.toString().split('.').last}'),
            if (documento.fechaVencimiento != null)
              Text('Vence: ${documento.fechaVencimiento}'),
          ],
        ),
        trailing: Chip(
          label: Text(_getEstadoLabel(documento.estado)),
          backgroundColor: estadoColor.withOpacity(0.2),
          labelStyle: TextStyle(color: estadoColor),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(documento.nombre),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Estado: ${_getEstadoLabel(documento.estado)}'),
                  if (documento.fechaVencimiento != null)
                    Text('Vence: ${documento.fechaVencimiento}'),
                  if (documento.observaciones != null)
                    Text('Observaciones: ${documento.observaciones}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getEstadoColor(EstadoDocumento estado) {
    switch (estado) {
      case EstadoDocumento.pendiente:
        return Colors.orange;
      case EstadoDocumento.aprobado:
        return Colors.green;
      case EstadoDocumento.rechazado:
        return Colors.red;
      case EstadoDocumento.vencido:
        return Colors.red;
    }
  }

  String _getEstadoLabel(EstadoDocumento estado) {
    switch (estado) {
      case EstadoDocumento.pendiente:
        return 'Pendiente';
      case EstadoDocumento.aprobado:
        return 'Aprobado';
      case EstadoDocumento.rechazado:
        return 'Rechazado';
      case EstadoDocumento.vencido:
        return 'Vencido';
    }
  }
}
