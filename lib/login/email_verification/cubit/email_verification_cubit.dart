import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  EmailVerificationCubit() : super(const EmailVerificationInitial(message: ''));
  final _auth = FirebaseAuth.instance;

  void sendEmailVerification() async {
    try {
      // emit(EmailVerificationLoading(message: state.message));
      await _auth.currentUser!.sendEmailVerification();
      emit(state.copyWidth(message: 'emailVerified Successfully'));
      // emit(EmailVerificationSuccess(message: state.message));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWidth(message: e.code));
      emit(EmailVerificationFailure(message: state.message));
    } on FirebaseException catch (e) {
      emit(state.copyWidth(message: e.code));
      emit(EmailVerificationFailure(message: state.message));
    } on FormatException catch (e) {
      emit(state.copyWidth(message: e.toString()));
      emit(EmailVerificationFailure(message: state.message));
    } on PlatformException catch (e) {
      emit(state.copyWidth(message: e.code));
      emit(EmailVerificationFailure(message: state.message));
    } catch (error) {
      emit(state.copyWidth(message: error.toString()));
      emit(EmailVerificationFailure(message: state.message));
    }
  }

  // void setTimeForAutoRedirect() {
  //   Timer.periodic(const Duration(seconds: 1), (timer) async {
  //     await _auth.currentUser!.reload();
  //     if (_auth.currentUser?.emailVerified ?? false) {
  //       emit(state.copyWidth(message: 'emailVerified Successfully'));
  //       // emit(EmailVerificationSuccess(message: state.message));
  //       timer.cancel;
  //     }
  //   });
  // }

  void checkEmailVerify() {
    if (_auth.currentUser != null) {
      if (_auth.currentUser!.emailVerified) {
        emit(EmailVerificationSuccess(message: state.message));
      } else {
        emit(state.copyWidth(message: 'Email is Not Verified'));
        emit(EmailVerificationFailure(message: state.message));
      }
    }
  }
}
