import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gestion_clientes/models/cliente.dart';
import 'package:gestion_clientes/models/registro.dart';
import 'package:gestion_clientes/screens/registros/registro_form.dart';
import 'package:provider/provider.dart';
import 'package:gestion_clientes/services/cliente_service.dart';
import 'package:gestion_clientes/services/registro_service.dart';

/// Pantalla que muestra la lista de registros asociados a clientes.
/// Permite crear, editar, eliminar y ver detalles de cada registro.
class RegistroListScreen extends StatelessWidget {
  const RegistroListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtiene los registros y clientes desde los servicios mediante Provider
    final registros = Provider.of<RegistroService>(context).registros;
    final clienteService = Provider.of<ClienteService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Registros'),
        actions: [
          // Botón para añadir un nuevo registro
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegistroFormScreen(),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: registros.length,
        itemBuilder: (context, index) {
          final registro = registros[index];

          // Busca el cliente correspondiente al registro actual
          final cliente = clienteService.obtenerClientePorId(
            registro.clienteId,
          );

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                cliente != null
                    ? '${cliente.name} ${cliente.lastName}'
                    : 'Cliente no encontrado',
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fecha: ${registro.fechaFormateada}'),
                  Text('Mascota: ${registro.mascota}'),
                  if (registro.imagePath != null)
                    const Text('(Con imagen adjunta)'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón para editar el registro
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RegistroFormScreen(registro: registro),
                      ),
                    ),
                  ),
                  // Botón para eliminar el registro
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteDialog(context, registro.id),
                  ),
                ],
              ),
              // Muestra detalles del registro al hacer tap
              onTap: () => _showDetailsDialog(context, registro, cliente),
            ),
          );
        },
      ),
    );
  }

  /// Muestra un cuadro de diálogo para confirmar la eliminación del registro.
  void _showDeleteDialog(BuildContext context, String registroId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Registro'),
        content: const Text('¿Está seguro que desea eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Elimina el registro a través del servicio
              Provider.of<RegistroService>(
                context,
                listen: false,
              ).eliminarRegistro(registroId);
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Muestra un cuadro de diálogo con los detalles completos del registro.
  void _showDetailsDialog(
    BuildContext context,
    Registro registro,
    Cliente? cliente,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles del Registro'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (cliente != null)
                Text('Cliente: ${cliente.name} ${cliente.lastName}'),
              Text('Fecha: ${registro.fechaFormateada}'),
              Text('Mascota: ${registro.mascota}'),
              const SizedBox(height: 10),
              const Text(
                'Requerimiento:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(registro.requerimiento),
              if (registro.imagePath != null) ...[
                const SizedBox(height: 10),
                const Text(
                  'Imagen adjunta:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Image.file(
                  File(registro.imagePath!),
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
