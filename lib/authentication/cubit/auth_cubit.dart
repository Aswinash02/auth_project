import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integration/authentication/model/user_model.dart';
import 'package:firebase_integration/authentication/repository/authentication_repository/user_repo_cubit.dart';
import 'package:flutter/cupertino.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit()
      : super(const AuthInitial(
            loginEmail: '',
            signUpEmail: '',
            selectedAuthScreen: AuthScreen.login,
            forgotEmail: ''));

  ///login
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  bool hidePassword = true;

  Future<void> loginWithUserCredential() async {
    try {
      emit(LoginLoading(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail));
      await _auth.signInWithEmailAndPassword(
          email: loginEmailController.text,
          password: loginPasswordController.text);
      emit(state.copyWidth(
          loginEmail: loginEmailController.text, message: 'Login Success'));
      emit(LoginSuccess(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail));
    } catch (e) {
      emit(LoginFailure(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail,
          message: 'Invalid Email or Password'));
    }
  }

  // void sendEmailVerification() async {
  //   try {
  //     await _auth.currentUser!.sendEmailVerification();
  //   } on FirebaseAuthException catch (e) {
  //     emit(state.copyWidth(message: e.code));
  //   } on FirebaseException catch (e) {
  //     emit(state.copyWidth(message: e.code));
  //   } on FormatException catch (e) {
  //     emit(state.copyWidth(message: e.toString()));
  //   } on PlatformException catch (e) {
  //     emit(state.copyWidth(message: e.code));
  //   } catch (error) {
  //     emit(state.copyWidth(message: error.toString()));
  //     emit(LoginFailure(email: state.email, message: state.message));
  //   }
  // }

  Future<void> signOutUser() async {
    await _auth.signOut();
    emit(LogOut(
        loginEmail: state.loginEmail,
        signUpEmail: state.signUpEmail,
        selectedAuthScreen: state.selectedAuthScreen,
        forgotEmail: state.forgotEmail));
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
          forgotEmail: state.forgotEmail));
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: signUpEmailCon.text.trim(),
          password: signUpPasswordCon.text.trim());
      final newUser = UserData(
          id: userCredential.user!.uid,
          name: signUpNameCon.text,
          email: signUpEmailCon.text);
      await userRepo.saveUserData(newUser);
      emit(state.copyWidth(
          signUpEmail: signUpEmailCon.text,
          selectedAuthScreen: AuthScreen.login));
      emit(SignupSuccess(
          signUpEmail: state.signUpEmail,
          loginEmail: state.loginEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail));
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
          message: 'The email address is already existing'));
    }
  }

  /// forgot password
  TextEditingController emailCon = TextEditingController();
  GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail() async {
    try {
      emit(ForgotPasswordLoading(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail));
      await auth.sendPasswordResetEmail(email: emailCon.text);
      emit(state.copyWidth(
          forgotEmail: emailCon.text,
          selectedAuthScreen: AuthScreen.resetPassword));
      emit(ForgotPasswordSuccess(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail));
    } catch (error) {
      emit(state.copyWidth(message: error.toString()));
      emit(ForgotPasswordFailure(
          loginEmail: state.loginEmail,
          signUpEmail: state.signUpEmail,
          selectedAuthScreen: state.selectedAuthScreen,
          forgotEmail: state.forgotEmail));
    }
  }

  void selectAuthScreen(AuthScreen screen) {
    emit(state.copyWidth(selectedAuthScreen: screen));
  }
}
