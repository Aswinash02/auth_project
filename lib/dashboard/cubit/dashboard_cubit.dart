import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integration/authentication/model/user_model.dart';

part 'dashboard_state.dart';

enum UserType { admin, user }

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit()
      : super(const DashboardInitial(
            userType: UserType.user, selectedTitle: ScreenName.dashboard));

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool enterDrawer = false;

  void fetchUserType() {
    if (_auth.currentUser != null) {
      if (_auth.currentUser?.email == 'aswin02122001@gmail.com' ||
          _auth.currentUser?.phoneNumber == '+919942737239') {
        emit(state.copyWith(userType: UserType.admin));
      }
    }
  }

  void emitUserType() {
    emit(state.copyWith(userType: UserType.user));
  }

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

  void selectedScreen(ScreenName selectedTitle) {
    emit(state.copyWith(selectedTitle: selectedTitle));
  }
}
