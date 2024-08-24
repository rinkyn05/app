import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../config/lang/app_localization.dart';
import '../../screens/sports/sports_details.dart';

class MasonrySports extends StatefulWidget {
  const MasonrySports({Key? key}) : super(key: key);

  @override
  _MasonrySportsState createState() => _MasonrySportsState();
}

class _MasonrySportsState extends State<MasonrySports> {
  DocumentSnapshot? _selectedSport;

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
              return Stack(
                children: [
                  Column(
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
                                  ? _buildIconItem(
                                      context, sports[i + index * 3])
                                  : SizedBox(width: 100),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedSport != null)
                    Positioned(
                      top: 150,
                      left: 0,
                      right: 0,
                      child: AnimatedPadding(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.only(
                          top: _selectedSport != null ? 0.0 : 300.0,
                        ),
                        child: _buildSelectedSportCard(context),
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
    bool isPremium = sport['MembershipEng'] == 'Premium';

    return GestureDetector(
      onTap: () {
        if (!isPremium) {
          setState(() {
            _selectedSport = sport;
          });
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (_selectedSport == null || _selectedSport == sport) &&
                      imageUrl != null &&
                      imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    )
                  : gifUrl != null && gifUrl.isNotEmpty
                      ? Image.network(
                          gifUrl,
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

  Widget _buildSelectedSportCard(BuildContext context) {
    String nombre = _selectedSport!['NombreEsp'] ?? 'Nombre no encontrado';
    double resistencia = double.parse(_selectedSport!['Resistencia'] ?? '0');
    double fisicoEstetico =
        double.parse(_selectedSport!['FisicoEstetico'] ?? '0');
    double potenciaAnaerobica =
        double.parse(_selectedSport!['PotenciaAnaerobica'] ?? '0');
    double saludBienestar =
        double.parse(_selectedSport!['SaludBienestar'] ?? '0');

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedSport = null;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  nombre,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildCircularProgress(
                        context,
                        AppLocalizations.of(context)!.translate('resistance'),
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
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SportsDetailsPage(sport: _selectedSport!),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('start'),
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgress(
      BuildContext context, String label, double value) {
    return SizedBox(
      width: 90,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularPercentIndicator(
            radius: 35,
            lineWidth: 4,
            percent: value / 100,
            center: Text(
              '${value.toInt()}%',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            progressColor: Colors.blue,
          ),
          SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
