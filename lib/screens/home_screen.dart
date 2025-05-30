import 'package:flutter/material.dart';

/// Pantalla principal (HomeScreen) de la aplicación.
/// Proporciona acceso a las funcionalidades principales:
/// - Ingreso de Cliente
/// - Crear Registro
/// - Lista de Clientes
/// - Lista de Registros
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior con título centrado
      appBar: AppBar(
        title: const Text('Gestión de Clientes'),
        centerTitle: true,
      ),
      // Cuerpo con botones de acción centrados verticalmente
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton(
              context,
              'Ingreso de Cliente',
              Icons.person_add,
              '/clientes-form', // Ruta definida en tu sistema de navegación
            ),
            const SizedBox(height: 20),
            _buildActionButton(
              context,
              'Crear Registro',
              Icons.note_add,
              '/registros-form',
            ),
            const SizedBox(height: 20),
            _buildActionButton(
              context,
              'Lista de Clientes',
              Icons.people,
              '/clientes-list',
            ),
            const SizedBox(height: 20),
            _buildActionButton(
              context,
              'Lista de Registros',
              Icons.list,
              '/registros-list',
            ),
          ],
        ),
      ),
    );
  }

  /// Crea un botón con ícono y texto, que navega a una ruta específica.
  ///
  /// [context] es el contexto de la aplicación.
  /// [text] es el texto del botón.
  /// [icon] es el ícono que acompaña el texto.
  /// [route] es la ruta de navegación que se activará al presionar el botón.
  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    String route,
  ) {
    return SizedBox(
      width: 250,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24),
        label: Text(text, style: const TextStyle(fontSize: 18)),
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
