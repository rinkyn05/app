import 'package:cloud_firestore/cloud_firestore.dart';

import '../../backend/models/category_in_post_model.dart';

class UpdatePostFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updatePost({
    required String id,
    required String nombreEsp,
    required String nombreEng,
    required String descripcionEsp,
    required String descripcionEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String imageUrl,
    required List<SelectedCategory> selectedCategories,
    required List<String> categories,
  }) async {
    await _firestore.collection('posts').doc(id).update({
      'NombreEsp': nombreEsp,
      'NombreEng': nombreEng,
      'DescripcionEsp': descripcionEsp,
      'DescripcionEng': descripcionEng,
      'ContenidoEsp': contenidoEsp,
      'ContenidoEng': contenidoEng,
      'Imagen': imageUrl,
      'Categorias': selectedCategories.map((c) => c.toMap()).toList(),
    });
  }
}
