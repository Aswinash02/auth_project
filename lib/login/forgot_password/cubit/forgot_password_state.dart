part of 'forgot_password_cubit.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({required this.email, required this.message});

  final String email;
  final String message;

  @override
  // TODO: implement props
  List<Object?> get props => [email, message];

  ForgotPasswordState copyWidth({String? email, String? message}) {
    return ForgotPasswordState(
        email: email ?? this.email, message: message ?? this.message);
  }
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial({required super.email, required super.message});
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading({required super.email, required super.message});
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  const ForgotPasswordSuccess({required super.email, required super.message});
}

class ForgotPasswordFailure extends ForgotPasswordState {
  const ForgotPasswordFailure({required super.email, required super.message});
}
