import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required this.firebaseAuth})
    : super(AuthenticationInitial()) {
    on<LoginEvent>(
      (event, emit) => eventLogin(event.email, event.password, emit),
    );
    on<RegisterEvent>(
      (event, emit) => eventRegister(event.email, event.password, emit),
    );
    on<LogoutEvent>((event, emit) => eventLogout(emit));
  }

  final FirebaseAuth firebaseAuth;

  Future<void> eventLogin(
    String email,
    String password,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      emit(AuthenticationAuthenticated(user: userCredential.user!));
    } catch (e) {
      emit(
        AuthenticationError(message: e.toString()),
      ); // Handle error appropriately
    }
  }

  Future<void> eventRegister(
    String email,
    String password,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(AuthenticationAuthenticated(user: userCredential.user!));
    } catch (e) {
      emit(
        AuthenticationError(message: e.toString()),
      ); // Handle error appropriately
    }
  }

  Future<void> eventLogout(Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      await firebaseAuth.signOut();
      emit(AuthenticationInitial());
    } catch (e) {
      emit(
        AuthenticationError(message: e.toString()),
      ); // Handle error appropriately
    }
  }
}
