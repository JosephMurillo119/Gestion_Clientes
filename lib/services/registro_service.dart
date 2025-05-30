import 'package:flutter/material.dart';
import 'package:gestion_clientes/models/registro.dart';

/// Servicio que gestiona la lista de registros de clientes.
///
/// Utiliza `ChangeNotifier` para notificar a los widgets que escuchan
/// cuando hay cambios en la lista de registros.
class RegistroService with ChangeNotifier {
  /// Lista privada que almacena todos los registros.
  final List<Registro> _registros = [];

  /// Obtiene la lista completa de registros.
  List<Registro> get registros => _registros;

  /// Agrega un nuevo registro a la lista y notifica a los oyentes.
  void agregarRegistro(Registro registro) {
    _registros.add(registro);
    notifyListeners();
  }

  /// Actualiza un registro existente identificado por su [id].
  ///
  /// Si se encuentra el registro, se reemplaza por [nuevoRegistro]
  /// y se notifica a los oyentes.
  void actualizarRegistro(String id, Registro nuevoRegistro) {
    final index = _registros.indexWhere((r) => r.id == id);
    if (index != -1) {
      _registros[index] = nuevoRegistro;
      notifyListeners();
    }
  }

  /// Elimina un registro de la lista según su [id].
  ///
  /// Después de eliminar, notifica a los oyentes.
  void eliminarRegistro(String id) {
    _registros.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  /// Retorna una lista de registros asociados a un cliente específico [clienteId].
  List<Registro> registrosPorCliente(String clienteId) {
    return _registros.where((r) => r.clienteId == clienteId).toList();
  }
}
