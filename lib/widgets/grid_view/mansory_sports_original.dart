import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../config/lang/app_localization.dart';
import '../../screens/sports/sports_details.dart';

class MasonrySportsOriginal extends StatelessWidget {
  const MasonrySportsOriginal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('sports').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final sports = snapshot.data!.docs;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: List.generate(
                      (sports.length / 3).ceil(),
                      (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          3,
                          (i) => i + index * 3 < sports.length
                              ? _buildIconItem(context, sports[i + index * 3])
                              : SizedBox(
                                  width:
                                      100),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildIconItem(BuildContext context, DocumentSnapshot sport) {
    String? imageUrl = sport['URL de la Imagen'];
    String? gifUrl = sport['URL del Gif'];
    String nombre = sport['NombreEsp'] ?? 'Nombre no encontrado';
    String contenido = sport['ContenidoEsp'] ?? 'Contenido no encontrado';
    double resistencia = double.parse(sport['Resistencia'] ?? '0');
    double fisicoEstetico = double.parse(sport['FisicoEstetico'] ?? '0');
    double potenciaAnaerobica =
        double.parse(sport['PotenciaAnaerobica'] ?? '0');
    double saludBienestar = double.parse(sport['SaludBienestar'] ?? '0');
    bool isPremium = sport['MembershipEng'] == 'Premium';

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
                        gifUrl != null && gifUrl.isNotEmpty
                            ? Image.network(
                                gifUrl,
                                width: 400,
                                height: 400,
                                fit: BoxFit.contain,
                              )
                            : Icon(Icons.error),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _buildCircularProgress(
                                context,
                                AppLocalizations.of(context)!
                                    .translate('resistance'),
                                resistencia),
                            _buildCircularProgress(
                                context,
                                AppLocalizations.of(context)!
                                    .translate('aestheticPhysical'),
                                fisicoEstetico),
                            _buildCircularProgress(
                                context,
                                AppLocalizations.of(context)!
                                    .translate('anaerobicPower'),
                                potenciaAnaerobica),
                            _buildCircularProgress(
                                context,
                                AppLocalizations.of(context)!
                                    .translate('healthWellness'),
                                saludBienestar),
                          ],
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0),
                          child: Text(
                            contenido,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SportsDetailsPage(sport: sport)),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('seeMore'),
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    )
                  : Icon(Icons.error),
            ),
            if (isPremium)
              Positioned.fill(
                child: Icon(
                  Icons.lock,
                  color: Colors.red,
                  size: 50,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress(
      BuildContext context, String label, double value) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularPercentIndicator(
            radius: 50,
            lineWidth: 6,
            percent: value / 100,
            center: Text(
              '${value.toInt()}%',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            progressColor: Colors.blue,
          ),
          SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
