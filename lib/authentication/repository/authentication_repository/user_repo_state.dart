part of 'user_repo_cubit.dart';

class UserRepoState extends Equatable {
  const UserRepoState(
      {required this.id,
      required this.name,
      required this.email,
      required this.message});

  final String id;
  final String name;
  final String email;
  final String message;

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, email, message];

  UserRepoState copyWidth(
      {String? id, String? email, String? name, String? message}) {
    return UserRepoState(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        message: message ?? this.message);
  }
}

class UserRepoInitial extends UserRepoState {
  const UserRepoInitial(
      {required super.id,
      required super.name,
      required super.email,
      required super.message});
}

class UserRepoLoading extends UserRepoState {
  const UserRepoLoading(
      {required super.id,
      required super.name,
      required super.email,
      required super.message});
}

class UserRepoLoaded extends UserRepoState {
  const UserRepoLoaded(
      {required super.id,
      required super.name,
      required super.email,
      required super.message});
}
class UserRepoFailure extends UserRepoState {
  const UserRepoFailure(
      {required super.id,
        required super.name,
        required super.email,
        required super.message});
}
