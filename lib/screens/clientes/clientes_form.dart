import 'package:flutter/material.dart';
import 'package:gestion_clientes/models/cliente.dart';
import 'package:gestion_clientes/services/cliente_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/// Pantalla que muestra un formulario para crear o editar un cliente.
class ClienteFormScreen extends StatefulWidget {
  /// Cliente a editar (opcional). Si es null, se creará un nuevo cliente.
  final Cliente? cliente;

  const ClienteFormScreen({super.key, this.cliente});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  // Llave para validar el formulario.
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto.
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _identificationController = TextEditingController();

  /// Inicializa el estado del formulario. Si se pasa un cliente, carga sus datos en los campos.
  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _nameController.text = widget.cliente!.name;
      _lastNameController.text = widget.cliente!.lastName;
      _ageController.text = widget.cliente!.age.toString();
      _identificationController.text = widget.cliente!.identification;
    }
  }

  /// Libera los recursos utilizados por los controladores.
  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _identificationController.dispose();
    super.dispose();
  }

  /// Construye la interfaz de usuario del formulario.
  @override
  Widget build(BuildContext context) {
    // Obtiene el servicio de clientes desde el Provider.
    final clienteService = Provider.of<ClienteService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cliente == null ? 'Nuevo Cliente' : 'Editar Cliente',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo de texto para el nombre.
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              // Campo de texto para el apellido.
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el apellido';
                  }
                  return null;
                },
              ),
              // Campo de texto para la edad.
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la edad';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              // Campo de texto para la identificación.
              TextFormField(
                controller: _identificationController,
                decoration: const InputDecoration(labelText: 'Identificación'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la identificación';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Botón para guardar el cliente.
              ElevatedButton(
                onPressed: () => _submitForm(clienteService),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Valida el formulario y guarda o actualiza el cliente usando el servicio correspondiente.
  void _submitForm(ClienteService clienteService) {
    if (_formKey.currentState!.validate()) {
      final cliente = Cliente(
        id: widget.cliente?.id ?? const Uuid().v4(), // Usa UUID si es nuevo
        name: _nameController.text,
        lastName: _lastNameController.text,
        age: int.parse(_ageController.text),
        identification: _identificationController.text,
      );

      if (widget.cliente == null) {
        // Agrega un nuevo cliente
        clienteService.agregarCliente(cliente);
      } else {
        // Actualiza el cliente existente
        clienteService.actualizarCliente(cliente.id, cliente);
      }

      // Regresa a la pantalla anterior
      Navigator.pop(context);
    }
  }
}
