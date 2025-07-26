part of 'authentication_bloc.dart';

// import 'package:flutter/material.dart';

@immutable
sealed class AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthenticationEvent {
  final String email;
  final String password;

  RegisterEvent({required this.email, required this.password});
}

class LogoutEvent extends AuthenticationEvent {}
