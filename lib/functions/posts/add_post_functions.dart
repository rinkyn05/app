import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../backend/models/category_in_post_model.dart';

class AddPostFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPostWithAutoIncrementId({
    required String nombreEsp,
    required String descripcionEsp,
    required String nombreEng,
    required String descripcionEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String imageUrl,
    required List<SelectedCategory> selectedCategories,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    String userName = userDoc.exists ? userDoc.get('Nombre') : '';

    DocumentReference metadataRef =
        _firestore.collection('metadata').doc('postData');
    DocumentSnapshot metadataSnapshot = await metadataRef.get();
    int lastPostId =
        metadataSnapshot.exists ? metadataSnapshot.get('lastPostId') : 0;
    int newPostId = lastPostId + 1;
    String postId = newPostId.toString();

    await metadataRef.set({'lastPostId': newPostId});

    await _firestore.collection('posts').doc(postId).set({
      'NombreEsp': nombreEsp,
      'DescripcionEsp': descripcionEsp,
      'NombreEng': nombreEng,
      'DescripcionEng': descripcionEng,
      'ContenidoEsp': contenidoEsp,
      'ContenidoEng': contenidoEng,
      'Categorias': selectedCategories
          .map((c) => {
                'id': c.id,
                'NombreEsp': c.categoryEsp,
                'NombreEng': c.categoryEng,
              })
          .toList(),
      'URL de la Imagen': imageUrl,
      'Nombre de Usuario': userName,
      'Correo Electrónico': user.email ?? '',
      'Fecha': DateTime.now(),
    });

    for (var category in selectedCategories) {
      DocumentReference categoryPostRef =
          _firestore.collection('categorypost').doc(category.id);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(categoryPostRef);
        if (snapshot.exists) {
          transaction.update(categoryPostRef, {
            'posts': FieldValue.arrayUnion([postId]),
            'postDetails': FieldValue.arrayUnion([
              {
                'postId': postId,
                'NombreEsp': nombreEsp,
                'DescripcionEsp': descripcionEsp,
                'NombreEng': nombreEng,
                'DescripcionEng': descripcionEng,
              }
            ])
          });
        } else {
          transaction.set(categoryPostRef, {
            'posts': [postId],
            'postDetails': [
              {
                'postId': postId,
                'NombreEsp': nombreEsp,
                'DescripcionEsp': descripcionEsp,
                'NombreEng': nombreEng,
                'DescripcionEng': descripcionEng,
              }
            ]
          });
        }
      });
    }
  }
}
