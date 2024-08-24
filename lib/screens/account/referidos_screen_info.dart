import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';
import '../../widgets/custom_appbar_new.dart';
import 'referidos_screen.dart';

class PantallaReferidosInfo extends StatefulWidget {
  final String correoUsuario;
  final String nombreUsuario;
  final String userImageUrl;

  const PantallaReferidosInfo({
    Key? key,
    required this.correoUsuario,
    required this.nombreUsuario,
    required this.userImageUrl,
  }) : super(key: key);

  @override
  _PantallaReferidosInfoState createState() => _PantallaReferidosInfoState();
}

class _PantallaReferidosInfoState extends State<PantallaReferidosInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '¡${AppLocalizations.of(context)!.translate('hello')} ${widget.nombreUsuario}!',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Bienvenidos a nuestra seccion de referidos, el programa funciona asi: con los primeros 5 referidos recibes un 10% de descuento para formar parte de nuestra comunidad premium y después de 5 referidos vas ganando dinero. A continuación se muestran los beneficios que obtienen nuestros usuarios por referido:',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                        leading: Icon(Icons.circle, size: 8),
                        title: Text(
                          'Nivel 1: 5 Referidos = 10% de Descuento',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.circle, size: 8),
                        title: Text(
                          'Nivel 2: 6 a 29 Referidos = 20% de Ganancia',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.circle, size: 8),
                        title: Text(
                          'Nivel 3: 30 a 49 Referidos = 30% de Ganancia',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.circle, size: 8),
                        title: Text(
                          'Nivel 4: 50 a 99 Referidos = 40% de Ganancia',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.circle, size: 8),
                        title: Text(
                          'Nivel 5: 100 Referidos en adelante = 50% de Ganancia',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PantallaReferidos(
                            correoUsuario: widget.correoUsuario,
                            nombreUsuario: widget.nombreUsuario,
                            userImageUrl: widget.userImageUrl,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.translate('myReferrals'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
