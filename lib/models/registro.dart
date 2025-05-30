import 'package:intl/intl.dart';

class Registro {
  final String id;
  final String clienteId;
  final DateTime fecha;
  final String mascota;
  final String requerimiento;
  final String? imagePath;

  Registro({
    required this.id,
    required this.clienteId,
    required this.fecha,
    required this.mascota,
    required this.requerimiento,
    this.imagePath,
  });

  String get fechaFormateada => DateFormat('dd/MM/yyyy HH:mm').format(fecha);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'fecha': fecha.toIso8601String(),
      'mascota': mascota,
      'requerimiento': requerimiento,
      'imagePath': imagePath,
    };
  }

  factory Registro.fromMap(Map<String, dynamic> map) {
    return Registro(
      id: map['id'],
      clienteId: map['clienteId'],
      fecha: DateTime.parse(map['fecha']),
      mascota: map['mascota'],
      requerimiento: map['requerimiento'],
      imagePath: map['imagePath'],
    );
  }
}
