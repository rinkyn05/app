import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/widgets/custom_appbar_new.dart';
import '../../config/lang/app_localization.dart';
import '../../config/utils/appcolors.dart';

class MyObjectives extends StatefulWidget {
  @override
  _MyObjectivesState createState() => _MyObjectivesState();
}

class _MyObjectivesState extends State<MyObjectives> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _userEmail = '';
  List<String> _objectives = [];
  List<String> _completedObjectives = [];

  @override
  void initState() {
    super.initState();
    _getUserEmail();
    _fetchObjectives();
  }

  Future<void> _getUserEmail() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email!;
      });
    }
  }

  Future<void> _fetchObjectives() async {
    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_userEmail).get();
      if (userDoc.exists) {
        final Map<String, dynamic> data =
            userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('misobjetivos')) {
          _objectives = List<String>.from(data['misobjetivos']);
          debugPrint('Objetivos obtenidos de Firestore: $_objectives');
        }
        if (data.containsKey('misobjetivoscompletados')) {
          _completedObjectives =
              List<String>.from(data['misobjetivoscompletados']);
          debugPrint(
              'Objetivos completados obtenidos de Firestore: $_completedObjectives');
        }
        setState(() {});
      }
    } catch (e) {
      print('Error fetching objectives: $e');
    }
  }

  Future<void> _addObjective(String objective) async {
    try {
      final DocumentReference userRef =
          _firestore.collection('users').doc(_userEmail);
      final DocumentSnapshot userDoc = await userRef.get();
      if (userDoc.exists) {
        final Map<String, dynamic> data =
            userDoc.data() as Map<String, dynamic>;
        List<String> currentObjectives = [];
        if (data.containsKey('misobjetivos')) {
          currentObjectives = List<String>.from(data['misobjetivos']);
        }
        currentObjectives.add(objective);
        await userRef.update({'misobjetivos': currentObjectives});
        _objectives = currentObjectives;
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Objetivo agregado: $objective')));
          debugPrint('Objetivo agregado: $objective');
        });
      } else {
        await userRef.set({
          'misobjetivos': [objective]
        }, SetOptions(merge: true));
        _objectives = [objective];
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Objetivo agregado: $objective')));
          debugPrint('Objetivo agregado: $objective');
        });
      }
    } catch (e) {
      print('Error adding objective: $e');
    }
  }

  Future<void> _completeObjective(String objective) async {
    try {
      final DocumentReference userRef =
          _firestore.collection('users').doc(_userEmail);
      final DocumentSnapshot userDoc = await userRef.get();
      if (userDoc.exists) {
        final Map<String, dynamic> data =
            userDoc.data() as Map<String, dynamic>;
        List<String> currentObjectives = [];
        List<String> currentCompletedObjectives = [];
        if (data.containsKey('misobjetivos')) {
          currentObjectives = List<String>.from(data['misobjetivos']);
        }
        if (data.containsKey('misobjetivoscompletados')) {
          currentCompletedObjectives =
              List<String>.from(data['misobjetivoscompletados']);
        }
        currentObjectives.remove(objective);
        currentCompletedObjectives.add(objective);
        await userRef.update({
          'misobjetivos': currentObjectives,
          'misobjetivoscompletados': currentCompletedObjectives,
        });
        _objectives = currentObjectives;
        _completedObjectives = currentCompletedObjectives;
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .translate('objectivesCompleted'))));
          debugPrint('Objetivo completado: $objective');
        });
      }
    } catch (e) {
      print('Error completing objective: $e');
    }
  }

  void _showAddObjectiveDialog(BuildContext context) {
    String newObjective = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(AppLocalizations.of(context)!.translate('addNewObjectives')),
          content: TextField(
            onChanged: (value) {
              newObjective = value;
            },
            decoration: InputDecoration(
              hintText: 'Escribe tu nuevo objetivo aquí',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.translate('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                if (newObjective.isNotEmpty) {
                  _addObjective(newObjective);
                  Navigator.of(context).pop();
                }
              },
              child: Text(AppLocalizations.of(context)!.translate('add')),
            ),
          ],
        );
      },
    );
  }

  void _showCompleteObjectiveDialog(BuildContext context, String objective) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(AppLocalizations.of(context)!.translate('markAsComplete')),
          content:
              Text(AppLocalizations.of(context)!.translate('wantMarkComplete')),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.translate('cancel'))),
            ElevatedButton(
              onPressed: () {
                _completeObjective(objective);
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.translate('complete')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNew(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                AppLocalizations.of(context)!.translate('objectives'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddObjectiveDialog(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.gdarkblue2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                textStyle: Theme.of(context).textTheme.titleMedium,
              ),
              child: Text(
                AppLocalizations.of(context)!.translate('addObjectives'),
              ),
            ),
          ),
          _objectives.isEmpty
              ? Center(
                  child: Text(AppLocalizations.of(context)!
                      .translate('noHaveObjectives')))
              : Expanded(
                  child: ListView.builder(
                    itemCount: _objectives.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(_objectives[index]),
                            ),
                            IconButton(
                              icon: Icon(Icons.check_circle_outline),
                              onPressed: () {
                                _showCompleteObjectiveDialog(
                                    context, _objectives[index]);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          _completedObjectives.isEmpty
              ? Center(
                  child: Text(AppLocalizations.of(context)!
                      .translate('noCompletedObjectives')))
              : Expanded(
                  child: ListView.builder(
                    itemCount: _completedObjectives.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(_completedObjectives[index]),
                            ),
                            Icon(Icons.check_circle, color: Colors.green),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
