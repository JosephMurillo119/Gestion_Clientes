import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gestion_clientes/models/cliente.dart';
import 'package:gestion_clientes/models/registro.dart';
import 'package:gestion_clientes/services/cliente_service.dart';
import 'package:gestion_clientes/services/image_service.dart';
import 'package:gestion_clientes/services/registro_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/// Pantalla para crear o editar un registro asociado a un cliente.
/// Permite seleccionar un cliente, ingresar datos de la mascota, requerimientos
/// y agregar una imagen relacionada al registro.
class RegistroFormScreen extends StatefulWidget {
  final Registro? registro;

  const RegistroFormScreen({super.key, this.registro});

  @override
  State<RegistroFormScreen> createState() => _RegistroFormScreenState();
}

class _RegistroFormScreenState extends State<RegistroFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mascotaController = TextEditingController();
  final _requerimientoController = TextEditingController();

  String? _selectedClienteId;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    // Si se recibe un registro (modo edición), llenar los campos con los datos existentes
    if (widget.registro != null) {
      _selectedClienteId = widget.registro!.clienteId;
      _mascotaController.text = widget.registro!.mascota;
      _requerimientoController.text = widget.registro!.requerimiento;
      _imagePath = widget.registro!.imagePath;
    }
  }

  @override
  void dispose() {
    _mascotaController.dispose();
    _requerimientoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientes = Provider.of<ClienteService>(context).clientes;
    final registroService = Provider.of<RegistroService>(context);
    final imageService = ImageService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.registro == null ? 'Nuevo Registro' : 'Editar Registro',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo desplegable para seleccionar el cliente asociado al registro
              DropdownButtonFormField<String>(
                value: _selectedClienteId,
                decoration: const InputDecoration(labelText: 'Cliente'),
                items: clientes.map((cliente) {
                  return DropdownMenuItem(
                    value: cliente.id,
                    child: Text('${cliente.name} ${cliente.lastName}'),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedClienteId = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione un cliente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Campo de fecha (solo visualización, no editable)
              TextFormField(
                controller: TextEditingController(
                  text: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                ),
                decoration: const InputDecoration(labelText: 'Fecha'),
                enabled: false,
              ),
              const SizedBox(height: 16),
              // Campo para ingresar el nombre o tipo de mascota
              TextFormField(
                controller: _mascotaController,
                decoration: const InputDecoration(labelText: 'Mascota'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese información sobre la mascota';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Campo para ingresar los requerimientos relacionados al registro
              TextFormField(
                controller: _requerimientoController,
                decoration: const InputDecoration(labelText: 'Requerimiento'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el requerimiento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Vista previa de la imagen si existe una cargada
              if (_imagePath != null)
                Image.file(File(_imagePath!), height: 150, fit: BoxFit.cover),
              // Botón para seleccionar y guardar una imagen desde la galería
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Cargar Imagen'),
                onPressed: () async {
                  final path = await imageService.pickAndSaveImage();
                  if (path != null) {
                    setState(() => _imagePath = path);
                  }
                },
              ),
              const SizedBox(height: 20),
              // Botón para enviar el formulario
              ElevatedButton(
                onPressed: () => _submitForm(registroService),
                child: const Text('Guardar Registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Envía el formulario. Si es válido, guarda o actualiza el registro.
  void _submitForm(RegistroService registroService) {
    if (_formKey.currentState!.validate() && _selectedClienteId != null) {
      final registro = Registro(
        id: widget.registro?.id ?? const Uuid().v4(),
        clienteId: _selectedClienteId!,
        fecha: DateTime.now(),
        mascota: _mascotaController.text,
        requerimiento: _requerimientoController.text,
        imagePath: _imagePath,
      );

      if (widget.registro == null) {
        // Crear nuevo registro
        registroService.agregarRegistro(registro);
      } else {
        // Actualizar registro existente
        registroService.actualizarRegistro(registro.id, registro);
      }

      // Cierra la pantalla y vuelve a la anterior
      Navigator.pop(context);
    }
  }
}
