import 'package:flutter/material.dart';
import 'package:gestion_clientes/models/cliente.dart';

/// Servicio de gestión de clientes.
/// Utiliza `ChangeNotifier` para notificar a los widgets que estén escuchando
/// cuando se realizan cambios en la lista de clientes.
class ClienteService with ChangeNotifier {
  /// Lista privada de clientes
  final List<Cliente> _clientes = [];

  /// Getter público para acceder a la lista de clientes
  List<Cliente> get clientes => _clientes;

  /// Agrega un nuevo cliente a la lista y notifica a los oyentes.
  ///
  /// [cliente] es el objeto Cliente que se desea agregar.
  void agregarCliente(Cliente cliente) {
    _clientes.add(cliente);
    notifyListeners(); // Notifica a los widgets que usan esta lista
  }

  /// Actualiza la información de un cliente existente y notifica a los oyentes.

  /// [id]
  /// [nuevoCliente] contiene los datos actualizados.
  void actualizarCliente(String id, Cliente nuevoCliente) {
    final index = _clientes.indexWhere((c) => c.id == id);
    if (index != -1) {
      _clientes[index] = nuevoCliente;
      notifyListeners();
    }
  }

  /// Elimina un cliente de la lista por su ID y notifica a los oyentes.
  ///
  /// [id] es el identificador del cliente a eliminar.
  void eliminarCliente(String id) {
    _clientes.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  /// Obtiene un cliente por su ID.
  ///
  /// [id] es el identificador del cliente a buscar.
  /// Retorna el cliente si se encuentra, o `null` si no existe.
  Cliente? obtenerClientePorId(String id) {
    try {
      return _clientes.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
