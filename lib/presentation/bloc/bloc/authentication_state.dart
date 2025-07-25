part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class AuthenticationAuthenticated extends AuthenticationState {
  final User user;

  AuthenticationAuthenticated({required this.user});
}

final class AuthenticationError extends AuthenticationState {
  final String message;

  AuthenticationError({required this.message});
}
