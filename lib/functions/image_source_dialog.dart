import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> showImageSourceDialog(BuildContext context) async {
  return showDialog<ImageSource>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Elija la fuente de la imagen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Cámara'),
            onTap: () {
              Navigator.pop(context, ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galería'),
            onTap: () {
              Navigator.pop(context, ImageSource.gallery);
            },
          ),
        ],
      ),
    ),
  );
}
