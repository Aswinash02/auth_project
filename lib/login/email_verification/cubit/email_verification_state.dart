part of 'email_verification_cubit.dart';

class EmailVerificationState extends Equatable {
  const EmailVerificationState({required this.message});

  final String message;

  @override
  // TODO: implement props
  List<Object?> get props => [message];

  EmailVerificationState copyWidth({String? message}) {
    return EmailVerificationState(message: message ?? this.message);
  }
}

class EmailVerificationInitial extends EmailVerificationState {
  const EmailVerificationInitial({required super.message});
}

class EmailVerificationLoading extends EmailVerificationState {
  const EmailVerificationLoading({required super.message});
}

class EmailVerificationFailure extends EmailVerificationState {
  const EmailVerificationFailure({required super.message});
}

class EmailVerificationSuccess extends EmailVerificationState {
  const EmailVerificationSuccess({required super.message});
}
