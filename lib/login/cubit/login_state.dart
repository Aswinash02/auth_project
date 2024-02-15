part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({required this.email, required this.message});

  final String email;
  final String message;

  @override
  // TODO: implement props
  List<Object?> get props => [email,message];

  LoginState copyWidth({String? email, String? message}) {
    return LoginState(
        email: email ?? this.email, message: message ?? this.message);
  }
}

class LoginInitial extends LoginState {
  const LoginInitial({required super.email, required super.message});
}

class LoginSuccess extends LoginState {
  const LoginSuccess({required super.email, required super.message});
}

class LoginFailure extends LoginState {
  const LoginFailure({required super.email, required super.message});
}

class LoginLoading extends LoginState {
  const LoginLoading({required super.email, required super.message});
}
