import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integration/model/user_model.dart';
import 'package:firebase_integration/repository/authentication_repository/user_repo_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(const SignupInitial(email: '', message: '', name: ''));
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  final userRepo = UserRepo();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      emit(SignupLoading(
          email: state.email, message: state.message, name: state.name));
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      final newUser = UserData(
          id: userCredential.user!.uid, name: name.text, email: email.text);
      await userRepo.saveUserData(newUser);
      emit(state.copyWidth(
          email: email.text, name: name.text, message: 'Signup Successful'));
      emit(SignupSuccess(
          email: state.email, message: state.message, name: state.name));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWidth(message: e.code));
      emit(SignupFailure(
          email: state.email, message: state.message, name: state.name));
    } on FirebaseException catch (e) {
      emit(state.copyWidth(message: e.code));
      emit(SignupFailure(
          email: state.email, message: state.message, name: state.name));
    } on FormatException catch (e) {
      emit(state.copyWidth(message: e.toString()));
      emit(SignupFailure(
          email: state.email, message: state.message, name: state.name));
    } on PlatformException catch (e) {
      emit(state.copyWidth(message: e.code));
      emit(SignupFailure(
          email: state.email, message: state.message, name: state.name));
    } catch (error) {
      emit(state.copyWidth(message: error.toString()));
      emit(SignupFailure(
          email: state.email, message: state.message, name: state.name));
    }
  }
}
