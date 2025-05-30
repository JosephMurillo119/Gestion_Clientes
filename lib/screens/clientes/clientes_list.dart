import 'package:flutter/material.dart';
import 'package:gestion_clientes/models/cliente.dart';
import 'package:gestion_clientes/screens/clientes/clientes_form.dart';
import 'package:provider/provider.dart';
import 'package:gestion_clientes/services/cliente_service.dart';

/// Pantalla que muestra una lista de clientes con opciones para agregar, editar o eliminar.
class ClienteListScreen extends StatelessWidget {
  const ClienteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtiene la lista de clientes desde el servicio usando Provider.
    final clientes = Provider.of<ClienteService>(context).clientes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
        actions: [
          // Botón para agregar un nuevo cliente, abre la pantalla de formulario.
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ClienteFormScreen(),
              ),
            ),
          ),
        ],
      ),
      // Lista dinámica de clientes
      body: ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          final cliente = clientes[index];
          return ListTile(
            title: Text('${cliente.name} ${cliente.lastName}'),
            subtitle: Text(
              'ID: ${cliente.identification} - Edad: ${cliente.age}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Botón para editar cliente. Navega al formulario con los datos cargados.
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClienteFormScreen(cliente: cliente),
                    ),
                  ),
                ),
                // Botón para eliminar cliente. Muestra un diálogo de confirmación.
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, cliente.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Muestra un cuadro de diálogo para confirmar la eliminación de un cliente.
  void _showDeleteDialog(BuildContext context, String clienteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Cliente'),
        content: const Text('¿Está seguro que desea eliminar este cliente?'),
        actions: [
          // Cancela la acción
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          // Confirma la eliminación
          TextButton(
            onPressed: () {
              // Elimina el cliente usando el servicio.
              Provider.of<ClienteService>(
                context,
                listen: false,
              ).eliminarCliente(clienteId);

              Navigator.pop(context); // Cierra el diálogo
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
