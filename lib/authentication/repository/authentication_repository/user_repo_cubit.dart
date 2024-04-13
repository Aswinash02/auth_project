import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_integration/authentication/model/user_model.dart';
import 'package:flutter/services.dart';

part 'user_repo_state.dart';

class UserRepo extends Cubit<UserRepoState> {
  UserRepo()
      : super(const UserRepoInitial(email: '', name: '', id: '', message: ''));

  final firebaseInstance = FirebaseFirestore.instance;

  Future<void> saveUserData(UserData userData) async {
    try {
      emit(UserRepoLoading(
          id: state.id,
          name: state.name,
          email: state.email,
          message: state.message));
      await firebaseInstance
          .collection('users')
          .doc(userData.id)
          .set(userData.toJson());
      emit(state.copyWidth(
          name: userData.name, id: userData.id, email: userData.email));
      emit(UserRepoLoaded(
          id: state.id,
          name: state.name,
          email: state.email,
          message: state.message));
    } on FirebaseException catch (e) {
      emit(state.copyWidth(message: e.code));
      emit(UserRepoFailure(
          id: state.id,
          name: state.name,
          email: state.email,
          message: state.message));
    } on PlatformException catch (e) {
      emit(state.copyWidth(message: e.code));
      emit(UserRepoFailure(
          id: state.id,
          name: state.name,
          email: state.email,
          message: state.message));
    } catch (e) {
      emit(state.copyWidth(message: e.toString()));
      emit(UserRepoFailure(
          id: state.id,
          name: state.name,
          email: state.email,
          message: state.message));
    }
  }
}
