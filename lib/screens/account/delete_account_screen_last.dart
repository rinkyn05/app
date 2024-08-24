import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../config/lang/app_localization.dart';
import '../../functions/sign_out.dart';
import 'delete_account_policy_screen.dart';

class DeleteAccountScreenLast extends StatefulWidget {
  final String userEmail;
  const DeleteAccountScreenLast({Key? key, required this.userEmail})
      : super(key: key);

  @override
  DeleteAccountScreenLastState createState() => DeleteAccountScreenLastState();
}

class DeleteAccountScreenLastState extends State<DeleteAccountScreenLast> {
  bool _isConfirmed = false;
  bool _policyAccepted = false;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLoc.translate('deleteAccount')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                appLoc.translate('deleteAccountTitle'),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                appLoc.translate('deleteAccountConfirmation'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _emailField(),
              const SizedBox(height: 20),
              CheckboxListTile(
                title: Text(
                  appLoc.translate('acceptPolicyConfirmation'),
                ),
                value: _policyAccepted,
                onChanged: (value) {
                  setState(() {
                    _policyAccepted = value ?? false;
                    _checkConfirmation();
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      appLoc.translate('deleteAccountPolicy'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.bodyLarge!.fontFamily,
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const DeleteAccountPolicyScreen(),
                        ),
                      );
                    },
                    child: Text(
                      appLoc.translate('see'),
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily:
                            Theme.of(context).textTheme.bodyLarge!.fontFamily,
                        fontSize:
                            Theme.of(context).textTheme.bodyLarge!.fontSize,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    _isConfirmed && _policyAccepted ? _deleteAccount : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
                  backgroundColor: _isConfirmed ? Colors.red : Colors.grey[300],
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 20.0),
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                ),
                child: Text(
                  appLoc.translate('yesDeleteAccountOption'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      initialValue: widget.userEmail,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Email',
      ),
    );
  }

  void _checkConfirmation() {
    setState(() {
      _isConfirmed = widget.userEmail.isNotEmpty && _policyAccepted;
    });
  }

  void _deleteAccount() async {
    final appLoc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user?.uid);
      await userDocRef.delete();

      final userStatsDocRef =
          FirebaseFirestore.instance.collection('userstats').doc(user?.email);
      await userStatsDocRef.delete();

      final usersMedicalDocRef = FirebaseFirestore.instance
          .collection('usersmedical')
          .doc(user?.email);
      await usersMedicalDocRef.delete();

      final referidosDocRef =
          FirebaseFirestore.instance.collection('referidos').doc(user?.email);
      await referidosDocRef.delete();

      final gymFriendsEmailsDocRef = FirebaseFirestore.instance
          .collection('gymfriendsemails')
          .doc(user?.email);
      await gymFriendsEmailsDocRef.delete();

      final gymFriendsDocRef =
          FirebaseFirestore.instance.collection('gymfriends').doc(user?.email);
      await gymFriendsDocRef.delete();

      final usersCollectionRef = FirebaseFirestore.instance.collection('users');
      final querySnapshot = await usersCollectionRef
          .where('Correo Electrónico', isEqualTo: user?.email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final userDocToDelete = querySnapshot.docs.first.reference;
        await userDocToDelete.delete();
      }

      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      signOut(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appLoc.translate('accountDeletedSuccessfully')),
        ),
      );
    } catch (error) {
      print('Error deleting account: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appLoc.translate('failedToDeleteAccount')),
        ),
      );
    }
  }
}
