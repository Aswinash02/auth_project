part of 'auth_cubit.dart';

enum AuthScreen {
  login,
  signUp,
  forgotPassword,
  resetPassword,
  otpVerificationForm,
  emailVerificationForm
}

class AuthState extends Equatable {
  const AuthState({
    required this.loginEmail,
    required this.signUpEmail,
    required this.forgotEmail,
    required this.selectedAuthScreen,
    this.message,
  });

  final String loginEmail;
  final String signUpEmail;
  final String forgotEmail;
  final AuthScreen selectedAuthScreen;
  final String? message;

  @override
  // TODO: implement props
  List<Object?> get props =>
      [selectedAuthScreen, loginEmail, message, signUpEmail, forgotEmail];

  AuthState copyWidth(
      {String? signUpEmail,
      AuthScreen? selectedAuthScreen,
      String? loginEmail,
      String? forgotEmail,
      String? message}) {
    return AuthState(
      loginEmail: loginEmail ?? this.loginEmail,
      message: message ?? this.message,
      signUpEmail: signUpEmail ?? this.signUpEmail,
      selectedAuthScreen: selectedAuthScreen ?? this.selectedAuthScreen,
      forgotEmail: forgotEmail ?? this.forgotEmail,
    );
  }
}

class AuthInitial extends AuthState {
  const AuthInitial({
    required super.loginEmail,
    required super.signUpEmail,
    required super.forgotEmail,
    required super.selectedAuthScreen,
  });
}

class LoginSuccess extends AuthState {
  const LoginSuccess({
    required super.loginEmail,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
  });
}

class LoginFailure extends AuthState {
  const LoginFailure({
    required this.message,
    required super.loginEmail,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
  });

  @override
  final String message;
}

class LoginLoading extends AuthState {
  const LoginLoading({
    required super.loginEmail,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
  });
}

class LogOut extends AuthState {
  const LogOut({
    required super.loginEmail,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
  });
}

class SignupSuccess extends AuthState {
  const SignupSuccess(
      {required super.loginEmail,
      required super.signUpEmail,
      required super.selectedAuthScreen,
      required super.forgotEmail});
}

class SignupFailure extends AuthState {
  const SignupFailure({
    required super.loginEmail,
    required this.message,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
  });

  @override
  final String message;
}

class SignupLoading extends AuthState {
  const SignupLoading({
    required super.loginEmail,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
  });
}

class ForgotPasswordLoading extends AuthState {
  const ForgotPasswordLoading(
      {required super.loginEmail,
      required super.signUpEmail,
      required super.selectedAuthScreen,
      required super.forgotEmail});
}

class ForgotPasswordSuccess extends AuthState {
  const ForgotPasswordSuccess(
      {required super.loginEmail,
      required super.signUpEmail,
      required super.selectedAuthScreen,
      required super.forgotEmail});
}

class ForgotPasswordFailure extends AuthState {
  const ForgotPasswordFailure(
      {required super.loginEmail,
      required super.signUpEmail,
      required super.selectedAuthScreen,
      required super.forgotEmail});
}
