import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../functions/gym_friends_functions.dart';
import '../widgets/custom_appbar_gynder.dart';
import 'role_first_page.dart';
import '../../config/lang/app_localization.dart';

class GymDerScreen extends StatefulWidget {
  const GymDerScreen({Key? key}) : super(key: key);

  @override
  _GymDerScreenState createState() => _GymDerScreenState();
}

class _GymDerScreenState extends State<GymDerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GymFriendsFunctions _gymFriendsFunctions = GymFriendsFunctions();

  late Future<List<DocumentSnapshot>> _futureGymFriends;
  late Future<List<String>> _futureUserInteractions;
  late Stream<DocumentSnapshot> _interactionsStream;

  @override
  void initState() {
    super.initState();
    _futureGymFriends = _getGymFriends();
    _futureUserInteractions = _getUserInteractions();
    _checkCurrentUserEmail();
    _setupInteractionsStream();
  }

  Future<void> _checkCurrentUserEmail() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final userEmail = user.email;
      print('Current User Email: $userEmail');
    } else {
      print('Current User Email is null');
    }
  }

  Future<List<DocumentSnapshot>> _getGymFriends() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final userEmail = user.email;
      final gymFriendSnapshot = await _firestore.collection('gymfriends').get();
      final gymFriends =
          gymFriendSnapshot.docs.where((doc) => doc.id != userEmail).toList();
      for (var friend in gymFriends) {
        final friendEmail = friend.data()['Correo Electrónico'] as String?;
        if (friendEmail != null) {
          print('Friend Email: $friendEmail');
        } else {
          print('Friend Email is null');
        }
      }
      return gymFriends;
    } else {
      return [];
    }
  }

  Future<List<String>> _getUserInteractions() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final userEmail = user.email;
      final userInteractionsSnapshot =
          await _firestore.collection('gymfriendsemails').doc(userEmail).get();
      final userInteractionsData = userInteractionsSnapshot.data();
      final List<String> userInteractions = [];

      if (userInteractionsData != null) {
        if (userInteractionsData['liked'] != null) {
          userInteractionsData['liked'].forEach((email) {
            userInteractions.add('liked:$email');
          });
        }

        if (userInteractionsData['youDisliked'] != null) {
          userInteractionsData['youDisliked'].forEach((email) {
            userInteractions.add('youDisliked:$email');
          });
        }

        if (userInteractionsData['follow'] != null) {
          userInteractionsData['follow'].forEach((email) {
            userInteractions.add('follow:$email');
          });
        }
      }

      return userInteractions;
    } else {
      return [];
    }
  }

  void _setupInteractionsStream() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userEmail = user.email;
      _interactionsStream =
          _firestore.collection('gymfriendsemails').doc(userEmail).snapshots();
    }
  }

  void _showFilterDialog(BuildContext context) {
    bool isManSelected = false;
    bool isWomanSelected = false;
    RangeValues ageRange = RangeValues(18, 30);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.translate('show')),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: Text(AppLocalizations.of(context)!.translate('man')),
                    value: isManSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        isManSelected = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title:
                        Text(AppLocalizations.of(context)!.translate('woman')),
                    value: isWomanSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        isWomanSelected = value!;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!.translate('age_range'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  RangeSlider(
                    values: ageRange,
                    min: 18,
                    max: 80,
                    divisions: 50,
                    labels: RangeLabels(
                      '${ageRange.start.round()}',
                      '${ageRange.end.round()}',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        ageRange = values;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                Center(
                  child: ElevatedButton(
                    child:
                        Text(AppLocalizations.of(context)!.translate('accept')),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarGynder(
        onBackButtonPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RoleFirstPage(),
            ),
          );
        },
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _futureGymFriends,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final gymFriends = snapshot.data!;
            return StreamBuilder<DocumentSnapshot>(
              stream: _interactionsStream,
              builder: (context, interactionsSnapshot) {
                if (interactionsSnapshot.connectionState ==
                        ConnectionState.waiting ||
                    interactionsSnapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else if (interactionsSnapshot.hasError) {
                  return Center(
                      child: Text('Error: ${interactionsSnapshot.error}'));
                } else {
                  final userInteractionsData =
                      interactionsSnapshot.data!.data() as Map<String, dynamic>;
                  final userInteractions = [];
                  userInteractionsData.forEach((key, value) {
                    if (key == 'liked' ||
                        key == 'youDisliked' ||
                        key == 'follow') {
                      (value as List).forEach((email) {
                        userInteractions.add('$key:$email');
                      });
                    }
                  });

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "${AppLocalizations.of(context)!.translate('community')}",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.filter_list),
                              iconSize: 40.0,
                              onPressed: () {
                                _showFilterDialog(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          itemCount: gymFriends.length,
                          itemBuilder: (context, index) {
                            final userData = gymFriends[index].data()
                                as Map<String, dynamic>;
                            final imageUrl = userData['image_url'] ??
                                'https://firebasestorage.googleapis.com/v0/b/gabriel-coach-c7e30.appspot.com/o/gym.png?alt=media&token=7d0d4ccf-be30-4564-b829-0c342887d0e3';
                            final name = userData['Nombre'] ?? 'N/A';
                            final membership = userData['Membership'] ?? 'N/A';
                            final nivel = userData['Nivel'] ?? 'N/A';
                            var followers = userData['Followers'] ?? 0;
                            var likes = userData['Like'] ?? 0;
                            var dislikes = userData['Dislike'] ?? 0;
                            final userEmail = _auth.currentUser!.email;

                            final interactionKey =
                                '${userData['Correo Electrónico']}';
                            Color likeColor = Colors.grey;
                            Color dislikeColor = Colors.grey;
                            Color followColor = Colors.grey;

                            if (userInteractions
                                .contains('liked:$interactionKey')) {
                              likeColor = Colors.green;
                              dislikeColor = Colors.grey;
                              followColor = Colors.lightBlueAccent;
                            } else if (userInteractions
                                .contains('youDisliked:$interactionKey')) {
                              dislikeColor = Colors.red;
                              likeColor = Colors.grey;
                              followColor = Colors.grey;
                            } else if (userInteractions
                                .contains('follow:$interactionKey')) {
                              followColor = Colors.lightBlueAccent;
                              likeColor = Colors.green;
                              dislikeColor = Colors.grey;
                            }

                            return DraggableCard(
                              imageUrl: imageUrl,
                              name: name,
                              membership: membership,
                              nivel: nivel,
                              followers: followers,
                              likes: likes,
                              dislikes: dislikes,
                              likeColor: likeColor,
                              dislikeColor: dislikeColor,
                              followColor: followColor,
                              onLikePressed: () {
                                print('Like button pressed');
                                final email =
                                    userData['Correo Electrónico'] as String?;
                                if (email != null) {
                                  _gymFriendsFunctions
                                      .likeUser(userEmail!, email)
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Has dado like')),
                                    );
                                    setState(() {
                                      likes++;
                                    });
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error.toString())),
                                    );
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Email is null')),
                                  );
                                }
                              },
                              onDislikePressed: () {
                                print('Dislike button pressed');
                                final email =
                                    userData['Correo Electrónico'] as String?;
                                if (email != null) {
                                  _gymFriendsFunctions
                                      .dislikeUser(userEmail!, email)
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Has dado dislike')),
                                    );
                                    setState(() {
                                      dislikes++;
                                    });
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error.toString())),
                                    );
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Email is null')),
                                  );
                                }
                              },
                              onFollowPressed: () {
                                print('Follow button pressed');
                                final email =
                                    userData['Correo Electrónico'] as String?;
                                if (email != null) {
                                  _gymFriendsFunctions
                                      .followUser(userEmail!, email)
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Has dado follow')),
                                    );
                                    setState(() {
                                      followers++;
                                    });
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error.toString())),
                                    );
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Email is null')),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class DraggableCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String membership;
  final String nivel;
  final int followers;
  final int likes;
  final int dislikes;
  final Color likeColor;
  final Color dislikeColor;
  final Color followColor;
  final VoidCallback? onLikePressed;
  final VoidCallback? onDislikePressed;
  final VoidCallback? onFollowPressed;

  DraggableCard({
    required this.imageUrl,
    required this.name,
    required this.membership,
    required this.nivel,
    required this.followers,
    required this.likes,
    required this.dislikes,
    required this.likeColor,
    required this.dislikeColor,
    required this.followColor,
    this.onLikePressed,
    this.onDislikePressed,
    this.onFollowPressed,
  });

  final List<List<Color>> colorCombinations = [
    [
      Color.fromARGB(255, 0, 54, 99).withOpacity(0.1),
      Color.fromARGB(255, 0, 34, 61).withOpacity(0.8),
    ],
    [
      Color.fromARGB(255, 0, 113, 106).withOpacity(0.1),
      Color.fromARGB(255, 0, 61, 51).withOpacity(0.8),
    ],
    [
      Color.fromARGB(255, 250, 124, 104).withOpacity(0.1),
      Color.fromARGB(255, 54, 0, 0).withOpacity(0.8),
    ],
    [
      Color.fromARGB(255, 0, 201, 177).withOpacity(0.1),
      Color.fromARGB(255, 0, 54, 50).withOpacity(0.8),
    ],
  ];

  List<Color> getRandomColors() {
    final random = Random();
    return colorCombinations[random.nextInt(colorCombinations.length)];
  }

  @override
  Widget build(BuildContext context) {
    final randomColors = getRandomColors();
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.white.withOpacity(0.3),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(imageUrl, fit: BoxFit.contain),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: randomColors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.7, 1],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      membership,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                    Text(
                      nivel,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon:
                              Icon(Icons.favorite, color: likeColor, size: 46),
                          onPressed: onLikePressed,
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down,
                              color: dislikeColor, size: 46),
                          onPressed: onDislikePressed,
                        ),
                        IconButton(
                          icon:
                              Icon(Icons.people, color: followColor, size: 46),
                          onPressed: onFollowPressed,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
