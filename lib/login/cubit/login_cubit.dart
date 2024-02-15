import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial(email: '', message: ''));
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> loginWithUserCredential() async {
    try {
      emit(LoginLoading(email: state.email, message: state.message));
      await _auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      emit(state.copyWidth(email: email.text, message: 'Login Success'));
      emit(LoginSuccess(email: state.email, message: state.message));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWidth(message: e.code));
      emit(LoginFailure(email: state.email, message: state.message));
    } on FirebaseException catch (e) {
      emit(state.copyWidth(message: e.code));
      emit(LoginFailure(email: state.email, message: state.message));
    } on FormatException catch (e) {
      emit(state.copyWidth(message: e.toString()));
      emit(LoginFailure(email: state.email, message: state.message));
    } on PlatformException catch (e) {
      emit(state.copyWidth(message: e.code));
      emit(LoginFailure(email: state.email, message: state.message));
    } catch (error) {
      emit(state.copyWidth(message: error.toString()));
      emit(LoginFailure(email: state.email, message: state.message));
    }
  }

  void sendEmailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      emit(state.copyWidth(message: e.code));
    } on FirebaseException catch (e) {
      emit(state.copyWidth(message: e.code));
    } on FormatException catch (e) {
      emit(state.copyWidth(message: e.toString()));
    } on PlatformException catch (e) {
      emit(state.copyWidth(message: e.code));
    } catch (error) {
      emit(state.copyWidth(message: error.toString()));
      emit(LoginFailure(email: state.email, message: state.message));
    }
  }
}
