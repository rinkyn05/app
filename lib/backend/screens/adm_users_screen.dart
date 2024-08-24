import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../config/lang/app_localization.dart';
import '../../functions/role_checker.dart';
import '../admin/admin_start_screen.dart';

class AdmUsersScreen extends StatefulWidget {
  const AdmUsersScreen({Key? key}) : super(key: key);

  @override
  AdmUsersScreenState createState() => AdmUsersScreenState();
}

class AdmUsersScreenState extends State<AdmUsersScreen> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    bool hasAccess = await checkUserRole();
    if (!hasAccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showAccessDeniedDialog(context);
        }
      });
    }
  }

  void _showAccessDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.translate('accessDeniedTitle')),
          content: Text(
              AppLocalizations.of(context)!.translate('accessDeniedMessage')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.translate('okButton')),
            ),
          ],
        );
      },
    );
  }

  void _fetchUsers() {
    _usersFuture = FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((doc) => {
                  'Nombre': doc.data()['Nombre'] ?? '',
                  'Correo Electrónico': doc.data()['Correo Electrónico'] ?? '',
                  'Rol': doc.data()['Rol'] ?? '',
                  'Membership': doc.data()['Membership'] ?? '',
                  'ImageUrl': doc.data()['ImageUrl'] ?? '',
                })
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const AdminStartScreen(nombre: '', rol: '')),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error al cargar usuarios'),
                  );
                }
                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron usuarios'),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Total de Usuarios: ${snapshot.data!.length}'),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final user = snapshot.data![index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: user['ImageUrl'].isNotEmpty
                                    ? NetworkImage(user['ImageUrl'])
                                    : null,
                                child: user['ImageUrl'].isEmpty
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              title: Text('${index + 1}. ${user['Nombre']}'),
                              subtitle: Text(
                                  'Correo: ${user['Correo Electrónico']}\nRol: ${user['Rol']}\nMembresía: ${user['Membership']}'),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
