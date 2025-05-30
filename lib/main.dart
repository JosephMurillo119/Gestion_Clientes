import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importación de pantallas
import 'package:gestion_clientes/screens/home_screen.dart';
import 'package:gestion_clientes/screens/clientes/clientes_form.dart';
import 'package:gestion_clientes/screens/clientes/clientes_list.dart';
import 'package:gestion_clientes/screens/registros/registro_form.dart';
import 'package:gestion_clientes/screens/registros/registro_list.dart';

// Importación de servicios
import 'package:gestion_clientes/services/cliente_service.dart';
import 'package:gestion_clientes/services/registro_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClienteService()),
        ChangeNotifierProvider(create: (_) => RegistroService()),
      ],
      child: const MyApp(),
    ),
  );
}

/// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Clientes',
      debugShowCheckedModeBanner: false, // Quita la etiqueta DEBUG
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Ruta inicial
      initialRoute: '/',
      // Definición de rutas
      routes: {
        '/': (context) => const HomeScreen(),
        '/clientes-form': (context) => const ClienteFormScreen(),
        '/clientes-list': (context) => const ClienteListScreen(),
        '/registros-form': (context) => const RegistroFormScreen(),
        '/registros-list': (context) => const RegistroListScreen(),
      },
    );
  }
}
