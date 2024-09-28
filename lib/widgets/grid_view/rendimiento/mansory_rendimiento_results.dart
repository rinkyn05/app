import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../config/lang/app_localization.dart';
import '../../../config/utils/appcolors.dart';
import '../../../screens/rendimiento/rendimiento_f_details.dart';

class MasonryRendimientoResults extends StatefulWidget {
  final String selectedIntensity;

  const MasonryRendimientoResults({
    Key? key,
    required this.selectedIntensity, // Recibe la selección de intensidad
  }) : super(key: key);

  @override
  _MasonryRendimientoResultsState createState() =>
      _MasonryRendimientoResultsState();
}

class _MasonryRendimientoResultsState extends State<MasonryRendimientoResults> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'cTcTIBOgM9E',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('results')),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 6.0,
                      color: AppColors.adaptableColor(context),
                    ),
                  ),
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    onReady: () {},
                  ),
                ),
              ),
              StreamBuilder(
                stream: _getRendimientoStream(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final rendimiento = snapshot.data!.docs;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${rendimiento.length} resultados encontrados',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          children: List.generate(
                            (rendimiento.length / 3).ceil(),
                            (index) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                3,
                                (i) => i + index * 3 < rendimiento.length
                                    ? _buildIconItem(
                                        context, rendimiento[i + index * 3])
                                    : SizedBox(width: 100),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getRendimientoStream() {
  String fieldToSearch = Localizations.localeOf(context).languageCode == 'es'
      ? 'intensityEsp'
      : 'intensityEng';
  
  if (widget.selectedIntensity.isEmpty) {
    return FirebaseFirestore.instance
        .collection('rendimientoFisico')
        .snapshots();
  } else {
    return FirebaseFirestore.instance
        .collection('rendimientoFisico')
        .where(fieldToSearch, isEqualTo: widget.selectedIntensity)
        .snapshots();
  }
}


  Widget _buildIconItem(BuildContext context, DocumentSnapshot rendimiento) {
    String? imageUrl = rendimiento['URL de la Imagen'];
    String nombre = rendimiento['NombreEsp'] ?? 'Nombre no encontrado';
    String contenido = rendimiento['ContenidoEsp'] ?? 'Contenido no encontrado';
    bool isPremium = rendimiento['MembershipEng'] == 'Premium';

    return GestureDetector(
      onTap: () {
        if (!isPremium) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          nombre,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            contenido,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RendimientoDetailsPage(rendimiento: rendimiento),
            ),
          );
        }
      },
      child: Card(
        margin: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.broken_image,
                      size: 120,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                nombre,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
