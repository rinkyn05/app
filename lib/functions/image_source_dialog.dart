import 'package:flutter/material.dart'; // Importa el paquete de Material Design de Flutter.
import 'package:image_picker/image_picker.dart'; // Importa el paquete de Image Picker para seleccionar imágenes.

/// Muestra un cuadro de diálogo para seleccionar la fuente de una imagen.
///
/// Esta función muestra un diálogo que permite al usuario elegir entre
/// usar la cámara o seleccionar una imagen de la galería.
///
/// Devuelve la fuente de la imagen seleccionada como un valor de tipo [ImageSource].
Future<ImageSource?> showImageSourceDialog(BuildContext context) async {
  return showDialog<ImageSource>(
    // Muestra un diálogo que retorna un valor de tipo ImageSource.
    context: context, // Contexto de la aplicación para el diálogo.
    builder: (BuildContext context) => AlertDialog(
      // Crea un AlertDialog.
      title: const Text('Elija la fuente de la imagen'), // Título del diálogo.
      content: Column(
        // Contenido del diálogo.
        mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del contenido.
        children: [
          // Opción para usar la cámara.
          ListTile(
            leading: const Icon(Icons.camera_alt), // Icono de la cámara.
            title: const Text('Cámara'), // Texto del elemento del menú.
            onTap: () {
              // Acción al tocar la opción.
              Navigator.pop(
                  context,
                  ImageSource
                      .camera); // Cierra el diálogo y devuelve ImageSource.camera.
            },
          ),
          // Opción para seleccionar de la galería.
          ListTile(
            leading: const Icon(Icons.photo_library), // Icono de la galería.
            title: const Text('Galería'), // Texto del elemento del menú.
            onTap: () {
              // Acción al tocar la opción.
              Navigator.pop(
                  context,
                  ImageSource
                      .gallery); // Cierra el diálogo y devuelve ImageSource.gallery.
            },
          ),
        ],
      ),
    ),
  );
}
