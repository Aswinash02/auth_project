import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit()
      : super(const ForgotPasswordInitial(email: '', message: ''));

  TextEditingController email = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail() async {
    try {
      emit(ForgotPasswordLoading(email: state.email, message: state.message));
      await auth.sendPasswordResetEmail(email: email.text);
      emit(state.copyWidth(email: email.text));
      emit(ForgotPasswordSuccess(email: state.email, message: state.message));
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
      emit(ForgotPasswordFailure(email: state.email, message: state.message));
    }
  }
}
