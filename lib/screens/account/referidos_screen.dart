// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:super_clipboard/super_clipboard.dart';
import '../../config/lang/app_localization.dart';
import '../../functions/referidos/referidos_service.dart';
import '../../widgets/custom_appbar_new.dart';

class PantallaReferidos extends StatefulWidget {
  final String correoUsuario;
  final String nombreUsuario;
  final String userImageUrl;

  const PantallaReferidos({
    Key? key,
    required this.correoUsuario,
    required this.nombreUsuario,
    required this.userImageUrl,
  }) : super(key: key);

  @override
  PantallaReferidosState createState() => PantallaReferidosState();
}

class PantallaReferidosState extends State<PantallaReferidos> {
  final ReferidosService _referidosService = ReferidosService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.userImageUrl),
                  radius: 60.0,
                ),
                const SizedBox(height: 10),
                Text(
                  '¡${AppLocalizations.of(context)!.translate('hello')} ${widget.nombreUsuario}!',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  'Código de referido: r_${widget.nombreUsuario}',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () async {
                    final clipboard = SystemClipboard.instance;
                    if (clipboard == null) {
                      return;
                    }
                    final item = DataWriterItem();
                    item.add(Formats.plainText('r_${widget.nombreUsuario}'));
                    await clipboard.write([item]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!
                              .translate('referralCodeCopied'),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('copyCode'),
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _referidosService.obtenerReferidos(widget.correoUsuario),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final referidos = snapshot.data ?? [];

                if (referidos.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate('noReferrals'),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: referidos.length,
                  itemBuilder: (context, index) {
                    final referido = referidos[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(referido['imagenPerfil']),
                      ),
                      title: Text(
                        referido['nombre'],
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        referido['correo'],
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
