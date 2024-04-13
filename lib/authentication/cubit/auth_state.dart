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
    required this.isLoggedIn,
    required this.selectedAuthScreen,
    required this.verificationId,
    this.message,
  });

  final String loginEmail;
  final String signUpEmail;
  final String forgotEmail;
  final AuthScreen selectedAuthScreen;
  final String? message;
  final String verificationId;
  final bool isLoggedIn;

  @override
  // TODO: implement props
  List<Object?> get props => [
        selectedAuthScreen,
        loginEmail,
        message,
        signUpEmail,
        forgotEmail,
        verificationId
      ];

  AuthState copyWidth(
      {String? signUpEmail,
      String? verificationId,
      AuthScreen? selectedAuthScreen,
      String? loginEmail,
      String? forgotEmail,
      bool? isLoggedIn,
      String? message}) {
    return AuthState(
      loginEmail: loginEmail ?? this.loginEmail,
      message: message ?? this.message,
      verificationId: verificationId ?? this.verificationId,
      signUpEmail: signUpEmail ?? this.signUpEmail,
      selectedAuthScreen: selectedAuthScreen ?? this.selectedAuthScreen,
      forgotEmail: forgotEmail ?? this.forgotEmail,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class AuthInitial extends AuthState {
  const AuthInitial({
    required super.loginEmail,
    required super.signUpEmail,
    required super.forgotEmail,
    required super.selectedAuthScreen,
    required super.verificationId, required super.isLoggedIn,
  });
}

class LoginSuccess extends AuthState {
  const LoginSuccess({
    required super.loginEmail,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
    required super.verificationId, required super.isLoggedIn,
  });
}

class LoginFailure extends AuthState {
  const LoginFailure({
    required this.message,
    required super.loginEmail,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
    required super.verificationId, required super.isLoggedIn,
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
    required super.verificationId, required super.isLoggedIn,
  });
}

class LogOut extends AuthState {
  const LogOut({
    required super.loginEmail,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
    required super.verificationId, required super.isLoggedIn,
  });
}

class PhoneNumVerifyFailed extends AuthState {
  const PhoneNumVerifyFailed({
    required super.loginEmail,
    required this.message,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
    required super.verificationId, required super.isLoggedIn,
  });

  @override
  final String message;
}

class PhoneOTPVerifyFailed extends AuthState {
  const PhoneOTPVerifyFailed({
    required super.loginEmail,
    required this.message,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
    required super.verificationId, required super.isLoggedIn,
  });

  @override
  final String message;
}

class PhoneOTPVerifySuccess extends AuthState {
  const PhoneOTPVerifySuccess({
    required super.loginEmail,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
    required super.verificationId, required super.isLoggedIn,
  });
}

class PhoneOTPVerifyLoading extends AuthState {
  const PhoneOTPVerifyLoading({
    required super.loginEmail,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
    required super.verificationId, required super.isLoggedIn,
  });
}

class SignupSuccess extends AuthState {
  const SignupSuccess(
      {required super.loginEmail,
      required super.signUpEmail,
      required super.selectedAuthScreen,
      required super.forgotEmail,
      required super.verificationId, required super.isLoggedIn});
}

class SignupFailure extends AuthState {
  const SignupFailure({
    required super.loginEmail,
    required this.message,
    required super.signUpEmail,
    required super.selectedAuthScreen,
    required super.forgotEmail,
    required super.verificationId, required super.isLoggedIn,
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
    required super.verificationId, required super.isLoggedIn,
  });
}

class ForgotPasswordLoading extends AuthState {
  const ForgotPasswordLoading(
      {required super.loginEmail,
      required super.signUpEmail,
      required super.selectedAuthScreen,
      required super.forgotEmail,
      required super.verificationId, required super.isLoggedIn});
}

class ForgotPasswordSuccess extends AuthState {
  const ForgotPasswordSuccess(
      {required super.loginEmail,
      required super.signUpEmail,
      required super.selectedAuthScreen,
      required super.forgotEmail,
      required super.verificationId, required super.isLoggedIn});
}

class ForgotPasswordFailure extends AuthState {
  const ForgotPasswordFailure(
      {required super.loginEmail,
      required super.signUpEmail,
      required super.selectedAuthScreen,
      required super.forgotEmail,
      required super.verificationId, required super.isLoggedIn});
}

class EmailVerifySuccess extends AuthState {
  const EmailVerifySuccess(
      {required super.loginEmail,
      required super.signUpEmail,
      required super.selectedAuthScreen,
      required super.forgotEmail,
      required super.verificationId, required super.isLoggedIn});
}

class EmailVerifyFailure extends AuthState {
  const EmailVerifyFailure(
      {required super.loginEmail,
      required super.signUpEmail,
      required super.selectedAuthScreen,
      required super.forgotEmail,
      required super.verificationId, required super.isLoggedIn});
}

// class OTPVerifySuccess extends AuthState {
//   const OTPVerifySuccess(
//       {required super.loginEmail,
//       required super.signUpEmail,
//       required super.selectedAuthScreen,
//       required super.forgotEmail});
// }
