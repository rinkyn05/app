import 'package:cloud_firestore/cloud_firestore.dart';

class GymFriendsFunctions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> likeUser(String userEmail, String likedUserEmail) async {
    final userRef = _firestore.collection('gymfriends').doc(userEmail);
    final likedUserRef =
        _firestore.collection('gymfriends').doc(likedUserEmail);
    final userLikesRef =
        _firestore.collection('gymfriendsemails').doc(userEmail);

    await _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userLikesRef);

      if (userDoc.exists &&
          userDoc.data()?['liked'] != null &&
          userDoc.data()?['liked'].contains(likedUserEmail)) {
        print('Ya has dado like a este usuario');
        return;
      }

      await transaction.update(userRef, {
        'likedyou': FieldValue.arrayUnion([likedUserEmail]),
        'like': FieldValue.increment(1),
      });
      await transaction.update(likedUserRef, {'like': FieldValue.increment(1)});

      print('User $userEmail liked user $likedUserEmail');
      await updateLikesInfo(userEmail, likedUserEmail);
    });
  }

  Future<void> updateLikesInfo(String userEmail, String likedUserEmail) async {
    final userLikesRef =
        _firestore.collection('gymfriendsemails').doc(userEmail);
    final likedUserLikesRef =
        _firestore.collection('gymfriendsemails').doc(likedUserEmail);

    final userLikesDoc = await userLikesRef.get();
    final likedUserLikesDoc = await likedUserLikesRef.get();

    List<dynamic> dislikedBy =
        (userLikesDoc.data()?['dislikedBy'] ?? []) as List<dynamic>;
    List<dynamic> youDisliked =
        (likedUserLikesDoc.data()?['youDisliked'] ?? []) as List<dynamic>;

    dislikedBy.remove(likedUserEmail);
    youDisliked.remove(userEmail);

    await userLikesRef.update({
      'liked': FieldValue.arrayUnion([likedUserEmail]),
      'dislikedBy': dislikedBy,
      'youDisliked': [],
    });

    await likedUserLikesRef.update({
      'likedBy': FieldValue.arrayUnion([userEmail]),
      'dislikedBy': [],
      'youDisliked': youDisliked,
    });

    print('Likes info updated for user $userEmail and user $likedUserEmail');
  }

  Future<void> dislikeUser(String userEmail, String dislikedUserEmail) async {
    final userRef = _firestore.collection('gymfriends').doc(userEmail);
    final dislikedUserRef =
        _firestore.collection('gymfriends').doc(dislikedUserEmail);
    final userDislikesRef =
        _firestore.collection('gymfriendsemails').doc(userEmail);

    await _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userDislikesRef);

      if (userDoc.exists &&
          userDoc.data()?['youDisliked'] != null &&
          userDoc.data()?['youDisliked'].contains(dislikedUserEmail)) {
        print(
            'Ya has dado dislike a este usuario');
        return;
      }

      await transaction.update(userRef, {
        'dislikeyou': FieldValue.arrayUnion([dislikedUserEmail]),
        'dislike': FieldValue.increment(1),
      });
      await transaction
          .update(dislikedUserRef, {'dislike': FieldValue.increment(1)});

      print('User $userEmail disliked user $dislikedUserEmail');
      await updateDislikesInfo(userEmail, dislikedUserEmail);
    });
  }

  Future<void> updateDislikesInfo(
      String userEmail, String dislikedUserEmail) async {
    final userLikesRef =
        _firestore.collection('gymfriendsemails').doc(userEmail);
    final dislikedUserLikesRef =
        _firestore.collection('gymfriendsemails').doc(dislikedUserEmail);

    final userLikesDoc = await userLikesRef.get();
    final dislikedUserLikesDoc = await dislikedUserLikesRef.get();

    List<dynamic> youDisliked =
        (userLikesDoc.data()?['youDisliked'] ?? []) as List<dynamic>;
    List<dynamic> dislikedBy =
        (dislikedUserLikesDoc.data()?['dislikedBy'] ?? []) as List<dynamic>;

    youDisliked.add(dislikedUserEmail);
    dislikedBy.add(userEmail);

    List<dynamic> follows =
        (userLikesDoc.data()?['follow'] ?? []) as List<dynamic>;
    follows.remove(dislikedUserEmail);

    await userLikesRef.update({
      'liked': FieldValue.arrayRemove([dislikedUserEmail]),
      'youDisliked': youDisliked,
      'follow': follows,
    });

    await dislikedUserLikesRef.update({
      'likedBy': FieldValue.arrayRemove([userEmail]),
      'dislikedBy': dislikedBy,
    });

    print(
        'Dislikes info updated for user $userEmail and user $dislikedUserEmail');
  }

  Future<void> followUser(String userEmail, String followedUserEmail) async {
    final userRef = _firestore.collection('gymfriends').doc(userEmail);
    final followedUserRef =
        _firestore.collection('gymfriends').doc(followedUserEmail);
    final userFollowsRef =
        _firestore.collection('gymfriendsemails').doc(userEmail);

    await _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userFollowsRef);

      if (userDoc.exists &&
          userDoc.data()?['follow'] != null &&
          userDoc.data()?['follow'].contains(followedUserEmail)) {
        print(
            'Ya estás siguiendo a este usuario');
        return;
      }

      await transaction.update(userRef, {
        'followers': FieldValue.arrayUnion([followedUserEmail]),
        'follow': FieldValue.increment(1),
      });
      await transaction
          .update(followedUserRef, {'followers': FieldValue.increment(1)});

      print('User $userEmail followed user $followedUserEmail');
      await updateFollowsInfo(userEmail, followedUserEmail);
    });
  }

  Future<void> updateFollowsInfo(
      String userEmail, String followedUserEmail) async {
    final userLikesRef =
        _firestore.collection('gymfriendsemails').doc(userEmail);
    final followedUserLikesRef =
        _firestore.collection('gymfriendsemails').doc(followedUserEmail);

    final userLikesDoc = await userLikesRef.get();
    final followedUserLikesDoc = await followedUserLikesRef.get();

    List<dynamic> youDisliked =
        (userLikesDoc.data()?['youDisliked'] ?? []) as List<dynamic>;
    List<dynamic> dislikedBy =
        (followedUserLikesDoc.data()?['dislikedBy'] ?? []) as List<dynamic>;

    dislikedBy.remove(userEmail);
    youDisliked.remove(followedUserEmail);

    await userLikesRef.update({
      'youDisliked': youDisliked,
      'follow': FieldValue.arrayUnion([followedUserEmail]),
    });

    await followedUserLikesRef.update({
      'dislikedBy': dislikedBy,
      'followers': FieldValue.arrayUnion([userEmail]),
    });

    print(
        'Follows info updated for user $userEmail and user $followedUserEmail');
  }
}
