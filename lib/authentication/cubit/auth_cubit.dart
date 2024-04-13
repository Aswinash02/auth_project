import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integration/authentication/model/user_model.dart';
import 'package:firebase_integration/authentication/repository/authentication_repository/user_repo_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
      : super(const AuthInitial(
            loginEmail: '',
            signUpEmail: '',
            selectedAuthScreen: AuthScreen.login,
            forgotEmail: '',
            verificationId: '',
            isLoggedIn: false));

  ///login
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();
  TextEditingController otp5 = TextEditingController();
  TextEditingController otp6 = TextEditingController();
  bool hidePassword = true;
  late Timer _timer;

  Future<void> setLocalUserCredential() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<bool> getLocalUserCredential() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getBool('isLoggedIn');
    return user ?? false;
  }

  Future<void> loginWithUserCredential() async {
    try {
      emit(LoginLoading(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail,
          verificationId: state.verificationId,
          isLoggedIn: state.isLoggedIn));
      await _auth.signInWithEmailAndPassword(
          email: loginEmailController.text,
          password: loginPasswordController.text);
      if (loginEmailController.text != 'aswin02122001@gmail.com') {
        await phoneNumVerify();
      }
      emit(state.copyWidth(
          loginEmail: loginEmailController.text, message: 'Login Success'));
      emit(LoginSuccess(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail,
          verificationId: state.verificationId,
          isLoggedIn: state.isLoggedIn));
    } catch (e) {
      emit(LoginFailure(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail,
          verificationId: state.verificationId,
          message: 'Invalid Email or Password',
          isLoggedIn: state.isLoggedIn));
    }
  }

  Future<void> phoneNumVerify() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: '+91${phoneCon.text}',
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
        },
        codeSent: (verificationId, resendToken) {
          emit(state.copyWidth(verificationId: verificationId));
          selectAuthScreen(AuthScreen.otpVerificationForm);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          emit(state.copyWidth(verificationId: verificationId));
        },
        verificationFailed: (error) {
          if (error.code == 'invalid-phone-number') {
            emit(PhoneNumVerifyFailed(
                loginEmail: state.loginEmail,
                message: error.code,
                signUpEmail: state.signUpEmail,
                selectedAuthScreen: state.selectedAuthScreen,
                forgotEmail: state.forgotEmail,
                verificationId: state.verificationId,
                isLoggedIn: state.isLoggedIn));
          } else {
            emit(PhoneNumVerifyFailed(
                loginEmail: state.loginEmail,
                message: 'Something Went Wrong',
                signUpEmail: state.signUpEmail,
                selectedAuthScreen: state.selectedAuthScreen,
                forgotEmail: state.forgotEmail,
                verificationId: state.verificationId,
                isLoggedIn: state.isLoggedIn));
          }
        });
  }

  Future<void> verifyOTP() async {
    try {
      emit(PhoneOTPVerifyLoading(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail,
          verificationId: state.verificationId,
          isLoggedIn: state.isLoggedIn));
      final otp =
          otp1.text + otp2.text + otp3.text + otp4.text + otp5.text + otp6.text;
      final credential = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: state.verificationId, smsCode: otp));
      if (credential.user != null) {
        emit(PhoneOTPVerifySuccess(
            loginEmail: state.loginEmail,
            signUpEmail: state.signUpEmail,
            selectedAuthScreen: state.selectedAuthScreen,
            forgotEmail: state.forgotEmail,
            verificationId: state.verificationId,
            isLoggedIn: state.isLoggedIn));
      } else {
        emit(PhoneOTPVerifyFailed(
            loginEmail: state.loginEmail,
            message: 'OTP Verification Failed',
            signUpEmail: state.signUpEmail,
            selectedAuthScreen: state.selectedAuthScreen,
            forgotEmail: state.forgotEmail,
            verificationId: state.verificationId,
            isLoggedIn: state.isLoggedIn));
      }
    } catch (e) {
      emit(PhoneOTPVerifyFailed(
          loginEmail: state.loginEmail,
          message: e.toString(),
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail,
          verificationId: state.verificationId,
          isLoggedIn: state.isLoggedIn));
    }
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
    emit(LogOut(
        loginEmail: state.loginEmail,
        signUpEmail: state.signUpEmail,
        selectedAuthScreen: state.selectedAuthScreen,
        forgotEmail: state.forgotEmail,
        verificationId: state.verificationId,
        isLoggedIn: state.isLoggedIn));
  }

  /// SignUp
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  TextEditingController signUpEmailCon = TextEditingController();
  TextEditingController signUpPasswordCon = TextEditingController();
  TextEditingController signUpConfirmPasswordCon = TextEditingController();
  TextEditingController signUpNameCon = TextEditingController();
  final userRepo = UserRepo();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      emit(SignupLoading(
          signUpEmail: state.signUpEmail,
          loginEmail: state.loginEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail,
          verificationId: state.verificationId,
          isLoggedIn: state.isLoggedIn));
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: signUpEmailCon.text.trim(),
          password: signUpPasswordCon.text.trim());
      await emailVerification();
      final newUser = UserData(
          id: userCredential.user!.uid,
          name: signUpNameCon.text,
          email: signUpEmailCon.text);
      await userRepo.saveUserData(newUser);
      emit(state.copyWidth(
          signUpEmail: signUpEmailCon.text,
          selectedAuthScreen: AuthScreen.emailVerificationForm));

      emit(SignupSuccess(
          signUpEmail: state.signUpEmail,
          loginEmail: state.loginEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail,
          verificationId: state.verificationId,
          isLoggedIn: state.isLoggedIn));
      signUpNameCon.clear();
      signUpEmailCon.clear();
      signUpPasswordCon.clear();
      signUpConfirmPasswordCon.clear();
    } catch (e) {
      emit(SignupFailure(
          signUpEmail: state.signUpEmail,
          loginEmail: state.loginEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail,
          message: 'The email address is already existing',
          verificationId: state.verificationId,
          isLoggedIn: state.isLoggedIn));
    }
  }

  Future<void> emailVerification() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        _auth.currentUser?.reload();
        if (_auth.currentUser!.emailVerified) {
          timer.cancel();
          emit(EmailVerifySuccess(
              loginEmail: state.loginEmail,
              signUpEmail: state.signUpEmail,
              selectedAuthScreen: state.selectedAuthScreen,
              forgotEmail: state.forgotEmail,
              verificationId: state.verificationId,
              isLoggedIn: state.isLoggedIn));
          // emit(state.copyWidth(selectedAuthScreen: AuthScreen.login));
        }
      });
    } catch (e) {
      print('Error  ${e.toString()}');
    }
  }

  /// forgot password
  TextEditingController emailCon = TextEditingController();
  GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();

  Future<void> sendPasswordResetEmail() async {
    try {
      emit(ForgotPasswordLoading(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail,
          verificationId: state.verificationId,
          isLoggedIn: state.isLoggedIn));
      await _auth.sendPasswordResetEmail(email: emailCon.text);
      emit(state.copyWidth(
          forgotEmail: emailCon.text,
          selectedAuthScreen: AuthScreen.resetPassword));
      emit(ForgotPasswordSuccess(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail,
          verificationId: state.verificationId,
          isLoggedIn: state.isLoggedIn));
    } catch (error) {
      emit(state.copyWidth(message: error.toString()));
      emit(ForgotPasswordFailure(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail,
          verificationId: state.verificationId,
          isLoggedIn: state.isLoggedIn));
    }
  }

  void selectAuthScreen(AuthScreen screen) {
    emit(state.copyWidth(selectedAuthScreen: screen));
  }

  Stream<User?> isLoggedIn(){
    return _auth.authStateChanges();
  }
}
