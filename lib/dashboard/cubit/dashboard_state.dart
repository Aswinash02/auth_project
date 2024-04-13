part of 'dashboard_cubit.dart';

enum
ScreenName { dashboard, category, product, wishList, order, setting,logOut }

class DashboardState extends Equatable {
  const DashboardState({
    required this.userType,
    required this.selectedTitle,
  });

  final UserType userType;
  final ScreenName selectedTitle;

  DashboardState copyWith({UserType? userType, ScreenName? selectedTitle}) {
    return DashboardState(
        userType: userType ?? this.userType,
        selectedTitle: selectedTitle ?? this.selectedTitle);
  }

  @override
  List<Object?> get props => [userType, selectedTitle];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial(
      {required super.userType, required super.selectedTitle});
}
