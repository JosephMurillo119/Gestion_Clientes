import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Servicio para seleccionar y guardar imágenes localmente desde la galería.
///
/// Utiliza `image_picker` para obtener la imagen y `path_provider` para
/// guardar el archivo en el directorio de documentos de la aplicación.
class ImageService {
  /// Instancia de ImagePicker para seleccionar imágenes desde la galería.
  final ImagePicker _picker = ImagePicker();

  /// Permite al usuario seleccionar una imagen de la galería y guardarla localmente.
  ///
  /// Retorna la ruta del archivo guardado si la imagen fue seleccionada y guardada correctamente.
  /// Si el usuario cancela la selección o ocurre un error, retorna `null`.
  Future<String?> pickAndSaveImage() async {
    try {
      // Abre la galería para seleccionar una imagen
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      // Si no se seleccionó ninguna imagen, retornar null
      if (image == null) return null;

      // Obtiene el directorio de documentos de la app
      final directory = await getApplicationDocumentsDirectory();

      // Obtiene el nombre del archivo desde la ruta original
      final fileName = path.basename(image.path);

      // Copia la imagen seleccionada a la ruta de almacenamiento interno
      final savedImage = await File(
        image.path,
      ).copy('${directory.path}/$fileName');

      // Retorna la ruta donde fue guardada la imagen
      return savedImage.path;
    } catch (e) {
      // En caso de error, imprime en consola y retorna null
      debugPrint('Error al seleccionar imagen: $e');
      return null;
    }
  }
}
