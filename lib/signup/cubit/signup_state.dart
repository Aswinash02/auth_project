part of 'signup_cubit.dart';

class SignupState extends Equatable {
  const SignupState(
      {required this.email, required this.message, required this.name});

  final String email;
  final String name;
  final String message;

  @override
  // TODO: implement props
  List<Object?> get props => [email, message, name];

  SignupState copyWidth({String? email, String? message, String? name}) {
    return SignupState(
        email: email ?? this.email,
        message: message ?? this.message,
        name: name ?? this.name);
  }
}

class SignupInitial extends SignupState {
  const SignupInitial(
      {required super.email, required super.message, required super.name});
}

class SignupSuccess extends SignupState {
  const SignupSuccess(
      {required super.email, required super.message, required super.name});
}

class SignupFailure extends SignupState {
  const SignupFailure(
      {required super.email, required super.message, required super.name});
}

class SignupLoading extends SignupState {
  const SignupLoading(
      {required super.email, required super.message, required super.name});
}
