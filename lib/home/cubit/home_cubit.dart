import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_integration/model/user_model.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final _db = FirebaseFirestore.instance;

  Stream<List<UserData>> fetchUser() {
    try {
      return _db.collection('users').snapshots().map(
        (querySnapshot) {
          return querySnapshot.docs.map((doc) {
            return UserData.fromJson(doc);
          }).toList();
        },

      );
    } catch (e) {
      rethrow;
    }
  }
}
