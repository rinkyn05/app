import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAlimentosFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAlimentosWithAutoIncrementId({
    required String nombreEsp,
    required String nombreEng,
    required String contenidoEsp,
    required String contenidoEng,
    required String video,
    required String calorias,
    required String proteina,
    required String porcion,
    required String gsaturadas,
    required String gMonoinsaturadas,
    required String gPoliinsaturadas,
    required String gHidrogenadas,
    required String grasa,
    required String carbohidrato,
    required String vitamina,
    required String fibra,
    required String azucar,
    required String sodio,
    required String imageUrl,
    required String membershipEsp,
    required String membershipEng,
    required String categoryEsp,
    required String categoryEng,
    required String tipoEsp,
    required String tipoEng,
    required String tipoGrasaEsp,
    required String tipoGrasaEng,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    String userName = userDoc.exists ? userDoc.get('Nombre') : '';

    DocumentReference metadataRef =
        _firestore.collection('metadata').doc('alimentosData');
    DocumentSnapshot metadataSnapshot = await metadataRef.get();
    int lastAlimentosId =
        metadataSnapshot.exists ? metadataSnapshot.get('lastAlimentosId') : 0;
    int newAlimentosId = lastAlimentosId + 1;
    String alimentosId = newAlimentosId.toString();

    await metadataRef.set({'lastAlimentosId': newAlimentosId});

    await _firestore.collection('alimentos').doc(alimentosId).set({
      'NombreEsp': nombreEsp,
      'NombreEng': nombreEng,
      'ContenidoEsp': contenidoEsp,
      'ContenidoEng': contenidoEng,
      'Video': video,
      'Calorias': calorias,
      'Proteina': proteina,
      'Porcion': porcion,
      'GrasaSaturadas': gsaturadas,
      'GrasaMonoinsaturadas': gMonoinsaturadas,
      'GrasaPoliinsaturadas': gPoliinsaturadas,
      'GrasaHidrogenadas': gHidrogenadas,
      'Grasa': grasa,
      'Carbohidrato': carbohidrato,
      'Vitamina': vitamina,
      'Fibra': fibra,
      'Azucar': azucar,
      'Sodio': sodio,
      'URL de la Imagen': imageUrl,
      'MembershipEsp': membershipEsp,
      'MembershipEng': membershipEng,
      'CategoryEsp': categoryEsp,
      'CategoryEng': categoryEng,
      'TipoEsp': tipoEsp,
      'TipoEng': tipoEng,
      'TipoGrasaEsp': tipoGrasaEsp,
      'TipoGrasaEng': tipoGrasaEng,
      'Nombre de Usuario': userName,
      'Correo Electrónico': user.email ?? '',
      'Fecha': DateTime.now(),
    });
  }
}
